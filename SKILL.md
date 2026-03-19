---
name: react-review-skills
description: Review React and Next.js pull requests for performance, readability, maintainability, and accessibility. Use when the user asks for PR review, code review comments, refactor guidance, or quality gates for React/Next.js codebases, including projects that use ESLint or Biome.
---

# React Review Skills

Run a multi-gate review workflow for React/Next.js PRs and output severity-ranked findings with concrete fixes.

## Workflow

1. Scope the PR and determine review strategy.
2. Run project convention gate.
3. Run performance and architecture gate.
4. Run readability and maintainability gate.
5. Run accessibility gate.
6. Run test coverage gate.
7. Report findings with evidence and patches.
8. Self-check all findings before submitting.

## 1) Scope The PR

- Identify changed files and classify by concern: `app/`, `pages/`, components, hooks, data layer, tests.
- Detect lint stack from repository files:
  - Biome: `biome.json` or `biome.jsonc`
  - ESLint: `eslint.config.*` or `.eslintrc*`
- If both exist, keep both checks in scope.

Use `scripts/collect-pr-context.sh` to gather quick context before reviewing.

### Review Strategy By Diff Size

Determine total changed lines from diffstat and adapt depth:

- **Small PR (< 100 lines)**: Skip exhaustive gate-by-gate. Focus on the most relevant 1–2 gates based on file types. Keep comments concise.
- **Medium PR (100–500 lines)**: Run all gates normally.
- **Large PR (> 500 lines)**: Prioritize high-impact files (> 50 lines changed) first. Review remaining files at surface level. Flag if PR should be split.

## 2) Project Convention Gate

Check whether the PR follows project-local conventions. Look for these sources in the target repository (in order):

1. `CLAUDE.md` — project instructions
2. `CONVENTIONS.md` or `conventions.md` — explicit convention doc
3. `.eslintrc*` / `eslint.config.*` / `biome.json` — enforced rules imply conventions
4. Existing code patterns in the same directory as changed files

Common convention violations to check:

- State management: Does the project use a specific library (Zustand, Jotai, Recoil)? Are new state patterns consistent?
- Data fetching: Does the project use a specific pattern (`useSuspenseQuery`, React Query, SWR)? Is `useEffect + fetch` used where it shouldn't be?
- File/folder structure: Does the new code follow existing naming and organization?
- Component patterns: Are new components consistent with existing ones (export style, prop types, composition patterns)?
- Import ordering and path aliases.

If no explicit convention source is found, infer conventions from the dominant patterns in the existing codebase and review against those.

## 3) Performance And Architecture Gate (Vercel-first)

Prioritize findings in this order:

1. Network waterfall and sequential fetch patterns.
2. Over-broad client boundaries (`'use client'` too high in tree).
3. Bundle inflation from avoidable client code or heavy dependencies.
4. Missed server-side data fetching opportunities.
5. Avoidable rerenders and unstable props/effects.

Read [references/vercel-react-rules.md](references/vercel-react-rules.md) for review heuristics.

## 4) Readability And Maintainability Gate (Toss fundamentals)

Review by four lenses:

1. Readability
2. Predictability
3. Cohesion
4. Coupling

Apply example-driven checks from [references/toss-code-quality.md](references/toss-code-quality.md).

## 5) Accessibility Gate

- Always check semantic HTML, keyboard path, control labeling, and focus behavior in changed UI.
- If ESLint is present, include `jsx-a11y` diagnostics.
- If Biome is present, include Biome a11y diagnostics.
- If automated checks are missing, apply manual checklist from [references/a11y-pr-checklist.md](references/a11y-pr-checklist.md).

## 6) Test Coverage Gate

Review test adequacy for changed code:

- **New component or hook added without test**: Flag as P1. Every new public component/hook should have at least a render/basic behavior test.
- **Logic changed but test not updated**: Flag as P1. If branching logic, data transformation, or state transitions changed, related tests must reflect the change.
- **Test coupled to implementation details**: Flag as P2. Tests should assert on behavior (rendered output, user interaction results), not internal state or implementation specifics (e.g., checking `setState` was called).
- **Missing edge case coverage**: Flag as P2. If the diff introduces error handling, loading states, or boundary conditions, verify tests cover those paths.

If the project has no test infrastructure at all, note it in the summary but do not flag individual files.

## 7) Output Format

- Use `assets/templates/pr-review-comment.md` for each finding.
- Use `assets/templates/pr-summary.md` for final summary.
- Order findings by severity:
  - `P0`: broken behavior, security/privacy, severe accessibility blocker, or large performance regression.
  - `P1`: significant maintainability/readability/perf risk likely to cause bugs or team friction.
  - `P2`: improvement suggestions and local cleanups.
- Include for each finding:
  - exact file/line
  - violated principle
  - why this matters
  - concrete fix suggestion

### Implementation Checklist

The PR summary must end with a numbered checklist of all findings. This checklist is designed to be copied directly to the implementation agent so that no finding is skipped without explicit justification. Each item must include severity, title, and file location.

### Confidence Criteria

Assign confidence to each finding:

- **high**: The issue is directly visible in the diff. No ambiguity — the code clearly violates a rule or pattern.
- **medium**: The issue depends on surrounding context (e.g., how a parent component uses this prop, what the API returns). Likely a problem but needs verification.
- **low**: Speculative suggestion. Based on pattern heuristics but may be intentional or irrelevant. Requires runtime or domain knowledge to confirm.

Rules:
- `low` confidence findings should be grouped in a separate "Suggestions (needs verification)" section, not mixed with high/medium findings.
- Never assign P0 severity with low confidence. If unsure, downgrade to P1.

### Repeated Pattern Detection

Check [references/common-findings.md](references/common-findings.md) before writing comments. If a finding matches a previously recorded common pattern:
- Reference the pattern ID in the comment.
- If the same pattern has appeared 3+ times, suggest adding a lint rule or convention doc entry instead of repeating the review comment.

After each review, if a new pattern emerged that is likely to recur, append it to `references/common-findings.md`.

## 8) Self-Check Before Submitting

Before posting review comments, verify each finding against these checks:

1. **Diff-grounded**: Is this finding about code in the current diff, or am I commenting on pre-existing code? Only comment on pre-existing code if the diff makes it worse.
2. **Fix compiles**: Does the suggested fix actually work? Would it introduce type errors, missing imports, or broken references?
3. **Severity accurate**: Re-evaluate each P0. Is it truly broken behavior/security/severe a11y? If uncertain, downgrade.
4. **Not duplicate**: Am I making the same point in multiple comments? Consolidate into one.
5. **Actionable**: Can the author fix this with the information provided? If not, add more context.

If a finding fails any of these checks, either fix it or remove it before submitting.

## Tooling Mapping

Use [references/lint-tooling-map.md](references/lint-tooling-map.md) to map rule intent across ESLint and Biome so comments stay tool-agnostic.

## Review Guardrails

- Prefer small, verifiable suggestions over broad rewrites.
- Do not request abstraction unless it reduces coupling or repeated change cost.
- Allow intentional duplication when it keeps ownership boundaries clear.
- When uncertain, mark assumptions explicitly.
