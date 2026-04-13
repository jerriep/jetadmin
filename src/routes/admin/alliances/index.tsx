import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { type ColumnDef, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { ChevronRightIcon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";

type Alliance = typeof alliance.$inferSelect;

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async () => await getAlliances(),
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
  const data = Route.useLoaderData();

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return <DataTable table={table} mustDisplayFooter={false} />;
}
