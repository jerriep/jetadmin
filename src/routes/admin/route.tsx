import type { NavItem } from "#/types/nav";
import { createFileRoute, Link } from "@tanstack/react-router";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarHeader,
  SidebarMenu,
  SidebarMenuButton,
  SidebarMenuItem,
  SidebarMenuSub,
  SidebarMenuSubButton,
  SidebarMenuSubItem,
} from "@/components/ui/sidebar";
import { GalleryVerticalEnd } from "lucide-react";
import {
  Breadcrumb,
  BreadcrumbItem,
  BreadcrumbLink,
  BreadcrumbList,
  BreadcrumbPage,
  BreadcrumbSeparator,
} from "@/components/ui/breadcrumb";
import { Separator } from "@/components/ui/separator";
import { SidebarInset, SidebarProvider, SidebarTrigger } from "@/components/ui/sidebar";

export const Route = createFileRoute("/admin")({
  component: RouteComponent,
});

const navItems: NavItem[] = [
  { title: "Affiliate Report", to: "/admin" },
  { title: "Affiliates", to: "/admin" },
  { title: "Aircraft Types", to: "/admin" },
  { title: "Airline Info CMS", to: "/admin" },
  { title: "Airlines", to: "/admin" },
  { title: "Alliances", to: "/admin" },
  { title: "Ancillaries Settings", to: "/admin" },
  { title: "AutoCharge Rules", to: "/admin" },
  { title: "Automated Refunds", to: "/admin" },
  { title: "AutoTicket Report", to: "/admin" },
  { title: "AutoTicket Rules", to: "/admin" },
  { title: "Baggage Advice Rules", to: "/admin" },
  { title: "Baggage Rules", to: "/admin" },
  { title: "Batch PNR Lookup", to: "/admin" },
  { title: "Batch Rule Upload", to: "/admin" },
  { title: "Booking and Service Fees CMS", to: "/admin" },
  { title: "Booking Email Preview", to: "/admin" },
  { title: "Booking Query Log", to: "/admin" },
  { title: "Booking Recovery", to: "/admin" },
  { title: "Booking Rules", to: "/admin" },
  { title: "Cache Management", to: "/admin" },
  { title: "Cancel PNR", to: "/admin" },
  { title: "Change Password", to: "/admin" },
  { title: "Cities and Airports", to: "/admin" },
  { title: "CMS", to: "/admin" },
  { title: "Continents", to: "/admin" },
  { title: "Contribution to overhead", to: "/admin" },
  { title: "Corporate Credit Cards", to: "/admin" },
  { title: "Countries", to: "/admin" },
  { title: "Customer Advice Rules", to: "/admin" },
  { title: "Customer Support Tools", to: "/admin" },
  { title: "Delay Ticketing Rules", to: "/admin" },
  { title: "Destination CMS", to: "/admin" },
  { title: "Domain Conversion URL", to: "/admin" },
  { title: "Domains", to: "/admin" },
  { title: "Exchange Rates", to: "/admin" },
  { title: "Exclusion Rules", to: "/admin" },
  { title: "Fee Rules", to: "/admin" },
  { title: "Flight Query Rules", to: "/admin" },
  { title: "Flight Query Rules (Incremental)", to: "/admin" },
  { title: "Flight Query Rules (Revalidate)", to: "/admin" },
  { title: "Flight Vouchers", to: "/admin" },
  { title: "Get PNR", to: "/admin" },
  { title: "Google Flights Fee Rules Upload", to: "/admin" },
  { title: "Homepage CMS", to: "/admin" },
  { title: "Import / Export Data", to: "/admin" },
  { title: "Landing Page CMS", to: "/admin" },
  { title: "Margin Rules", to: "/admin" },
  { title: "Margin Rules Upload", to: "/admin" },
  { title: "Metasearch Multi-city Rules", to: "/admin" },
  { title: "Metasearch Rules", to: "/admin" },
  { title: "Mileages", to: "/admin" },
  { title: "Net Income Percentages", to: "/admin" },
  { title: "One Way Aggregate Rules", to: "/admin" },
  { title: "Operations Rules", to: "/admin" },
  { title: "Payment Offer Rules", to: "/admin" },
  { title: "Payment Processing", to: "/admin" },
  { title: "Payment Processing Reporting", to: "/admin" },
  { title: "Payment Type Rules", to: "/admin" },
  { title: "Product Selection Rules", to: "/admin" },
  { title: "Purchase Travel Insurance", to: "/admin" },
  { title: "Reconciliation Upload", to: "/admin" },
  { title: "Reports", to: "/admin" },
  { title: "Resend Customer Confirmation Email", to: "/admin" },
  { title: "Sabre Sales Report", to: "/admin" },
  {
    title: "SEO",
    to: "/admin",
    children: [
      { title: "Cheap Flights", to: "/admin" },
      { title: "Meta Tags", to: "/admin" },
    ],
  },
  { title: "Settings", to: "/admin" },
  { title: "Supplier Booking Upload", to: "/admin" },
  { title: "Ticketing Form of Payment", to: "/admin" },
  { title: "Trace Tool", to: "/admin" },
  { title: "Update E-Ticket Airlines", to: "/admin" },
  { title: "Update Frequent Flyer Airlines", to: "/admin" },
  { title: "Update Purchased Ancillary", to: "/admin" },
  { title: "User Management", to: "/admin" },
  { title: "Virtual Credit Card Generator", to: "/admin" },
  { title: "WebFare Booking Queries", to: "/admin" },
];

