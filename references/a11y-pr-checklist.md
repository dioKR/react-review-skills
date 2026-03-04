# Accessibility PR Checklist

## Blockers (P0)

### Interactive Element Not Keyboard Reachable

```tsx
// Bad: div with click but no keyboard access
<div onClick={handleClick}>Click me</div>

// Good: Use semantic element
<button onClick={handleClick}>Click me</button>

// If div is required, add keyboard support
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => e.key === 'Enter' && handleClick()}
>
  Click me
</div>
```

### Form Control Without Accessible Name

```tsx
// Bad: Input without label
<input type="email" placeholder="Email" />

// Good: Visible label
<label>
  Email
  <input type="email" />
</label>

// Or with htmlFor
<label htmlFor="email">Email</label>
<input id="email" type="email" />

// Or with aria-label for icon-only
<input type="search" aria-label="Search products" />
```

### Missing Alt Text

```tsx
// Bad: No alt
<img src="/hero.jpg" />

// Good: Descriptive alt
<img src="/hero.jpg" alt="Team celebrating product launch" />

// Decorative image: empty alt
<img src="/decorative-line.svg" alt="" />
```

### Focus Trapped in Modal

```tsx
// Bad: Focus escapes modal, or no escape possible
<div className="modal">
  <input autoFocus />
  <button>Submit</button>
  {/* No close button, no Escape handler */}
</div>

// Good: Trap focus + allow Escape
<dialog
  ref={dialogRef}
  onKeyDown={(e) => e.key === 'Escape' && onClose()}
>
  <button onClick={onClose} aria-label="Close dialog">X</button>
  <input autoFocus />
  <button>Submit</button>
</dialog>

// Or use focus-trap library
import { FocusTrap } from 'focus-trap-react';
<FocusTrap>
  <div role="dialog" aria-modal="true">...</div>
</FocusTrap>
```

## Important (P1)

### Click on Non-semantic Element

```tsx
// Bad: span as button
<span className="link" onClick={goToProfile}>Profile</span>

// Good: Use anchor or button
<a href="/profile">Profile</a>
// or
<button type="button" onClick={goToProfile}>Profile</button>
```

### Broken Heading Structure

```tsx
// Bad: Skips levels
<h1>Page Title</h1>
<h4>Subsection</h4>  {/* Skipped h2, h3 */}

// Good: Sequential levels
<h1>Page Title</h1>
<h2>Section</h2>
<h3>Subsection</h3>
```

### Status Updates Not Announced

```tsx
// Bad: Toast appears but not announced
<div className="toast">{message}</div>

// Good: Use live region
<div role="status" aria-live="polite">{message}</div>

// For errors
<div role="alert">{errorMessage}</div>

// Or use aria-describedby on form controls
<input aria-describedby="error-msg" aria-invalid={!!error} />
{error && <span id="error-msg" role="alert">{error}</span>}
```

## Improvements (P2)

### Landmark Usage

```tsx
// Before: div soup
<div className="header">...</div>
<div className="sidebar">...</div>
<div className="content">...</div>

// After: Semantic landmarks
<header>...</header>
<nav aria-label="Main navigation">...</nav>
<main>...</main>
<aside>...</aside>
<footer>...</footer>
```

### Vague Link Text

```tsx
// Bad: Generic text
<a href="/docs">Click here</a>
<a href="/pricing">Learn more</a>

// Good: Descriptive
<a href="/docs">View documentation</a>
<a href="/pricing">See pricing plans</a>
```

### Redundant ARIA

```tsx
// Bad: role="button" on button is redundant
<button role="button">Submit</button>
<a href="/home" role="link">Home</a>

// Good: Remove redundant roles
<button>Submit</button>
<a href="/home">Home</a>
```

## Tool Notes

- ESLint stacks: map to `jsx-a11y` rules where available.
- Biome stacks: include Biome a11y diagnostics.
- If no automation exists, keep manual checks concise and scoped to changed UI.

## Quick Test Checklist

1. **Tab through**: Can you reach every interactive element?
2. **Enter/Space**: Do buttons and links activate?
3. **Escape**: Can you close modals?
4. **Screen reader**: Run VoiceOver (Mac) or NVDA (Windows) briefly on changed UI.
