import type { ToOptions } from "@tanstack/react-router";

export type NavItem = ToOptions & {
  title: string;
  children?: NavItem[];
};
