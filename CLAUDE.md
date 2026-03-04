# Claude Code Instructions

Use this repository as a React/Next.js PR review skill pack.

## Quick Use

Run from the project you want to review:

```bash
react-review-claude origin/main
```

Paste the printed prompt into Claude Code.

## Source of Truth

- `SKILL.md`

## Required Review Flow

1. Scope changed files and lint stack (ESLint/Biome).
2. Review Vercel performance and architecture first.
3. Review Toss code quality:
   - Readability
   - Predictability
   - Cohesion
   - Coupling
4. Review accessibility.
5. Return severity-ranked findings with concrete fixes.

## References

- `references/vercel-react-rules.md`
- `references/toss-code-quality.md`
- `references/a11y-pr-checklist.md`
- `references/lint-tooling-map.md`

## Output Templates

- `assets/templates/pr-review-comment.md`
- `assets/templates/pr-summary.md`

## Context Script

- `scripts/collect-pr-context.sh <base-ref>`

## Severity

- `P0`: broken behavior, security/privacy, severe a11y blocker, or large performance regression
- `P1`: significant maintainability/readability/perf risk
- `P2`: improvement suggestions and local cleanups
