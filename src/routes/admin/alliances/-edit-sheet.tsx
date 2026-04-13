import { useState, useEffect, type FormEvent } from "react";
import { createServerFn } from "@tanstack/react-start";
import { eq } from "drizzle-orm";
import { z } from "zod";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
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

export type Alliance = typeof alliance.$inferSelect;

const allianceFormSchema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  priorityInList: z.boolean(),
});

type AllianceFormData = z.infer<typeof allianceFormSchema>;
type FormErrors = Partial<Record<keyof AllianceFormData, string>>;

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

function toFormData(row: Alliance): AllianceFormData {
  return {
    code: row.code ?? "",
    name: row.name ?? "",
    active: row.active ?? false,
    allowInQuery: row.allowInQuery ?? false,
    priorityInList: row.priorityInList ?? false,
  };
}

export function EditAllianceSheet({
  alliance,
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
    alliance ? toFormData(alliance) : { code: "", name: "", active: false, allowInQuery: false, priorityInList: false }
  );
  const [errors, setErrors] = useState<FormErrors>({});
  const [saving, setSaving] = useState(false);

  useEffect(() => {
    if (alliance) {
      setFormData(toFormData(alliance));
      setErrors({});
    }
  }, [alliance]);

  const setField = <K extends keyof AllianceFormData>(key: K, value: AllianceFormData[K]) => {
    setFormData((prev) => ({ ...prev, [key]: value }));
    setErrors((prev) => ({ ...prev, [key]: undefined }));
  };

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    const result = allianceFormSchema.safeParse(formData);
    if (!result.success) {
      const flat = result.error.flatten().fieldErrors;
      setErrors({ code: flat.code?.[0], name: flat.name?.[0] });
      return;
    }
    setSaving(true);
    try {
      await updateAlliance({ data: { pk: alliance!.pk, ...result.data } });
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
