# Vercel React/Next Review Rules

## Priority

Review in this order:

1. Remove waterfalls from async work.
2. Reduce client bundle size.
3. Place data fetching at the right boundary.
4. Avoid unstable rerender triggers.

## Checks With Examples

### 1. Sequential Await (Waterfall)

```tsx
// Bad: Sequential fetches (waterfall)
async function Page() {
  const user = await getUser();      // 200ms
  const posts = await getPosts();    // 300ms
  const comments = await getComments(); // 200ms
  // Total: 700ms
}

// Good: Parallel fetches
async function Page() {
  const [user, posts, comments] = await Promise.all([
    getUser(),
    getPosts(),
    getComments(),
  ]);
  // Total: 300ms (longest)
}
```

### 2. Over-broad Client Boundary

```tsx
// Bad: Entire page becomes client bundle
'use client';
export default function ProductPage({ product }) {
  const [qty, setQty] = useState(1);
  return (
    <div>
      <h1>{product.name}</h1>           {/* Static - should be server */}
      <p>{product.description}</p>      {/* Static - should be server */}
      <QuantityPicker value={qty} onChange={setQty} />
    </div>
  );
}

// Good: Only interactive part is client
export default function ProductPage({ product }) {
  return (
    <div>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
      <QuantityPicker />  {/* 'use client' inside this component only */}
    </div>
  );
}
```

### 3. Heavy Dynamic Import

```tsx
// Bad: Always load heavy chart library
import { Chart } from 'chart.js';

// Good: Load only when needed
const Chart = dynamic(() => import('chart.js').then(m => m.Chart), {
  loading: () => <Skeleton />,
  ssr: false,
});
```

### 4. Unstable Props Causing Rerenders

```tsx
// Bad: New object/array every render
<List items={items.filter(x => x.active)} />
<Button style={{ color: 'blue' }} />
<Modal onClose={() => setOpen(false)} />

// Good: Stable references
const activeItems = useMemo(() => items.filter(x => x.active), [items]);
const buttonStyle = useMemo(() => ({ color: 'blue' }), []);
const handleClose = useCallback(() => setOpen(false), []);

<List items={activeItems} />
<Button style={buttonStyle} />
<Modal onClose={handleClose} />
```

### 5. Missing Cache/Revalidation

```tsx
// Bad: No cache strategy
const data = await fetch('/api/products');

// Good: Explicit cache control
const data = await fetch('/api/products', {
  next: { revalidate: 3600 }  // ISR: revalidate every hour
});

// Or for static data
const data = await fetch('/api/config', {
  cache: 'force-cache'
});
```

## PR Comment Pattern

- State observed pattern.
- State user impact (latency, JS shipped, hydration cost).
- Suggest smallest safe change first.
