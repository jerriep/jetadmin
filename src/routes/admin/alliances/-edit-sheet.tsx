import { useAppForm } from "#/components/form/form";
import { Button } from "@/components/ui/button";
import { FieldGroup, FieldLegend, FieldSeparator, FieldSet } from "@/components/ui/field";
import { Sheet, SheetContent, SheetFooter, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import {
  type Alliance,
  allianceFormSchema,
  useCreateAllianceMutation,
  useUpdateAllianceMutation,
} from "@/services/alliances";

export type { Alliance };

// ---- Component --------------------------------------------------------------

export function AllianceSheet({
  alliance,
  open,
  onOpenChange,
}: {
  alliance: Alliance | null;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const isEditing = alliance !== null;

  const { mutateAsync: createAlliance } = useCreateAllianceMutation();
  const { mutateAsync: updateAlliance } = useUpdateAllianceMutation();

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
      if (isEditing) {
        await updateAlliance({ pk: alliance.pk, values: value });
      } else {
        await createAlliance(value);
      }
      onOpenChange(false);
    },
  });

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="flex flex-col p-0">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            form.handleSubmit();
          }}
          className="flex flex-1 flex-col overflow-hidden"
        >
          <SheetHeader className="border-b px-6 py-4">
            <SheetTitle>{isEditing ? "Edit Alliance" : "New Alliance"}</SheetTitle>
          </SheetHeader>

          <div className="flex-1 overflow-y-auto px-6 py-5">
            <FieldGroup>
              <FieldSet>
                <form.AppField name="code">
                  {(field) => <field.InputField label="Code" id="alliance-code" />}
                </form.AppField>
                <form.AppField name="name">
                  {(field) => <field.InputField label="Name" id="alliance-name" />}
                </form.AppField>
              </FieldSet>
              <FieldSeparator />
              <FieldSet>
                <FieldLegend>Settings</FieldLegend>
                <FieldGroup className="gap-3">
                  <form.AppField name="active">
                    {(field) => <field.CheckboxField label="Active" id="alliance-active" />}
                  </form.AppField>
                  <form.AppField name="allowInQuery">
                    {(field) => (
                      <field.CheckboxField label="Allow in query" id="alliance-allow-in-query" />
                    )}
                  </form.AppField>
                  <form.AppField name="priorityInList">
                    {(field) => (
                      <field.CheckboxField
                        label="Priority in list"
                        id="alliance-priority-in-list"
                      />
                    )}
                  </form.AppField>
                </FieldGroup>
              </FieldSet>
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
                    {isSubmitting ? "Saving…" : isEditing ? "Save changes" : "Add alliance"}
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
