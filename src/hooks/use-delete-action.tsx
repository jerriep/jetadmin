import { useConfirm } from "@/components/confirm-dialog";
import { useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";

type DeleteActionOptions<T extends { pk: string; name: string | null }> = {
  fetchFn: (pk: string) => Promise<T | null>;
  deleteFn: (pk: string) => Promise<void>;
  listQueryKey: readonly unknown[];
  entityLabel: string;
};

export function useDeleteAction<T extends { pk: string; name: string | null }>({
  fetchFn,
  deleteFn,
  listQueryKey,
  entityLabel,
}: DeleteActionOptions<T>) {
  const confirm = useConfirm();
  const queryClient = useQueryClient();

  const performDelete = async (pk: string) => {
    const item = await fetchFn(pk);

    if (!item) {
      toast.error(`${entityLabel} not found. It may have been deleted by another user.`);
      queryClient.invalidateQueries({ queryKey: listQueryKey });
      return;
    }

    const confirmed = await confirm({
      title: `Delete ${entityLabel}`,
      description: (
        <>
          Are you sure you want to delete <strong>{item.name}</strong>? This action cannot be
          undone.
        </>
      ),
      confirmLabel: "Delete",
    });

    if (confirmed) {
      await deleteFn(item.pk);
    }
  };

  return { performDelete };
}
