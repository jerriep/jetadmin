import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc, count } from "drizzle-orm";
import { type ColumnDef, type Updater, type PaginationState, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { z } from "zod";
import { pageSizeSchema } from "@/schemas/filters";

const searchSchema = z.object({
  page: z.number().int().positive().default(1),
  pageSize: pageSizeSchema.default(25),
});

type SearchParams = z.infer<typeof searchSchema>;
type Alliance = typeof alliance.$inferSelect;

const getAlliances = createServerFn({ method: "GET" })
  .inputValidator((data: SearchParams) => data)
  .handler(async ({ data: { page, pageSize } }) => {
    const [rows, [{ total }]] = await Promise.all([
      db.select().from(alliance).orderBy(asc(alliance.name)).limit(pageSize).offset((page - 1) * pageSize),
      db.select({ total: count() }).from(alliance),
    ]);
    return { rows, total };
  });

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  validateSearch: searchSchema,
  loaderDeps: ({ search }) => ({ page: search.page, pageSize: search.pageSize }),
  loader: async ({ deps }) => await getAlliances({ data: deps }),
});

const columns: ColumnDef<Alliance>[] = [
  {
    accessorKey: "code",
    header: "Code",
  },
  {
    accessorKey: "name",
    header: "Name",
  },
  {
    accessorKey: "active",
    header: "Active",
    cell: ({ getValue }) => (
      <BooleanBadgeCell value={getValue<boolean | null>()} trueLabel="Active" falseLabel="Inactive" />
    ),
  },
  {
    accessorKey: "allowInQuery",
    header: "Allow in Query",
    cell: ({ getValue }) => (
      <BooleanBadgeCell value={getValue<boolean | null>()} trueLabel="Allow" falseLabel="Disallow" />
    ),
  },
  {
    accessorKey: "priorityInList",
    header: "Priority in List",
    cell: ({ getValue }) => <BooleanBadgeCell value={getValue<boolean | null>()} />,
  },
  {
    id: "actions",
    header: () => null,
    cell: () => <ChevronRightIcon className="size-4 text-muted-foreground" />,
  },
];

function RouteComponent() {
  const { rows, total } = Route.useLoaderData();
  const { page, pageSize } = Route.useSearch();
  const navigate = useNavigate();
  const totalPages = Math.ceil(total / pageSize);

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
        to: "/admin/alliances",
        search: {
          page: next.pageIndex + 1,
          pageSize: next.pageSize as SearchParams["pageSize"],
        },
      });
    },
  });

  return <DataTable table={table} />;
}
