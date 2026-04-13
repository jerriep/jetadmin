import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc, count, eq } from "drizzle-orm";
import { type ColumnDef, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Pagination,
  PaginationContent,
  PaginationItem,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";

type AirlineRow = typeof airline.$inferSelect;
type StatusFilter = "all" | "active" | "inactive";

const PAGE_SIZE = 25;

const getAirlines = createServerFn({ method: "GET" })
  .inputValidator((data: { status: StatusFilter; page: number }) => data)
  .handler(async ({ data: { status, page } }) => {
    const where =
      status === "active"
        ? eq(airline.active, true)
        : status === "inactive"
          ? eq(airline.active, false)
          : undefined;

    const [rows, [{ total }]] = await Promise.all([
      db
        .select()
        .from(airline)
        .where(where)
        .orderBy(asc(airline.name))
        .limit(PAGE_SIZE)
        .offset((page - 1) * PAGE_SIZE),
      db.select({ total: count() }).from(airline).where(where),
    ]);

    return { rows, total };
  });

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  validateSearch: (search): { status: StatusFilter; page: number } => ({
    status: (["all", "active", "inactive"].includes(search.status as string)
      ? search.status
      : "all") as StatusFilter,
    page: typeof search.page === "number" && search.page > 0 ? Math.floor(search.page) : 1,
  }),
  loaderDeps: ({ search }) => ({ status: search.status, page: search.page }),
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
  const { status, page } = Route.useSearch();
  const navigate = useNavigate();
  const totalPages = Math.ceil(total / PAGE_SIZE);

  const table = useReactTable({
    data: rows,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const tableRows = table.getRowModel().rows;

  return (
    <div className="flex flex-col gap-4">
      <Tabs
        value={status}
        onValueChange={(value) =>
          navigate({ to: "/admin/airlines", search: { status: value as StatusFilter, page: 1 } })
        }
      >
        <TabsList>
          <TabsTrigger value="all">All</TabsTrigger>
          <TabsTrigger value="active">Active</TabsTrigger>
          <TabsTrigger value="inactive">Inactive</TabsTrigger>
        </TabsList>
      </Tabs>
      <Table>
        <TableHeader>
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers.map((header) => (
                <TableHead key={header.id} className="whitespace-nowrap">
                  {header.isPlaceholder
                    ? null
                    : flexRender(header.column.columnDef.header, header.getContext())}
                </TableHead>
              ))}
            </TableRow>
          ))}
        </TableHeader>
        <TableBody>
          {tableRows.length > 0 ? (
            tableRows.map((row) => (
              <TableRow key={row.id} className="cursor-pointer">
                {row.getVisibleCells().map((cell) => (
                  <TableCell key={cell.id}>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
              </TableRow>
            ))
          ) : (
            <TableRow>
              <TableCell
                colSpan={columns.length}
                className="py-8 text-center text-muted-foreground"
              >
                No airlines found.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
      </Table>
      {totalPages > 1 && (
        <div className="flex items-center justify-between">
          <p className="text-sm text-muted-foreground">
            Page {page} of {totalPages} ({total} airlines)
          </p>
          <Pagination>
            <PaginationContent>
              <PaginationItem>
                <PaginationPrevious
                  onClick={() =>
                    navigate({ to: "/admin/airlines", search: { status, page: page - 1 } })
                  }
                  aria-disabled={page <= 1}
                  className={page <= 1 ? "pointer-events-none opacity-50" : "cursor-pointer"}
                />
              </PaginationItem>
              <PaginationItem>
                <PaginationNext
                  onClick={() =>
                    navigate({ to: "/admin/airlines", search: { status, page: page + 1 } })
                  }
                  aria-disabled={page >= totalPages}
                  className={page >= totalPages ? "pointer-events-none opacity-50" : "cursor-pointer"}
                />
              </PaginationItem>
            </PaginationContent>
          </Pagination>
        </div>
      )}
    </div>
  );
}
