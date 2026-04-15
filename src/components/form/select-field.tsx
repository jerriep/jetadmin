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
  options,
  placeholder,
  nullable = false,
}: {
  label: string;
  id: string;
  options: Option[];
  placeholder?: string;
  nullable?: boolean;
}) {
  const field = useFieldContext<string | null>();

  return (
    <Field>
      <FieldLabel htmlFor={id}>{label}</FieldLabel>
      <Select
        value={field.state.value ?? ""}
        onValueChange={(value) => field.handleChange(value === "" ? null : value)}
        items={options}
      >
        <SelectTrigger id={id} className="w-full">
          <SelectValue placeholder={placeholder ?? "Select…"} />
        </SelectTrigger>
        <SelectContent>
          {nullable && <SelectItem value="">None</SelectItem>}
          {options.map((opt) => (
            <SelectItem key={opt.value} value={opt.value}>
              {opt.label}
            </SelectItem>
          ))}
        </SelectContent>
      </Select>
    </Field>
  );
}
