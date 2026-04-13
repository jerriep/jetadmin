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

## Vite

When installing packages that bring in transitive CJS dependencies, Vite may silently fail to pre-bundle them. Symptom: hydration dies entirely — clicks work (SSR HTML is fine) but `useEffect` never runs and `console.log` in the render body never appears in the browser console. Fix by adding the offending subpath to `optimizeDeps.include` in `vite.config.ts`, then do a full dev server restart.

Current entries needed for the TanStack hotkeys ecosystem:

```ts
optimizeDeps: {
  include: ['use-sync-external-store/shim/with-selector'],
}
```

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

## Text casing conventions

| Context | Convention | Examples |
|---|---|---|
| Page titles, modal/sheet headings | Title Case | "Edit Alliance", "New Alliance" |
| Table column headers | Sentence case | "Allow in query", "Priority in list" |
| Form field labels | Sentence case | "Allow in query", "Priority in list" |
| Button labels | Sentence case | "New alliance", "Save changes", "Add alliance" |
| Navigation items | Title Case (product feature names) | "Airline Info CMS", "User Management" |
| Badge / status text | Title Case | "Active", "Inactive", "Allow", "Disallow" |
| Validation error messages | Sentence case, no trailing period | "Code is required" |
| Placeholder text | Sentence case | "Search by name or IATA code…" |
