import { createFormHook } from "@tanstack/react-form";
import { fieldContext, formContext } from "./form-context";
import { CheckboxField } from "#/components/form/checkbox-field";
import { InputField } from "#/components/form/input-field";
import { SelectField } from "#/components/form/select-field";

export const { useAppForm, withForm } = createFormHook({
  fieldContext,
  formContext,
  fieldComponents: {
    InputField,
    CheckboxField,
    SelectField,
  },
  formComponents: {},
});
