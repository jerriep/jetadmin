import { pgTable, pgSchema, unique, uuid, varchar, boolean } from "drizzle-orm/pg-core"
import { sql } from "drizzle-orm"

export const dbo = pgSchema("dbo");

export const aspNetRoleClaimsIdSeq = dbo.sequence("AspNetRoleClaims_Id_seq", {  startWith: "1", increment: "1", minValue: "1", maxValue: "2147483647", cache: "1", cycle: false })
export const aspNetUserClaimsIdSeq = dbo.sequence("AspNetUserClaims_Id_seq", {  startWith: "1", increment: "1", minValue: "1", maxValue: "2147483647", cache: "1", cycle: false })
export const flightNumberReplacementPkSeq = dbo.sequence("flight_number_replacement_pk_seq", {  startWith: "1", increment: "1", minValue: "1", maxValue: "2147483647", cache: "1", cycle: false })
export const schemaversionsSchemaversionsidSeq = dbo.sequence("schemaversions_schemaversionsid_seq", {  startWith: "1", increment: "1", minValue: "1", maxValue: "2147483647", cache: "1", cycle: false })

export const alliance = dbo.table("alliance", {
	pk: uuid().default(sql`uuid_generate_v4()`).primaryKey().notNull(),
	code: varchar(),
	name: varchar(),
	active: boolean().default(false),
	allowInQuery: boolean("allow_in_query").default(false),
	priorityInList: boolean("priority_in_list"),
}, (table) => [
	unique("uc_alliance_code").on(table.code),
]);
