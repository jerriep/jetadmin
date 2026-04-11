import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { type ColumnDef, flexRender, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { useHotkey } from "@tanstack/react-hotkeys";
import { useEffect, useRef, useState } from "react";
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
      <BooleanBadgeCell
        value={getValue<boolean | null>()}
        trueLabel="Allow"
        falseLabel="Disallow"
      />
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
  const [selectedIndex, setSelectedIndex] = useState<number | null>(null);
  const rowRefs = useRef<Array<HTMLTableRowElement | null>>([]);

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const rows = table.getRowModel().rows;

  useHotkey("ArrowDown", () => {
    setSelectedIndex((prev) => {
      if (prev === null) return 0;
      return Math.min(prev + 1, rows.length - 1);
    });
  });

  useHotkey("ArrowUp", () => {
    setSelectedIndex((prev) => {
      if (prev === null) return 0;
      return Math.max(prev - 1, 0);
    });
  });

  useHotkey("Escape", () => {
    setSelectedIndex(null);
  });

  useEffect(() => {
    if (selectedIndex !== null) {
      rowRefs.current[selectedIndex]?.scrollIntoView({ block: "nearest" });
    }
  }, [selectedIndex]);

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
        {rows.length > 0 ? (
          rows.map((row, index) => (
            <TableRow
              key={row.id}
              ref={(el) => { rowRefs.current[index] = el; }}
              data-selected={selectedIndex === index}
              className="cursor-pointer data-[selected=true]:bg-muted"
              onClick={() => setSelectedIndex(index)}
            >
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
