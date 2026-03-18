# Claude Code Instructions

Use this repository as a React/Next.js PR review skill pack.

## Quick Use

Run from the project you want to review:

```bash
react-review-claude
```

Paste the printed prompt into Claude Code.
Default base ref is the current branch upstream.

## Source of Truth

- `SKILL.md`

## Required Review Flow

1. Scope changed files, lint stack, and determine review strategy by diff size.
2. Review project convention compliance.
3. Review Vercel performance and architecture.
4. Review Toss code quality:
   - Readability
   - Predictability
   - Cohesion
   - Coupling
5. Review accessibility.
6. Review test coverage.
7. Return severity-ranked findings with concrete fixes.
8. Self-check all findings before submitting.

## References

- `references/vercel-react-rules.md`
- `references/toss-code-quality.md`
- `references/a11y-pr-checklist.md`
- `references/lint-tooling-map.md`
- `references/common-findings.md`

## Output Templates

- `assets/templates/pr-review-comment.md`
- `assets/templates/pr-summary.md`

## Context Script

- `scripts/collect-pr-context.sh <base-ref>`

## Severity

- `P0`: broken behavior, security/privacy, severe a11y blocker, or large performance regression
- `P1`: significant maintainability/readability/perf risk
- `P2`: improvement suggestions and local cleanups

## Confidence

- `high`: directly visible in diff, no ambiguity
- `medium`: depends on surrounding context, likely a problem
- `low`: speculative, needs runtime/domain verification — group separately, never assign P0
