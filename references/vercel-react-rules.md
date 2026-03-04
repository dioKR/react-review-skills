# Vercel React/Next Review Rules

## Priority

Review in this order:

1. Remove waterfalls from async work.
2. Reduce client bundle size.
3. Place data fetching at the right boundary.
4. Avoid unstable rerender triggers.

## Checks

- Flag sequential `await` in independent requests.
- Flag top-level `'use client'` that drags static/content UI into client bundle.
- Prefer server components by default in App Router.
- Use dynamic import for heavy optional UI.
- Verify cache/revalidation choice is explicit where needed.

## PR Comment Pattern

- State observed pattern.
- State user impact (latency, JS shipped, hydration cost).
- Suggest smallest safe change first.
