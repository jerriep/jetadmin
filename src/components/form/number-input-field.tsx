import { useFieldContext } from "#/components/form/form-context";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";

export function NumberInputField({ label, id }: { label: string; id: string }) {
  const field = useFieldContext<number | null>();
  const hasError = field.state.meta.isTouched && field.state.meta.errors.length > 0;

  return (
    <Field data-invalid={hasError || undefined}>
      <FieldLabel htmlFor={id}>{label}</FieldLabel>
      <Input
        id={id}
        type="number"
        value={field.state.value ?? ""}
        onChange={(e) =>
          field.handleChange(e.target.value === "" ? null : Number(e.target.value))
        }
        onBlur={field.handleBlur}
      />
      {hasError && (
        <FieldError
          errors={field.state.meta.errors.map((e) => ({
            message: (e as { message: string }).message,
          }))}
        />
      )}
    </Field>
  );
}
