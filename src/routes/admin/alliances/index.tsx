import { createFileRoute } from "@tanstack/react-router";
import { createServerFn } from "@tanstack/react-start";
import { asc } from "drizzle-orm";
import { db } from "#/db/index";
import { alliance } from "#/db/schema/schema";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { BooleanIconCell } from "@/components/table-boolean-icon-cell";
import { BooleanBadgeCell } from "@/components/table-boolean-badge-cell";

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
    <Table>
      <TableHeader>
        <TableRow>
          <TableHead>Code</TableHead>
          <TableHead>Name</TableHead>
          <TableHead>Active</TableHead>
          <TableHead>Allow in Query</TableHead>
          <TableHead>Priority in List</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody>
        {alliances.map((a) => (
          <TableRow key={a.pk}>
            <TableCell>{a.code}</TableCell>
            <TableCell>{a.name}</TableCell>
            <TableCell>
              <BooleanIconCell value={a.active} />
            </TableCell>
            <TableCell>
              <BooleanBadgeCell value={a.allowInQuery} trueLabel="Allow" falseLabel="Disallow" />
            </TableCell>
            <TableCell>
              <BooleanBadgeCell value={a.priorityInList} />
            </TableCell>
          </TableRow>
        ))}
        {alliances.length === 0 && (
          <TableRow>
            <TableCell colSpan={5} className="py-8 text-center text-muted-foreground">
              No alliances found.
            </TableCell>
          </TableRow>
        )}
      </TableBody>
    </Table>
  );
}
