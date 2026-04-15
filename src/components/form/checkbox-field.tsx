import * as React from "react";
import { useFieldContext } from "#/components/form/form-context";
import { Checkbox } from "@/components/ui/checkbox";
import { Field, FieldLabel } from "@/components/ui/field";

export function CheckboxField({
  label,
  id,
  ...checkboxProps
}: { label: string } & Omit<React.ComponentProps<typeof Checkbox>, "checked" | "onCheckedChange">) {
  const reactId = React.useId();
  const resolvedId = id ?? reactId;
  const field = useFieldContext<boolean>();

  return (
    <Field orientation="horizontal">
      <Checkbox
        id={resolvedId}
        {...checkboxProps}
        checked={field.state.value}
        onCheckedChange={(checked) => field.handleChange(checked)}
      />
      <FieldLabel htmlFor={resolvedId}>{label}</FieldLabel>
    </Field>
  );
}
