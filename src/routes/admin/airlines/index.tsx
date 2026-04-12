import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
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

type AirlineRow = typeof airline.$inferSelect;

const getAirlines = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(airline).orderBy(asc(airline.name));
});

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  loader: async () => await getAirlines(),
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
      <span className="tabular-nums text-muted-foreground">
        {getValue<string | null>() ?? "—"}
      </span>
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

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const rows = table.getRowModel().rows;

  return (
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
            <TableCell colSpan={columns.length} className="py-8 text-center text-muted-foreground">
              No airlines found.
            </TableCell>
          </TableRow>
        )}
      </TableBody>
    </Table>
  );
}
