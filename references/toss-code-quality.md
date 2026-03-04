# Toss Code Quality Mapping For PR Review

Use these lenses and example mappings from Frontend Fundamentals.

## 1) Readability

### Nested Ternary → Explicit Branching

```tsx
// Bad: Hard to parse
const status = isLoading ? 'loading' : hasError ? 'error' : data ? 'success' : 'idle';

// Good: Explicit branching
function getStatus() {
  if (isLoading) return 'loading';
  if (hasError) return 'error';
  if (data) return 'success';
  return 'idle';
}
```

### Name Complex Conditions

```tsx
// Bad: What does this mean?
if (user.age >= 19 && user.verified && !user.blocked && user.subscription !== 'free') {
  showPremiumContent();
}

// Good: Named condition
const canAccessPremium = user.age >= 19
  && user.verified
  && !user.blocked
  && user.subscription !== 'free';

if (canAccessPremium) {
  showPremiumContent();
}
```

### Magic Numbers → Named Constants

```tsx
// Bad: What is 86400000?
setTimeout(refresh, 86400000);

// Good: Named constant
const ONE_DAY_MS = 24 * 60 * 60 * 1000;
setTimeout(refresh, ONE_DAY_MS);
```

## 2) Predictability

### Hidden Side Effects

```tsx
// Bad: formatDate secretly logs analytics
function formatDate(date) {
  analytics.track('date_formatted');  // Hidden side effect!
  return date.toLocaleDateString();
}

// Good: Pure function, side effect explicit
function formatDate(date) {
  return date.toLocaleDateString();
}
// Call analytics separately where needed
```

### Natural Read Order

```tsx
// Bad: Jump around to understand flow
function handleSubmit() {
  if (!validate()) return;
  const data = prepareData();
  submitToServer(data);
}

function validate() { /* ... defined below */ }
function prepareData() { /* ... defined below */ }

// Good: Define before use, or colocate
function handleSubmit() {
  const validate = () => { /* inline or above */ };
  const prepareData = () => { /* inline or above */ };

  if (!validate()) return;
  const data = prepareData();
  submitToServer(data);
}
```

### Consistent Comparison Order

```tsx
// Bad: Inconsistent - sometimes value first, sometimes constant
if (status === 'active') { }
if ('pending' === status) { }
if (count > 0) { }
if (10 < count) { }

// Good: Always variable on left
if (status === 'active') { }
if (status === 'pending') { }
if (count > 0) { }
if (count < 10) { }
```

## 3) Cohesion

### Group Code That Changes Together

```tsx
// Bad: Validation scattered
// validators/email.ts
export const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// validators/phone.ts
export const phoneRegex = /^\d{3}-\d{4}-\d{4}$/;

// components/SignupForm.tsx
import { emailRegex } from '../validators/email';
import { phoneRegex } from '../validators/phone';

// Good: Colocate with feature
// features/signup/validation.ts
export const signupValidation = {
  email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  phone: /^\d{3}-\d{4}-\d{4}$/,
};
```

### Split Mutually Exclusive UI

```tsx
// Bad: One component with many branches
function UserCard({ user }) {
  if (user.type === 'admin') {
    return <div>Admin UI with extra controls...</div>;
  }
  if (user.type === 'guest') {
    return <div>Guest UI with limited access...</div>;
  }
  return <div>Regular user UI...</div>;
}

// Good: Separate components
function AdminCard({ user }) { /* ... */ }
function GuestCard({ user }) { /* ... */ }
function MemberCard({ user }) { /* ... */ }

const UserCardMap = { admin: AdminCard, guest: GuestCard, member: MemberCard };
function UserCard({ user }) {
  const Component = UserCardMap[user.type] ?? MemberCard;
  return <Component user={user} />;
}
```

## 4) Coupling

### Over-generalized Shared Module

```tsx
// Bad: God utility that couples everything
// utils/index.ts
export function formatMoney(n) { }
export function validateEmail(s) { }
export function calculateTax(price, region) { }
export function getUserFullName(user) { }

// Good: Feature-scoped utilities
// features/payment/format.ts
export function formatMoney(n) { }
export function calculateTax(price, region) { }

// features/user/helpers.ts
export function getUserFullName(user) { }
```

### Deep Props Drilling → Composition

```tsx
// Bad: Props drilling through 4 levels
<App user={user}>
  <Layout user={user}>
    <Sidebar user={user}>
      <UserAvatar user={user} />
    </Sidebar>
  </Layout>
</App>

// Good: Composition or context
<App>
  <Layout sidebar={<Sidebar><UserAvatar user={user} /></Sidebar>}>
    {children}
  </Layout>
</App>

// Or use context for truly global data
const user = useUser();
```

### Unfocused Hook

```tsx
// Bad: Hook couples unrelated concerns
function usePageState() {
  const [user, setUser] = useState(null);
  const [cart, setCart] = useState([]);
  const [notifications, setNotifications] = useState([]);
  // Now everything depends on everything
}

// Good: Separate hooks for separate concerns
function useUser() { }
function useCart() { }
function useNotifications() { }
```

## Review Prompts

- Would a new teammate predict behavior without running it?
- If this feature changes next week, what unrelated files also change?
- Is the abstraction reducing repeated change cost, or just moving complexity?
