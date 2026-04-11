import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";

const getAlliances = createServerFn({ method: "GET" }).handler(async () => {
  return await db.select().from(alliance).orderBy(asc(alliance.name));
});

export const Route = createFileRoute("/admin/alliances/")({
  component: RouteComponent,
  loader: async () => await getAlliances(),
});

function RouteComponent() {
  const alliances = Route.useLoaderData();

  return (
    <div>
      <h1 className="text-2xl font-semibold mb-4">Alliances</h1>
      <table className="w-full text-sm border-collapse">
        <thead>
          <tr className="border-b text-left text-muted-foreground">
            <th className="py-2 pr-4 font-medium">Code</th>
            <th className="py-2 pr-4 font-medium">Name</th>
            <th className="py-2 pr-4 font-medium">Active</th>
            <th className="py-2 pr-4 font-medium">Allow in Query</th>
            <th className="py-2 pr-4 font-medium">Priority in List</th>
          </tr>
        </thead>
        <tbody>
          {alliances.map((a) => (
            <tr key={a.pk} className="border-b hover:bg-muted/50">
              <td className="py-2 pr-4">{a.code}</td>
              <td className="py-2 pr-4">{a.name}</td>
              <td className="py-2 pr-4">{a.active ? "Yes" : "No"}</td>
              <td className="py-2 pr-4">{a.allowInQuery ? "Yes" : "No"}</td>
              <td className="py-2 pr-4">{a.priorityInList ? "Yes" : "No"}</td>
            </tr>
          ))}
          {alliances.length === 0 && (
            <tr>
              <td colSpan={5} className="py-8 text-center text-muted-foreground">
                No alliances found.
              </td>
            </tr>
          )}
        </tbody>
      </table>
    </div>
  );
}
