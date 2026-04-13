import { useState } from "react";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { and, asc, count, eq, ilike, or } from "drizzle-orm";
import { type ColumnDef, type Row, type Updater, type PaginationState, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import {
  Table,
  TableBody,
  TableCell,
  TableFooter,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { Field, FieldLabel } from "@/components/ui/field";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { Input } from "@/components/ui/input";
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { z } from "zod";
import { activeStatusFilterSchema, PAGE_SIZES, pageSizeSchema } from "@/schemas/filters";
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

function getPageNumbers(page: number, totalPages: number): (number | "ellipsis")[] {
  if (totalPages <= 7) return Array.from({ length: totalPages }, (_, i) => i + 1);
  if (page <= 4) return [1, 2, 3, 4, 5, "ellipsis", totalPages];
  if (page >= totalPages - 3) return [1, "ellipsis", totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
  return [1, "ellipsis", page - 1, page, page + 1, "ellipsis", totalPages];
}

function TableSection({ table, tableRows, columns }: {
  table: ReturnType<typeof useReactTable<AirlineRow>>;
  tableRows: Row<AirlineRow>[];
  columns: ColumnDef<AirlineRow>[];
}) {
  const { pageIndex, pageSize } = table.getState().pagination;
  const page = pageIndex + 1;
  const totalPages = table.getPageCount();

  return (
    <div className="overflow-hidden rounded-lg border">
      <Table>
        <TableHeader className="bg-muted">
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers.map((header) => (
                <TableHead key={header.id}>
                  {header.isPlaceholder ? null : flexRender(header.column.columnDef.header, header.getContext())}
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
              <TableCell colSpan={columns.length} className="py-8 text-center text-muted-foreground">
                No airlines found.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
        <TableFooter>
          <TableRow>
            <TableCell colSpan={columns.length} className="bg-background px-4 py-2">
              <div className="flex items-center justify-between gap-4">
                <Field orientation="horizontal" className="w-fit">
                  <FieldLabel htmlFor="page-size">Rows per page</FieldLabel>
                  <Select value={String(pageSize)} onValueChange={(value) => table.setPageSize(Number(value))}>
                    <SelectTrigger className="w-20" id="page-size"><SelectValue /></SelectTrigger>
                    <SelectContent align="start">
                      <SelectGroup>{PAGE_SIZES.map((size) => <SelectItem key={size} value={String(size)}>{size}</SelectItem>)}</SelectGroup>
                    </SelectContent>
                  </Select>
                </Field>
                <Pagination className="mx-0 w-auto">
                  <PaginationContent>
                    <PaginationItem>
                      <PaginationPrevious onClick={() => table.previousPage()} aria-disabled={!table.getCanPreviousPage()} className={!table.getCanPreviousPage() ? "pointer-events-none opacity-50" : "cursor-pointer"} />
                    </PaginationItem>
                    {getPageNumbers(page, totalPages).map((p, i) =>
                      p === "ellipsis" ? (
                        <PaginationItem key={`ellipsis-${i}`}><PaginationEllipsis /></PaginationItem>
                      ) : (
                        <PaginationItem key={p}>
                          <PaginationLink isActive={p === page} onClick={() => table.setPageIndex(p - 1)} className="cursor-pointer">{p}</PaginationLink>
                        </PaginationItem>
                      )
                    )}
                    <PaginationItem>
                      <PaginationNext onClick={() => table.nextPage()} aria-disabled={!table.getCanNextPage()} className={!table.getCanNextPage() ? "pointer-events-none opacity-50" : "cursor-pointer"} />
                    </PaginationItem>
                  </PaginationContent>
                </Pagination>
              </div>
            </TableCell>
          </TableRow>
        </TableFooter>
      </Table>
    </div>
  );
}

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

  const tableRows = table.getRowModel().rows;

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
      <TableSection table={table} tableRows={tableRows} columns={columns} />
    </div>
  );
}
