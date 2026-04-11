# jetadmin — Claude Notes

## Data fetching

Use **TanStack Start server functions + route loaders** for all data access. Do not introduce TanStack Query.

```ts
const getData = createServerFn({ method: "GET" }).handler(async () => { ... });

export const Route = createFileRoute('/admin/...')({
  loader: async () => await getData(),
});

function Component() {
  const data = Route.useLoaderData();
}
```

For **pagination**, use TanStack Router search params (`validateSearch`) — the loader re-runs automatically on param changes and caches per param combination. Only reach for TanStack Query if a specific UX requirement can't be met by the loader pattern.

## Component conventions

### `src/components/ui/`
Reserved for **shadcn components only**. Do not add custom components here.

### `src/components/`
Custom shared components live here.

#### Boolean table cell components
Two variants exist for displaying boolean values in tables — use whichever fits the column:

- `table-boolean-icon-cell.tsx` → `BooleanIconCell` — compact green check / red X icon, good for dense columns
- `table-boolean-badge-cell.tsx` → `BooleanBadgeCell` — green/red pill badge, good for status-like columns

Both accept `boolean | null` and support dark mode. `BooleanBadgeCell` accepts optional `trueLabel`/`falseLabel` props (default: "Yes"/"No").

```tsx
import { BooleanIconCell } from "@/components/table-boolean-icon-cell";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";

<TableCell><BooleanIconCell value={row.active} /></TableCell>
<TableCell><BooleanBadgeCell value={row.allowInQuery} /></TableCell>
```
