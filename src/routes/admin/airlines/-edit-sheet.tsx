import { useQuery } from "@tanstack/react-query";
import { useAppForm } from "#/components/form/form";
import { Button } from "@/components/ui/button";
import { Sheet, SheetContent, SheetFooter, SheetHeader, SheetTitle } from "@/components/ui/sheet";
import {
  Sidebar,
  SidebarContent,
  SidebarGroup,
  SidebarGroupLabel,
  SidebarMenu,
  SidebarMenuItem,
  SidebarMenuButton,
  SidebarProvider,
} from "@/components/ui/sidebar";
import { type Airline, airlineFormSchema, useUpdateAirlineMutation } from "@/services/airlines";
import { allianceQueryOptions } from "@/services/alliances";

export type { Airline };

// ---- Component --------------------------------------------------------------

export function AirlineSheet({
  airline: airlineData,
  open,
  onOpenChange,
}: {
  airline: Airline;
  open: boolean;
  onOpenChange: (open: boolean) => void;
}) {
  const { data: alliances = [] } = useQuery(allianceQueryOptions.list());

  const allianceOptions = alliances
    .filter((a): a is typeof a & { name: string } => a.name !== null)
    .map((a) => ({ value: a.pk, label: a.name }));

  const { mutateAsync: updateAirline } = useUpdateAirlineMutation();

  const form = useAppForm({
    validators: {
      onChange: airlineFormSchema,
    },
    defaultValues: {
      code: airlineData.code ?? "",
      name: airlineData.name ?? "",
      code3: airlineData.code3 ?? "",
      alternateLookupName: airlineData.alternateLookupName ?? "",
      generalUrl: airlineData.generalUrl ?? "",
      allianceFk: airlineData.allianceFk ?? null,
      tier: airlineData.tier ?? null,
      active: airlineData.active,
      allowInQuery: airlineData.allowInQuery,
      allowInSearchResult: airlineData.allowInSearchResult,
      allowInCombinationInSearchResult: airlineData.allowInCombinationInSearchResult,
      priorityInList: airlineData.priorityInList,
      sellFirst: airlineData.sellFirst,
      sellSeparately: airlineData.sellSeparately,
      sellContiguously: airlineData.sellContiguously ?? false,
      filterSimilarPricePoints: airlineData.filterSimilarPricePoints,
      showBaggageRecheckWarning: airlineData.showBaggageRecheckWarning,
      supportsETicketing: airlineData.supportsETicketing,
      eTicketingSupportAirlines: airlineData.eTicketingSupportAirlines ?? "",
      noETicketForInfant: airlineData.noETicketForInfant,
      highestEconomyBookingClass: airlineData.highestEconomyBookingClass,
      platingCarrierCode: airlineData.platingCarrierCode ?? "",
      isBspParticipant: airlineData.isBspParticipant,
      excludedFlightNumbers: airlineData.excludedFlightNumbers,
      excludedCodeshares: airlineData.excludedCodeshares,
      supportsPticketing: airlineData.supportsPticketing,
      pTicketingSupportAirlines: airlineData.pTicketingSupportAirlines ?? "",
      pTicketForInfant: airlineData.pTicketForInfant,
      supportsEPay: airlineData.supportsEPay,
      frequentFlyerSupport: airlineData.frequentFlyerSupport ?? false,
      frequentFlyerName: airlineData.frequentFlyerName ?? "",
      priorityInFrequentFlyerList: airlineData.priorityInFrequentFlyerList ?? false,
      frequentFlyerSupportAirlines: airlineData.frequentFlyerSupportAirlines,
      requirePassport: airlineData.requirePassport,
      requiresMiddleName: airlineData.requiresMiddleName,
      passengerNameLengthLimit: airlineData.passengerNameLengthLimit,
      requiresSecureFlightSsrsForAllBookings: airlineData.requiresSecureFlightSsrsForAllBookings,
      rejectsDebitCards: airlineData.rejectsDebitCards,
      tfSupplierName: airlineData.tfSupplierName ?? "",
      tfPrepay: airlineData.tfPrepay,
      tfDefaultCurrency: airlineData.tfDefaultCurrency ?? "",
      tfPromptForPassportIfOptional: airlineData.tfPromptForPassportIfOptional,
      tfSupportsNdc: airlineData.tfSupportsNdc,
      duffelSourceName: airlineData.duffelSourceName ?? "",
      everbreadLccBookingCodeOverride: airlineData.everbreadLccBookingCodeOverride ?? "",
      firstPassApfp: airlineData.firstPassApfp,
      excludeObFeesAu: airlineData.excludeObFeesAu,
      excludeObFeesNz: airlineData.excludeObFeesNz,
    },
    onSubmit: async ({ value }) => {
      await updateAirline({ pk: airlineData.pk, values: value });
      onOpenChange(false);
    },
  });

  return (
    <Sheet open={open} onOpenChange={onOpenChange}>
      <SheetContent side="right" className="flex flex-col p-0 sm:!max-w-none sm:w-[65vw]">
        <form
          onSubmit={(e) => {
            e.preventDefault();
            form.handleSubmit();
          }}
          className="flex flex-1 flex-col overflow-hidden"
        >
          <SheetHeader className="border-b px-6 py-4">
            <SheetTitle>Edit Airline</SheetTitle>
          </SheetHeader>

          <SidebarProvider className="flex flex-1 overflow-hidden min-h-0">
            <Sidebar collapsible="none" className="border-r">
              <SidebarContent>
                <SidebarGroup>
                  <SidebarGroupLabel>Sections</SidebarGroupLabel>
                  <SidebarMenu>
                    {[
                      ["s-identity", "Identity"],
                      ["s-status", "Status"],
                      ["s-search", "Search"],
                      ["s-eticket", "E-Ticketing"],
                      ["s-pticket", "P-Ticketing"],
                      ["s-ff", "Frequent Flyer"],
                      ["s-passenger", "Passenger requirements"],
                      ["s-tf", "TravelFusion"],
                      ["s-other", "Other integrations"],
                    ].map(([id, label]) => (
                      <SidebarMenuItem key={id}>
                        <SidebarMenuButton
                          onClick={() =>
                            document
                              .getElementById(id)
                              ?.scrollIntoView({ behavior: "smooth", block: "start" })
                          }
                        >
                          {label}
                        </SidebarMenuButton>
                      </SidebarMenuItem>
                    ))}
                  </SidebarMenu>
                </SidebarGroup>
              </SidebarContent>
            </Sidebar>
            <div className="flex-1 overflow-y-auto px-6 py-5">
              <div className="flex flex-col gap-8">
                <div id="s-identity" className="flex flex-col gap-4">
                  <div className="grid grid-cols-2 gap-x-6 gap-y-4">
                    <form.AppField name="code">
                      {(f) => <f.InputField label="IATA code" id="code" autoFocus />}
                    </form.AppField>
                    <form.AppField name="code3">
                      {(f) => <f.InputField label="ICAO code" id="code3" />}
                    </form.AppField>
                    <div className="col-span-2">
                      <form.AppField name="name">
                        {(f) => <f.InputField label="Name" id="name" />}
                      </form.AppField>
                    </div>
                    <div className="col-span-2">
                      <form.AppField name="alternateLookupName">
                        {(f) => <f.InputField label="Alternate lookup name" id="alt-name" />}
                      </form.AppField>
                    </div>
                    <div className="col-span-2">
                      <form.AppField name="generalUrl">
                        {(f) => <f.InputField label="General URL" id="general-url" />}
                      </form.AppField>
                    </div>
                    <form.AppField name="allianceFk">
                      {(f) => (
                        <f.SelectField
                          label="Alliance"
                          id="alliance"
                          items={allianceOptions}
                          placeholder="No alliance"
                          nullable
                        />
                      )}
                    </form.AppField>
                    <form.AppField name="tier">
                      {(f) => <f.NumberInputField label="Tier" id="tier" />}
                    </form.AppField>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-status" className="flex flex-col gap-3">
                  <p className="text-base font-medium">Status</p>
                  <div className="grid grid-cols-2 gap-3">
                    <form.AppField name="active">
                      {(f) => <f.CheckboxField label="Active" id="active" />}
                    </form.AppField>
                    <form.AppField name="priorityInList">
                      {(f) => <f.CheckboxField label="Priority in list" id="priority" />}
                    </form.AppField>
                    <form.AppField name="sellFirst">
                      {(f) => <f.CheckboxField label="Sell first" id="sell-first" />}
                    </form.AppField>
                    <form.AppField name="sellSeparately">
                      {(f) => <f.CheckboxField label="Sell separately" id="sell-sep" />}
                    </form.AppField>
                    <form.AppField name="sellContiguously">
                      {(f) => <f.CheckboxField label="Sell contiguously" id="sell-cont" />}
                    </form.AppField>
                    <form.AppField name="filterSimilarPricePoints">
                      {(f) => (
                        <f.CheckboxField label="Filter similar price points" id="filter" />
                      )}
                    </form.AppField>
                    <div className="col-span-2">
                      <form.AppField name="showBaggageRecheckWarning">
                        {(f) => (
                          <f.CheckboxField label="Show baggage recheck warning" id="baggage" />
                        )}
                      </form.AppField>
                    </div>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-search" className="flex flex-col gap-3">
                  <p className="text-base font-medium">Search</p>
                  <div className="grid grid-cols-2 gap-3">
                    <form.AppField name="allowInQuery">
                      {(f) => <f.CheckboxField label="Allow in query" id="allow-query" />}
                    </form.AppField>
                    <form.AppField name="allowInSearchResult">
                      {(f) => (
                        <f.CheckboxField label="Allow in search result" id="allow-search" />
                      )}
                    </form.AppField>
                    <div className="col-span-2">
                      <form.AppField name="allowInCombinationInSearchResult">
                        {(f) => (
                          <f.CheckboxField
                            label="Allow in combination in search result"
                            id="allow-combo"
                          />
                        )}
                      </form.AppField>
                    </div>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-eticket" className="flex flex-col gap-4">
                  <p className="text-base font-medium">E-Ticketing</p>
                  <div className="grid grid-cols-3 gap-3">
                    <form.AppField name="supportsETicketing">
                      {(f) => <f.CheckboxField label="Supports e-ticketing" id="eticket" />}
                    </form.AppField>
                    <form.AppField name="noETicketForInfant">
                      {(f) => (
                        <f.CheckboxField label="No e-ticket for infant" id="eticket-infant" />
                      )}
                    </form.AppField>
                    <form.AppField name="isBspParticipant">
                      {(f) => <f.CheckboxField label="BSP participant" id="bsp" />}
                    </form.AppField>
                  </div>
                  <div className="grid grid-cols-2 gap-x-6 gap-y-4">
                    <form.AppField name="eTicketingSupportAirlines">
                      {(f) => (
                        <f.InputField
                          label="E-ticketing support airlines"
                          id="eticket-airlines"
                        />
                      )}
                    </form.AppField>
                    <form.AppField name="highestEconomyBookingClass">
                      {(f) => (
                        <f.InputField label="Highest economy booking class" id="econ-class" />
                      )}
                    </form.AppField>
                    <form.AppField name="platingCarrierCode">
                      {(f) => <f.InputField label="Plating carrier code" id="plating" />}
                    </form.AppField>
                    <form.AppField name="excludedFlightNumbers">
                      {(f) => (
                        <f.InputField label="Excluded flight numbers" id="excl-flights" />
                      )}
                    </form.AppField>
                    <div className="col-span-2">
                      <form.AppField name="excludedCodeshares">
                        {(f) => (
                          <f.InputField label="Excluded codeshares" id="excl-codeshares" />
                        )}
                      </form.AppField>
                    </div>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-pticket" className="flex flex-col gap-4">
                  <p className="text-base font-medium">P-Ticketing</p>
                  <div className="grid grid-cols-3 gap-3">
                    <form.AppField name="supportsPticketing">
                      {(f) => <f.CheckboxField label="Supports p-ticketing" id="pticket" />}
                    </form.AppField>
                    <form.AppField name="pTicketForInfant">
                      {(f) => (
                        <f.CheckboxField label="P-ticket for infant" id="pticket-infant" />
                      )}
                    </form.AppField>
                    <form.AppField name="supportsEPay">
                      {(f) => <f.CheckboxField label="Supports e-pay" id="epay" />}
                    </form.AppField>
                  </div>
                  <form.AppField name="pTicketingSupportAirlines">
                    {(f) => (
                      <f.InputField
                        label="P-ticketing support airlines"
                        id="pticket-airlines"
                      />
                    )}
                  </form.AppField>
                </div>

                <hr className="border-border" />

                <div id="s-ff" className="flex flex-col gap-4">
                  <p className="text-base font-medium">Frequent Flyer</p>
                  <div className="grid grid-cols-2 gap-3">
                    <form.AppField name="frequentFlyerSupport">
                      {(f) => (
                        <f.CheckboxField label="Frequent flyer support" id="ff-support" />
                      )}
                    </form.AppField>
                    <form.AppField name="priorityInFrequentFlyerList">
                      {(f) => (
                        <f.CheckboxField
                          label="Priority in frequent flyer list"
                          id="ff-priority"
                        />
                      )}
                    </form.AppField>
                  </div>
                  <div className="grid grid-cols-2 gap-x-6 gap-y-4">
                    <form.AppField name="frequentFlyerName">
                      {(f) => <f.InputField label="Frequent flyer name" id="ff-name" />}
                    </form.AppField>
                    <form.AppField name="frequentFlyerSupportAirlines">
                      {(f) => (
                        <f.InputField
                          label="Frequent flyer support airlines"
                          id="ff-airlines"
                        />
                      )}
                    </form.AppField>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-passenger" className="flex flex-col gap-4">
                  <p className="text-base font-medium">Passenger Requirements</p>
                  <div className="grid grid-cols-2 gap-3">
                    <form.AppField name="requirePassport">
                      {(f) => <f.CheckboxField label="Require passport" id="passport" />}
                    </form.AppField>
                    <form.AppField name="requiresMiddleName">
                      {(f) => (
                        <f.CheckboxField label="Requires middle name" id="middle-name" />
                      )}
                    </form.AppField>
                    <form.AppField name="requiresSecureFlightSsrsForAllBookings">
                      {(f) => (
                        <f.CheckboxField
                          label="Requires secure flight SSRs for all bookings"
                          id="secure-flight"
                        />
                      )}
                    </form.AppField>
                    <form.AppField name="rejectsDebitCards">
                      {(f) => <f.CheckboxField label="Rejects debit cards" id="debit" />}
                    </form.AppField>
                  </div>
                  <div className="max-w-xs">
                    <form.AppField name="passengerNameLengthLimit">
                      {(f) => (
                        <f.NumberInputField
                          label="Passenger name length limit"
                          id="name-limit"
                        />
                      )}
                    </form.AppField>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-tf" className="flex flex-col gap-4">
                  <p className="text-base font-medium">TravelFusion</p>
                  <div className="grid grid-cols-2 gap-x-6 gap-y-4">
                    <form.AppField name="tfSupplierName">
                      {(f) => <f.InputField label="Supplier name" id="tf-supplier" />}
                    </form.AppField>
                    <form.AppField name="tfDefaultCurrency">
                      {(f) => <f.InputField label="Default currency" id="tf-currency" />}
                    </form.AppField>
                  </div>
                  <div className="grid grid-cols-3 gap-3">
                    <form.AppField name="tfPrepay">
                      {(f) => <f.CheckboxField label="Prepay" id="tf-prepay" />}
                    </form.AppField>
                    <form.AppField name="tfPromptForPassportIfOptional">
                      {(f) => (
                        <f.CheckboxField
                          label="Prompt for passport if optional"
                          id="tf-passport"
                        />
                      )}
                    </form.AppField>
                    <form.AppField name="tfSupportsNdc">
                      {(f) => <f.CheckboxField label="Supports NDC" id="tf-ndc" />}
                    </form.AppField>
                  </div>
                </div>

                <hr className="border-border" />

                <div id="s-other" className="flex flex-col gap-4">
                  <p className="text-base font-medium">Other Integrations</p>
                  <div className="grid grid-cols-2 gap-x-6 gap-y-4">
                    <form.AppField name="duffelSourceName">
                      {(f) => <f.InputField label="Duffel source name" id="duffel" />}
                    </form.AppField>
                    <form.AppField name="everbreadLccBookingCodeOverride">
                      {(f) => (
                        <f.InputField
                          label="Everbread LCC booking code override"
                          id="everbread"
                        />
                      )}
                    </form.AppField>
                  </div>
                  <div className="grid grid-cols-3 gap-3">
                    <form.AppField name="firstPassApfp">
                      {(f) => <f.CheckboxField label="First pass APFP" id="apfp" />}
                    </form.AppField>
                    <form.AppField name="excludeObFeesAu">
                      {(f) => <f.CheckboxField label="Exclude OB fees (AU)" id="ob-au" />}
                    </form.AppField>
                    <form.AppField name="excludeObFeesNz">
                      {(f) => <f.CheckboxField label="Exclude OB fees (NZ)" id="ob-nz" />}
                    </form.AppField>
                  </div>
                </div>
              </div>
            </div>
          </SidebarProvider>

          <SheetFooter className="flex-row justify-end border-t px-6 py-4">
            <form.Subscribe selector={(state) => state.isSubmitting}>
              {(isSubmitting) => (
                <>
                  <Button
                    type="button"
                    variant="outline"
                    onClick={() => onOpenChange(false)}
                    disabled={isSubmitting}
                  >
                    Cancel
                  </Button>
                  <Button type="submit" disabled={isSubmitting}>
                    {isSubmitting ? "Saving\u2026" : "Save changes"}
                  </Button>
                </>
              )}
            </form.Subscribe>
          </SheetFooter>
        </form>
      </SheetContent>
    </Sheet>
  );
}
