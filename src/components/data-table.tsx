import { flexRender, useReactTable } from "@tanstack/react-table";
import {
  Table,
  TableBody,
  TableCell,
  TableFooter,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import {
  Pagination,
  PaginationContent,
  PaginationEllipsis,
  PaginationItem,
  PaginationLink,
  PaginationNext,
  PaginationPrevious,
} from "@/components/ui/pagination";
import { Field, FieldLabel } from "@/components/ui/field";
import {
  Select,
  SelectContent,
  SelectGroup,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import { PAGE_SIZES } from "@/schemas/filters";

function getPageNumbers(page: number, totalPages: number): (number | "ellipsis")[] {
  if (totalPages <= 7) return Array.from({ length: totalPages }, (_, i) => i + 1);
  if (page <= 4) return [1, 2, 3, 4, 5, "ellipsis", totalPages];
  if (page >= totalPages - 3) return [1, "ellipsis", totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages];
  return [1, "ellipsis", page - 1, page, page + 1, "ellipsis", totalPages];
}

export function DataTable<TData>({ table, mustDisplayFooter = true }: {
  table: ReturnType<typeof useReactTable<TData>>;
  mustDisplayFooter?: boolean;
}) {
  const { pageIndex, pageSize } = table.getState().pagination;
  const page = pageIndex + 1;
  const totalPages = table.getPageCount();
  const tableRows = table.getRowModel().rows;
  const colSpan = table.getVisibleFlatColumns().length;

  return (
    <div className="overflow-hidden rounded-lg border">
      <Table>
        <TableHeader className="bg-muted">
          {table.getHeaderGroups().map((headerGroup) => (
            <TableRow key={headerGroup.id}>
              {headerGroup.headers.map((header) => (
                <TableHead key={header.id}>
                  {header.isPlaceholder ? null : flexRender(header.column.columnDef.header, header.getContext())}
                </TableHead>
              ))}
            </TableRow>
          ))}
        </TableHeader>
        <TableBody>
          {tableRows.length > 0 ? (
            tableRows.map((row) => (
              <TableRow key={row.id} className="hover:bg-transparent">
                {row.getVisibleCells().map((cell) => (
                  <TableCell key={cell.id}>
                    {flexRender(cell.column.columnDef.cell, cell.getContext())}
                  </TableCell>
                ))}
              </TableRow>
            ))
          ) : (
            <TableRow>
              <TableCell colSpan={colSpan} className="py-8 text-center text-muted-foreground">
                No results found.
              </TableCell>
            </TableRow>
          )}
        </TableBody>
        {mustDisplayFooter && <TableFooter>
          <TableRow>
            <TableCell colSpan={colSpan} className="bg-background px-4 py-2">
              <div className="flex items-center justify-between gap-4">
                <Field orientation="horizontal" className="w-fit">
                  <FieldLabel htmlFor="data-table-page-size">Rows per page</FieldLabel>
                  <Select value={String(pageSize)} onValueChange={(value) => table.setPageSize(Number(value))}>
                    <SelectTrigger className="w-20" id="data-table-page-size"><SelectValue /></SelectTrigger>
                    <SelectContent align="start">
                      <SelectGroup>{PAGE_SIZES.map((size) => <SelectItem key={size} value={String(size)}>{size}</SelectItem>)}</SelectGroup>
                    </SelectContent>
                  </Select>
                </Field>
                <Pagination className="mx-0 w-auto">
                  <PaginationContent>
                    <PaginationItem>
                      <PaginationPrevious onClick={() => table.previousPage()} aria-disabled={!table.getCanPreviousPage()} className={!table.getCanPreviousPage() ? "pointer-events-none opacity-50" : "cursor-pointer"} />
                    </PaginationItem>
                    {getPageNumbers(page, totalPages).map((p, i) =>
                      p === "ellipsis" ? (
                        <PaginationItem key={`ellipsis-${i}`}><PaginationEllipsis /></PaginationItem>
                      ) : (
                        <PaginationItem key={p}>
                          <PaginationLink isActive={p === page} onClick={() => table.setPageIndex(p - 1)} className="cursor-pointer">{p}</PaginationLink>
                        </PaginationItem>
                      )
                    )}
                    <PaginationItem>
                      <PaginationNext onClick={() => table.nextPage()} aria-disabled={!table.getCanNextPage()} className={!table.getCanNextPage() ? "pointer-events-none opacity-50" : "cursor-pointer"} />
                    </PaginationItem>
                  </PaginationContent>
                </Pagination>
              </div>
            </TableCell>
          </TableRow>
        </TableFooter>}
      </Table>
    </div>
  );
}
