import { useState } from "react";
import { toast } from "sonner";
import { createFileRoute, useRouter } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc, eq } from "drizzle-orm";
import { type ColumnDef, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, PlusIcon, Trash2Icon } from "lucide-react";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Button } from "@/components/ui/button";
import { useConfirm } from "@/components/confirm-dialog";
import { type Alliance, AllianceSheet } from "./-edit-sheet";

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

const getAlliance = createServerFn({ method: "GET" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    const result = await db.select().from(alliance).where(eq(alliance.pk, pk)).limit(1);
    return result[0] ?? null;
  });

const deleteAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    await db.delete(alliance).where(eq(alliance.pk, pk));
  });

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async () => await getAlliances(),
});

function RouteComponent() {
  const data = Route.useLoaderData();
  const router = useRouter();
  const confirm = useConfirm();

  // null = closed, "new" = create mode, Alliance = edit mode
  const [sheetAlliance, setSheetAlliance] = useState<Alliance | "new" | null>(null);

  const columns: ColumnDef<Alliance>[] = [
    { accessorKey: "code", header: "Code" },
    { accessorKey: "name", header: "Name" },
    {
      accessorKey: "active",
      header: "Active",
      cell: ({ getValue }) => (
        <BooleanBadgeCell value={getValue<boolean | null>()} trueLabel="Active" falseLabel="Inactive" />
      ),
    },
    {
      accessorKey: "allowInQuery",
      header: "Allow in query",
      cell: ({ getValue }) => (
        <BooleanBadgeCell value={getValue<boolean | null>()} trueLabel="Allowed" falseLabel="Not allowed" />
      ),
    },
    {
      accessorKey: "priorityInList",
      header: "Priority in list",
      cell: ({ getValue }) => <BooleanBadgeCell value={getValue<boolean | null>()} />,
    },
    {
      id: "actions",
      header: "",
      cell: ({ row }) => (
        <div className="flex items-center justify-end gap-1">
          <Button
            variant="outline"
            size="sm"
            onClick={async () => {
              const allianceForEdit = await getAlliance({ data: { pk: row.original.pk } });
              if (allianceForEdit) {
                setSheetAlliance(allianceForEdit);
              } else {
                toast.error("Alliance not found. It may have been deleted by another user.");
                router.invalidate();
              }
            }}
          >
            <PencilIcon className="size-4 shrink-0" />
            Edit
          </Button>
          <Button
            variant="outline"
            size="icon-sm"
            aria-label="Delete"
            className="border-destructive/50 text-destructive hover:bg-destructive/10 hover:text-destructive"
            onClick={async () => {
              const allianceForDelete = await getAlliance({ data: { pk: row.original.pk } });
              if (!allianceForDelete) {
                toast.error("Alliance not found. It may have been deleted by another user.");
                router.invalidate();
                return;
              }
              const confirmed = await confirm({
                title: "Delete alliance",
                description: <>Are you sure you want to delete <strong>{allianceForDelete.name}</strong>? This action cannot be undone.</>,
                confirmLabel: "Delete",
              });
              if (confirmed) {
                await deleteAlliance({ data: { pk: allianceForDelete.pk } });
                router.invalidate();
              }
            }}
          >
            <Trash2Icon className="size-4 shrink-0" />
          </Button>
        </div>
      ),
    },
  ];

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  const selectedAlliance = sheetAlliance === "new" ? null : sheetAlliance;

  return (
    <>
      <div className="flex justify-end">
        <Button onClick={() => setSheetAlliance("new")}>
          <PlusIcon className="size-4 shrink-0" />
          New alliance
        </Button>
      </div>

      <DataTable table={table} mustDisplayFooter={false} />

      <AllianceSheet
        key={sheetAlliance === "new" ? "new" : (sheetAlliance?.pk ?? "")}
        alliance={selectedAlliance}
        open={sheetAlliance !== null}
        onOpenChange={(open) => { if (!open) setSheetAlliance(null); }}
        onSaved={() => router.invalidate()}
      />
    </>
  );
}
