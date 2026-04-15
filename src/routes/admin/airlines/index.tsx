import { useState } from "react";
import { toast } from "sonner";
import { createFileRoute, useNavigate } from "@tanstack/react-router";
import { useQuery, useQueryClient } from "@tanstack/react-query";
import { type ColumnDef, type Updater, type PaginationState, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, Trash2Icon } from "lucide-react";
import { Input } from "@/components/ui/input";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { useConfirm } from "@/components/confirm-dialog";
import { useDebouncedCallback } from "@tanstack/react-pacer";
import {
  type Airline,
  type AirlineSearchParams,
  airlineSearchSchema,
  airlineQueryOptions,
  airlineKeys,
  useDeleteAirlineMutation,
} from "@/services/airlines";
import { AirlineSheet } from "./-edit-sheet";

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  validateSearch: airlineSearchSchema,
  loaderDeps: ({ search }) => ({
    status: search.status,
    page: search.page,
    pageSize: search.pageSize,
    q: search.q,
  }),
  loader: async ({ context: { queryClient }, deps }) => {
    await queryClient.ensureQueryData(airlineQueryOptions.list(deps));
  },
});

function RouteComponent() {
  const queryClient = useQueryClient();
  const { status, page, pageSize, q } = Route.useSearch();
  const navigate = useNavigate();
  const confirm = useConfirm();

  const { data } = useQuery(airlineQueryOptions.list({ status, page, pageSize, q }));
  const rows = data?.rows ?? [];
  const total = data?.total ?? 0;
  const totalPages = Math.ceil(total / pageSize);

  const { mutateAsync: deleteAirline } = useDeleteAirlineMutation();

  const [searchInput, setSearchInput] = useState(q);
  const [sheetAirline, setSheetAirline] = useState<Airline | null>(null);

  const debouncedNavigate = useDebouncedCallback(
    (value: string) =>
      navigate({ to: "/admin/airlines", search: { status, page: 1, pageSize, q: value } }),
    { wait: 300 },
  );

  const columns: ColumnDef<Airline>[] = [
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
      header: "",
      cell: ({ row }) => (
        <div className="flex items-center justify-end gap-1">
          <Button
            variant="outline"
            size="sm"
            onClick={async () => {
              const airlineForEdit = await queryClient.fetchQuery({
                ...airlineQueryOptions.detail(row.original.pk),
                staleTime: 0,
              });
              if (airlineForEdit) {
                setSheetAirline(airlineForEdit);
              } else {
                toast.error("Airline not found. It may have been deleted by another user.");
                queryClient.invalidateQueries({ queryKey: airlineKeys.lists() });
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
              const airlineForDelete = await queryClient.fetchQuery({
                ...airlineQueryOptions.detail(row.original.pk),
                staleTime: 0,
              });
              if (!airlineForDelete) {
                toast.error("Airline not found. It may have been deleted by another user.");
                queryClient.invalidateQueries({ queryKey: airlineKeys.lists() });
                return;
              }
              const confirmed = await confirm({
                title: "Delete airline",
                description: (
                  <>
                    Are you sure you want to delete <strong>{airlineForDelete.name}</strong>? This
                    action cannot be undone.
                  </>
                ),
                confirmLabel: "Delete",
              });
              if (confirmed) {
                await deleteAirline(airlineForDelete.pk);
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
          pageSize: next.pageSize as AirlineSearchParams["pageSize"],
          q,
        },
      });
    },
  });

  return (
    <div className="flex flex-col gap-4">
      <div className="flex items-center gap-4">
        <Tabs
          value={status}
          onValueChange={(value) =>
            navigate({
              to: "/admin/airlines",
              search: { status: value as AirlineSearchParams["status"], page: 1, pageSize, q },
            })
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
          onChange={(e) => {
            setSearchInput(e.target.value);
            debouncedNavigate(e.target.value);
          }}
          className="max-w-xs"
        />
      </div>
      <DataTable table={table} />

      {sheetAirline && (
        <AirlineSheet
          key={sheetAirline.pk}
          airline={sheetAirline}
          open={sheetAirline !== null}
          onOpenChange={(open) => {
            if (!open) setSheetAirline(null);
          }}
        />
      )}
    </div>
  );
}
