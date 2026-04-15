import { useQuery } from "@tanstack/react-query";
import { useAppForm } from "#/components/form/form";
import { Button } from "@/components/ui/button";
import { FieldGroup, FieldLegend, FieldSeparator, FieldSet } from "@/components/ui/field";
import { Sheet, SheetContent, SheetFooter, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import {
  type Airline,
  airlineFormSchema,
  useUpdateAirlineMutation,
} from "@/services/airlines";
import { allianceQueryOptions } from "@/services/alliances";

export type { Airline };

// ---- Component --------------------------------------------------------------

export function AirlineSheet({
  airline: airlineData,
  open,
  onOpenChange,
}: {
  airline: Airline;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const { data: alliances = [] } = useQuery(allianceQueryOptions.list());

  const allianceOptions = alliances
    .filter((a): a is typeof a & { name: string } => a.name !== null)
    .map((a) => ({ value: a.pk, label: a.name }));

  const { mutateAsync: updateAirline } = useUpdateAirlineMutation();

  const form = useAppForm({
    validators: {
      onChange: airlineFormSchema,
    },
    defaultValues: {
      code: airlineData.code ?? "",
      name: airlineData.name ?? "",
      code3: airlineData.code3 ?? "",
      allianceFk: airlineData.allianceFk ?? null,
      active: airlineData.active,
      allowInQuery: airlineData.allowInQuery,
      allowInSearchResult: airlineData.allowInSearchResult,
      allowInCombinationInSearchResult: airlineData.allowInCombinationInSearchResult,
      priorityInList: airlineData.priorityInList,
    },
    onSubmit: async ({ value }) => {
      await updateAirline({ pk: airlineData.pk, values: value });
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
            <SheetTitle>Edit Airline</SheetTitle>
          </SheetHeader>

          <div className="flex-1 overflow-y-auto px-6 py-5">
            <FieldGroup>
              <FieldSet>
                <form.AppField name="code">
                  {(field) => <field.InputField label="IATA code" id="airline-code" />}
                </form.AppField>
                <form.AppField name="name">
                  {(field) => <field.InputField label="Name" id="airline-name" />}
                </form.AppField>
                <form.AppField name="code3">
                  {(field) => <field.InputField label="ICAO code" id="airline-code3" />}
                </form.AppField>
                <form.AppField name="allianceFk">
                  {(field) => (
                    <field.SelectField
                      label="Alliance"
                      id="airline-alliance"
                      options={allianceOptions}
                      placeholder="No alliance"
                      nullable
                    />
                  )}
                </form.AppField>
              </FieldSet>
              <FieldSeparator />
              <FieldSet>
                <FieldLegend>Settings</FieldLegend>
                <FieldGroup className="gap-3">
                  <form.AppField name="active">
                    {(field) => <field.CheckboxField label="Active" id="airline-active" />}
                  </form.AppField>
                  <form.AppField name="allowInQuery">
                    {(field) => (
                      <field.CheckboxField label="Allow in query" id="airline-allow-in-query" />
                    )}
                  </form.AppField>
                  <form.AppField name="allowInSearchResult">
                    {(field) => (
                      <field.CheckboxField
                        label="Allow in search result"
                        id="airline-allow-in-search-result"
                      />
                    )}
                  </form.AppField>
                  <form.AppField name="allowInCombinationInSearchResult">
                    {(field) => (
                      <field.CheckboxField
                        label="Allow in combination in search result"
                        id="airline-allow-in-combination"
                      />
                    )}
                  </form.AppField>
                  <form.AppField name="priorityInList">
                    {(field) => (
                      <field.CheckboxField label="Priority in list" id="airline-priority-in-list" />
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
