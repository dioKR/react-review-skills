# Toss Code Quality Mapping For PR Review

Use these lenses and example mappings from Frontend Fundamentals.

## 1) Readability

- Replace nested ternary chains with explicit branching.
- Give names to complex conditions.
- Replace magic numbers with named constants at the right scope.

Example pages: `ternary-operator`, `condition-name`, `magic-number-readability`.

## 2) Predictability

- Pull hidden side effects out of utility functions.
- Keep code in natural read order to reduce jumps.
- Keep comparison order consistent and intention-revealing.

Example pages: `hidden-logic`, `comparison-order`, `login-start-page`.

## 3) Cohesion

- Group code that changes together.
- Split mutually exclusive UI paths into separate components.
- Keep form/domain rules near the feature using them.

Example pages: `submit-button`, `form-fields`, `magic-number-cohesion`.

## 4) Coupling

- Avoid over-generalized shared modules that increase cross-feature impact.
- Prefer composition over deep props drilling where practical.
- Keep hooks focused; avoid state that couples unrelated flows.

Example pages: `use-bottom-sheet`, `use-page-state-coupling`, `use-user`, `item-edit-modal`, `user-policy`, `http`, `code-directory`.

## Review Prompts

- Would a new teammate predict behavior without running it?
- If this feature changes next week, what unrelated files also change?
- Is the abstraction reducing repeated change cost, or just moving complexity?
