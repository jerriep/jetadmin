import { useState, useEffect, type FormEvent } from "react";
import { createFileRoute, useRouter } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc, eq } from "drizzle-orm";
import { type ColumnDef, getCoreRowModel, useReactTable } from "@tanstack/react-table";
import { PencilIcon, Trash2Icon } from "lucide-react";
import { z } from "zod";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";
import { DataTable } from "@/components/data-table";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Field, FieldLabel, FieldError, FieldGroup } from "@/components/ui/field";
import {
  Sheet,
  SheetContent,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";

type Alliance = typeof alliance.$inferSelect;

// ---- Server functions -------------------------------------------------------

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

const allianceFormSchema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  priorityInList: z.boolean(),
});

type AllianceFormData = z.infer<typeof allianceFormSchema>;
type AllianceFormErrors = Partial<Record<keyof AllianceFormData, string>>;

const updateAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string } & AllianceFormData) => data)
  .handler(async ({ data }) => {
    await db
      .update(alliance)
      .set({
        code: data.code,
        name: data.name,
        active: data.active,
        allowInQuery: data.allowInQuery,
        priorityInList: data.priorityInList,
      })
      .where(eq(alliance.pk, data.pk));
  });

// ---- Route ------------------------------------------------------------------

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async () => await getAlliances(),
});

// ---- Edit sheet -------------------------------------------------------------

function toFormData(row: Alliance): AllianceFormData {
  return {
    code: row.code ?? "",
    name: row.name ?? "",
    active: row.active ?? false,
    allowInQuery: row.allowInQuery ?? false,
    priorityInList: row.priorityInList ?? false,
  };
}

function EditAllianceSheet({
  alliance: row,
  open,
  onOpenChange,
  onSaved,
}: {
  alliance: Alliance | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const [formData, setFormData] = useState<AllianceFormData>(() =>
    row ? toFormData(row) : { code: "", name: "", active: false, allowInQuery: false, priorityInList: false }
  );
  const [errors, setErrors] = useState<AllianceFormErrors>({});
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (row) {
      setFormData(toFormData(row));
      setErrors({});
    }
  }, [row]);

  const setField = <K extends keyof AllianceFormData>(key: K, value: AllianceFormData[K]) => {
    setFormData((prev) => ({ ...prev, [key]: value }));
    setErrors((prev) => ({ ...prev, [key]: undefined }));
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    const result = allianceFormSchema.safeParse(formData);
    if (!result.success) {
      const flat = result.error.flatten().fieldErrors;
      setErrors({
        code: flat.code?.[0],
        name: flat.name?.[0],
      });
      return;
    }
    setSaving(true);
    try {
      await updateAlliance({ data: { pk: row!.pk, ...result.data } });
      onSaved();
      onOpenChange(false);
    } finally {
      setSaving(false);
    }
  };

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="flex flex-col p-0">
        <form onSubmit={handleSubmit} className="flex flex-1 flex-col overflow-hidden">
          <SheetHeader className="border-b px-6 py-4">
            <SheetTitle>Edit Alliance</SheetTitle>
          </SheetHeader>

          <div className="flex-1 overflow-y-auto px-6 py-5">
            <FieldGroup>
              <Field data-invalid={!!errors.code || undefined}>
                <FieldLabel htmlFor="alliance-code">Code</FieldLabel>
                <Input
                  id="alliance-code"
                  value={formData.code}
                  onChange={(e) => setField("code", e.target.value)}
                />
                <FieldError errors={errors.code ? [{ message: errors.code }] : []} />
              </Field>

              <Field data-invalid={!!errors.name || undefined}>
                <FieldLabel htmlFor="alliance-name">Name</FieldLabel>
                <Input
                  id="alliance-name"
                  value={formData.name}
                  onChange={(e) => setField("name", e.target.value)}
                />
                <FieldError errors={errors.name ? [{ message: errors.name }] : []} />
              </Field>

              <Field orientation="horizontal">
                <FieldLabel htmlFor="alliance-active">Active</FieldLabel>
                <Switch
                  id="alliance-active"
                  checked={formData.active}
                  onCheckedChange={(checked) => setField("active", checked)}
                />
              </Field>

              <Field orientation="horizontal">
                <FieldLabel htmlFor="alliance-allow-in-query">Allow in Query</FieldLabel>
                <Switch
                  id="alliance-allow-in-query"
                  checked={formData.allowInQuery}
                  onCheckedChange={(checked) => setField("allowInQuery", checked)}
                />
              </Field>

              <Field orientation="horizontal">
                <FieldLabel htmlFor="alliance-priority-in-list">Priority in List</FieldLabel>
                <Switch
                  id="alliance-priority-in-list"
                  checked={formData.priorityInList}
                  onCheckedChange={(checked) => setField("priorityInList", checked)}
                />
              </Field>
            </FieldGroup>
          </div>

          <SheetFooter className="border-t px-6 py-4">
            <Button
              type="button"
              variant="outline"
              onClick={() => onOpenChange(false)}
              disabled={saving}
            >
              Cancel
            </Button>
            <Button type="submit" disabled={saving}>
              {saving ? "Saving…" : "Save changes"}
            </Button>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}

// ---- Page component ---------------------------------------------------------

function RouteComponent() {
  const data = Route.useLoaderData();
  const router = useRouter();
  const [editingAlliance, setEditingAlliance] = useState<Alliance | null>(null);

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
      cell: ({ row }) => (
        <div className="flex items-center justify-end gap-1">
          <Button variant="outline" size="sm" onClick={() => setEditingAlliance(row.original)}>
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

  const table = useReactTable({
    data,
    columns,
    getCoreRowModel: getCoreRowModel(),
  });

  return (
    <>
      <DataTable table={table} mustDisplayFooter={false} />

      <EditAllianceSheet
        alliance={editingAlliance}
        open={editingAlliance !== null}
        onOpenChange={(open) => { if (!open) setEditingAlliance(null); }}
        onSaved={() => router.invalidate()}
      />
    </>
  );
}
