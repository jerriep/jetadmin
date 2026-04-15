import { createServerFn } from "@tanstack/react-start";
import { and, asc, count, eq, ilike, or } from "drizzle-orm";
import { queryOptions, useMutation, useQueryClient } from "@tanstack/react-query";
import { z } from "zod";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import { activeStatusFilterSchema, pageSizeSchema } from "@/schemas/filters";

export type Airline = typeof airline.$inferSelect;

export const airlineSearchSchema = z.object({
  status: activeStatusFilterSchema.default("all"),
  page: z.number().int().positive().default(1),
  pageSize: pageSizeSchema.default(25),
  q: z.string().default(""),
});

export type AirlineSearchParams = z.infer<typeof airlineSearchSchema>;

export const airlineFormSchema = z.object({
  code: z.string().min(1, "IATA code is required"),
  name: z.string().min(1, "Name is required"),
  code3: z.string(),
  allianceFk: z.string().nullable(),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  allowInSearchResult: z.boolean(),
  allowInCombinationInSearchResult: z.boolean(),
  priorityInList: z.boolean(),
});

export type AirlineFormValues = z.infer<typeof airlineFormSchema>;

// ---- Server functions -------------------------------------------------------

export const listAirlines = createServerFn({ method: "GET" })
  .inputValidator((data: AirlineSearchParams) => data)
  .handler(async ({ data: { status, page, pageSize, q } }) => {
    const statusFilter =
      status === "active"
        ? eq(airline.active, true)
        : status === "inactive"
          ? eq(airline.active, false)
          : undefined;

    const searchFilter = q
      ? or(ilike(airline.name, `%${q}%`), ilike(airline.code, `%${q}%`))
      : undefined;

    const where = and(statusFilter, searchFilter);

    const [rows, [{ total }]] = await Promise.all([
      db
        .select()
        .from(airline)
        .where(where)
        .orderBy(asc(airline.name))
        .limit(pageSize)
        .offset((page - 1) * pageSize),
      db.select({ total: count() }).from(airline).where(where),
    ]);

    return { rows, total };
  });

export const getAirline = createServerFn({ method: "GET" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    const result = await db.select().from(airline).where(eq(airline.pk, pk)).limit(1);
    return result[0] ?? null;
  });

export const updateAirline = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string } & AirlineFormValues) => data)
  .handler(async ({ data: { pk, code3, ...values } }) => {
    await db
      .update(airline)
      .set({ ...values, code3: code3 || null })
      .where(eq(airline.pk, pk));
  });

export const deleteAirline = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    await db.delete(airline).where(eq(airline.pk, pk));
  });

// ---- Query keys -------------------------------------------------------------

export const airlineKeys = {
  all:     () => ["airlines"]                                           as const,
  lists:   () => [...airlineKeys.all(), "list"]                         as const,
  list:    (params: AirlineSearchParams) => [...airlineKeys.lists(), params] as const,
  details: () => [...airlineKeys.all(), "detail"]                       as const,
  detail:  (pk: string) => [...airlineKeys.details(), pk]               as const,
};

// ---- Query options ----------------------------------------------------------

export const airlineQueryOptions = {
  list: (params: AirlineSearchParams) =>
    queryOptions({
      queryKey: airlineKeys.list(params),
      queryFn: () => listAirlines({ data: params }),
    }),
  detail: (pk: string) =>
    queryOptions({
      queryKey: airlineKeys.detail(pk),
      queryFn: () => getAirline({ data: { pk } }),
    }),
};

// ---- Mutation hooks ---------------------------------------------------------

export function useUpdateAirlineMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ pk, values }: { pk: string; values: AirlineFormValues }) =>
      updateAirline({ data: { pk, ...values } }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: airlineKeys.all() });
    },
  });
}

export function useDeleteAirlineMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (pk: string) => deleteAirline({ data: { pk } }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: airlineKeys.all() });
    },
  });
}
