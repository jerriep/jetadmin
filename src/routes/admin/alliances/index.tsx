import { useState } from "react";
import { toast } from "sonner";
import { createFileRoute } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { type ColumnDef, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, PlusIcon, Trash2Icon } from "lucide-react";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Button } from "@/components/ui/button";
import { useConfirm } from "@/components/confirm-dialog";
import {
  type Alliance,
  allianceQueryOptions,
  allianceKeys,
  getAlliance,
  useDeleteAllianceMutation,
} from "@/services/alliances";
import { AllianceSheet } from "./-edit-sheet";

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async ({ context: { queryClient } }) => {
    await queryClient.ensureQueryData(allianceQueryOptions.list());
  },
});

function RouteComponent() {
  const queryClient = useQueryClient();
  const confirm = useConfirm();
  const { data: alliances = [] } = useQuery(allianceQueryOptions.list());
  const deleteAlliance = useDeleteAllianceMutation();

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
              const allianceForEdit = await queryClient.fetchQuery(
                allianceQueryOptions.detail(row.original.pk),
              );
              if (allianceForEdit) {
                setSheetAlliance(allianceForEdit);
              } else {
                toast.error("Alliance not found. It may have been deleted by another user.");
                queryClient.invalidateQueries({ queryKey: allianceKeys.lists() });
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
                queryClient.invalidateQueries({ queryKey: allianceKeys.lists() });
                return;
              }
              const confirmed = await confirm({
                title: "Delete alliance",
                description: (
                  <>
                    Are you sure you want to delete <strong>{allianceForDelete.name}</strong>? This
                    action cannot be undone.
                  </>
                ),
                confirmLabel: "Delete",
              });
              if (confirmed) {
                await deleteAlliance.mutateAsync(allianceForDelete.pk);
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
    data: alliances,
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
        onOpenChange={(open) => {
          if (!open) setSheetAlliance(null);
        }}
      />
    </>
  );
}
