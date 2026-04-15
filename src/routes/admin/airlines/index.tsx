import { useState } from "react";
import { toast } from "sonner";
import { createFileRoute, useNavigate, useRouter } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { and, asc, count, eq, ilike, or } from "drizzle-orm";
import { type ColumnDef, type Updater, type PaginationState, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, Trash2Icon } from "lucide-react";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import { Input } from "@/components/ui/input";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Tabs, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { Button } from "@/components/ui/button";
import { useConfirm } from "@/components/confirm-dialog";
import { z } from "zod";
import { activeStatusFilterSchema, pageSizeSchema } from "@/schemas/filters";
import { useDebouncedCallback } from "@tanstack/react-pacer";
import { type Airline, AirlineSheet } from "./-edit-sheet";

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

const getAirline = createServerFn({ method: "GET" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    const result = await db.select().from(airline).where(eq(airline.pk, pk)).limit(1);
    return result[0] ?? null;
  });

const deleteAirline = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    await db.delete(airline).where(eq(airline.pk, pk));
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

function RouteComponent() {
  const { rows, total } = Route.useLoaderData();
  const { status, page, pageSize, q } = Route.useSearch();
  const navigate = useNavigate();
  const router = useRouter();
  const confirm = useConfirm();
  const totalPages = Math.ceil(total / pageSize);

  const [searchInput, setSearchInput] = useState(q);
  const [sheetAirline, setSheetAirline] = useState<Airline | null>(null);

  const debouncedNavigate = useDebouncedCallback(
    (value: string) =>
      navigate({ to: "/admin/airlines", search: { status, page: 1, pageSize, q: value } }),
    { wait: 300 },
  );

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
      header: "",
      cell: ({ row }) => (
        <div className="flex items-center justify-end gap-1">
          <Button
            variant="outline"
            size="sm"
            onClick={async () => {
              const airlineForEdit = await getAirline({ data: { pk: row.original.pk } });
              if (airlineForEdit) {
                setSheetAirline(airlineForEdit);
              } else {
                toast.error("Airline not found. It may have been deleted by another user.");
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
              const airlineForDelete = await getAirline({ data: { pk: row.original.pk } });
              if (!airlineForDelete) {
                toast.error("Airline not found. It may have been deleted by another user.");
                router.invalidate();
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
                await deleteAirline({ data: { pk: airlineForDelete.pk } });
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
      <DataTable table={table} />

      {sheetAirline && (
        <AirlineSheet
          key={sheetAirline.pk}
          airline={sheetAirline}
          open={sheetAirline !== null}
          onOpenChange={(open) => { if (!open) setSheetAirline(null); }}
          onSaved={() => router.invalidate()}
        />
      )}
    </div>
  );
}
