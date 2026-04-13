import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { type ColumnDef, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, Trash2Icon } from "lucide-react";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Button } from "@/components/ui/button";

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
    header: "",
    cell: () => (
      <div className="flex items-center justify-end gap-1">
        <Button variant="outline" size="sm">
          <PencilIcon className="size-4 shrink-0" />
          Edit
        </Button>
        <Button
          variant="outline"
          size="icon-sm"
          aria-label="Delete"
          className="border-destructive/50 text-destructive hover:bg-destructive/10 hover:text-destructive"
        >
          <Trash2Icon className="size-4 shrink-0" />
        </Button>
      </div>
    ),
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
