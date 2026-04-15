import { createServerFn } from "@tanstack/react-start";
import { asc, eq } from "drizzle-orm";
import { queryOptions, useMutation, useQueryClient } from "@tanstack/react-query";
import { z } from "zod";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";

export type Alliance = typeof alliance.$inferSelect;

export const allianceFormSchema = z.object({
  code: z.string().min(1, "Code is required"),
  name: z.string().min(1, "Name is required"),
  active: z.boolean(),
  allowInQuery: z.boolean(),
  priorityInList: z.boolean(),
});

export type AllianceFormValues = z.infer<typeof allianceFormSchema>;

// ---- Server functions -------------------------------------------------------

export const listAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

export const getAlliance = createServerFn({ method: "GET" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    const result = await db.select().from(alliance).where(eq(alliance.pk, pk)).limit(1);
    return result[0] ?? null;
  });

export const createAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: AllianceFormValues) => data)
  .handler(async ({ data }) => {
    await db.insert(alliance).values(data);
  });

export const updateAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string } & AllianceFormValues) => data)
  .handler(async ({ data: { pk, ...values } }) => {
    await db.update(alliance).set(values).where(eq(alliance.pk, pk));
  });

export const deleteAlliance = createServerFn({ method: "POST" })
  .inputValidator((data: { pk: string }) => data)
  .handler(async ({ data: { pk } }) => {
    await db.delete(alliance).where(eq(alliance.pk, pk));
  });

// ---- Query keys -------------------------------------------------------------

export const allianceKeys = {
  all:     () => ["alliances"]                              as const,
  lists:   () => [...allianceKeys.all(), "list"]            as const,
  details: () => [...allianceKeys.all(), "detail"]          as const,
  detail:  (pk: string) => [...allianceKeys.details(), pk]  as const,
};

// ---- Query options ----------------------------------------------------------

export const allianceQueryOptions = {
  list: () =>
    queryOptions({
      queryKey: allianceKeys.lists(),
      queryFn: () => listAlliances(),
    }),
  detail: (pk: string) =>
    queryOptions({
      queryKey: allianceKeys.detail(pk),
      queryFn: () => getAlliance({ data: { pk } }),
    }),
};

// ---- Mutation hooks ---------------------------------------------------------

export function useCreateAllianceMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (values: AllianceFormValues) => createAlliance({ data: values }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: allianceKeys.all() });
    },
  });
}

export function useUpdateAllianceMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ pk, values }: { pk: string; values: AllianceFormValues }) =>
      updateAlliance({ data: { pk, ...values } }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: allianceKeys.all() });
    },
  });
}

export function useDeleteAllianceMutation() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (pk: string) => deleteAlliance({ data: { pk } }),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: allianceKeys.all() });
    },
  });
}
