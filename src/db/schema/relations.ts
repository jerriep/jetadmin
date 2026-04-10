import { relations } from "drizzle-orm/relations";
import { alliance, airline } from "./schema";

export const airlineRelations = relations(airline, ({one}) => ({
	alliance: one(alliance, {
		fields: [airline.allianceFk],
		references: [alliance.pk]
	}),
}));

export const allianceRelations = relations(alliance, ({many}) => ({
	airlines: many(airline),
}));