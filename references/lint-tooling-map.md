# ESLint + Biome Tooling Map

Keep findings principle-first, then cite tool-specific diagnostics.

## Principle To Tool Mapping

- Accessible naming for controls
  - ESLint: `jsx-a11y/control-has-associated-label`
  - Biome: a11y diagnostics for unlabeled controls
- Alt text for images/media
  - ESLint: `jsx-a11y/alt-text`
  - Biome: a11y diagnostics for missing alt text
- Non-interactive elements with interactions
  - ESLint: `jsx-a11y/no-noninteractive-element-interactions`
  - Biome: a11y diagnostics for semantic mismatch
- Positive tabIndex misuse
  - ESLint: `jsx-a11y/tabindex-no-positive`
  - Biome: a11y diagnostics for focus-order risk

## Reporting Rule

1. Explain principle in plain language.
2. Add tool diagnostic name only as supporting evidence.
3. Provide patch-level fix suggestion.
