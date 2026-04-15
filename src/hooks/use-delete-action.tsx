import { useConfirm } from "@/components/confirm-dialog";
import { useQueryClient } from "@tanstack/react-query";
import { toast } from "sonner";

const toTitleCase = (s: string) => s.replace(/\b\w/g, (c) => c.toUpperCase());

type EntityDescriptor<T, TId> = {
  label: string;
  getId: (item: T) => TId;
  getDisplayName: (item: T) => string;
};

type DeleteActionOptions<T, TId> = {
  entity: EntityDescriptor<T, TId>;
  fetchFn: (id: TId) => Promise<T | null>;
  deleteFn: (id: TId) => Promise<void>;
  listQueryKey: readonly unknown[];
};

export function useDeleteAction<T, TId>({
  entity,
  fetchFn,
  deleteFn,
  listQueryKey,
}: DeleteActionOptions<T, TId>) {
  const confirm = useConfirm();
  const queryClient = useQueryClient();

  const performDelete = async (id: TId) => {
    const item = await fetchFn(id);

    if (!item) {
      toast.error(`${toTitleCase(entity.label)} not found. It may have been deleted by another user.`);
      queryClient.invalidateQueries({ queryKey: listQueryKey });
      return;
    }

    const confirmed = await confirm({
      title: `Delete ${toTitleCase(entity.label)}`,
      description: (
        <>
          Are you sure you want to delete <strong>{entity.getDisplayName(item)}</strong>? This
          action cannot be undone.
        </>
      ),
      confirmLabel: "Delete",
    });

    if (confirmed) {
      await deleteFn(entity.getId(item));
    }
  };

  return { performDelete };
}
