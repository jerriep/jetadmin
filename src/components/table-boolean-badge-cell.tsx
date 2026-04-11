import { Badge } from "@/components/ui/badge";

export function BooleanBadgeCell({
  value,
  trueLabel = "Yes",
  falseLabel = "No",
}: {
  value: boolean | null;
  trueLabel?: string;
  falseLabel?: string;
}) {
  return value ? (
    <Badge className="bg-green-100 text-green-700 border-green-200 dark:bg-green-900/30 dark:text-green-400 dark:border-green-800">
      {trueLabel}
    </Badge>
  ) : (
    <Badge className="bg-red-100 text-red-700 border-red-200 dark:bg-red-900/30 dark:text-red-400 dark:border-red-800">
      {falseLabel}
    </Badge>
  );
}
