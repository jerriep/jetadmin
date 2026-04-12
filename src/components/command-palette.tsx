import { useNavigate } from "@tanstack/react-router";
import { useHotkey } from "@tanstack/react-hotkeys";
import { useState } from "react";
import { adminNavItems } from "@/config/nav";
import type { NavItem } from "#/types/nav";
import {
  Command,
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
} from "@/components/ui/command";

function flattenNavItems(items: NavItem[]): NavItem[] {
  return items.flatMap((item) =>
    item.children ? [item, ...flattenNavItems(item.children)] : [item],
  );
}

const allNavItems = flattenNavItems(adminNavItems);

export function CommandPalette() {
  const [open, setOpen] = useState(false);
  const navigate = useNavigate();

  useHotkey("Mod+K", () => setOpen((prev) => !prev), { ignoreInputs: false });

  function handleSelect(item: NavItem) {
    setOpen(false);
    navigate(item);
  }

  return (
    <CommandDialog open={open} onOpenChange={setOpen}>
      <Command>
        <CommandInput placeholder="Go to..." />
        <CommandList>
          <CommandEmpty>No results found.</CommandEmpty>
          <CommandGroup heading="Navigation">
            {allNavItems.map((item) => (
              <CommandItem key={item.title} value={item.title} onSelect={() => handleSelect(item)}>
                {item.title}
              </CommandItem>
            ))}
          </CommandGroup>
        </CommandList>
      </Command>
    </CommandDialog>
  );
}
