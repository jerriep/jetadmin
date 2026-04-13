import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc, eq } from "drizzle-orm";
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
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";

type AirlineRow = typeof airline.$inferSelect;
type StatusFilter = "all" | "active" | "inactive";

const getAirlines = createServerFn({ method: "GET" })
  .inputValidator((data: { status: StatusFilter }) => data)
  .handler(async ({ data: { status } }) => {
    return await db
      .select()
      .from(airline)
      .where(
        status === "active"
          ? eq(airline.active, true)
          : status === "inactive"
            ? eq(airline.active, false)
            : undefined,
      )
      .orderBy(asc(airline.name));
  });

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  validateSearch: (search): { status: StatusFilter } => ({
    status: (["all", "active", "inactive"].includes(search.status as string)
      ? search.status
      : "all") as StatusFilter,
  }),
  loaderDeps: ({ search }) => ({ status: search.status }),
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
  const data = Route.useLoaderData();
  const { status } = Route.useSearch();
  const navigate = useNavigate();

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const rows = table.getRowModel().rows;

  return (
    <div className="flex flex-col gap-4">
      <Tabs
        value={status}
        onValueChange={(value) =>
          navigate({ to: "/admin/airlines", search: { status: value as StatusFilter } })
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
          {rows.length > 0 ? (
            rows.map((row) => (
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
    </div>
  );
}
