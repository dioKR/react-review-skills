# Agent Instructions (Codex)

When reviewing React/Next.js pull requests in this repository:

1. Treat `SKILL.md` as the source of truth.
2. Follow gate order:
   - Vercel performance/architecture
   - Toss code quality (readability, predictability, cohesion, coupling)
   - Accessibility
3. Use output templates:
   - `assets/templates/pr-review-comment.md`
   - `assets/templates/pr-summary.md`
4. Use severity levels:
   - `P0`: broken behavior, security/privacy, severe a11y blocker, large perf regression
   - `P1`: meaningful maintainability/readability/perf risk
   - `P2`: local improvements
5. Before review, gather context with:
   - `scripts/collect-pr-context.sh <base-ref>`
