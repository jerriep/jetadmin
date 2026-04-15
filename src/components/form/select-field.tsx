import * as React from "react";
import { useFieldContext } from "#/components/form/form-context";
import { Field, FieldLabel } from "@/components/ui/field";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";

type Option = { value: string; label: string };

export function SelectField({
  label,
  id,
  items,
  placeholder,
  nullable = false,
  ...selectProps
}: {
  label: string;
  items: Option[];
  placeholder?: string;
  nullable?: boolean;
} & Omit<React.ComponentProps<typeof Select>, "value" | "onValueChange" | "items" | "children">) {
  const reactId = React.useId();
  const resolvedId = id ?? reactId;
  const field = useFieldContext<string | null>();

  return (
    <Field>
      <FieldLabel htmlFor={resolvedId}>{label}</FieldLabel>
      <Select
        {...selectProps}
        value={field.state.value ?? ""}
        onValueChange={(value) => field.handleChange((value as string) === "" ? null : (value as string))}
        items={items}
      >
        <SelectTrigger id={resolvedId} className="w-full">
          <SelectValue placeholder={placeholder ?? "Select…"} />
        </SelectTrigger>
        <SelectContent>
          {nullable && <SelectItem value="">None</SelectItem>}
          {items.map((opt) => (
            <SelectItem key={opt.value} value={opt.value}>
              {opt.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </Field>
  );
}
