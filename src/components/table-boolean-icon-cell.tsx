import { Check, X } from "lucide-react";

export function BooleanIconCell({ value }: { value: boolean | null }) {
  return value ? (
    <Check className="size-4 text-green-600 dark:text-green-400" />
  ) : (
    <X className="size-4 text-red-600 dark:text-red-400" />
  );
}