function RouteComponent() {
  return (
    <SidebarProvider
      style={
        {
          "--sidebar-width": "19rem",
        } as React.CSSProperties
      }
    >
      <AppSidebar />
      <SidebarInset>
        <header className="flex h-16 shrink-0 items-center gap-2 border-b px-4">
          <SidebarTrigger className="-ml-1" />
          <Separator
            orientation="vertical"
            className="mr-2 data-[orientation=vertical]:h-4 data-[orientation=vertical]:self-center"
          />
          <Breadcrumb>
            <BreadcrumbList>
              <BreadcrumbItem className="hidden md:block">
                <BreadcrumbLink href="#">Build Your Application</BreadcrumbLink>
              </BreadcrumbItem>
              <BreadcrumbSeparator className="hidden md:block" />
              <BreadcrumbItem>
                <BreadcrumbPage>Data Fetchingsssssss</BreadcrumbPage>
              </BreadcrumbItem>
            </BreadcrumbList>
          </Breadcrumb>
        </header>
        <div className="flex flex-1 flex-col gap-4 p-4">
          <div className="grid auto-rows-min gap-4 md:grid-cols-3">
            <div className="aspect-video rounded-xl bg-muted/50" />
            <div className="aspect-video rounded-xl bg-muted/50" />
            <div className="aspect-video rounded-xl bg-muted/50" />
          </div>
          <div className="min-h-[100vh] flex-1 rounded-xl bg-muted/50 md:min-h-min" />
        </div>
      </SidebarInset>
    </SidebarProvider>
  );
}

export function AppSidebar({ ...props }: React.ComponentProps<typeof Sidebar>) {
  return (
    <Sidebar variant="inset" {...props}>
      <SidebarHeader>
        <SidebarMenu>
          <SidebarMenuItem>
            <SidebarMenuButton
              size="lg"
              render={
                <a href="#">
                  <div className="flex aspect-square size-9 items-center justify-center rounded-lg bg-sidebar-primary text-sidebar-primary-foreground">
                    <GalleryVerticalEnd className="size-5" />
                  </div>
                  <div className="flex flex-col gap-1.5 leading-none">
                    <span className="font-medium">Documentation</span>
                    <span className="">v0.0.0</span>
                  </div>
                </a>
              }
            ></SidebarMenuButton>
          </SidebarMenuItem>
        </SidebarMenu>
      </SidebarHeader>
      <SidebarContent>
        <SidebarGroup>
          <SidebarMenu className="gap-2">
            {navItems.map((item) => (
              <SidebarMenuItem key={item.title}>
                <SidebarMenuButton
                  render={
                    <Link to={item.to} className="font-medium">
                      {item.title}
                    </Link>
                  }
                ></SidebarMenuButton>
                {item.children && (
                  <SidebarMenuSub>
                    {item.children.map((child) => (
                      <SidebarMenuSubItem key={child.title}>
                        <SidebarMenuSubButton
                          render={<Link to={child.to}>{child.title}</Link>}
                        ></SidebarMenuSubButton>
                      </SidebarMenuSubItem>
                    ))}
                  </SidebarMenuSub>
                )}
              </SidebarMenuItem>
            ))}
          </SidebarMenu>
        </SidebarGroup>
      </SidebarContent>
    </Sidebar>
  );
}
