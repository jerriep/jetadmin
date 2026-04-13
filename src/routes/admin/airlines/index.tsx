import { useState } from "react";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { and, asc, count, eq, ilike, or } from "drizzle-orm";
import { type ColumnDef, type Updater, type PaginationState, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import { Input } from "@/components/ui/input";
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { z } from "zod";
import { activeStatusFilterSchema, pageSizeSchema } from "@/schemas/filters";
import { useDebouncedCallback } from "@tanstack/react-pacer";

const searchSchema = z.object({
  status: activeStatusFilterSchema.default("all"),
  page: z.number().int().positive().default(1),
  pageSize: pageSizeSchema.default(25),
  q: z.string().default(""),
});

type SearchParams = z.infer<typeof searchSchema>;
type AirlineRow = typeof airline.$inferSelect;

const getAirlines = createServerFn({ method: "GET" })
  .inputValidator((data: SearchParams) => data)
  .handler(async ({ data: { status, page, pageSize, q } }) => {
    const statusFilter =
      status === "active"
        ? eq(airline.active, true)
        : status === "inactive"
          ? eq(airline.active, false)
          : undefined;

    const searchFilter = q
      ? or(ilike(airline.name, `%${q}%`), ilike(airline.code, `%${q}%`))
      : undefined;

    const where = and(statusFilter, searchFilter);

    const [rows, [{ total }]] = await Promise.all([
      db
        .select()
        .from(airline)
        .where(where)
        .orderBy(asc(airline.name))
        .limit(pageSize)
        .offset((page - 1) * pageSize),
      db.select({ total: count() }).from(airline).where(where),
    ]);

    return { rows, total };
  });

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  validateSearch: searchSchema,
  loaderDeps: ({ search }) => ({
    status: search.status,
    page: search.page,
    pageSize: search.pageSize,
    q: search.q,
  }),
  loader: async ({ deps }) => await getAirlines({ data: deps }),
});

const columns: ColumnDef<AirlineRow>[] = [
  {
    id: "logo",
    header: () => null,
    cell: ({ row }) => (
      <img
        src={`https://www.jetabroad.com.au/assets/airlines/logos/${row.original.code}.svg`}
        alt={row.original.name ?? row.original.code ?? ""}
        className="size-8 object-contain"
      />
    ),
  },
  {
    accessorKey: "code",
    header: "IATA",
    cell: ({ getValue }) => (
      <span className="tabular-nums text-muted-foreground">{getValue<string | null>() ?? "—"}</span>
    ),
  },
  {
    accessorKey: "name",
    header: "Name",
  },
  {
    accessorKey: "active",
    header: "Active",
    cell: ({ getValue }) => (
      <BooleanBadgeCell value={getValue<boolean>()} trueLabel="Active" falseLabel="Inactive" />
    ),
  },
  {
    id: "actions",
    header: () => null,
    cell: () => <ChevronRightIcon className="size-4 text-muted-foreground" />,
  },
];


function RouteComponent() {
  const { rows, total } = Route.useLoaderData();
  const { status, page, pageSize, q } = Route.useSearch();
  const navigate = useNavigate();
  const totalPages = Math.ceil(total / pageSize);

  const [searchInput, setSearchInput] = useState(q);

  const debouncedNavigate = useDebouncedCallback(
    (value: string) =>
      navigate({ to: "/admin/airlines", search: { status, page: 1, pageSize, q: value } }),
    { wait: 300 },
  );

  const table = useReactTable({
    data: rows,
    columns,
    getCoreRowModel: getCoreRowModel(),
    manualPagination: true,
    pageCount: totalPages,
    state: {
      pagination: { pageIndex: page - 1, pageSize },
    },
    onPaginationChange: (updater: Updater<PaginationState>) => {
      const prev = { pageIndex: page - 1, pageSize };
      const next = typeof updater === "function" ? updater(prev) : updater;
      navigate({
        to: "/admin/airlines",
        search: {
          status,
          page: next.pageIndex + 1,
          pageSize: next.pageSize as SearchParams["pageSize"],
          q,
        },
      });
    },
  });

  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-center gap-4">
        <Tabs
          value={status}
          onValueChange={(value) =>
            navigate({ to: "/admin/airlines", search: { status: value as SearchParams["status"], page: 1, pageSize, q } })
          }
        >
          <TabsList>
            <TabsTrigger value="all">All</TabsTrigger>
            <TabsTrigger value="active">Active</TabsTrigger>
            <TabsTrigger value="inactive">Inactive</TabsTrigger>
          </TabsList>
        </Tabs>
        <Input
          placeholder="Search by name or IATA code…"
          value={searchInput}
          onChange={(e) => { setSearchInput(e.target.value); debouncedNavigate(e.target.value); }}
          className="max-w-xs"
        />
      </div>
      <DataTable table={table} />
    </div>
  );
}
