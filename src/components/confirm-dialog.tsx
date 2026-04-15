import { createContext, useCallback, useContext, useState } from "react";
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "@/components/ui/alert-dialog";

type ConfirmOptions = {
  title: string;
  description?: React.ReactNode;
  confirmLabel?: string;
  cancelLabel?: string;
};

type ConfirmDialogState = ConfirmOptions & {
  resolve: (confirmed: boolean) => void;
};

const ConfirmContext = createContext<((options: ConfirmOptions) => Promise<boolean>) | null>(null);

export function ConfirmDialogProvider({ children }: { children: React.ReactNode }) {
  const [state, setState] = useState<ConfirmDialogState | null>(null);

  const confirm = useCallback((options: ConfirmOptions): Promise<boolean> => {
    return new Promise((resolve) => {
      setState({ ...options, resolve });
    });
  }, []);

  const handleConfirm = () => {
    state?.resolve(true);
    setState(null);
  };

  const handleCancel = () => {
    state?.resolve(false);
    setState(null);
  };

  return (
    <ConfirmContext.Provider value={confirm}>
      {children}
      <AlertDialog open={state !== null} onOpenChange={(open) => { if (!open) handleCancel(); }}>
        <AlertDialogContent>
          <AlertDialogHeader>
            <AlertDialogTitle>{state?.title}</AlertDialogTitle>
            {state?.description && (
              <AlertDialogDescription>{state.description}</AlertDialogDescription>
            )}
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel onClick={handleCancel}>
              {state?.cancelLabel ?? "Cancel"}
            </AlertDialogCancel>
            <AlertDialogAction variant="destructive" onClick={handleConfirm}>
              {state?.confirmLabel ?? "Confirm"}
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </ConfirmContext.Provider>
  );
}

export function useConfirm() {
  const confirm = useContext(ConfirmContext);
  if (!confirm) throw new Error("useConfirm must be used within a ConfirmDialogProvider");
  return confirm;
}
