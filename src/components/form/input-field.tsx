import { useFieldContext } from "#/components/form/form-context";
import { Field, FieldError, FieldLabel } from "@/components/ui/field";
import { Input } from "@/components/ui/input";

export function InputField({ label, id }: { label: string; id: string }) {
  const field = useFieldContext<string>();
  const hasError = field.state.meta.isTouched && field.state.meta.errors.length > 0;

  return (
    <Field data-invalid={hasError || undefined}>
      <FieldLabel htmlFor={id}>{label}</FieldLabel>
      <Input
        id={id}
        value={field.state.value}
        onChange={(e) => field.handleChange(e.target.value)}
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
