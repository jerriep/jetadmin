import { createServerFn } from "@tanstack/react-start";
import { eq } from "drizzle-orm";
import { z } from "zod";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import { useAppForm } from "#/components/form/form";
import { Button } from "@/components/ui/button";
import { FieldGroup } from "@/components/ui/field";
import {
  Sheet,
  SheetContent,
  SheetFooter,
  SheetHeader,
  SheetTitle,
} from "@/components/ui/sheet";

export type Alliance = typeof alliance.$inferSelect;

// ---- Validation schema ------------------------------------------------------

const allianceFormSchema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  priorityInList: z.boolean(),
});

// ---- Server function --------------------------------------------------------

const updateAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: {
    pk: string;
    code: string;
    name: string;
    active: boolean;
    allowInQuery: boolean;
    priorityInList: boolean;
  }) => data)
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

// ---- Component --------------------------------------------------------------

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
  const form = useAppForm({
    validators: {
      onChange: allianceFormSchema,
    },
    defaultValues: {
      code: alliance?.code ?? "",
      name: alliance?.name ?? "",
      active: alliance?.active ?? false,
      allowInQuery: alliance?.allowInQuery ?? false,
      priorityInList: alliance?.priorityInList ?? false,
    },
    onSubmit: async ({ value }) => {
      await updateAlliance({ data: { pk: alliance!.pk, ...value } });
      onSaved();
      onOpenChange(false);
    },
  });

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="flex flex-col p-0">
        <form
          onSubmit={(e) => { e.preventDefault(); form.handleSubmit(); }}
          className="flex flex-1 flex-col overflow-hidden"
        >
          <SheetHeader className="border-b px-6 py-4">
            <SheetTitle>Edit Alliance</SheetTitle>
          </SheetHeader>

          <div className="flex-1 overflow-y-auto px-6 py-5">
            <FieldGroup>
              <form.AppField name="code">
                {(field) => <field.InputField label="Code" id="alliance-code" />}
              </form.AppField>

              <form.AppField name="name">
                {(field) => <field.InputField label="Name" id="alliance-name" />}
              </form.AppField>

              <form.AppField name="active">
                {(field) => <field.CheckboxField label="Active" id="alliance-active" />}
              </form.AppField>

              <form.AppField name="allowInQuery">
                {(field) => <field.CheckboxField label="Allow in Query" id="alliance-allow-in-query" />}
              </form.AppField>

              <form.AppField name="priorityInList">
                {(field) => <field.CheckboxField label="Priority in List" id="alliance-priority-in-list" />}
              </form.AppField>
            </FieldGroup>
          </div>

          <SheetFooter className="border-t px-6 py-4">
            <form.Subscribe selector={(state) => state.isSubmitting}>
              {(isSubmitting) => (
                <>
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => onOpenChange(false)}
                    disabled={isSubmitting}
                  >
                    Cancel
                  </Button>
                  <Button type="submit" disabled={isSubmitting}>
                    {isSubmitting ? "Saving…" : "Save changes"}
                  </Button>
                </>
              )}
            </form.Subscribe>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
