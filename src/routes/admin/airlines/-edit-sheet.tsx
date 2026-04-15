import { useEffect, useState } from "react";
import { createServerFn } from "@tanstack/react-start";
import { asc, eq } from "drizzle-orm";
import { z } from "zod";
import { db } from "#/db/index";
import { airline, alliance } from "#/db/schema/schema";
import { useAppForm } from "#/components/form/form";
import { Button } from "@/components/ui/button";
import { FieldGroup, FieldLegend, FieldSeparator, FieldSet } from "@/components/ui/field";
import { Sheet, SheetContent, SheetFooter, SheetHeader, SheetTitle } from "@/components/ui/sheet";

export type Airline = typeof airline.$inferSelect;
export type AllianceOption = { pk: string; name: string | null };

// ---- Validation schema ------------------------------------------------------

const airlineFormSchema = z.object({
  code: z.string().min(1, "IATA code is required"),
  name: z.string().min(1, "Name is required"),
  code3: z.string(),
  allianceFk: z.string().nullable(),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  allowInSearchResult: z.boolean(),
  allowInCombinationInSearchResult: z.boolean(),
  priorityInList: z.boolean(),
});

type AirlineFormValues = z.infer<typeof airlineFormSchema>;

// ---- Server functions -------------------------------------------------------

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db
    .select({ pk: alliance.pk, name: alliance.name })
    .from(alliance)
    .orderBy(asc(alliance.name));
});

const updateAirline = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string } & AirlineFormValues) => data)
  .handler(async ({ data: { pk, code3, ...values } }) => {
    await db
      .update(airline)
      .set({ ...values, code3: code3 || null })
      .where(eq(airline.pk, pk));
  });

// ---- Component --------------------------------------------------------------

export function AirlineSheet({
  airline: airlineData,
  open,
  onOpenChange,
  onSaved,
}: {
  airline: Airline;
  open: boolean;
  onOpenChange: (open: boolean) => void;
  onSaved: () => void;
}) {
  const [alliances, setAlliances] = useState<AllianceOption[]>([]);

  useEffect(() => {
    getAlliances().then(setAlliances);
  }, []);

  const allianceOptions = alliances
    .filter((a): a is { pk: string; name: string } => a.name !== null)
    .map((a) => ({ value: a.pk, label: a.name }));

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
      await updateAirline({ data: { pk: airlineData.pk, ...value } });
      onSaved();
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
