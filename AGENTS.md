# Agent Instructions (Codex)

When reviewing React/Next.js pull requests in this repository:

1. Treat `SKILL.md` as the source of truth.
2. Determine review strategy based on diff size (small/medium/large).
3. Follow gate order:
   - Project convention compliance
   - Vercel performance/architecture
   - Toss code quality (readability, predictability, cohesion, coupling)
   - Accessibility
   - Test coverage
4. Use output templates:
   - `assets/templates/pr-review-comment.md`
   - `assets/templates/pr-summary.md`
5. Use severity levels:
   - `P0`: broken behavior, security/privacy, severe a11y blocker, large perf regression
   - `P1`: meaningful maintainability/readability/perf risk
   - `P2`: local improvements
6. Assign confidence to each finding:
   - `high`: directly visible in diff
   - `medium`: depends on context, likely a problem
   - `low`: speculative — group separately, never assign P0
7. Check `references/common-findings.md` for recurring patterns. Update after review.
8. Self-check all findings before submitting:
   - Is the finding about the current diff (not pre-existing code)?
   - Does the suggested fix compile?
   - Is the severity accurate?
   - Is the comment actionable?
9. Before review, gather context with:
   - `scripts/collect-pr-context.sh <base-ref>`
