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
  // Identity
  code: z.string().min(1, "IATA code is required"),
  name: z.string().min(1, "Name is required"),
  code3: z.string(),
  alternateLookupName: z.string(),
  generalUrl: z.string(),
  allianceFk: z.string().nullable(),
  tier: z.number().int().nullable(),

  // Status & search
  active: z.boolean(),
  allowInQuery: z.boolean(),
  allowInSearchResult: z.boolean(),
  allowInCombinationInSearchResult: z.boolean(),
  priorityInList: z.boolean(),
  sellFirst: z.boolean(),
  sellSeparately: z.boolean(),
  sellContiguously: z.boolean(),
  filterSimilarPricePoints: z.boolean(),
  showBaggageRecheckWarning: z.boolean(),

  // E-ticketing
  supportsETicketing: z.boolean(),
  eTicketingSupportAirlines: z.string(),
  noETicketForInfant: z.boolean(),
  highestEconomyBookingClass: z.string().max(1),
  platingCarrierCode: z.string(),
  isBspParticipant: z.boolean(),
  excludedFlightNumbers: z.string(),
  excludedCodeshares: z.string(),

  // P-ticketing
  supportsPticketing: z.boolean(),
  pTicketingSupportAirlines: z.string(),
  pTicketForInfant: z.boolean(),
  supportsEPay: z.boolean(),

  // Frequent flyer
  frequentFlyerSupport: z.boolean(),
  frequentFlyerName: z.string(),
  priorityInFrequentFlyerList: z.boolean(),
  frequentFlyerSupportAirlines: z.string(),

  // Passenger rules
  requirePassport: z.boolean(),
  requiresMiddleName: z.boolean(),
  passengerNameLengthLimit: z.number().int(),
  requiresSecureFlightSsrsForAllBookings: z.boolean(),
  rejectsDebitCards: z.boolean(),

  // Integrations
  tfSupplierName: z.string(),
  tfPrepay: z.boolean(),
  tfDefaultCurrency: z.string(),
  tfPromptForPassportIfOptional: z.boolean(),
  tfSupportsNdc: z.boolean(),
  duffelSourceName: z.string(),
  everbreadLccBookingCodeOverride: z.string(),
  firstPassApfp: z.boolean(),
  excludeObFeesAu: z.boolean(),
  excludeObFeesNz: z.boolean(),
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
  .handler(async ({ data: { pk, code3, alternateLookupName, generalUrl, platingCarrierCode, eTicketingSupportAirlines, pTicketingSupportAirlines, frequentFlyerName, everbreadLccBookingCodeOverride, tfSupplierName, tfDefaultCurrency, duffelSourceName, ...values } }) => {
    const n = (v: string) => v || null;
    await db
      .update(airline)
      .set({
        ...values,
        code3: n(code3),
        alternateLookupName: n(alternateLookupName),
        generalUrl: n(generalUrl),
        platingCarrierCode: n(platingCarrierCode),
        eTicketingSupportAirlines: n(eTicketingSupportAirlines),
        pTicketingSupportAirlines: n(pTicketingSupportAirlines),
        frequentFlyerName: n(frequentFlyerName),
        everbreadLccBookingCodeOverride: n(everbreadLccBookingCodeOverride),
        tfSupplierName: n(tfSupplierName),
        tfDefaultCurrency: n(tfDefaultCurrency),
        duffelSourceName: n(duffelSourceName),
      })
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
