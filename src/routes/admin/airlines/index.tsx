import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { ChevronRightIcon } from "lucide-react";
import { db } from "#/db/index";
import { airline } from "#/db/schema/schema";
import {
  Item,
  ItemActions,
  ItemContent,
  ItemDescription,
  ItemGroup,
  ItemMedia,
  ItemTitle,
} from "#/components/ui/item";

const getAirlines = createServerFn({ method: "GET" }).handler(async () => {
  return await db
    .select({
      pk: airline.pk,
      code: airline.code,
      code3: airline.code3,
      name: airline.name,
      active: airline.active,
      tier: airline.tier,
    })
    .from(airline)
    .orderBy(asc(airline.name));
});

export const Route = createFileRoute("/admin/airlines/")({
  component: RouteComponent,
  loader: async () => await getAirlines(),
});

function RouteComponent() {
  const data = Route.useLoaderData();

  if (data.length === 0) {
    return <p className="py-8 text-center text-sm text-muted-foreground">No airlines found.</p>;
  }

  return (
    <ItemGroup>
      {data.map((row) => (
        <Item key={row.pk} variant="outline" className="hover:bg-muted cursor-pointer">
          <ItemMedia variant="image" className="w-16 [&_img]:object-contain">
            <img
              src={`https://www.jetabroad.com.au/assets/airlines/logos/${row.code}.svg`}
              alt={row.name ?? row.code ?? ""}
            />
          </ItemMedia>
          <ItemContent>
            <ItemTitle>{row.name}</ItemTitle>
            <ItemDescription>
              {[row.code, row.code3].filter(Boolean).join(" · ")}
              {row.tier != null ? ` · Tier ${row.tier}` : ""}
            </ItemDescription>
          </ItemContent>
          <ItemActions>
            <ChevronRightIcon className="size-4 text-muted-foreground" />
          </ItemActions>
        </Item>
      ))}
    </ItemGroup>
  );
}
