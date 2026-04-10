import {
  pgTable,
  pgSchema,
  uniqueIndex,
  foreignKey,
  unique,
  uuid,
  varchar,
  boolean,
  char,
  integer,
} from "drizzle-orm/pg-core";
import { sql } from "drizzle-orm";

export const dbo = pgSchema("dbo");

export const aspNetRoleClaimsIdSeq = dbo.sequence("AspNetRoleClaims_Id_seq", {
  startWith: "1",
  increment: "1",
  minValue: "1",
  maxValue: "2147483647",
  cache: "1",
  cycle: false,
});
export const aspNetUserClaimsIdSeq = dbo.sequence("AspNetUserClaims_Id_seq", {
  startWith: "1",
  increment: "1",
  minValue: "1",
  maxValue: "2147483647",
  cache: "1",
  cycle: false,
});
export const flightNumberReplacementPkSeq = dbo.sequence("flight_number_replacement_pk_seq", {
  startWith: "1",
  increment: "1",
  minValue: "1",
  maxValue: "2147483647",
  cache: "1",
  cycle: false,
});
export const schemaversionsSchemaversionsidSeq = dbo.sequence(
  "schemaversions_schemaversionsid_seq",
  {
    startWith: "1",
    increment: "1",
    minValue: "1",
    maxValue: "2147483647",
    cache: "1",
    cycle: false,
  },
);

export const airline = dbo.table(
  "airline",
  {
    pk: uuid()
      .default(sql`uuid_generate_v4()`)
      .primaryKey()
      .notNull(),
    code: varchar(),
    name: varchar(),
    code3: varchar(),
    generalUrl: varchar("general_url"),
    active: boolean().default(false).notNull(),
    allowInQuery: boolean("allow_in_query").default(false).notNull(),
    allowInSearchResult: boolean("allow_in_search_result").default(false).notNull(),
    allowInCombinationInSearchResult: boolean("allow_in_combination_in_search_result")
      .default(false)
      .notNull(),
    priorityInList: boolean("priority_in_list").default(false).notNull(),
    allianceFk: uuid("alliance_fk"),
    frequentFlyerSupport: boolean("frequent_flyer_support").default(false),
    frequentFlyerName: varchar("frequent_flyer_name"),
    priorityInFrequentFlyerList: boolean("priority_in_frequent_flyer_list").default(false),
    eTicketingSupportAirlines: varchar("e_ticketing_support_airlines"),
    noETicketForInfant: boolean("no_e_ticket_for_infant").default(false).notNull(),
    isBspParticipant: boolean("is_bsp_participant").default(false).notNull(),
    platingCarrierCode: varchar("plating_carrier_code"),
    excludedFlightNumbers: varchar("excluded_flight_numbers").default("").notNull(),
    supportsPticketing: boolean("supports_pticketing").notNull(),
    supportsEPay: boolean("supports_e_pay").notNull(),
    pTicketForInfant: boolean("p_ticket_for_infant").notNull(),
    pTicketingSupportAirlines: varchar("p_ticketing_support_airlines"),
    supportsETicketing: boolean("supports_e_ticketing").notNull(),
    highestEconomyBookingClass: char("highest_economy_booking_class", { length: 1 })
      .default("")
      .notNull(),
    frequentFlyerSupportAirlines: varchar("frequent_flyer_support_airlines").default("").notNull(),
    excludedCodeshares: varchar("excluded_codeshares").default("").notNull(),
    showBaggageRecheckWarning: boolean("show_baggage_recheck_warning").default(false).notNull(),
    requiresSecureFlightSsrsForAllBookings: boolean("requires_secure_flight_ssrs_for_all_bookings")
      .default(false)
      .notNull(),
    tier: integer(),
    filterSimilarPricePoints: boolean("filter_similar_price_points").default(false).notNull(),
    everbreadLccBookingCodeOverride: varchar("everbread_lcc_booking_code_override"),
    rejectsDebitCards: boolean("rejects_debit_cards").default(false).notNull(),
    sellFirst: boolean("sell_first").default(false).notNull(),
    tfSupplierName: varchar("tf_supplier_name"),
    tfPrepay: boolean("tf_prepay").default(false).notNull(),
    tfDefaultCurrency: varchar("tf_default_currency"),
    tfPromptForPassportIfOptional: boolean("tf_prompt_for_passport_if_optional")
      .default(false)
      .notNull(),
    sellSeparately: boolean("sell_separately").default(false).notNull(),
    firstPassApfp: boolean("first_pass_apfp").default(false).notNull(),
    sellContiguously: boolean("sell_contiguously").default(false),
    excludeObFeesAu: boolean("exclude_ob_fees_au").default(false).notNull(),
    excludeObFeesNz: boolean("exclude_ob_fees_nz").default(false).notNull(),
    requiresMiddleName: boolean("requires_middle_name").default(true).notNull(),
    tfSupportsNdc: boolean("tf_supports_ndc").default(false).notNull(),
    duffelSourceName: varchar("duffel_source_name"),
    requirePassport: boolean("require_passport").default(false).notNull(),
    passengerNameLengthLimit: integer("passenger_name_length_limit").default(28).notNull(),
    alternateLookupName: varchar("alternate_lookup_name"),
  },
  (table) => [
    uniqueIndex("idx_airline_alternate_lookup_name").using(
      "btree",
      table.alternateLookupName.asc().nullsLast().op("text_ops"),
    ),
    foreignKey({
      columns: [table.allianceFk],
      foreignColumns: [alliance.pk],
      name: "fk_airline_alliance",
    }),
    unique("uc_airline_code").on(table.code),
  ],
);
export const alliance = dbo.table(
  "alliance",
  {
    pk: uuid()
      .default(sql`uuid_generate_v4()`)
      .primaryKey()
      .notNull(),
    code: varchar(),
    name: varchar(),
    active: boolean().default(false),
    allowInQuery: boolean("allow_in_query").default(false),
    priorityInList: boolean("priority_in_list"),
  },
  (table) => [unique("uc_alliance_code").on(table.code)],
);
