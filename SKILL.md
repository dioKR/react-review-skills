---
name: react-review-skills
description: Review React and Next.js pull requests for performance, readability, maintainability, and accessibility. Use when the user asks for PR review, code review comments, refactor guidance, or quality gates for React/Next.js codebases, including projects that use ESLint or Biome.
---

# React Review Skills

Run a three-gate review workflow for React/Next.js PRs and output severity-ranked findings with concrete fixes.

## Workflow

1. Scope the PR.
2. Run performance and architecture gate.
3. Run readability and maintainability gate.
4. Run accessibility gate.
5. Report findings with evidence and patches.

## 1) Scope The PR

- Identify changed files and classify by concern: `app/`, `pages/`, components, hooks, data layer, tests.
- Detect lint stack from repository files:
  - Biome: `biome.json` or `biome.jsonc`
  - ESLint: `eslint.config.*` or `.eslintrc*`
- If both exist, keep both checks in scope.

Use `scripts/collect-pr-context.sh` to gather quick context before reviewing.

## 2) Performance And Architecture Gate (Vercel-first)

Prioritize findings in this order:

1. Network waterfall and sequential fetch patterns.
2. Over-broad client boundaries (`'use client'` too high in tree).
3. Bundle inflation from avoidable client code or heavy dependencies.
4. Missed server-side data fetching opportunities.
5. Avoidable rerenders and unstable props/effects.

Read [references/vercel-react-rules.md](references/vercel-react-rules.md) for review heuristics.

## 3) Readability And Maintainability Gate (Toss fundamentals)

Review by four lenses:

1. Readability
2. Predictability
3. Cohesion
4. Coupling

Apply example-driven checks from [references/toss-code-quality.md](references/toss-code-quality.md).

## 4) Accessibility Gate

- Always check semantic HTML, keyboard path, control labeling, and focus behavior in changed UI.
- If ESLint is present, include `jsx-a11y` diagnostics.
- If Biome is present, include Biome a11y diagnostics.
- If automated checks are missing, apply manual checklist from [references/a11y-pr-checklist.md](references/a11y-pr-checklist.md).

## 5) Output Format

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

## Tooling Mapping

Use [references/lint-tooling-map.md](references/lint-tooling-map.md) to map rule intent across ESLint and Biome so comments stay tool-agnostic.

## Review Guardrails

- Prefer small, verifiable suggestions over broad rewrites.
- Do not request abstraction unless it reduces coupling or repeated change cost.
- Allow intentional duplication when it keeps ownership boundaries clear.
- When uncertain, mark assumptions explicitly.
