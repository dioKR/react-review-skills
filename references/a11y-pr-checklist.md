# Accessibility PR Checklist

## Blockers (P0)

- Interactive element not reachable by keyboard.
- Form control without accessible name.
- Non-text content missing equivalent text where required.
- Focus lost or trapped with no escape path in modal/dialog patterns.

## Important (P1)

- Click handlers on non-semantic elements without keyboard equivalent.
- Heading structure breaks page outline significantly.
- Status/error updates not announced for assistive tech.

## Improvements (P2)

- Landmark usage can be clearer (`main`, `nav`, `aside`).
- Link/button wording can be more descriptive.
- Redundant ARIA attributes can be removed.

## Tool Notes

- ESLint stacks: map to `jsx-a11y` rules where available.
- Biome stacks: include Biome a11y diagnostics.
- If no automation exists, keep manual checks concise and scoped to changed UI.
