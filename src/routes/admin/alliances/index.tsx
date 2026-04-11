import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import {
  type ColumnDef,
  flexRender,
  getCoreRowModel,
  useReactTable,
} from "@tanstack/react-table";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { BooleanIconCell } from "@/components/table-boolean-icon-cell";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";

type Alliance = typeof alliance.$inferSelect;

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
    cell: ({ getValue }) => <BooleanIconCell value={getValue<boolean | null>()} />,
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
];

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async () => await getAlliances(),
});

function RouteComponent() {
  const data = Route.useLoaderData();

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <Table>
      <TableHeader>
        {table.getHeaderGroups().map((headerGroup) => (
          <TableRow key={headerGroup.id}>
            {headerGroup.headers.map((header) => (
              <TableHead key={header.id}>
                {header.isPlaceholder
                  ? null
                  : flexRender(header.column.columnDef.header, header.getContext())}
              </TableHead>
            ))}
          </TableRow>
        ))}
      </TableHeader>
      <TableBody>
        {table.getRowModel().rows.length > 0 ? (
          table.getRowModel().rows.map((row) => (
            <TableRow key={row.id}>
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
              No alliances found.
            </TableCell>
          </TableRow>
        )}
      </TableBody>
    </Table>
  );
}
