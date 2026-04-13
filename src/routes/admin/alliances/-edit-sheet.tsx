import { createServerFn } from "@tanstack/react-start";
import { useForm } from "@tanstack/react-form";
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
  const form = useForm({
    defaultValues: {
      code: alliance?.code ?? "",
      name: alliance?.name ?? "",
      active: alliance?.active ?? false,
      allowInQuery: alliance?.allowInQuery ?? false,
      priorityInList: alliance?.priorityInList ?? false,
    },
    validators: {
      onChange: allianceFormSchema,
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

              <form.Field name="code">
                {(field) => (
                  <Field data-invalid={field.state.meta.isTouched && field.state.meta.errors.length > 0 || undefined}>
                    <FieldLabel htmlFor="alliance-code">Code</FieldLabel>
                    <Input
                      id="alliance-code"
                      value={field.state.value}
                      onChange={(e) => field.handleChange(e.target.value)}
                      onBlur={field.handleBlur}
                    />
                    {field.state.meta.isTouched && (
                      <FieldError errors={field.state.meta.errors.map((e) => ({ message: (e as { message: string }).message }))} />
                    )}
                  </Field>
                )}
              </form.Field>

              <form.Field name="name">
                {(field) => (
                  <Field data-invalid={field.state.meta.isTouched && field.state.meta.errors.length > 0 || undefined}>
                    <FieldLabel htmlFor="alliance-name">Name</FieldLabel>
                    <Input
                      id="alliance-name"
                      value={field.state.value}
                      onChange={(e) => field.handleChange(e.target.value)}
                      onBlur={field.handleBlur}
                    />
                    {field.state.meta.isTouched && (
                      <FieldError errors={field.state.meta.errors.map((e) => ({ message: (e as { message: string }).message }))} />
                    )}
                  </Field>
                )}
              </form.Field>

              <form.Field name="active">
                {(field) => (
                  <Field orientation="horizontal">
                    <FieldLabel htmlFor="alliance-active">Active</FieldLabel>
                    <Switch
                      id="alliance-active"
                      checked={field.state.value}
                      onCheckedChange={(checked) => field.handleChange(checked)}
                    />
                  </Field>
                )}
              </form.Field>

              <form.Field name="allowInQuery">
                {(field) => (
                  <Field orientation="horizontal">
                    <FieldLabel htmlFor="alliance-allow-in-query">Allow in Query</FieldLabel>
                    <Switch
                      id="alliance-allow-in-query"
                      checked={field.state.value}
                      onCheckedChange={(checked) => field.handleChange(checked)}
                    />
                  </Field>
                )}
              </form.Field>

              <form.Field name="priorityInList">
                {(field) => (
                  <Field orientation="horizontal">
                    <FieldLabel htmlFor="alliance-priority-in-list">Priority in List</FieldLabel>
                    <Switch
                      id="alliance-priority-in-list"
                      checked={field.state.value}
                      onCheckedChange={(checked) => field.handleChange(checked)}
                    />
                  </Field>
                )}
              </form.Field>

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
