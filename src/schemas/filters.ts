import { z } from "zod";

export const activeStatusFilterSchema = z.enum(["all", "active", "inactive"]);

export const pageSizeSchema = z.union([z.literal(10), z.literal(25), z.literal(50), z.literal(100)]);
export const PAGE_SIZES = pageSizeSchema.options.map((o) => o.value);
