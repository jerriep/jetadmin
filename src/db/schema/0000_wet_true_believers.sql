-- Current sql file was generated after introspecting the database
-- If you want to run this migration please uncomment this code before executing migrations
/*
CREATE SCHEMA "dbo";
--> statement-breakpoint
CREATE SEQUENCE "dbo"."AspNetRoleClaims_Id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1;--> statement-breakpoint
CREATE SEQUENCE "dbo"."AspNetUserClaims_Id_seq" INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START WITH 1 CACHE 1;--> statement-breakpoint
CREATE TABLE "dbo"."AspNetUsers" (
	"Id" varchar(128) PRIMARY KEY NOT NULL,
	"ApplicationId" uuid NOT NULL,
	"MobileAlias" text,
	"IsAnonymous" boolean NOT NULL,
	"LastActivityDate" timestamp NOT NULL,
	"MobilePIN" text,
	"LoweredEmail" text,
	"LoweredUserName" text,
	"PasswordQuestion" text,
	"PasswordAnswer" text,
	"IsApproved" boolean NOT NULL,
	"IsLockedOut" boolean NOT NULL,
	"CreateDate" timestamp NOT NULL,
	"LastLoginDate" timestamp NOT NULL,
	"LastPasswordChangedDate" timestamp NOT NULL,
	"LastLockoutDate" timestamp NOT NULL,
	"FailedPasswordAttemptCount" integer NOT NULL,
	"FailedPasswordAttemptWindowStart" timestamp NOT NULL,
	"FailedPasswordAnswerAttemptCount" integer NOT NULL,
	"FailedPasswordAnswerAttemptWindowStart" timestamp NOT NULL,
	"Comment" text,
	"Discriminator" text,
	"Email" varchar(256),
	"EmailConfirmed" boolean NOT NULL,
	"PasswordHash" text,
	"SecurityStamp" text,
	"PhoneNumber" text,
	"PhoneNumberConfirmed" boolean NOT NULL,
	"TwoFactorEnabled" boolean NOT NULL,
	"LockoutEndDateUtc" timestamp,
	"LockoutEnabled" boolean NOT NULL,
	"AccessFailedCount" integer NOT NULL,
	"UserName" varchar(256) NOT NULL,
	"LegacyPasswordHash" varchar(256),
	"NormalizedUserName" varchar(256),
	"NormalizedEmail" varchar(256),
	"ConcurrencyStamp" text
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetUserClaims" (
	"Id" integer PRIMARY KEY DEFAULT nextval('dbo."AspNetUserClaims_Id_seq"'::regclass) NOT NULL,
	"UserId" varchar(128) NOT NULL,
	"ClaimType" text,
	"ClaimValue" text
);
--> statement-breakpoint
CREATE TABLE "dbo"."air_gateway_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"airline_substitution" varchar DEFAULT '',
	"operations_office_id" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"parameter_id" uuid,
	"airline_exclusion" varchar DEFAULT '',
	"per_provider_limit" integer,
	"max_offers_per_cabin" integer,
	"request_timeout" integer,
	"no_cache" boolean DEFAULT false NOT NULL,
	"non_stop" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."airline" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"code" varchar,
	"name" varchar,
	"code3" varchar,
	"general_url" varchar,
	"active" boolean DEFAULT false NOT NULL,
	"allow_in_query" boolean DEFAULT false NOT NULL,
	"allow_in_search_result" boolean DEFAULT false NOT NULL,
	"allow_in_combination_in_search_result" boolean DEFAULT false NOT NULL,
	"priority_in_list" boolean DEFAULT false NOT NULL,
	"alliance_fk" uuid,
	"frequent_flyer_support" boolean DEFAULT false,
	"frequent_flyer_name" varchar,
	"priority_in_frequent_flyer_list" boolean DEFAULT false,
	"e_ticketing_support_airlines" varchar,
	"no_e_ticket_for_infant" boolean DEFAULT false NOT NULL,
	"is_bsp_participant" boolean DEFAULT false NOT NULL,
	"plating_carrier_code" varchar,
	"excluded_flight_numbers" varchar DEFAULT '' NOT NULL,
	"supports_pticketing" boolean NOT NULL,
	"supports_e_pay" boolean NOT NULL,
	"p_ticket_for_infant" boolean NOT NULL,
	"p_ticketing_support_airlines" varchar,
	"supports_e_ticketing" boolean NOT NULL,
	"highest_economy_booking_class" char(1) DEFAULT '' NOT NULL,
	"frequent_flyer_support_airlines" varchar DEFAULT '' NOT NULL,
	"excluded_codeshares" varchar DEFAULT '' NOT NULL,
	"show_baggage_recheck_warning" boolean DEFAULT false NOT NULL,
	"requires_secure_flight_ssrs_for_all_bookings" boolean DEFAULT false NOT NULL,
	"tier" integer,
	"filter_similar_price_points" boolean DEFAULT false NOT NULL,
	"everbread_lcc_booking_code_override" varchar,
	"rejects_debit_cards" boolean DEFAULT false NOT NULL,
	"sell_first" boolean DEFAULT false NOT NULL,
	"tf_supplier_name" varchar,
	"tf_prepay" boolean DEFAULT false NOT NULL,
	"tf_default_currency" varchar,
	"tf_prompt_for_passport_if_optional" boolean DEFAULT false NOT NULL,
	"sell_separately" boolean DEFAULT false NOT NULL,
	"first_pass_apfp" boolean DEFAULT false NOT NULL,
	"sell_contiguously" boolean DEFAULT false,
	"exclude_ob_fees_au" boolean DEFAULT false NOT NULL,
	"exclude_ob_fees_nz" boolean DEFAULT false NOT NULL,
	"requires_middle_name" boolean DEFAULT true NOT NULL,
	"tf_supports_ndc" boolean DEFAULT false NOT NULL,
	"duffel_source_name" varchar,
	"require_passport" boolean DEFAULT false NOT NULL,
	"passenger_name_length_limit" integer DEFAULT 28 NOT NULL,
	"alternate_lookup_name" varchar,
	CONSTRAINT "uc_airline_code" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."aircraft_type" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"description" varchar NOT NULL,
	"display_description" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."airline_cabin_class" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"airline_fk" uuid,
	"booking_class" varchar NOT NULL,
	"cabin_class" varchar NOT NULL,
	"description" varchar NOT NULL,
	"interface_code" varchar,
	"flight_numbers" varchar DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."airline_blue_ribbon_bags_available" (
	"airline_id" integer PRIMARY KEY NOT NULL,
	"airline_code" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."airline_extended_info" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"airline_fk" uuid NOT NULL,
	"blurb" varchar,
	"active" boolean DEFAULT false,
	"header" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetRoles" (
	"Id" varchar(128) PRIMARY KEY NOT NULL,
	"Name" varchar(256) NOT NULL,
	"NormalizedName" varchar(256),
	"ConcurrencyStamp" text
);
--> statement-breakpoint
CREATE TABLE "dbo"."agacountry_region" (
	"country_code" varchar PRIMARY KEY NOT NULL,
	"region" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."airwallex_create_card_log" (
	"pk" uuid NOT NULL,
	"request_id" uuid NOT NULL,
	"succeeded" boolean DEFAULT false NOT NULL,
	"request_details" varchar NOT NULL,
	"created_by" varchar(30) NOT NULL,
	"date_changed" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."amadeus_office" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"office_id" varchar NOT NULL,
	"organization_id" varchar NOT NULL,
	"time_zone_id" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."amadeus_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"exclude_published_fares" boolean DEFAULT false NOT NULL,
	"exclude_nego_fares" boolean DEFAULT false NOT NULL,
	"recommendation_count" integer DEFAULT 0 NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"operations_office_id" varchar,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"merge_airlines" boolean DEFAULT false NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"mandatory_airline_type" varchar,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"parameter_id" uuid,
	"corporate_codes" varchar,
	"enable_atpco" boolean DEFAULT false NOT NULL,
	"enable_ndc" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."amadeus_sales_summaries" (
	"document_number" varchar PRIMARY KEY NOT NULL,
	"office_id" varchar NOT NULL,
	"currency_code" varchar NOT NULL,
	"sequence_number" varchar,
	"airline_id" varchar,
	"total_amount" numeric(19, 2),
	"taxes" numeric(19, 2),
	"fees" numeric(19, 2),
	"commission" numeric(19, 2),
	"form_of_payment" varchar,
	"passenger_name" varchar,
	"agent_sign" varchar,
	"reference_number" varchar,
	"transaction_type" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."alliance" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"code" varchar,
	"name" varchar,
	"active" boolean DEFAULT false,
	"allow_in_query" boolean DEFAULT false,
	"priority_in_list" boolean,
	CONSTRAINT "uc_alliance_code" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."ancillaries_setting" (
	"id" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"provider" varchar(50) NOT NULL,
	"domain" varchar(50) NOT NULL,
	"product" varchar(200) NOT NULL,
	"active" boolean NOT NULL,
	"experiment_group_code" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."aspnet_Applications" (
	"ApplicationId" uuid PRIMARY KEY NOT NULL,
	"ApplicationName" text,
	"Description" text,
	"LoweredApplicationName" text
);
--> statement-breakpoint
CREATE TABLE "dbo"."ancillary_transaction_purchase" (
	"id" uuid PRIMARY KEY NOT NULL,
	"booking_id" uuid NOT NULL,
	"provider" varchar NOT NULL,
	"type" varchar NOT NULL,
	"transaction_number" varchar NOT NULL,
	"transaction_cost" numeric(18, 2) NOT NULL,
	"transaction_currency" char(3) NOT NULL,
	"created_time" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."auto_charge_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"cabin_class" varchar DEFAULT '' NOT NULL,
	"flight_type" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"currencies" varchar,
	"is_exclusion" boolean DEFAULT false NOT NULL,
	"notes" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."baggage_advice_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar(50) NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"airlines" varchar(1024),
	"origin_ports" varchar(256),
	"origin_countries" varchar(256),
	"origin_continents" varchar(50),
	"destination_ports" varchar(256),
	"destination_countries" varchar(256),
	"destination_continents" varchar(50),
	"excluded_origin_ports" varchar(256),
	"excluded_origin_countries" varchar(256),
	"excluded_origin_continents" varchar(50),
	"excluded_destination_ports" varchar(256),
	"excluded_destination_countries" varchar(256),
	"excluded_destination_continents" varchar(50),
	"cabin_class" varchar(50),
	"booking_class" varchar(50),
	"fare_types" varchar(50),
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"ticketing_latency_days" integer DEFAULT 0 NOT NULL,
	"flight_numbers" varchar(1000),
	"codeshare_airline_codes" varchar(500),
	"flight_type" varchar(500),
	"use_for_adult" boolean DEFAULT false NOT NULL,
	"use_for_child" boolean DEFAULT false NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"customer_advice" varchar,
	"apply_segment_by_segment" boolean NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar(30) DEFAULT 'admin' NOT NULL,
	"app_version" varchar(40) DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"apply_leg_by_leg" boolean DEFAULT false NOT NULL,
	"apply_whole_pnr" boolean DEFAULT false NOT NULL,
	"apply_whole_aggregated_itinerary" boolean DEFAULT false NOT NULL,
	"baggage" boolean DEFAULT false NOT NULL,
	"summary" varchar(8000),
	"partial_fare_basis" varchar(50),
	"amount_provided" boolean DEFAULT true NOT NULL,
	"purchasable" boolean DEFAULT false NOT NULL,
	"validating_carrier" varchar(1024),
	"operation_offices" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."baggage_advice_rule_parameter_default_value" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar(100) NOT NULL,
	"value" varchar(100) NOT NULL,
	"baggage_advice_rule_pk" uuid NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."auto_ticket_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_types" varchar,
	"fare_types" varchar,
	"airlines" varchar,
	"operation_office_id" varchar,
	"booking_engines" varchar,
	"ticketing_method" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."baggage_protection_purchase" (
	"id" uuid PRIMARY KEY NOT NULL,
	"booking_id" uuid NOT NULL,
	"master_reference_number" varchar NOT NULL,
	"service_number" varchar,
	"product_code" varchar NOT NULL,
	"is_international" boolean NOT NULL,
	"product_price" numeric(18, 2) NOT NULL,
	"product_price_currency" char(3) NOT NULL,
	"bag_coverage" numeric(18, 2) NOT NULL,
	"bag_coverage_currency" char(3) NOT NULL,
	"total_passenger" integer NOT NULL,
	"total_price" numeric(18, 2) NOT NULL,
	"total_price_currency" char(3) NOT NULL,
	"flight_details" varchar NOT NULL,
	"departure_dt" timestamp NOT NULL,
	"last_arrival_dt" timestamp NOT NULL,
	"covered_persons" varchar NOT NULL,
	"status" varchar DEFAULT '' NOT NULL,
	"service_status_code" varchar,
	"service_errors" varchar,
	"created_time" timestamp NOT NULL,
	"issued_time" timestamp,
	"row_version" "bytea" DEFAULT convert_to(to_char(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.US'::text), 'UTF8'::name) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_ancillary" (
	"id" uuid PRIMARY KEY NOT NULL,
	"time" timestamp NOT NULL,
	"booked_ticket_id" uuid NOT NULL,
	"booked_passenger_id" uuid NOT NULL,
	"type" varchar NOT NULL,
	"document_number" varchar NOT NULL,
	"associated_ticket_number" varchar NOT NULL,
	"payment_total_currency" varchar NOT NULL,
	"payment_total_amount" numeric(10, 2) NOT NULL,
	"description" varchar,
	"marketing_provider" varchar,
	"start_location" varchar,
	"end_location" varchar,
	"settlement_authorization" varchar,
	"coupon_status" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."baggage_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar(850) NOT NULL,
	"allow_code_share" boolean NOT NULL,
	"origin_ports" varchar(1000),
	"origin_countries" varchar(1000),
	"origin_continents" varchar(1000),
	"destination_ports" varchar(1000),
	"destination_countries" varchar(1000),
	"destination_continents" varchar(1000),
	"weight_adjustment" double precision NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean NOT NULL,
	"included_booking_engines" varchar(1000),
	"validating_carriers" varchar(1000),
	"operation_offices" varchar(1000),
	"use_hard_code_baggage" boolean NOT NULL,
	"hard_code_baggage_content" varchar,
	"hard_code_baggage_override_real_baggage" boolean NOT NULL,
	"active" boolean NOT NULL,
	"include_service_codes" varchar(1000),
	"exclude_service_codes" varchar(1000),
	"include_commercial_names" varchar(1000),
	"exclude_commercial_names" varchar(1000),
	"operating_carriers" varchar(1024),
	"operating_carriers_exact_match" boolean DEFAULT false NOT NULL,
	"marketing_carriers" varchar(1024),
	"marketing_carriers_exact_match" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."authorisation_hash_log" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"hash" varchar NOT NULL,
	"date_time" timestamp NOT NULL,
	"authorisation_transaction_fk" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."auto_ticket_pnr" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"reference_number" varchar NOT NULL,
	"master_reference_number" varchar NOT NULL,
	"office_id" varchar NOT NULL,
	"status" varchar NOT NULL,
	"email" varchar,
	"mobile_number" varchar,
	"departure_date_time_utc" timestamp,
	"status_change_date_time" timestamp NOT NULL,
	"customer_last_name" varchar,
	"customer_title" varchar,
	"has_non_cancelable_booking_in_aggregate" boolean NOT NULL,
	"airline_name" varchar,
	"refunded" boolean NOT NULL,
	"form_of_payment" varchar,
	"commission" numeric(18, 2),
	"alternative_mobile_number" varchar,
	"alternative_email" varchar,
	"airline_code" varchar,
	"booking_engine_type" varchar DEFAULT 'AM' NOT NULL,
	"lease_time" timestamp,
	"created_time" timestamp(6),
	"simultaneous_retry_count" integer DEFAULT 0 NOT NULL,
	"tour_code" varchar,
	"ticketing_method" varchar,
	"corporate_card_fk" uuid,
	"actual_ticketing_date" timestamp,
	"booking_price" numeric(10, 2),
	"ticketing_price" numeric(10, 2),
	"price_currency_code" varchar,
	"booking_office_id" varchar,
	"actual_ticketing_date_utc" timestamp with time zone,
	"previous_suggested_delayed_ticketing_date_utc" timestamp with time zone,
	"delay_ticketing_rule_fk" uuid,
	"wenrix_suggested_delayed_ticketing_date_utc" timestamp with time zone,
	"wenrix_expected_saving" numeric(10, 2),
	"wenrix_balance_currency" varchar,
	"booked_status_trigger" varchar,
	"ticketed_complete_count" smallint DEFAULT 0 NOT NULL,
	"is_flight_number_masked" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_fare_flight_leg_segment_pivot" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booked_fare_fk" uuid NOT NULL,
	"flight_leg_segment_fk" uuid NOT NULL,
	"booking_request_fk" uuid,
	"fare_basis_codes" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_ticket" (
	"id" uuid PRIMARY KEY NOT NULL,
	"time" timestamp NOT NULL,
	"booking_request_fk" uuid,
	"booking_result_fk" uuid,
	"booking_engine" char(2) NOT NULL,
	"reference_number" varchar NOT NULL,
	"booking_date_time" timestamp NOT NULL,
	"booking_last_updated" timestamp NOT NULL,
	"office_id" varchar NOT NULL,
	"booking_office" varchar,
	"agent_office" varchar,
	"booking_source" varchar,
	"payment_method" varchar,
	"pnr_remark_transaction" varchar,
	"remark" varchar,
	"special_service_request" varchar,
	"supplier_ticket_status" varchar,
	"supplier_booking_status" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_fare_surcharge" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"surcharge_type" char(2) NOT NULL,
	"description" varchar DEFAULT '' NOT NULL,
	"booked_fare_fk" uuid NOT NULL,
	"fare_surcharge_rule_fk" uuid,
	"airline_fk" uuid,
	"fulfilment_currency_code" char(3) DEFAULT '' NOT NULL,
	"original_currency_code" char(3) DEFAULT '' NOT NULL,
	"original_surcharge" numeric(18, 2) DEFAULT '0' NOT NULL,
	"base_currency_code" char(3) DEFAULT '' NOT NULL,
	"base_surcharge" numeric(18, 2) DEFAULT '0' NOT NULL,
	"webfare_currency_code" char(3) DEFAULT '' NOT NULL,
	"webfare_surcharge" numeric(18, 2) DEFAULT '0' NOT NULL,
	"purchase_currency_code" char(3) DEFAULT '' NOT NULL,
	"purchase_surcharge" numeric(18, 2) DEFAULT '0' NOT NULL,
	"passenger_count" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_and_service_fees" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booking_and_service_fees_text" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_attempt" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"first_date_time" timestamp NOT NULL,
	"last_date_time" timestamp NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"booking_request_fk" uuid,
	"status" char(2) NOT NULL,
	"description" varchar,
	"itinerary" varchar,
	"flight_numbers" varchar,
	"dates_of_travel" varchar,
	"currency" char(3),
	"price" numeric(10, 2),
	"source" char(2),
	"booking_engine" char(2),
	"correlation_id" uuid,
	"first_date_time_utc" timestamp with time zone,
	"last_date_time_utc" timestamp with time zone,
	"pac_price_change" numeric(10, 2)
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_form" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"status" varchar,
	"session_fk" uuid NOT NULL,
	"date" timestamp NOT NULL,
	"purchaser_name" varchar,
	"work_phone_country_code" varchar,
	"work_phone_area_code" varchar,
	"work_phone_number" varchar,
	"home_phone_country_code" varchar,
	"home_phone_area_code" varchar,
	"home_phone_number" varchar,
	"mobile_country_code" varchar,
	"mobile_number" varchar,
	"email" varchar,
	"subscribe_to_newsletter_value" boolean,
	"verify_email" varchar,
	"street_address_line1" varchar,
	"street_address_line2" varchar,
	"city_or_suburb" varchar,
	"post_code" varchar,
	"state" varchar,
	"country" varchar,
	"has_card_number" boolean,
	"has_expiry_month" boolean,
	"has_expiry_year" boolean,
	"has_verification_number" boolean,
	"card_holders_phone_country_code" varchar,
	"card_holders_phone_number" varchar,
	"issuing_bank" varchar,
	"card_issuer" varchar,
	"name_on_card" varchar,
	"passenger_details" varchar,
	"price_point" varchar,
	"initial_payment_checkpoint" boolean,
	"booking_request_fk" uuid,
	"phone_number" varchar,
	"phone_country_code" varchar,
	"date_sent_remind_email" timestamp,
	"alternative_email" varchar,
	"alternative_mobile_number" varchar,
	"affiliate_tracking_id" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_request_fee" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"fee_type" varchar NOT NULL,
	"is_chargeable" boolean NOT NULL,
	"currency_code" varchar NOT NULL,
	"amount" numeric(7, 2) NOT NULL,
	"booking_result_fk" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_reference_number_fountain" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"value" integer NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_passenger_ticket" (
	"id" uuid PRIMARY KEY NOT NULL,
	"booked_ticket_id" uuid NOT NULL,
	"ticket_number" varchar NOT NULL,
	"ticketing_entry" char(2),
	"agent_sine" varchar,
	"issued_date_time" timestamp NOT NULL,
	"customer_name" varchar NOT NULL,
	"base_fare_currency" varchar NOT NULL,
	"base_fare_amount" numeric(10, 2) NOT NULL,
	"total_currency" varchar NOT NULL,
	"total_amount" numeric(10, 2) NOT NULL,
	"ticketing_transaction" varchar NOT NULL,
	"coupon" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_result" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"office_id" varchar,
	"reference_number" varchar NOT NULL,
	"result_code" varchar,
	"succeeded" boolean NOT NULL,
	"auto_cancelled" boolean NOT NULL,
	"time_of_booking" timestamp NOT NULL,
	"payment_method" char(1) DEFAULT '' NOT NULL,
	"search_engine_type" char(2) DEFAULT '' NOT NULL,
	"price_variation" numeric(18, 2),
	"price_variation_currency_code" varchar,
	"booking_engine_type" char(2) DEFAULT '' NOT NULL,
	"tfreference" varchar,
	"auto_ticket_record_created" boolean,
	"validating_carrier" varchar,
	"cancelled" boolean,
	"airline_record_locator" varchar,
	"primary_booking_engine" char(2),
	"ticket_status" varchar,
	"flight_item_index" varchar,
	"is_failure_prevented" boolean DEFAULT false NOT NULL,
	"ticketing_office_id" varchar,
	"fare_id" uuid,
	"searched_fare_id" uuid,
	"initial_result_code" varchar,
	"error_detail" varchar,
	"is_urgent_ticketing_sent" boolean DEFAULT false NOT NULL,
	"platform_last_ticketing_date_utc" timestamp with time zone,
	"ticketing_restriction" varchar,
	"special_service_requests" varchar,
	"supplier_source" varchar,
	"supplier_reference_number" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"use_for_adult" boolean DEFAULT true NOT NULL,
	"use_for_child" boolean DEFAULT true NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"booking_class" varchar,
	"fare_types" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_type" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"included_search_engines" varchar,
	"booking_engine_type" varchar NOT NULL,
	"booking_pcc" varchar,
	"search_pccs" varchar,
	"is_skip_booking" boolean DEFAULT false NOT NULL,
	"operating_carriers" varchar,
	"validating_carriers" varchar,
	"is_skip_revalidate" boolean DEFAULT false NOT NULL,
	"supplier_source" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_state" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"record_locator" varchar NOT NULL,
	"cancelled" boolean NOT NULL,
	"row_version" "bytea" DEFAULT convert_to(to_char(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.US'::text), 'UTF8'::name) NOT NULL,
	CONSTRAINT "booking_state_record_locator_key" UNIQUE("record_locator")
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_state_change_log" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"record_locator" varchar NOT NULL,
	"cancelled" boolean NOT NULL,
	"username" varchar NOT NULL,
	"date_time" timestamp,
	"result_code" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_request" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_query_fk" uuid,
	"session_fk" uuid NOT NULL,
	"started_date_time" timestamp NOT NULL,
	"completed_date_time" timestamp,
	"succeeded" boolean,
	"reference_number" varchar,
	"authorisation_id" varchar DEFAULT '',
	"delivery_charge_accepted" boolean DEFAULT false NOT NULL,
	"payment_type" char(1),
	"email_address" varchar,
	"domain_code" char(3) NOT NULL,
	"affiliate" varchar,
	"geolocated_country" varchar,
	"is_in_progress" boolean NOT NULL,
	"last_ticketing_date" timestamp,
	"last_ticketing_date_check" timestamp,
	"need_ticketing_email" boolean,
	"affiliate_date" timestamp,
	"started_date_time_utc" timestamp with time zone,
	"completed_date_time_utc" timestamp with time zone,
	"fraud_status" varchar,
	"contains_virtual_interline" boolean DEFAULT false NOT NULL,
	"fare_selected_event_id" uuid,
	"fare_id" uuid,
	"reported_fraud_status" varchar,
	"last_modified_date_utc" timestamp with time zone,
	"last_ticketing_date_utc" timestamp with time zone,
	"is_payment_failure_prevented" boolean DEFAULT false NOT NULL,
	"is_payment_failure_notification_sent" boolean DEFAULT false NOT NULL,
	"experiment_group_code" varchar,
	"last_reported_date_time_utc" timestamp with time zone,
	"customer_accepted_unmasked_flights" boolean DEFAULT false NOT NULL,
	"is_payment_failure" boolean DEFAULT false,
	"is_failure_prevented" boolean
);
--> statement-breakpoint
CREATE TABLE "dbo"."booking_promotion" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"promotion_code" varchar NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"amount_currency" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."bsp_sales_summaries" (
	"document_number" varchar PRIMARY KEY NOT NULL,
	"airline_id" varchar,
	"issue_date" timestamp,
	"currency_code" varchar,
	"settlement_period" varchar,
	"stat" varchar,
	"cash" numeric(19, 2),
	"credit" numeric(19, 2),
	"taxes_cr" numeric(19, 2),
	"taxes_ca" numeric(19, 2),
	"commission_percent" numeric(19, 2),
	"commission_amount" numeric(19, 2),
	"vat_commission" numeric(19, 2),
	"cancellation_fees" numeric(19, 2),
	"tcnnumber" varchar,
	"report_system" varchar,
	"destination" varchar,
	"comments" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."city_port" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"city_code" varchar,
	"city_name" varchar,
	"city_qualifier" varchar,
	"port_code" varchar,
	"port_name" varchar,
	"country_fk" uuid NOT NULL,
	"allow_in_query" boolean DEFAULT false NOT NULL,
	"allow_in_search_result" boolean DEFAULT false NOT NULL,
	"priority_in_list" boolean DEFAULT false NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"full_description" varchar,
	"short_description" varchar,
	"alternate_search_text" varchar,
	"allow_as_origin" boolean DEFAULT false NOT NULL,
	"disabled_from" timestamp DEFAULT '9999-12-31 23:59:59.998' NOT NULL,
	"disabled_to" timestamp DEFAULT '1753-01-01 00:00:00' NOT NULL,
	"hotel_city_id" varchar,
	"time_zone_id" varchar,
	"is_metropolitan_area" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."change_tracking" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"action" varchar NOT NULL,
	"entity" varchar NOT NULL,
	"new_value" varchar NOT NULL,
	"username" varchar NOT NULL,
	"date_changed" timestamp(6) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."cheap_flight_settings" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"domain" char(3) DEFAULT 'all' NOT NULL,
	"enabled" boolean DEFAULT false NOT NULL,
	"minimum_cities_for_subindex" integer DEFAULT 0 NOT NULL,
	"minimum_searches" integer DEFAULT 0 NOT NULL,
	"most_popular_cities" integer DEFAULT 0 NOT NULL,
	"current_country_results" integer DEFAULT 0 NOT NULL,
	"other_countries_results" integer DEFAULT 0 NOT NULL,
	"minimum_searches_from_origin" integer DEFAULT 0 NOT NULL,
	"days_very_high_relevance" integer DEFAULT 0 NOT NULL,
	"days_high_relevance" integer DEFAULT 0 NOT NULL,
	"days_medium_relevance" integer DEFAULT 0 NOT NULL,
	"days_low_relevance" integer DEFAULT 0 NOT NULL,
	"tolerance" integer DEFAULT 0 NOT NULL,
	"nearby_destinations_results" integer DEFAULT 0 NOT NULL,
	"show_destination_info" boolean DEFAULT false NOT NULL,
	CONSTRAINT "uq_cheap_flight_settings_domain" UNIQUE("domain")
);
--> statement-breakpoint
CREATE TABLE "dbo"."city_pair_mileage" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"city_pair_id" varchar NOT NULL,
	"mileage" integer NOT NULL,
	"last_check" timestamp
);
--> statement-breakpoint
CREATE TABLE "dbo"."commission_rate_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"commission_rate" numeric(18, 2) NOT NULL,
	"operations_office_fk" uuid,
	"airlines" varchar NOT NULL,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"operation_offices" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."city_port_time_zone" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"city_port_fk" uuid NOT NULL,
	"utc_offset" double precision NOT NULL,
	"daylight_savings_start" timestamp,
	"daylight_savings_end" timestamp
);
--> statement-breakpoint
CREATE TABLE "dbo"."cms_entry" (
	"key" varchar(100) PRIMARY KEY NOT NULL,
	"value" varchar,
	"description" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."content_page" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"domain_code" char(3) NOT NULL,
	"relative_url" varchar(200) NOT NULL,
	"content_directory" varchar(100),
	"expires" timestamp,
	"redirect_url" varchar(200),
	"experiment_group_code" varchar(50),
	CONSTRAINT "uc_content_page_domain_code_relative_url_experiment_group_code" UNIQUE("domain_code","experiment_group_code","relative_url")
);
--> statement-breakpoint
CREATE TABLE "dbo"."content_image" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"content_fk" uuid NOT NULL,
	"image_file_path" varchar(255),
	"image_caption" varchar(255),
	"sort_order" integer,
	"active" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."continent_area" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"continent_fk" uuid,
	"area_name" varchar,
	"area_code" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."country" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"code" varchar,
	"name" varchar,
	"active" boolean DEFAULT false NOT NULL,
	"allow_in_query" boolean DEFAULT false NOT NULL,
	"allow_in_address" boolean DEFAULT false NOT NULL,
	"priority_in_list" boolean DEFAULT false NOT NULL,
	"ticket_delivery_latency_days" integer DEFAULT 0 NOT NULL,
	"continent_area_fk" uuid,
	"always_auto_charge_credit_cards" boolean DEFAULT false NOT NULL,
	"currency" varchar,
	CONSTRAINT "country_code_key" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."corporate_card" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"card_name" varchar,
	"card_type" varchar NOT NULL,
	"description" varchar,
	"number" varchar,
	"verification_code" varchar,
	"name_on_card" varchar,
	"expiration_date" varchar,
	"currency" varchar NOT NULL,
	"purpose" varchar,
	"cipher_key" varchar,
	"requester_ecn" integer,
	"issued_to_ecn" integer,
	"country_code" varchar,
	"account_id" integer
);
--> statement-breakpoint
CREATE TABLE "dbo"."bundle_product_purchase" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"bundle_offer_id" uuid NOT NULL,
	"currency" char(3) DEFAULT '' NOT NULL,
	"booking_id" uuid NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"price" numeric(18, 2) NOT NULL,
	"passenger_purchases" varchar DEFAULT '' NOT NULL,
	"customer" varchar DEFAULT '' NOT NULL,
	"master_reference_number" varchar DEFAULT '' NOT NULL,
	"confirmation_recipients" varchar DEFAULT '' NOT NULL,
	"flight_detail" varchar DEFAULT '' NOT NULL,
	"departure_date" timestamp NOT NULL,
	"arrival_date" timestamp NOT NULL,
	"status" varchar DEFAULT '' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"booked_price" numeric(18, 2) NOT NULL,
	"booked_currency" char(3) DEFAULT '' NOT NULL,
	"purchase_item_details" varchar DEFAULT '' NOT NULL,
	"confirmation_code" varchar DEFAULT '' NOT NULL,
	"issue_time" timestamp,
	"service_status_code" varchar DEFAULT '' NOT NULL,
	"service_errors" varchar DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."cpa_affiliate" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"affiliate_code" varchar NOT NULL,
	"landing_page" varchar DEFAULT 'BookingForm' NOT NULL,
	"pingback_url" varchar,
	"tracking_parameter" varchar,
	"domain" varchar DEFAULT 'JAU' NOT NULL,
	"queries_per_minute" integer DEFAULT 167 NOT NULL,
	"allowed_api" varchar DEFAULT 'NORMAL' NOT NULL,
	"pre_shared_key" varchar,
	"affiliate_group" varchar,
	"affiliate_cost_percentage" numeric(18, 2) DEFAULT '0'
);
--> statement-breakpoint
CREATE TABLE "dbo"."continent" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"code" varchar,
	"name" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."customer_advice_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar(50) NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"airlines" varchar(1024),
	"origin_ports" varchar(256),
	"origin_countries" varchar(256),
	"origin_continents" varchar(50),
	"destination_ports" varchar(256),
	"destination_countries" varchar(256),
	"destination_continents" varchar(50),
	"cabin_class" varchar(50),
	"booking_class" varchar(50),
	"fare_types" varchar(50),
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"ticketing_latency_days" integer DEFAULT 0 NOT NULL,
	"flight_numbers" varchar(1000),
	"codeshare_airline_codes" varchar(500),
	"flight_type" varchar(500),
	"use_for_adult" boolean DEFAULT false NOT NULL,
	"use_for_child" boolean DEFAULT false NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"customer_advice" varchar,
	"apply_segment_by_segment" boolean NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar(30) DEFAULT 'admin' NOT NULL,
	"app_version" varchar(40) DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"apply_leg_by_leg" boolean DEFAULT false NOT NULL,
	"apply_whole_pnr" boolean DEFAULT false NOT NULL,
	"apply_whole_aggregated_itinerary" boolean DEFAULT false NOT NULL,
	"baggage" boolean DEFAULT false NOT NULL,
	"advice_type" varchar(100),
	"summary" varchar(8000),
	"partial_fare_basis" varchar(50),
	"excluded_origin_ports" varchar(256),
	"excluded_origin_countries" varchar(256),
	"excluded_origin_continents" varchar(50),
	"excluded_destination_ports" varchar(256),
	"excluded_destination_countries" varchar(256),
	"excluded_destination_continents" varchar(50),
	"operation_offices" varchar,
	"search_operation_offices" varchar,
	"search_supplier_source" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."dates_to_avoid_ticketing" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"date" date NOT NULL,
	"note" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."delay_ticketing_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"airlines" varchar,
	"booking_engines" varchar,
	"ticket_delay_time" varchar,
	"note" varchar,
	"operation_office_id" varchar,
	"active" boolean NOT NULL,
	"date_changed" timestamp NOT NULL,
	"user_name" varchar,
	"operating_carriers" varchar,
	"processing_delay_hours" integer DEFAULT 0 NOT NULL,
	"is_flight_number_masked" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."destinations" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar(50),
	"blurb" varchar,
	"active" boolean DEFAULT false NOT NULL,
	"header" varchar,
	"auto_generated" boolean NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."domain_conversion_url" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"domain_fk" uuid NOT NULL,
	"url" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."duffel_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"airline_substitution" varchar DEFAULT '',
	"operations_office_id" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"parameter_id" uuid,
	"airline_exclusion" varchar DEFAULT '',
	"max_connections" integer,
	"offer_limit" integer DEFAULT 200 NOT NULL,
	"supplier_time_out" integer
);
--> statement-breakpoint
CREATE TABLE "dbo"."dynamic_flight_search_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"operations_office_id" varchar,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"affiliates_to_include_for_metasearch" varchar,
	"exclude_from_metasearch" boolean DEFAULT false,
	"parameter_id" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."fare_family_flight_query_parameters" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"airline" varchar DEFAULT '' NOT NULL,
	"fare_including_baggage" varchar,
	"fare_excluding_baggage" varchar,
	"partial_fare_basis" boolean DEFAULT true NOT NULL,
	"recommendation_count" integer DEFAULT 0 NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"airline_substitution" varchar,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"operations_office_id" varchar,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"parameter_id" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."exchange_rate" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"currency_code" char(3) NOT NULL,
	"description" varchar DEFAULT '' NOT NULL,
	"actual_rate" numeric(18, 10) DEFAULT '0' NOT NULL,
	"reciprocal_rate" numeric(18, 10) DEFAULT '0' NOT NULL,
	"last_updated" timestamp NOT NULL,
	"allow_automatic_update" boolean DEFAULT false NOT NULL,
	"maximum_allowed_automatic_update_percentage" numeric(10, 5) DEFAULT '0' NOT NULL,
	"conversion_uplift" numeric(10, 5) DEFAULT '0' NOT NULL,
	"rounding_factor" numeric(10, 5) DEFAULT '0' NOT NULL,
	"is_in_cannonball" boolean DEFAULT false NOT NULL,
	"display_order" smallint DEFAULT 0 NOT NULL,
	"is_european_currency" boolean DEFAULT false NOT NULL,
	"as_at" timestamp NOT NULL,
	"is_charged_in_aud" boolean DEFAULT false NOT NULL,
	"payment_gateway_code" char(3),
	CONSTRAINT "ck_exchange_rate_payment_gateway_code" CHECK ((payment_gateway_code = ''::bpchar) OR ((payment_gateway_code = 'SPY'::bpchar) OR ((payment_gateway_code = 'PFP'::bpchar) OR ((payment_gateway_code = 'EWY'::bpchar) OR ((payment_gateway_code = 'FTZ'::bpchar) OR (payment_gateway_code = 'SPD'::bpchar))))))
);
--> statement-breakpoint
CREATE TABLE "dbo"."exclusion_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"booking_class" varchar,
	"fare_types" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"is_combination_airline_results_exclusion_rule" boolean DEFAULT false NOT NULL,
	"is_contained_airline_results_exclusion_rule" boolean DEFAULT false NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"ticketing_latency_days" integer DEFAULT 0 NOT NULL,
	"flight_numbers" varchar,
	"codeshare_airline_codes" varchar,
	"flight_type" varchar,
	"is_non_companion_passenger_count_exclusion_rule" boolean DEFAULT false NOT NULL,
	"use_for_adult" boolean DEFAULT false NOT NULL,
	"use_for_child" boolean DEFAULT false NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"geolocation_included_continents" varchar,
	"geolocation_included_countries" varchar,
	"geolocation_excluded_continents" varchar,
	"geolocation_excluded_countries" varchar,
	"is_multiple_carrier_combination_excluded" boolean DEFAULT false NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"partial_fare_basis" varchar,
	"excluded_search_engines" varchar,
	"operation_offices" varchar,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer,
	"affiliate" varchar,
	"validating_carriers" varchar,
	"marketing_carrier_has_no_display_flight_numbers" boolean DEFAULT false NOT NULL,
	"is_for_revalidate_time" boolean DEFAULT true NOT NULL,
	"is_for_search_time" boolean DEFAULT true NOT NULL,
	"departure_date_pattern_query" varchar,
	"carrier_segment_pattern_query" varchar,
	"fare_basis_exact_match_pattern_query" varchar,
	"supplier_source" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."experiment_group" (
	"name" varchar(250) PRIMARY KEY NOT NULL,
	"code" varchar(50),
	"url_substring" varchar(255),
	"active" boolean DEFAULT true,
	"is_deleted" boolean DEFAULT false,
	"percentage" numeric(5, 2) DEFAULT '0' NOT NULL,
	"booking_form_script" varchar,
	"booking_form_css" varchar,
	"is_sticky" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."failed_booking_attempt" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"record_locator" varchar NOT NULL,
	"booking_date_time" timestamp NOT NULL,
	"child_record_locators" varchar NOT NULL,
	"city_pair" varchar NOT NULL,
	"payment_type" char(1),
	"equiv_aud_ttv" numeric(10, 2) NOT NULL,
	"total_departure_less_booking_days" integer NOT NULL,
	"fare_type" varchar NOT NULL,
	"failure_reason" varchar,
	"booking_request_fk" uuid NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."donation_setting" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"domain_code" char(3) NOT NULL,
	"active" boolean NOT NULL,
	"project_id" integer NOT NULL,
	"booking_form_html" varchar NOT NULL,
	"confirmation_page_html" varchar NOT NULL,
	"email_html" varchar NOT NULL,
	"yes_text" varchar(256) NOT NULL,
	"partner_active" boolean NOT NULL,
	"partner_name" varchar(64) NOT NULL,
	"offer_text" varchar(256) NOT NULL,
	"no_text" varchar(256) NOT NULL,
	"partner_amount2" numeric(4, 2) NOT NULL,
	"partner_amount5" numeric(4, 2) NOT NULL,
	"charity" varchar(128) DEFAULT '' NOT NULL,
	"project" varchar(128) DEFAULT '' NOT NULL,
	CONSTRAINT "ix_footprints_setting_domain_code" UNIQUE("domain_code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."fare_surcharge_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"use_for_adult" boolean DEFAULT true NOT NULL,
	"use_for_child" boolean DEFAULT true NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"booking_class" varchar,
	"fare_types" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"surcharge_amount" numeric(18, 2) DEFAULT '0' NOT NULL,
	"surcharge_currency_code" varchar DEFAULT '' NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_type" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"included_search_engines" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."domain" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"code" char(3) NOT NULL,
	"country_or_continent_code" varchar(2) DEFAULT '' NOT NULL,
	"country_or_continent_name" varchar(50) DEFAULT '' NOT NULL,
	"cheap_flights_link_domain_code" varchar(3) DEFAULT '' NOT NULL,
	"display_name" varchar(50) DEFAULT '' NOT NULL,
	"google_analytics_account" varchar(50) DEFAULT '' NOT NULL,
	"promotion_suffix" varchar(10) DEFAULT '' NOT NULL,
	"supports_insurance" boolean DEFAULT false NOT NULL,
	"top_level_domain" varchar(50) DEFAULT '' NOT NULL,
	"default_cannonball_currency_code" varchar(3) DEFAULT 'AUD' NOT NULL,
	"european_users_default_to_euro_currency_code" boolean DEFAULT false NOT NULL,
	"payment_methods_message" varchar(255) DEFAULT '' NOT NULL,
	"payment_methods_image_url" varchar(255) DEFAULT '' NOT NULL,
	"small_cannonball_payment_methods_image_url" varchar(255) DEFAULT '' NOT NULL,
	"supports_visa" boolean DEFAULT false NOT NULL,
	"supports_mastercard" boolean DEFAULT false NOT NULL,
	"supports_diners" boolean DEFAULT false NOT NULL,
	"supports_amex" boolean DEFAULT false NOT NULL,
	"supports_paypal" boolean DEFAULT false NOT NULL,
	"supports_bank_deposit" boolean DEFAULT false NOT NULL,
	"supports_telephone_callback" boolean DEFAULT false NOT NULL,
	"randomise_footer_homepage_link" boolean DEFAULT false NOT NULL,
	"optimiser_uacct" varchar(20),
	"optimiser_experiment_id" varchar(20),
	"homepage_content_directory" varchar(100) NOT NULL,
	"google_analytics_domain_name" varchar(50) DEFAULT 'none' NOT NULL,
	"show_help_panel_during_booking" boolean DEFAULT false NOT NULL,
	"show_help_panel_when_booking_failed" boolean DEFAULT false NOT NULL,
	"wait_panel_image_relative_url" varchar(200) NOT NULL,
	"hitwise_link_url" varchar(200),
	"hotels_enabled" boolean DEFAULT false NOT NULL,
	"hotels_url" varchar(200),
	"universal_analytics_account" varchar(50),
	"insurance_url" varchar(1000),
	"google_remarketing_conversion_id" varchar(50),
	CONSTRAINT "ix_domain_code" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."fee_uplift_via_margin_guess" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"range_from" integer DEFAULT 0 NOT NULL,
	"uplift_fee_amount" numeric(18, 2) DEFAULT '0',
	"fee_rule_fk" uuid,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"apply_per_leg" boolean DEFAULT false NOT NULL,
	"uplift_fee_percent" numeric(18, 4) DEFAULT '0' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fee_uplift_per_booking" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"range_from" integer DEFAULT 0 NOT NULL,
	"service_uplift_amount" numeric(18, 2) DEFAULT '0' NOT NULL,
	"service_uplift_percent" numeric(18, 4) DEFAULT '0' NOT NULL,
	"fee_rule_fk" uuid NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fees_and_charges" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"currency_code" varchar(3) NOT NULL,
	"refund_fee" numeric(18, 0) NOT NULL,
	"ticket_change_fee" numeric(18, 0) DEFAULT '0' NOT NULL,
	"telephone_booking_fee" numeric(18, 0) DEFAULT '0' NOT NULL,
	"group_booking_fee" numeric(18, 0) DEFAULT '0' NOT NULL,
	"invoice_fee" numeric(18, 0) DEFAULT '0' NOT NULL,
	"ticket_delivery_fee" numeric(18, 0) DEFAULT '0' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_booking_archive" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"flight_query_fk" uuid,
	"domestic" boolean DEFAULT false NOT NULL,
	"date_time" timestamp NOT NULL,
	"adult_count" integer DEFAULT 0 NOT NULL,
	"child_count" integer DEFAULT 0 NOT NULL,
	"infant_count" integer DEFAULT 0 NOT NULL,
	"passenger_count" integer DEFAULT 0 NOT NULL,
	"flight_booking_request_fk" uuid NOT NULL,
	"record_locator" varchar DEFAULT '' NOT NULL,
	"purchase_currency_code" varchar DEFAULT '' NOT NULL,
	"purchase_total_amount" numeric(18, 5) DEFAULT '0' NOT NULL,
	"purchase_service_fee_amount" numeric(18, 5) DEFAULT '0' NOT NULL,
	"purchaser_country_code" varchar DEFAULT '' NOT NULL,
	"fare_type" varchar DEFAULT '' NOT NULL,
	"main_carrier" varchar DEFAULT '' NOT NULL,
	"all_carriers" varchar DEFAULT '' NOT NULL,
	"alliance" varchar DEFAULT '' NOT NULL,
	"payment_type" char(1),
	"purchase_expedited_ticket_delivery_fee" numeric(18, 5) DEFAULT '0' NOT NULL,
	"purchase_callback_fee" numeric(18, 5) DEFAULT '0' NOT NULL,
	"succeeded" boolean DEFAULT false NOT NULL,
	"phone_area_code" varchar,
	"city_or_suburb" varchar,
	"post_code" varchar,
	"domain_code" char(3),
	"affiliate" varchar,
	"geolocated_country" varchar,
	"child_record_locators" varchar DEFAULT '' NOT NULL,
	"dj_search_count" integer DEFAULT 0 NOT NULL,
	"hh_search_count" integer DEFAULT 0 NOT NULL,
	"affiliate_medium" varchar,
	"affiliate_campaign" varchar,
	"affiliate_cookie_drop" timestamp,
	"purchase_affiliate_commissionable_amount" numeric(18, 5),
	"email_address" varchar DEFAULT '' NOT NULL,
	"donation" numeric(4, 2) DEFAULT '0' NOT NULL,
	"am_search_count" integer DEFAULT 0 NOT NULL,
	"voucher_redeemed_amount" numeric(18, 5),
	"revenue" numeric(18, 2) DEFAULT '0' NOT NULL,
	"base_fare_type" varchar DEFAULT '' NOT NULL,
	"is_search_force_conversion" boolean DEFAULT false NOT NULL,
	"purchaser_full_name" varchar DEFAULT '' NOT NULL,
	"partner_donation" numeric(4, 2) DEFAULT '0' NOT NULL,
	"donation_charity" varchar DEFAULT '' NOT NULL,
	"donation_project" varchar DEFAULT '' NOT NULL,
	"paypal_email" varchar,
	"promo_code" varchar,
	"affiliate_sub_id" varchar,
	"is_lowest_price" boolean DEFAULT false NOT NULL,
	"is_above_lowest_price_and_below_average_price" boolean DEFAULT false NOT NULL,
	"is_above_average_price" boolean DEFAULT false NOT NULL,
	"google_source" varchar,
	"google_medium" varchar,
	"google_campaign" varchar,
	"cancelled" boolean DEFAULT false NOT NULL,
	"ev_search_count" integer DEFAULT 0 NOT NULL,
	"yp_booking_count" integer DEFAULT 0 NOT NULL,
	"am_booking_count" integer DEFAULT 0 NOT NULL,
	"dj_booking_count" integer DEFAULT 0 NOT NULL,
	"hh_booking_count" integer DEFAULT 0 NOT NULL,
	"tf_search_count" integer DEFAULT 0 NOT NULL,
	"tf_booking_count" integer DEFAULT 0 NOT NULL,
	"itinerary" varchar DEFAULT '' NOT NULL,
	"vy_search_count" integer,
	"sa_search_count" integer,
	"sa_booking_count" integer,
	"office_id" varchar,
	"ds_search_count" integer,
	"insurance" numeric(18, 3),
	"payment_surcharge" numeric(18, 3),
	"purchaser_phone_number" varchar,
	"final_arrival_date" timestamp,
	"affiliate_device" varchar,
	"full_gst_amount" numeric(18, 5)
);
--> statement-breakpoint
CREATE TABLE "dbo"."fee_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"use_for_adult" boolean DEFAULT true NOT NULL,
	"use_for_child" boolean DEFAULT true NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"booking_class" varchar,
	"fare_types" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"uplift_from_base_fare" boolean DEFAULT false NOT NULL,
	"uplift_from_base_with_tax" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_type" varchar,
	"apply_only_when_airline_operates_no_segments" boolean DEFAULT false NOT NULL,
	"currency_code" varchar DEFAULT '' NOT NULL,
	"rule_level" smallint DEFAULT 1 NOT NULL,
	"affiliate" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"included_search_engines" varchar,
	"operations_office_fk" uuid,
	"search_flight_types" varchar,
	"aggregation_type" varchar,
	"multicity_min_legs" integer DEFAULT 0 NOT NULL,
	"multicity_max_legs" integer DEFAULT 0 NOT NULL,
	"operation_offices" varchar,
	"destination_match_type" varchar DEFAULT 'AnyInJourney' NOT NULL,
	"domains" varchar DEFAULT '' NOT NULL,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer,
	"city_port_pattern_query" varchar,
	"port_segment_pattern_query" varchar,
	"carrier_segment_pattern_query" varchar,
	"departure_date_pattern_query" varchar,
	"supplier_source" varchar,
	"is_price_change_rule" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_booking_tracking_value_factor" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"tag" varchar DEFAULT '' NOT NULL,
	"success" integer DEFAULT 0 NOT NULL,
	"bank_deposit" integer DEFAULT 0 NOT NULL,
	"callback" integer DEFAULT 0 NOT NULL,
	CONSTRAINT "uq_flight_booking_tracking_value_factor_tag" UNIQUE("tag")
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_query_segment" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"departure_port_fk" uuid NOT NULL,
	"arrival_port_fk" uuid NOT NULL,
	"arrival_port_is_designated_stopover" boolean NOT NULL,
	"departure_date_time" timestamp NOT NULL,
	"segment_number" integer DEFAULT 0 NOT NULL,
	"is_departure_time_specified" boolean
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_number_replacement" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"start_date" timestamp,
	"end_date" timestamp,
	"source_flight_number" varchar,
	"departure_port" varchar,
	"arrival_port" varchar,
	"replacement_flight_numbers" varchar,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP,
	"active" boolean DEFAULT false NOT NULL,
	"replacement_valid_start_date" timestamp,
	"replacement_valid_end_date" timestamp
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_query" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"session_fk" uuid NOT NULL,
	"is_requery" boolean DEFAULT false NOT NULL,
	"currency_code" varchar NOT NULL,
	"internal_fare_references" varchar,
	"fare_class" varchar,
	"flight_type" varchar NOT NULL,
	"adult_passenger_count" smallint NOT NULL,
	"child_passenger_count" smallint NOT NULL,
	"infant_passenger_count" smallint NOT NULL,
	"carrier_preference_code" varchar NOT NULL,
	"is_metasearch" boolean,
	"query_date_time" timestamp,
	"affiliate_code" varchar,
	"attribute_to_affiliate" varchar,
	"query_date_time_utc" timestamp with time zone
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_voucher" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"customer_email" varchar NOT NULL,
	"voucher_code" varchar NOT NULL,
	"amount" numeric(18, 2) NOT NULL,
	"amount_currency" varchar NOT NULL,
	"status" varchar,
	"created_date" timestamp NOT NULL,
	"expiry_date" timestamp,
	"last_booking_request_fk" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_check_city" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"city" varchar(128) NOT NULL,
	"country_code" varchar(2)
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_check_country" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"country" varchar(128) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_check_email" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"email" varchar(256) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_check_isp_name" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"isp_name" varchar(128) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_check_passenger_name" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar(256) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."fee_uplift_per_passenger" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"range_from" integer DEFAULT 0 NOT NULL,
	"base_uplift_amount" numeric(18, 2) DEFAULT '0',
	"base_uplift_percent" numeric(18, 4) DEFAULT '0',
	"service_uplift_amount" numeric(18, 2) DEFAULT '0',
	"service_uplift_percent" numeric(18, 4) DEFAULT '0',
	"fee_rule_fk" uuid,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_voucher_history" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_voucher_fk" uuid NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"amount" numeric(18, 2) NOT NULL,
	"amount_currency" varchar NOT NULL,
	"applied_date" timestamp NOT NULL,
	"user_name" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."fraud_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar(50) NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"airlines" varchar(1024),
	"origin_ports" varchar(256),
	"origin_countries" varchar(256),
	"origin_continents" varchar(50),
	"destination_ports" varchar(256),
	"destination_countries" varchar(256),
	"destination_continents" varchar(50),
	"cabin_class" varchar(50),
	"booking_class" varchar(50),
	"fare_types" varchar(50),
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"ticketing_latency_days" integer DEFAULT 0 NOT NULL,
	"flight_type" varchar(500),
	"is_non_companion_passenger_count_fraud_rule" boolean DEFAULT false NOT NULL,
	"use_for_adult" boolean DEFAULT false NOT NULL,
	"use_for_child" boolean DEFAULT false NOT NULL,
	"use_for_infant" boolean DEFAULT false NOT NULL,
	"geolocation_included_continents" varchar(50),
	"geolocation_included_countries" varchar(256),
	"geolocation_excluded_continents" varchar(50),
	"geolocation_excluded_countries" varchar(256),
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar(30) DEFAULT 'admin' NOT NULL,
	"app_version" varchar(40) DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"bank_country_codes" varchar(5000),
	"bank_names" varchar(5000)
);
--> statement-breakpoint
CREATE TABLE "dbo"."insurance_purchase" (
	"id" uuid PRIMARY KEY NOT NULL,
	"booking_id" uuid NOT NULL,
	"plan_id" varchar NOT NULL,
	"plan_cost" numeric(18, 2) NOT NULL,
	"plan_cost_currency" char(3) NOT NULL,
	"created_time" timestamp NOT NULL,
	"reference_number" varchar DEFAULT '' NOT NULL,
	"issued_time" timestamp,
	"total_ticket_price" numeric(18, 2),
	"total_ticket_price_currency" char(3),
	"purchaser_telephone" varchar NOT NULL,
	"purchaser_address_line1" varchar,
	"purchaser_address_line2" varchar,
	"purchaser_city" varchar,
	"purchaser_postal_code" varchar,
	"purchaser_country" varchar,
	"covered_persons" varchar NOT NULL,
	"status" varchar DEFAULT '' NOT NULL,
	"row_version" "bytea" DEFAULT convert_to(to_char(CURRENT_TIMESTAMP, 'YYYY-MM-DD HH24:MI:SS.US'::text), 'UTF8'::name) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."margin_header" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"booking_attempt_fk" uuid NOT NULL,
	"price_key" varchar NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"booking_request_fk" uuid,
	"booking_result_fk" uuid,
	"reference_number" varchar,
	"search_engine" char(2) NOT NULL,
	"booking_engine" char(2),
	"office_id" varchar NOT NULL,
	"validating_airline" varchar,
	"is_net" boolean NOT NULL,
	"purchase_currency_code" varchar NOT NULL,
	"purchase_amount" numeric(18, 2) NOT NULL,
	"office_currency_code" varchar NOT NULL,
	"total_amount" numeric(18, 2) NOT NULL,
	"log_date_time" timestamp NOT NULL,
	"reason" varchar,
	"itinerary" varchar,
	"ticket_type_code" varchar,
	"contribution_to_overhead_currency" varchar DEFAULT 'AUD' NOT NULL,
	"gross_revenue_flights" numeric(18, 2) DEFAULT '0.00' NOT NULL,
	"contribution_to_overhead" numeric(18, 2) DEFAULT '0.00' NOT NULL,
	"expected_contribution_to_overhead" numeric(18, 2) DEFAULT '0.00' NOT NULL,
	"flight_ttv" numeric(18, 2) DEFAULT '0.00' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."json_fares" (
	"content_key" varchar PRIMARY KEY NOT NULL,
	"office_id" varchar NOT NULL,
	"itinerary_key" varchar NOT NULL,
	"cost" numeric(18, 2) NOT NULL,
	"cost_currency" varchar NOT NULL,
	"travel_class" varchar NOT NULL,
	"legs" jsonb NOT NULL,
	"last_modified_date_time" timestamp with time zone NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."margin_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"use_for_adult" boolean NOT NULL,
	"use_for_child" boolean NOT NULL,
	"use_for_infant" boolean NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"booking_class" varchar,
	"fare_types" varchar,
	"weight_adjustment" double precision NOT NULL,
	"active" boolean NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean NOT NULL,
	"flight_type" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar NOT NULL,
	"app_version" varchar NOT NULL,
	"date_changed" timestamp NOT NULL,
	"notes" varchar NOT NULL,
	"included_search_engines" varchar,
	"included_booking_engines" varchar,
	"affiliate" varchar,
	"operations_office_fk" uuid,
	"validating_carriers" varchar,
	"scope_type" varchar NOT NULL,
	"amount_type" varchar NOT NULL,
	"currency_code" varchar,
	"margin_type" varchar NOT NULL,
	"margin_percentage" numeric(18, 4) DEFAULT '0' NOT NULL,
	"margin_value" numeric(18, 2) DEFAULT '0' NOT NULL,
	"exclude_code_share" boolean NOT NULL,
	"except_code_share_airlines" varchar,
	"include_tax" boolean NOT NULL,
	"tax_codes" varchar,
	"operation_offices" varchar,
	"account_codes" varchar,
	"corporate_codes" varchar,
	"partial_fare_basis" varchar,
	"retailer_codes" varchar,
	"search_flight_types" varchar,
	"flight_numbers" varchar,
	"minimum_adult_passenger_count" integer,
	"domains" varchar DEFAULT '' NOT NULL,
	"operating_carriers" varchar,
	"record_only" boolean DEFAULT false NOT NULL,
	"excluded_origin_ports" varchar,
	"excluded_origin_countries" varchar,
	"excluded_origin_continents" varchar,
	"excluded_destination_ports" varchar,
	"excluded_destination_countries" varchar,
	"excluded_destination_continents" varchar,
	"aggregation_type" varchar,
	"purchase_currencies" varchar,
	"payment_types" varchar DEFAULT '' NOT NULL,
	"expected_only" boolean DEFAULT false NOT NULL,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer,
	"search_sources" varchar,
	"operating_carriers_exact_match" boolean DEFAULT false NOT NULL,
	"apply_route_to_target" varchar,
	"arrival_date_from" timestamp,
	"arrival_date_to" timestamp,
	"excluded_partial_fare_basis" varchar,
	"tour_code" varchar,
	"ticket_designator" varchar,
	"endorsements" varchar,
	"marketing_carriers_closed_match" boolean DEFAULT false NOT NULL,
	"operating_carriers_closed_match" boolean DEFAULT false NOT NULL,
	"sub_fare_construction" varchar,
	"minimum_base_fare_plus_tax" numeric(18, 2),
	"maximum_base_fare_plus_tax" numeric(18, 2),
	"excluded_port_segment_pattern" varchar,
	"excluded_flight_numbers" varchar,
	"include_queue_surcharge" boolean DEFAULT true NOT NULL,
	"supplier_source" varchar,
	"is_revalidate_only" boolean DEFAULT false NOT NULL,
	"carrier_segment_pattern" varchar,
	"departure_pattern" varchar,
	"fare_basis_pattern" varchar,
	"transit_ports" varchar,
	"transit_countries" varchar,
	"transit_continents" varchar,
	"excluded_transit_ports" varchar,
	"excluded_transit_countries" varchar,
	"excluded_transit_continents" varchar,
	"apply_scope_type_per_passenger" boolean DEFAULT false
);
--> statement-breakpoint
CREATE TABLE "dbo"."margin_rule_applicable" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"margin_rule_fk" uuid NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"date_changed" timestamp NOT NULL,
	"flight_numbers" varchar,
	"operating_carriers" varchar,
	"excluded_origin_ports" varchar,
	"excluded_origin_countries" varchar,
	"excluded_origin_continents" varchar,
	"excluded_destination_ports" varchar,
	"excluded_destination_countries" varchar,
	"excluded_destination_continents" varchar,
	"operating_carriers_exact_match" boolean DEFAULT false NOT NULL,
	"operating_carriers_closed_match" boolean DEFAULT false NOT NULL,
	"marketing_carriers_closed_match" boolean DEFAULT false NOT NULL,
	"excluded_flight_numbers" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."operations_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"operations_office_fk" uuid NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_type" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."master_data_tables" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"table" varchar(255) NOT NULL,
	"is_master_data" boolean NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."meta_tag" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"domain" varchar(10) DEFAULT '' NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"relative_url" varchar(256) DEFAULT '' NOT NULL,
	"name" varchar(16) DEFAULT '' NOT NULL,
	"content" varchar(512) DEFAULT '' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."metasearch_multicity_rule" (
	"id" uuid PRIMARY KEY NOT NULL,
	"affiliate" varchar,
	"first_ports" varchar,
	"first_countries" varchar,
	"first_continents" varchar,
	"last_ports" varchar,
	"last_countries" varchar,
	"last_continents" varchar,
	"vice_versa" boolean NOT NULL,
	"reject" boolean NOT NULL,
	"weight_adjustment" double precision NOT NULL,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"domains" varchar DEFAULT '' NOT NULL,
	"search_flight_types" varchar,
	"multicity_min_legs" integer DEFAULT 0 NOT NULL,
	"multicity_max_legs" integer DEFAULT 0 NOT NULL,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"excluded_origin_ports" varchar,
	"excluded_origin_countries" varchar,
	"excluded_origin_continents" varchar,
	"excluded_destination_ports" varchar,
	"excluded_destination_countries" varchar,
	"excluded_destination_continents" varchar,
	"name" varchar DEFAULT '' NOT NULL,
	"rule_id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"user_name" varchar,
	"app_version" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar,
	"expiry_date" timestamp,
	"effective_date" timestamp,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer,
	"cabin_class" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."metasearch_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"affiliates" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"apply_vice_versa_on_origin_destination_pair" boolean NOT NULL,
	"reject" boolean DEFAULT false NOT NULL,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"domains" varchar DEFAULT '' NOT NULL,
	"search_flight_types" varchar,
	"excluded_origin_ports" varchar,
	"excluded_origin_countries" varchar,
	"excluded_origin_continents" varchar,
	"excluded_destination_ports" varchar,
	"excluded_destination_countries" varchar,
	"excluded_destination_continents" varchar,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"name" varchar DEFAULT '' NOT NULL,
	"rule_id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"user_name" varchar,
	"app_version" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer,
	"cabin_class" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."net_income_percentage" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"base_fare_type" varchar(20) NOT NULL,
	"standard_commision" numeric(18, 2) NOT NULL,
	"override" numeric(18, 2) NOT NULL,
	"gds_rebate" numeric(18, 2) NOT NULL,
	"merchant_fee" numeric(18, 2) NOT NULL,
	"gross_up_multiple" numeric(18, 2) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."one_way_aggregate_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"whole_itinerary_limited_to_ports" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"cabin_class" varchar DEFAULT '' NOT NULL,
	"flight_type" varchar,
	"oneway_aggregate_excluded" boolean DEFAULT false NOT NULL,
	"is_autocharged" boolean DEFAULT true NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"multicity_min_legs" integer DEFAULT 0 NOT NULL,
	"multicity_max_legs" integer DEFAULT 0 NOT NULL,
	"search_flight_types" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."generic_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"parameter_id" uuid,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"operations_office_id" varchar NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"execution_order" integer NOT NULL,
	"rule_id" uuid NOT NULL,
	"notes" text DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."operations_office" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"office_id" varchar DEFAULT '' NOT NULL,
	"search_currency_code" char(3) DEFAULT 'AUD' NOT NULL,
	"hh_terminal_country" varchar DEFAULT 'AU' NOT NULL,
	"hh_terminal_pcc" varchar DEFAULT '' NOT NULL,
	"hh_booking_pcc" varchar DEFAULT '' NOT NULL,
	"hh_booking_queue" varchar DEFAULT '00' NOT NULL,
	"hh_booking_category" varchar DEFAULT '0' NOT NULL,
	"hh_get_pnr_country" varchar DEFAULT 'AU' NOT NULL,
	"hh_get_pnr_pcc" varchar DEFAULT '' NOT NULL,
	"am_terminal_pcc" varchar DEFAULT '' NOT NULL,
	"am_booking_pcc" varchar DEFAULT '' NOT NULL,
	"am_organization_id" varchar DEFAULT '' NOT NULL,
	"haystack_pcc" varchar,
	"am_auto_ticket_pcc" uuid,
	"am_search_pcc" uuid,
	"am_retrieve_pnrpcc" uuid,
	"am_amsell_pcc" uuid,
	"am_evsell_pcc" uuid,
	"am_evsearch_pcc" uuid,
	"am_hhsearch_pcc" uuid,
	"am_hhsell_pcc" uuid,
	"am_transfer_pcc" uuid,
	"alternate_office_fk" uuid NOT NULL,
	"am_vysell_pcc" uuid,
	"sa_retrieve_pnrpcc" uuid,
	"sa_auto_ticket_pcc" uuid,
	"sa_search_pcc" uuid,
	"sa_hhsell_pcc" uuid,
	"sa_vysell_pcc" uuid,
	"sa_sasell_pcc" uuid,
	"sa_amsell_pcc" uuid,
	"am_sasell_pcc" uuid,
	"location_code" varchar,
	"sa_transfer_pcc" uuid,
	"sa_hhsearch_pcc" uuid,
	"is_allowed_for_query" boolean DEFAULT false NOT NULL,
	CONSTRAINT "ix_office_id" UNIQUE("office_id"),
	CONSTRAINT "uk_operations_office_office_id" UNIQUE("office_id")
);
--> statement-breakpoint
CREATE TABLE "dbo"."payment_offer_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar(50) NOT NULL,
	"code" varchar(50) NOT NULL,
	"summary_text" varchar NOT NULL,
	"expanded_text" varchar NOT NULL,
	"detailed_text" varchar NOT NULL,
	"action_button_text" varchar NOT NULL,
	"service_fee_percent" numeric(18, 2) NOT NULL,
	"service_fee_absolute_amount" numeric(18, 2) NOT NULL,
	"service_fee_absolute_currency" varchar(3) NOT NULL,
	"deposit_percent" numeric(18, 2) NOT NULL,
	"deposit_absolute_amount" numeric(18, 2) NOT NULL,
	"deposit_absolute_currency" varchar(3) NOT NULL,
	"cash_refund_percent" numeric(18, 2) NOT NULL,
	"credit_refund_percent" numeric(18, 2) NOT NULL,
	"minimum_days_until_departure" integer,
	"maximum_days_until_departure" integer,
	"minimum_price" numeric(18, 2),
	"minimum_price_currency" varchar(3),
	"maximum_price" numeric(18, 2),
	"maximum_price_currency" varchar(3),
	"minimum_percentage_refundable" numeric(18, 2),
	"maximum_percentage_refundable" numeric(18, 2),
	"search_flight_types" varchar(500),
	"aggregation_type" varchar(500),
	"included_search_engines" varchar(500),
	"number_of_payment_plan" integer DEFAULT 0 NOT NULL,
	"number_of_payment_day" integer DEFAULT 0,
	"active" boolean DEFAULT false NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"weight_adjustment" numeric(18, 2) DEFAULT '0' NOT NULL,
	"user_name" varchar(30) NOT NULL,
	"app_version" varchar(40) DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"validating_carriers" varchar,
	"spread_service_fee_across_payment" boolean DEFAULT false NOT NULL,
	"spread_ancillaries_across_payment" boolean DEFAULT false NOT NULL,
	"rule_id" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"terms_and_conditions_url" varchar,
	"terms_and_conditions_brief" varchar,
	"terms_and_conditions_full" varchar,
	"order_summary_line_item" varchar,
	"payment_information_sms" varchar,
	"payment_information_email_subject" varchar,
	"payment_information_email_body" varchar,
	"experiment_group_code" varchar(50),
	"booking_form_script" varchar,
	"booking_form_css" varchar,
	"view_detail_link_text" varchar,
	"minimum_cto_percentage" numeric(18, 2),
	"maximum_cto_percentage" numeric(18, 2),
	"nonrefundable_text" varchar,
	"no_changes_allow_text" varchar,
	"excluded_port_segment_pattern" varchar(8000),
	"excluded_validating_carriers" varchar,
	"minimum_base_fare_plus_tax" numeric(18, 2),
	"maximum_base_fare_plus_tax" numeric(18, 2),
	"included_features" varchar,
	"search_operation_offices" varchar,
	"search_supplier_source" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."page_footer" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"domain_code" char(3),
	"active" boolean NOT NULL,
	"uri" varchar NOT NULL,
	"display_text" varchar NOT NULL,
	"level" smallint NOT NULL,
	"priority" smallint NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."payment_type_surcharge_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"rule_id" uuid NOT NULL,
	"app_version" varchar,
	"notes" varchar,
	"domain_codes" varchar,
	"search_currency_codes" varchar,
	"search_sources" varchar,
	"airlines" varchar,
	"payment_type" varchar,
	"fixed_cost" numeric(18, 2) NOT NULL,
	"percentage_cost" numeric(18, 4) NOT NULL,
	"is_default_selected" boolean NOT NULL,
	"fixed_cost_currency" char(3) DEFAULT 'AUD' NOT NULL,
	"fare_types" varchar,
	"domains" varchar,
	"search_currencies" varchar,
	"payment_gateway_code" varchar NOT NULL,
	"affiliates" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"user_name" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_office" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"office_id" varchar NOT NULL,
	"username" varchar,
	"password" varchar,
	"location_code" varchar,
	"is_general_purpose" boolean DEFAULT false NOT NULL,
	"session_office_fk" uuid,
	"office_country" varchar,
	"time_zone_id" varchar,
	"booking_agency_address" varchar,
	"booking_agency_phone" varchar,
	"printer_code" varchar,
	"printer_location" varchar,
	"document_key_number" varchar,
	"invoice_printer_code" varchar,
	"custom_remarks" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."price_alert_subscription" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"flight_query_fk" uuid NOT NULL,
	"subscription_status" varchar(50) NOT NULL,
	"email" varchar(254) NOT NULL,
	"start_date" timestamp NOT NULL,
	"end_date" timestamp NOT NULL,
	"last_alert_sent" timestamp
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_alternate_office_airline_preference" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"sabre_parameter_alternate_office_fk" uuid NOT NULL,
	"airline_code" varchar NOT NULL,
	"airline_preference" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."product_selection_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"affiliate" varchar,
	"route" varchar,
	"selection_setting" varchar,
	"weight_adjustment" double precision NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."promotion" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"code" varchar NOT NULL,
	"twitter_text" varchar NOT NULL,
	"facebook_title" varchar NOT NULL,
	"facebook_description" varchar NOT NULL,
	"facebook_landing_url" varchar NOT NULL,
	"facebook_image_src" varchar NOT NULL,
	"order_summary_width" integer DEFAULT 0 NOT NULL,
	"order_summary_height" integer DEFAULT 0 NOT NULL,
	"icon_width" integer DEFAULT 99 NOT NULL,
	"icon_height" integer DEFAULT 43 NOT NULL,
	"order_summary_suffix_text" varchar,
	"icon_overlay_style" varchar DEFAULT 'color: White; font-size: 18px; font-weight: bold; padding-top: 19px; padding-left: 15px;' NOT NULL,
	"order_summary_overlay_style" varchar DEFAULT 'color: White; font-size: 18px; font-weight: bold; padding-top: 19px; padding-left: 15px;' NOT NULL,
	"icon_static_overlay_style" varchar NOT NULL,
	"show_social_network_icons" boolean DEFAULT true NOT NULL,
	"show_order_summary_banner" boolean DEFAULT true NOT NULL,
	"show_icon_on_booking_page" boolean DEFAULT true NOT NULL,
	CONSTRAINT "uq_promotion_code" UNIQUE("code")
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_parameter_alternate_office" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"sabre_parameter_fk" uuid NOT NULL,
	"code" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"exclude_published_fares" boolean DEFAULT false NOT NULL,
	"exclude_nego_fares" boolean DEFAULT false NOT NULL,
	"merge_airlines" boolean DEFAULT false NOT NULL,
	"itinerary_count" integer DEFAULT 0 NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"operations_office_id" varchar,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"mandatory_airline_type" varchar,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"set_diversity" boolean DEFAULT false,
	"price_weight" integer DEFAULT 0,
	"travel_time_weight" integer DEFAULT 0,
	"parameter_id" uuid,
	"multi_ticket_mode" varchar,
	"use_request_template" boolean DEFAULT false NOT NULL,
	"request_template" varchar,
	"governing_carrier" varchar,
	"alternate_offices" varchar,
	"account_codes" varchar,
	"corporate_codes" varchar,
	"retailer_codes" varchar,
	"operating_airline" varchar,
	"passenger_type_codes" varchar,
	"exclude_validating_carriers" varchar,
	"use_rest_api" boolean DEFAULT false NOT NULL,
	"enable_atpco" boolean DEFAULT false NOT NULL,
	"enable_ndc" boolean DEFAULT false NOT NULL,
	"enable_lcc" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."price_tolerance_rule" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"airlines" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"cabin_class" varchar,
	"currency_code" varchar DEFAULT '' NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"flight_type" varchar,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_refund_summaries" (
	"ticket_reference" varchar PRIMARY KEY NOT NULL,
	"refund_date" timestamp NOT NULL,
	"office_id" varchar NOT NULL,
	"reference_number" varchar,
	"passenger_name" varchar,
	"passenger_title" varchar,
	"sine" varchar,
	"form_of_payment" varchar,
	"currency_code" varchar,
	"total_amount" numeric(19, 2)
);
--> statement-breakpoint
CREATE TABLE "dbo"."sabre_sales_summaries" (
	"document_number" varchar PRIMARY KEY NOT NULL,
	"airline_id" varchar,
	"ticket_reference" varchar NOT NULL,
	"issue_date" timestamp NOT NULL,
	"office_id" varchar NOT NULL,
	"reference_number" varchar,
	"passenger_name" varchar,
	"passenger_title" varchar,
	"ticket_type" varchar,
	"commission" numeric(19, 2),
	"sine" varchar,
	"form_of_payment" varchar,
	"currency_code" varchar,
	"total_amount" numeric(19, 2),
	"act" varchar,
	"fees" numeric(19, 2),
	"invoice_number" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."schemaversions" (
	"schemaversionsid" serial PRIMARY KEY NOT NULL,
	"scriptname" varchar(255) NOT NULL,
	"applied" timestamp NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."pk_fare_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"parameter_id" uuid,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"operations_office_id" varchar NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"execution_order" integer NOT NULL,
	"rule_id" uuid NOT NULL,
	"notes" text DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."simplifly_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"parameter_id" uuid,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"operations_office_id" varchar NOT NULL,
	"airline_substitution" varchar DEFAULT '' NOT NULL,
	"airline_exclusion" varchar DEFAULT '' NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"execution_order" integer NOT NULL,
	"rule_id" uuid NOT NULL,
	"notes" text DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."setting" (
	"key" varchar PRIMARY KEY NOT NULL,
	"value" varchar,
	"description" varchar,
	"is_master_data" boolean DEFAULT true NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."support_phone_numbers" (
	"id" uuid PRIMARY KEY NOT NULL,
	"phone_number" varchar NOT NULL,
	"is_international" boolean NOT NULL,
	"country_fk" uuid,
	"continent_fk" uuid,
	CONSTRAINT "ux_support_phone_numbers_country_fk_phone_number" UNIQUE("country_fk","phone_number")
);
--> statement-breakpoint
CREATE TABLE "dbo"."stuck_booking_email" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"email" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."subscription" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"email_address" varchar NOT NULL,
	"date_subscribed" timestamp NOT NULL,
	"subscription_url" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."supplier_booking_summaries" (
	"pk" uuid PRIMARY KEY DEFAULT gen_random_uuid() NOT NULL,
	"transaction_datetime" timestamp with time zone NOT NULL,
	"supplier_code" varchar NOT NULL,
	"reference_number" varchar NOT NULL,
	"office_id" varchar,
	"ticket_reference" varchar,
	"created_datetime" timestamp with time zone DEFAULT (now() AT TIME ZONE 'UTC'::text) NOT NULL,
	"raw_data" text NOT NULL,
	"file_path" text NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."tax_invoice" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"payment_transaction_fk" uuid NOT NULL,
	"customer_name" varchar NOT NULL,
	"email_address" varchar NOT NULL,
	"address" varchar NOT NULL,
	"send_email" boolean NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."three_dstransaction_log" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"timestamp" timestamp with time zone NOT NULL,
	"body" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."ticketing_form_of_payment_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"payment_type" varchar,
	"validating_carriers" varchar,
	"operations_offices" varchar,
	"ticketing_operations_office" varchar,
	"ticketing_instructions" varchar,
	"booking_class" varchar,
	"cabin_class" varchar,
	"fare_types" varchar,
	"booking_engines" varchar,
	"origin_countries" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"tour_code" varchar,
	"destination_countries" varchar,
	"corporate_card_fk" uuid,
	"active" boolean DEFAULT true NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"notes" varchar,
	"user_name" varchar,
	"app_version" varchar,
	"date_changed" timestamp,
	"rule_id" uuid
);
--> statement-breakpoint
CREATE TABLE "dbo"."tfreport" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"time_of_booking" timestamp NOT NULL,
	"reference_number" varchar NOT NULL,
	"payment_method" varchar NOT NULL,
	"base_fare_aud" numeric(10, 2) NOT NULL,
	"taxes_and_fees_aud" numeric(10, 2) NOT NULL,
	"baggage_fee_aud" numeric(10, 2) NOT NULL,
	"credit_card_fee_aud" numeric(10, 2) NOT NULL,
	"passenger_count" smallint NOT NULL,
	"quoted_currency_code" varchar NOT NULL,
	"quoted_total_amount" numeric(10, 2) NOT NULL,
	"passenger_surnames" varchar NOT NULL,
	"total_sales_cost" numeric(10, 2) NOT NULL,
	"reciprocal_rate" numeric(18, 10) NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."tolerance_price_bracket" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"range_from" integer NOT NULL,
	"tolerance_amount" numeric(18, 2) NOT NULL,
	"tolerance_percent" numeric(18, 4) NOT NULL,
	"price_tolerance_rule_fk" uuid NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."session" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"start_date_time" timestamp NOT NULL,
	"end_date_time" timestamp,
	"user_agent" varchar,
	"user_host_address" varchar,
	"landing_url" varchar,
	"referring_url" varchar,
	"domain_code" char(3),
	"geolocation_country_code" char(2),
	"flight_voucher_issued_this_session" boolean,
	"issued_flight_voucher_id" uuid,
	"user_addresses" varchar,
	"persistent_cookie_key" uuid,
	"server_host" varchar,
	"app_version" varchar,
	"experiment_group_code" varchar,
	"client_os" varchar,
	"client_device" varchar,
	"client_device_type" varchar,
	"client_browser_name" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetRoleClaims" (
	"Id" serial PRIMARY KEY NOT NULL,
	"RoleId" varchar(128) NOT NULL,
	"ClaimType" text,
	"ClaimValue" text
);
--> statement-breakpoint
CREATE TABLE "dbo"."continent_destination_priority" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"origin_continent_fk" uuid NOT NULL,
	"destination_continent_fk" uuid NOT NULL,
	"priority" integer DEFAULT 0 NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_query_rule" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"name" varchar NOT NULL,
	"effective_date" timestamp,
	"expiry_date" timestamp,
	"departure_date_from" timestamp,
	"departure_date_to" timestamp,
	"whole_itinerary_limited_to_ports" varchar,
	"origin_ports" varchar,
	"origin_countries" varchar,
	"origin_continents" varchar,
	"destination_ports" varchar,
	"destination_countries" varchar,
	"destination_continents" varchar,
	"weight_adjustment" double precision DEFAULT 0 NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"use_as_default" boolean DEFAULT false NOT NULL,
	"apply_vice_versa_on_origin_destination_pair" boolean DEFAULT false NOT NULL,
	"cabin_class" varchar DEFAULT '' NOT NULL,
	"flight_type" varchar,
	"incremental" boolean DEFAULT false NOT NULL,
	"is_backup" boolean DEFAULT false NOT NULL,
	"excluded_origin_ports" varchar,
	"excluded_origin_countries" varchar,
	"excluded_origin_continents" varchar,
	"excluded_destination_ports" varchar,
	"excluded_destination_countries" varchar,
	"excluded_destination_continents" varchar,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"intermediate_ports" varchar,
	"affiliates" varchar,
	"multicity_min_legs" integer DEFAULT 0 NOT NULL,
	"multicity_max_legs" integer DEFAULT 0 NOT NULL,
	"domains" varchar DEFAULT '' NOT NULL,
	"search_flight_types" varchar,
	"city_port_pattern_query" varchar,
	"is_revalidate_only" boolean DEFAULT false NOT NULL,
	"use_main_rule_only" boolean DEFAULT false NOT NULL,
	"operating_carriers" varchar,
	"marketing_carriers" varchar,
	"validating_carriers" varchar,
	"arrival_date_from" timestamp,
	"arrival_date_to" timestamp,
	"min_departure_days_in_future" integer,
	"max_departure_days_in_future" integer
);
--> statement-breakpoint
CREATE TABLE "dbo"."payment_transaction" (
	"pk" uuid PRIMARY KEY NOT NULL,
	"related_transaction_fk" uuid,
	"void_transaction_fk" uuid,
	"booking_request_fk" uuid,
	"date_time" timestamp NOT NULL,
	"user_name" varchar,
	"credit_card_last_four_digits" varchar,
	"card_issuer" varchar,
	"card_previously_authorised" boolean,
	"transaction_type" varchar,
	"transaction_type_other1" varchar,
	"transaction_type_other2" varchar,
	"charge_type" varchar,
	"charge_description" varchar,
	"charge_remark1" varchar,
	"charge_remark2" varchar,
	"pnr" varchar,
	"missing_pnrremark1" varchar,
	"missing_pnrremark2" varchar,
	"currency_code" varchar,
	"value" numeric(10, 2),
	"equivalent_aud" numeric(10, 2),
	"comment1" varchar,
	"comment2" varchar,
	"fee_difference_reason1" varchar,
	"fee_difference_reason2" varchar,
	"reference_number" varchar,
	"raw_response_code" varchar,
	"full_response" varchar,
	"is_epay" boolean,
	"is_airline_website_sale" boolean,
	"is_airline_paid_by_cheque" boolean,
	"is_other_cos" boolean,
	"other_cosremark1" varchar,
	"other_cosremark2" varchar,
	"bank" varchar,
	"voice_authorisation_code" varchar,
	"previous_authorisation_transaction_fk" uuid,
	"succeeded" boolean NOT NULL,
	"payment_gateway_code" char(3),
	"secure_pay_pre_auth_id" char(6),
	"secure_pay_purchase_order_no" varchar,
	"authorisation_code" varchar,
	"gateway_reference" varchar,
	"tickler" varchar,
	"credit_card_token" varchar,
	"calculated_transaction_grid_number" varchar,
	"is_three_ds" boolean DEFAULT false NOT NULL,
	"payment_gateway_message" varchar,
	"retry_count" integer,
	"last_reported_date_time_utc" timestamp with time zone,
	"recorded_date_time_utc" timestamp with time zone,
	"connex_pay_sale_guid" uuid,
	"connex_pay_return_guid" uuid,
	"connex_pay_auth_only_guid" uuid,
	CONSTRAINT "ix_payment_transaction" UNIQUE("pk"),
	CONSTRAINT "ck_payment_transaction_payment_gateway_code" CHECK ((payment_gateway_code = 'CXP'::bpchar) OR (payment_gateway_code = 'PPL'::bpchar) OR (payment_gateway_code = 'SPY'::bpchar) OR (payment_gateway_code = 'PFP'::bpchar) OR (payment_gateway_code = 'EWY'::bpchar) OR (payment_gateway_code = 'FTZ'::bpchar) OR (payment_gateway_code = 'SPD'::bpchar) OR (payment_gateway_code = 'JET'::bpchar) OR (payment_gateway_code = 'SPA'::bpchar))
);
--> statement-breakpoint
CREATE TABLE "dbo"."auto_ticket_log" (
	"entry_id" uuid PRIMARY KEY NOT NULL,
	"pnr_id" uuid NOT NULL,
	"time" timestamp(6) NOT NULL,
	"message" varchar NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."margin_line" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"margin_header_fk" uuid NOT NULL,
	"log_date_time" timestamp NOT NULL,
	"type" varchar NOT NULL,
	"currency_code" varchar NOT NULL,
	"amount" numeric(18, 2) NOT NULL,
	"purchase_amount" numeric(18, 2) NOT NULL,
	"office_amount" numeric(18, 2) NOT NULL,
	"type_code" varchar,
	"reason" varchar,
	"passenger_type" varchar,
	"quantity" numeric(9, 2) NOT NULL,
	"total_amount" numeric(19, 4) NOT NULL,
	"total_purchase_amount" numeric(19, 4) NOT NULL,
	"total_office_amount" numeric(19, 4) NOT NULL,
	"reference_key" uuid,
	"is_fare_amount" boolean NOT NULL,
	"record_only" boolean DEFAULT false NOT NULL,
	"expected_only" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."tax_invoice_item" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"tax_invoice_fk" uuid NOT NULL,
	"index" smallint NOT NULL,
	"name" varchar NOT NULL,
	"amount" numeric(10, 2) NOT NULL,
	"gst" numeric(10, 2) NOT NULL,
	"gst_collected" boolean NOT NULL,
	"comments" varchar NOT NULL,
	"collected_by" varchar
);
--> statement-breakpoint
CREATE TABLE "dbo"."travel_fusion_flight_query_parameters" (
	"pk" uuid PRIMARY KEY DEFAULT uuid_generate_v4() NOT NULL,
	"active" boolean DEFAULT false NOT NULL,
	"flight_query_rule_fk" uuid NOT NULL,
	"execution_order" integer DEFAULT 0 NOT NULL,
	"airline_substitution" varchar DEFAULT '',
	"operations_office_id" varchar,
	"minimum_timeout" integer DEFAULT 0 NOT NULL,
	"maximum_timeout" integer DEFAULT 0 NOT NULL,
	"is_archive" boolean DEFAULT false NOT NULL,
	"is_deleted" boolean DEFAULT false NOT NULL,
	"rule_id" uuid NOT NULL,
	"user_name" varchar DEFAULT 'admin' NOT NULL,
	"app_version" varchar DEFAULT '1' NOT NULL,
	"date_changed" timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	"notes" varchar DEFAULT 'N/A' NOT NULL,
	"exclude_from_metasearch" boolean DEFAULT false,
	"affiliates_to_include_for_metasearch" varchar,
	"parameter_id" uuid,
	"airline_exclusion" varchar,
	"send_one_way_requests" boolean DEFAULT false NOT NULL,
	"send_return_requests" boolean DEFAULT true NOT NULL,
	"use_request_template" boolean DEFAULT false NOT NULL,
	"request_template" varchar,
	"send_suppliers_for_route" boolean DEFAULT false NOT NULL
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetUserRoles" (
	"UserId" varchar(128) NOT NULL,
	"RoleId" varchar(128) NOT NULL,
	CONSTRAINT "PK_dbo.AspNetUserRoles" PRIMARY KEY("RoleId","UserId")
);
--> statement-breakpoint
CREATE TABLE "dbo"."supplier_routes" (
	"supplier" varchar NOT NULL,
	"route" varchar NOT NULL,
	CONSTRAINT "supplier_routes_pkey" PRIMARY KEY("route","supplier")
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetUserLogins" (
	"LoginProvider" varchar(128) NOT NULL,
	"ProviderKey" varchar(128) NOT NULL,
	"UserId" varchar(128) NOT NULL,
	CONSTRAINT "PK_dbo.AspNetUserLogins" PRIMARY KEY("LoginProvider","ProviderKey","UserId")
);
--> statement-breakpoint
CREATE TABLE "dbo"."AspNetUserTokens" (
	"UserId" varchar(128) NOT NULL,
	"LoginProvider" varchar(128) NOT NULL,
	"Name" varchar(128) NOT NULL,
	"Value" text,
	CONSTRAINT "PK_AspNetUserTokens" PRIMARY KEY("LoginProvider","Name","UserId")
);
--> statement-breakpoint
CREATE TABLE "dbo"."booked_fare" (
	"pk" uuid DEFAULT uuid_generate_v4() NOT NULL,
	"passenger_type_code" varchar DEFAULT '' NOT NULL,
	"ticket_type_code" varchar DEFAULT '' NOT NULL,
	"booking_request_fk" uuid NOT NULL,
	"passenger_count" integer DEFAULT 0 NOT NULL,
	"base_currency_code" varchar DEFAULT '' NOT NULL,
	"base_fare" numeric(10, 2) DEFAULT '0' NOT NULL,
	"taxes_and_fees" numeric(10, 2) DEFAULT '0' NOT NULL,
	"service_fee" numeric(10, 2) DEFAULT '0' NOT NULL,
	"web_base_fare" numeric(10, 2) DEFAULT '0' NOT NULL,
	"web_taxes_and_fees" numeric(10, 2) DEFAULT '0' NOT NULL,
	"purchase_currency_code" varchar DEFAULT '' NOT NULL,
	"purchase_base_fare" numeric(10, 2) DEFAULT '0' NOT NULL,
	"purchase_taxes_and_fees" numeric(10, 2) DEFAULT '0' NOT NULL,
	"purchase_service_fee" numeric(10, 2) DEFAULT '0' NOT NULL,
	"original_base_fare" numeric(10, 2) DEFAULT '0' NOT NULL,
	"is_courtesy_conversion" boolean,
	"web_fare_currency_code" varchar DEFAULT '' NOT NULL,
	CONSTRAINT "pk_booked_fare_pk_booking_request_fk" PRIMARY KEY("booking_request_fk","pk")
);
--> statement-breakpoint
CREATE TABLE "dbo"."flight_leg_segment" (
	"pk" uuid NOT NULL,
	"departure_port_fk" uuid NOT NULL,
	"arrival_port_fk" uuid NOT NULL,
	"airline_fk" uuid NOT NULL,
	"codeshare_airline_fk" uuid,
	"departure_date_time" timestamp,
	"is_departure_time_empty" boolean DEFAULT false NOT NULL,
	"arrival_date_time" timestamp,
	"is_arrival_time_empty" boolean DEFAULT false NOT NULL,
	"flight_number" varchar NOT NULL,
	"aircraft_type" varchar,
	"mileage" integer,
	"number_of_stops" integer,
	"booking_class" varchar NOT NULL,
	"cabin_class" varchar NOT NULL,
	"cabin_class_description" varchar NOT NULL,
	"layover_time" integer,
	"booking_request_fk" uuid NOT NULL,
	"index" smallint NOT NULL,
	"flight_leg_index" smallint DEFAULT 0 NOT NULL,
	"booking_result_fk" uuid,
	"is_virtual_interline_connection" boolean DEFAULT false NOT NULL,
	"operating_carrier_fk" uuid,
	"travel_time" integer,
	"masking_flight_number" varchar,
	"operating_flight_number" varchar,
	"fare_basis_code" varchar,
	CONSTRAINT "pk_flight_leg_segment_pk_booking_request_fk" PRIMARY KEY("booking_request_fk","pk")
);
--> statement-breakpoint
ALTER TABLE "dbo"."AspNetUserClaims" ADD CONSTRAINT "FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "dbo"."AspNetUsers"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."air_gateway_flight_query_parameters" ADD CONSTRAINT "fk_air_gateway_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."air_gateway_flight_query_parameters" ADD CONSTRAINT "fk_air_gateway_flight_query_parameters_operations_office" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."airline" ADD CONSTRAINT "fk_airline_alliance" FOREIGN KEY ("alliance_fk") REFERENCES "dbo"."alliance"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."airline_cabin_class" ADD CONSTRAINT "fk_airlinecabinclass_airline" FOREIGN KEY ("airline_fk") REFERENCES "dbo"."airline"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."agacountry_region" ADD CONSTRAINT "fk_agacountry_region_country" FOREIGN KEY ("country_code") REFERENCES "dbo"."country"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."amadeus_flight_query_parameters" ADD CONSTRAINT "fk_amadeus_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."amadeus_flight_query_parameters" ADD CONSTRAINT "fk_amadeus_flight_query_parameters_operations_office" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."ancillary_transaction_purchase" ADD CONSTRAINT "fk_ancillary_transaction_purchase_booking_request" FOREIGN KEY ("booking_id") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."baggage_advice_rule_parameter_default_value" ADD CONSTRAINT "fk_baggage_advice_rule_parameter_default_value_baggage_advice_r" FOREIGN KEY ("baggage_advice_rule_pk") REFERENCES "dbo"."baggage_advice_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."baggage_protection_purchase" ADD CONSTRAINT "fk_baggage_protection_purchase_booking_request" FOREIGN KEY ("booking_id") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_ancillary" ADD CONSTRAINT "fk_booked_ancillary_booked_passenger_ticket" FOREIGN KEY ("booked_passenger_id") REFERENCES "dbo"."booked_passenger_ticket"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_ancillary" ADD CONSTRAINT "fk_booked_ancillary_booked_ticket" FOREIGN KEY ("booked_ticket_id") REFERENCES "dbo"."booked_ticket"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."authorisation_hash_log" ADD CONSTRAINT "fk_authorisation_hash_log_payment_transaction" FOREIGN KEY ("authorisation_transaction_fk") REFERENCES "dbo"."payment_transaction"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."auto_ticket_pnr" ADD CONSTRAINT "fk_auto_ticket_pnr_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_fare_flight_leg_segment_pivot" ADD CONSTRAINT "fk_booked_fare_flight_leg_segment_pivot_booked_fare" FOREIGN KEY ("booked_fare_fk","booking_request_fk") REFERENCES "dbo"."booked_fare"("pk","booking_request_fk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_fare_surcharge" ADD CONSTRAINT "fk_booked_fare_surcharge_airline" FOREIGN KEY ("airline_fk") REFERENCES "dbo"."airline"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_request_fee" ADD CONSTRAINT "fk_booking_request_fee_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_request_fee" ADD CONSTRAINT "fk_booking_request_fee_booking_result" FOREIGN KEY ("booking_result_fk") REFERENCES "dbo"."booking_result"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_passenger_ticket" ADD CONSTRAINT "fk_booked_passenger_ticket_booked_ticket" FOREIGN KEY ("booked_ticket_id") REFERENCES "dbo"."booked_ticket"("id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_result" ADD CONSTRAINT "fk_booking_result_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_request" ADD CONSTRAINT "fk_booking_request_flight_query" FOREIGN KEY ("flight_query_fk") REFERENCES "dbo"."flight_query"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_request" ADD CONSTRAINT "fk_booking_request_session" FOREIGN KEY ("session_fk") REFERENCES "dbo"."session"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booking_promotion" ADD CONSTRAINT "fk_booking_promotion_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."city_port" ADD CONSTRAINT "fk_city_port_country" FOREIGN KEY ("country_fk") REFERENCES "dbo"."country"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."commission_rate_rule" ADD CONSTRAINT "fk_commission_rate_rule_operations_office" FOREIGN KEY ("operations_office_fk") REFERENCES "dbo"."operations_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."content_page" ADD CONSTRAINT "fk_content_page_domain" FOREIGN KEY ("domain_code") REFERENCES "dbo"."domain"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."continent_area" ADD CONSTRAINT "fk_continent_area_continent" FOREIGN KEY ("continent_fk") REFERENCES "dbo"."continent"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."country" ADD CONSTRAINT "fk_country_continent_area" FOREIGN KEY ("continent_area_fk") REFERENCES "dbo"."continent_area"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."bundle_product_purchase" ADD CONSTRAINT "fk_bundle_product_purchase_booking_request" FOREIGN KEY ("booking_id") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."bundle_product_purchase" ADD CONSTRAINT "fk_bundle_product_purchase_flight_query" FOREIGN KEY ("flight_query_fk") REFERENCES "dbo"."flight_query"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."domain_conversion_url" ADD CONSTRAINT "fk_domain_conversion_url_domain" FOREIGN KEY ("domain_fk") REFERENCES "dbo"."domain"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."duffel_flight_query_parameters" ADD CONSTRAINT "fk_duffel_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."duffel_flight_query_parameters" ADD CONSTRAINT "fk_duffel_flight_query_parameters_operations_office" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."dynamic_flight_search_flight_query_parameters" ADD CONSTRAINT "fk_dynamic_flight_search_flight_query_parameters_flight_query_r" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."dynamic_flight_search_flight_query_parameters" ADD CONSTRAINT "fk_dynamic_flight_search_flight_query_parameters_operations_off" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."fare_family_flight_query_parameters" ADD CONSTRAINT "fk_fare_family_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."donation_setting" ADD CONSTRAINT "fk_footprints_setting_domain" FOREIGN KEY ("domain_code") REFERENCES "dbo"."domain"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."fee_uplift_via_margin_guess" ADD CONSTRAINT "fk_fee_uplift_via_margin_guess_fee_rule" FOREIGN KEY ("fee_rule_fk") REFERENCES "dbo"."fee_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."fee_uplift_per_booking" ADD CONSTRAINT "fk_fee_uplift_per_booking_fee_rule" FOREIGN KEY ("fee_rule_fk") REFERENCES "dbo"."fee_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."fee_rule" ADD CONSTRAINT "fk_fee_rule_operations_office" FOREIGN KEY ("operations_office_fk") REFERENCES "dbo"."operations_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_query_segment" ADD CONSTRAINT "fk_flight_query_segment_flight_query" FOREIGN KEY ("flight_query_fk") REFERENCES "dbo"."flight_query"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_query" ADD CONSTRAINT "fk_flight_query_session" FOREIGN KEY ("session_fk") REFERENCES "dbo"."session"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."fee_uplift_per_passenger" ADD CONSTRAINT "fk_fee_uplift_fee_rule" FOREIGN KEY ("fee_rule_fk") REFERENCES "dbo"."fee_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_voucher_history" ADD CONSTRAINT "fk_flight_voucher_history_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_voucher_history" ADD CONSTRAINT "fk_flight_voucher_history_flight_voucher" FOREIGN KEY ("flight_voucher_fk") REFERENCES "dbo"."flight_voucher"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."insurance_purchase" ADD CONSTRAINT "fk_insurance_purchase_booking_request" FOREIGN KEY ("booking_id") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."insurance_purchase" ADD CONSTRAINT "fk_insurance_purchase_country" FOREIGN KEY ("purchaser_country") REFERENCES "dbo"."country"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."margin_rule" ADD CONSTRAINT "fk_margin_rule_operations_office" FOREIGN KEY ("operations_office_fk") REFERENCES "dbo"."operations_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."margin_rule_applicable" ADD CONSTRAINT "fk_margin_rule" FOREIGN KEY ("margin_rule_fk") REFERENCES "dbo"."margin_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_rule" ADD CONSTRAINT "fk_operations_rule_operations_office" FOREIGN KEY ("operations_office_fk") REFERENCES "dbo"."operations_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."generic_flight_query_parameters" ADD CONSTRAINT "fk_generic_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_amsell_pcc" FOREIGN KEY ("am_amsell_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_auto_ticket_pcc" FOREIGN KEY ("am_auto_ticket_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_evsell_pcc" FOREIGN KEY ("am_evsell_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_retrieve_pnrpcc" FOREIGN KEY ("am_retrieve_pnrpcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_sasell_pcc" FOREIGN KEY ("am_sasell_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_search_pcc" FOREIGN KEY ("am_search_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_am_vysell_pcc" FOREIGN KEY ("am_vysell_pcc") REFERENCES "dbo"."amadeus_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_amsell_pcc" FOREIGN KEY ("sa_amsell_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_auto_ticket_pcc" FOREIGN KEY ("sa_auto_ticket_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_hhsell_pcc" FOREIGN KEY ("sa_hhsell_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_retrieve_pnrpcc" FOREIGN KEY ("sa_retrieve_pnrpcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_sasell_pcc" FOREIGN KEY ("sa_sasell_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_search_pcc" FOREIGN KEY ("sa_search_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_transfer_pcc" FOREIGN KEY ("sa_transfer_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."operations_office" ADD CONSTRAINT "fk_sa_vysell_pcc" FOREIGN KEY ("sa_vysell_pcc") REFERENCES "dbo"."sabre_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."page_footer" ADD CONSTRAINT "fk_page_footer_domain" FOREIGN KEY ("domain_code") REFERENCES "dbo"."domain"("code") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."sabre_alternate_office_airline_preference" ADD CONSTRAINT "sabre_alternate_office_airlin_sabre_parameter_alternate_of_fkey" FOREIGN KEY ("sabre_parameter_alternate_office_fk") REFERENCES "dbo"."sabre_parameter_alternate_office"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."sabre_parameter_alternate_office" ADD CONSTRAINT "fk_sabre_parameter_alternate_office_sabre_flight_query_paramete" FOREIGN KEY ("sabre_parameter_fk") REFERENCES "dbo"."sabre_flight_query_parameters"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."sabre_flight_query_parameters" ADD CONSTRAINT "fk_sabre_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."sabre_flight_query_parameters" ADD CONSTRAINT "fk_sabre_flight_query_parameters_operations_office" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."pk_fare_flight_query_parameters" ADD CONSTRAINT "fk_pk_fare_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."simplifly_flight_query_parameters" ADD CONSTRAINT "fk_simplifly_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."support_phone_numbers" ADD CONSTRAINT "fk_support_phone_numbers_continent_fk" FOREIGN KEY ("continent_fk") REFERENCES "dbo"."continent"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."support_phone_numbers" ADD CONSTRAINT "fk_support_phone_numbers_country_fk" FOREIGN KEY ("country_fk") REFERENCES "dbo"."country"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."tax_invoice" ADD CONSTRAINT "fk_tax_invoice_payment_transaction" FOREIGN KEY ("payment_transaction_fk") REFERENCES "dbo"."payment_transaction"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."three_dstransaction_log" ADD CONSTRAINT "fk_three_dstransaction_log_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."ticketing_form_of_payment_rule" ADD CONSTRAINT "fk_ticketing_form_of_payment_rule_corporate_card" FOREIGN KEY ("corporate_card_fk") REFERENCES "dbo"."corporate_card"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."tolerance_price_bracket" ADD CONSTRAINT "fk_tolerance_price_bracket_price_tolerance_rule" FOREIGN KEY ("price_tolerance_rule_fk") REFERENCES "dbo"."price_tolerance_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."AspNetRoleClaims" ADD CONSTRAINT "FK_AspNetRoleClaims_AspNetRoles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "dbo"."AspNetRoles"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."continent_destination_priority" ADD CONSTRAINT "continent_destination_priority_destination_continent_fk_fkey" FOREIGN KEY ("destination_continent_fk") REFERENCES "dbo"."continent"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."continent_destination_priority" ADD CONSTRAINT "continent_destination_priority_origin_continent_fk_fkey" FOREIGN KEY ("origin_continent_fk") REFERENCES "dbo"."continent"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."payment_transaction" ADD CONSTRAINT "fk_payment_transaction_payment_transaction_previous_authorisati" FOREIGN KEY ("previous_authorisation_transaction_fk") REFERENCES "dbo"."payment_transaction"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."auto_ticket_log" ADD CONSTRAINT "fk_auto_ticket_log_pnr_id" FOREIGN KEY ("pnr_id") REFERENCES "dbo"."auto_ticket_pnr"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."margin_line" ADD CONSTRAINT "fk_margin_line_margin_header" FOREIGN KEY ("margin_header_fk") REFERENCES "dbo"."margin_header"("pk") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."tax_invoice_item" ADD CONSTRAINT "fk_tax_invoice_item_tax_invoice" FOREIGN KEY ("tax_invoice_fk") REFERENCES "dbo"."tax_invoice"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."travel_fusion_flight_query_parameters" ADD CONSTRAINT "fk_travel_fusion_flight_query_parameters_flight_query_rule" FOREIGN KEY ("flight_query_rule_fk") REFERENCES "dbo"."flight_query_rule"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."travel_fusion_flight_query_parameters" ADD CONSTRAINT "fk_travel_fusion_flight_query_parameters_operations_office" FOREIGN KEY ("operations_office_id") REFERENCES "dbo"."operations_office"("office_id") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."AspNetUserRoles" ADD CONSTRAINT "FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId" FOREIGN KEY ("RoleId") REFERENCES "dbo"."AspNetRoles"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."AspNetUserRoles" ADD CONSTRAINT "FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "dbo"."AspNetUsers"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."AspNetUserLogins" ADD CONSTRAINT "FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "dbo"."AspNetUsers"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."AspNetUserTokens" ADD CONSTRAINT "FK_AspNetUserTokens_AspNetUsers_UserId" FOREIGN KEY ("UserId") REFERENCES "dbo"."AspNetUsers"("Id") ON DELETE cascade ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."booked_fare" ADD CONSTRAINT "fk_booked_fare_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_leg_segment" ADD CONSTRAINT "fk_flight_leg_segment_arrival_port_city_port" FOREIGN KEY ("arrival_port_fk") REFERENCES "dbo"."city_port"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_leg_segment" ADD CONSTRAINT "fk_flight_leg_segment_booking_request" FOREIGN KEY ("booking_request_fk") REFERENCES "dbo"."booking_request"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_leg_segment" ADD CONSTRAINT "fk_flight_leg_segment_booking_result" FOREIGN KEY ("booking_result_fk") REFERENCES "dbo"."booking_result"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_leg_segment" ADD CONSTRAINT "fk_flight_leg_segment_departure_port_city_port" FOREIGN KEY ("departure_port_fk") REFERENCES "dbo"."city_port"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
ALTER TABLE "dbo"."flight_leg_segment" ADD CONSTRAINT "fk_flight_leg_segment_operating_carrier_fk_airline" FOREIGN KEY ("operating_carrier_fk") REFERENCES "dbo"."airline"("pk") ON DELETE no action ON UPDATE no action;--> statement-breakpoint
CREATE UNIQUE INDEX "AspNetUsers_UserNameIndex" ON "dbo"."AspNetUsers" USING btree ("UserName" text_ops);--> statement-breakpoint
CREATE INDEX "AspNetUserClaims_IX_UserId" ON "dbo"."AspNetUserClaims" USING btree ("UserId" text_ops);--> statement-breakpoint
CREATE INDEX "ix_air_gateway_flight_query_parameters_flight_query_rule_fk" ON "dbo"."air_gateway_flight_query_parameters" USING btree ("flight_query_rule_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_air_gateway_flight_query_parameters_is_archive_active" ON "dbo"."air_gateway_flight_query_parameters" USING btree ("is_archive" bool_ops,"active" bool_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "idx_airline_alternate_lookup_name" ON "dbo"."airline" USING btree ("alternate_lookup_name" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "AspNetRoles_RoleNameIndex" ON "dbo"."AspNetRoles" USING btree ("Name" text_ops);--> statement-breakpoint
CREATE INDEX "ix_amadeus_sales_summaries_reference_number" ON "dbo"."amadeus_sales_summaries" USING btree ("reference_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_ancillary_transaction_purchase_created_time" ON "dbo"."ancillary_transaction_purchase" USING btree ("created_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_ancillary_transaction_purchase_provider" ON "dbo"."ancillary_transaction_purchase" USING btree ("provider" text_ops,"booking_id" text_ops);--> statement-breakpoint
CREATE INDEX "ix_ancillary_transaction_purchase_transaction_number_type" ON "dbo"."ancillary_transaction_purchase" USING btree ("type" text_ops,"provider" text_ops,"transaction_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_baggage_protection_purchase_created_time" ON "dbo"."baggage_protection_purchase" USING btree ("created_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_baggage_protection_purchase_master_reference_number_status" ON "dbo"."baggage_protection_purchase" USING btree ("master_reference_number" text_ops,"status" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ancillary_associated_ticket_number" ON "dbo"."booked_ancillary" USING btree ("associated_ticket_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ancillary_document_number" ON "dbo"."booked_ancillary" USING btree ("document_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ancillary_time" ON "dbo"."booked_ancillary" USING btree ("time" timestamp_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "unique_baggage_rule_name" ON "dbo"."baggage_rule" USING btree ("name" text_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_pnr_booking_request_fk" ON "dbo"."auto_ticket_pnr" USING btree ("booking_request_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_pnr_created_time" ON "dbo"."auto_ticket_pnr" USING btree ("created_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_pnr_status" ON "dbo"."auto_ticket_pnr" USING btree ("status" text_ops,"status_change_date_time" text_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_pnr_status_actual_ticketing_date_utc" ON "dbo"."auto_ticket_pnr" USING btree ("status" timestamptz_ops,"actual_ticketing_date_utc" text_ops,"booking_request_fk" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_fare_flight_leg_segment_pivot_flight_leg_segment_fk_b" ON "dbo"."booked_fare_flight_leg_segment_pivot" USING btree ("flight_leg_segment_fk" uuid_ops,"booked_fare_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ticket_booking_request" ON "dbo"."booked_ticket" USING btree ("id" uuid_ops,"booking_request_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ticket_booking_result" ON "dbo"."booked_ticket" USING btree ("id" uuid_ops,"booking_result_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ticket_reference_number" ON "dbo"."booked_ticket" USING btree ("id" uuid_ops,"reference_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booked_ticket_time" ON "dbo"."booked_ticket" USING btree ("time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cluster_last_date_time" ON "dbo"."booking_attempt" USING btree ("last_date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cx_booking_form_date" ON "dbo"."booking_form" USING btree ("date" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_form_booking_request_fk" ON "dbo"."booking_form" USING btree ("booking_request_fk" uuid_ops,"pk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_form_email" ON "dbo"."booking_form" USING btree ("email" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_form_flight_query_fk" ON "dbo"."booking_form" USING btree ("flight_query_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_result_margin_report" ON "dbo"."booking_result" USING btree ("booking_request_fk" uuid_ops,"reference_number" text_ops,"price_variation" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_result_result_code_ticket_status" ON "dbo"."booking_result" USING btree ("result_code" text_ops,"ticket_status" text_ops,"booking_request_fk" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_result_time_of_booking" ON "dbo"."booking_result" USING btree ("time_of_booking" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cx_booking_request_started_date_time" ON "dbo"."booking_request" USING btree ("started_date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request" ON "dbo"."booking_request" USING btree ("email_address" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_flight_query_fk_pk" ON "dbo"."booking_request" USING btree ("flight_query_fk" uuid_ops,"pk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_last_modified_date_utc" ON "dbo"."booking_request" USING btree ("last_modified_date_utc" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_last_reported_date_time_utc" ON "dbo"."booking_request" USING btree ("last_reported_date_time_utc" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_last_ticketing_date_utc" ON "dbo"."booking_request" USING btree ("last_ticketing_date_utc" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_need_ticketing_email" ON "dbo"."booking_request" USING btree ("need_ticketing_email" timestamp_ops,"last_ticketing_date" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_need_ticketing_email_v2" ON "dbo"."booking_request" USING btree ("need_ticketing_email" timestamptz_ops,"last_ticketing_date_utc" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_pk_flight_query_fk" ON "dbo"."booking_request" USING btree ("pk" uuid_ops,"flight_query_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_reference_number" ON "dbo"."booking_request" USING btree ("reference_number" text_ops,"completed_date_time" text_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_session_fk" ON "dbo"."booking_request" USING btree ("session_fk" uuid_ops,"pk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_booking_request_started_date_time" ON "dbo"."booking_request" USING btree ("started_date_time" timestamp_ops,"pk" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_active_allow_in_query_allow_in_search_result_city_code_count" ON "dbo"."city_port" USING btree ("active" text_ops,"allow_in_query" uuid_ops,"allow_in_search_result" bool_ops,"city_code" bool_ops,"country_fk" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_active" ON "dbo"."city_port" USING btree ("active" bool_ops,"allow_in_query" bool_ops,"allow_in_search_result" bool_ops,"city_code" bool_ops,"country_fk" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_allow_in_search" ON "dbo"."city_port" USING btree ("city_code" text_ops,"allow_in_search_result" text_ops,"allow_in_query" text_ops,"active" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_city_code" ON "dbo"."city_port" USING btree ("pk" uuid_ops,"city_code" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_city_code_port_code" ON "dbo"."city_port" USING btree ("city_code" text_ops,"port_code" text_ops,"country_fk" text_ops,"city_name" text_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_city_name" ON "dbo"."city_port" USING btree ("city_name" text_ops,"city_code" text_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_city_name_city_code" ON "dbo"."city_port" USING btree ("city_name" text_ops,"country_fk" text_ops,"city_code" text_ops,"full_description" text_ops,"priority_in_list" text_ops);--> statement-breakpoint
CREATE INDEX "ix_city_port_port_code" ON "dbo"."city_port" USING btree ("port_code" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "ix_city_pair_mileage" ON "dbo"."city_pair_mileage" USING btree ("city_pair_id" text_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "ix_country_code" ON "dbo"."country" USING btree ("code" text_ops);--> statement-breakpoint
CREATE INDEX "ix_duffel_flight_query_parameters_flight_query_rule_fk" ON "dbo"."duffel_flight_query_parameters" USING btree ("flight_query_rule_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_duffel_flight_query_parameters_is_archive_active" ON "dbo"."duffel_flight_query_parameters" USING btree ("is_archive" bool_ops,"active" bool_ops);--> statement-breakpoint
CREATE INDEX "idx_exchange_rate_pk_as_at_currency_code" ON "dbo"."exchange_rate" USING btree ("pk" timestamp_ops,"as_at" uuid_ops,"currency_code" bpchar_ops,"actual_rate" bpchar_ops);--> statement-breakpoint
CREATE INDEX "ix_exchange_rate_currency_code_as_at" ON "dbo"."exchange_rate" USING btree ("currency_code" timestamp_ops,"as_at" timestamp_ops,"pk" bpchar_ops);--> statement-breakpoint
CREATE INDEX "ix_failed_booking_attempt_booking_date_time" ON "dbo"."failed_booking_attempt" USING btree ("booking_date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cx_fee_uplift_via_margin_guess_date_changed" ON "dbo"."fee_uplift_via_margin_guess" USING btree ("date_changed" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_fee_rule_fk_fee_uplift_via_margin_guess" ON "dbo"."fee_uplift_via_margin_guess" USING btree ("fee_rule_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_fee_uplift_via_margin_guess_is_archive_is_deleted" ON "dbo"."fee_uplift_via_margin_guess" USING btree ("is_archive" bool_ops,"is_deleted" bool_ops,"fee_rule_fk" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_booking_archive_datetime" ON "dbo"."flight_booking_archive" USING btree ("date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cx_fee_rule_date_changed" ON "dbo"."fee_rule" USING btree ("date_changed" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_name_archive_deleted_active_expiry_date" ON "dbo"."fee_rule" USING btree ("name" text_ops,"is_archive" timestamp_ops,"is_deleted" timestamp_ops,"active" timestamp_ops,"expiry_date" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_query_segment_flight_query_fk" ON "dbo"."flight_query_segment" USING btree ("flight_query_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_query" ON "dbo"."flight_query" USING btree ("query_date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_query_query_datetime" ON "dbo"."flight_query" USING btree ("query_date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_query_session_fk" ON "dbo"."flight_query" USING btree ("session_fk" uuid_ops,"pk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_voucher_created_date" ON "dbo"."flight_voucher" USING btree ("created_date" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_voucher_email" ON "dbo"."flight_voucher" USING btree ("customer_email" text_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_voucher_applied_date" ON "dbo"."flight_voucher_history" USING btree ("applied_date" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_insurance_purchase_created_time" ON "dbo"."insurance_purchase" USING btree ("created_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_insurance_purchase_reference_number_status" ON "dbo"."insurance_purchase" USING btree ("reference_number" text_ops,"status" text_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_header" ON "dbo"."margin_header" USING btree ("booking_attempt_fk" text_ops,"price_key" text_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_header_booking_request_fk" ON "dbo"."margin_header" USING btree ("booking_request_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_header_booking_result_fk" ON "dbo"."margin_header" USING btree ("booking_result_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_header_flight_query_fk" ON "dbo"."margin_header" USING btree ("flight_query_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_json_fares_itinerary_key" ON "dbo"."json_fares" USING btree ("itinerary_key" text_ops);--> statement-breakpoint
CREATE INDEX "ix_json_fares_last_modified_date_time" ON "dbo"."json_fares" USING btree ("last_modified_date_time" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_json_fares_office_id" ON "dbo"."json_fares" USING btree ("office_id" text_ops);--> statement-breakpoint
CREATE INDEX "ix_json_fares_officeid_itinerary_key" ON "dbo"."json_fares" USING btree ("office_id" text_ops,"itinerary_key" text_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_rule_date_changed" ON "dbo"."margin_rule" USING btree ("date_changed" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_rule_eff_date_scope_type_active" ON "dbo"."margin_rule" USING btree ("effective_date" text_ops,"expiry_date" timestamp_ops,"scope_type" timestamp_ops,"active" bool_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_rule_applicable_margin_rule_fk" ON "dbo"."margin_rule_applicable" USING btree ("margin_rule_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_sabre_refund_summaries_refund_date" ON "dbo"."sabre_refund_summaries" USING btree ("refund_date" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_sabre_sales_summaries_reference_number" ON "dbo"."sabre_sales_summaries" USING btree ("reference_number" text_ops);--> statement-breakpoint
CREATE INDEX "ix_tax_invoice_payment_transaction_fk" ON "dbo"."tax_invoice" USING btree ("payment_transaction_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_three_dstransaction_log" ON "dbo"."three_dstransaction_log" USING btree ("timestamp" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ci_tfreport_date_time" ON "dbo"."tfreport" USING btree ("time_of_booking" timestamp_ops);--> statement-breakpoint
CREATE INDEX "cx_payment_transaction_date_time" ON "dbo"."payment_transaction" USING btree ("date_time" timestamp_ops);--> statement-breakpoint
CREATE INDEX "ix_payment_transaction_booking_request" ON "dbo"."payment_transaction" USING btree ("booking_request_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_payment_transaction_last_reported_date_time_utc" ON "dbo"."payment_transaction" USING btree ("last_reported_date_time_utc" timestamptz_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_log_pnr_id" ON "dbo"."auto_ticket_log" USING btree ("pnr_id" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_auto_ticket_log_time" ON "dbo"."auto_ticket_log" USING btree ("time" timestamp_ops);--> statement-breakpoint
CREATE UNIQUE INDEX "ix_margin_line" ON "dbo"."margin_line" USING btree ("margin_header_fk" uuid_ops,"log_date_time" timestamp_ops,"pk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_line_margin_header_fk" ON "dbo"."margin_line" USING btree ("margin_header_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_margin_line_reference_key" ON "dbo"."margin_line" USING btree ("reference_key" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_tax_invoice_item_tax_invoice_fk" ON "dbo"."tax_invoice_item" USING btree ("tax_invoice_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "AspNetUserRoles_IX_RoleId" ON "dbo"."AspNetUserRoles" USING btree ("RoleId" text_ops);--> statement-breakpoint
CREATE INDEX "AspNetUserRoles_IX_UserId" ON "dbo"."AspNetUserRoles" USING btree ("UserId" text_ops);--> statement-breakpoint
CREATE INDEX "ix_supplier_route" ON "dbo"."supplier_routes" USING btree ("supplier" text_ops,"route" text_ops);--> statement-breakpoint
CREATE INDEX "AspNetUserLogins_IX_UserId" ON "dbo"."AspNetUserLogins" USING btree ("UserId" text_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_leg_segment_booking_request_fk" ON "dbo"."flight_leg_segment" USING btree ("booking_request_fk" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_leg_segment_booking_result_fk" ON "dbo"."flight_leg_segment" USING btree ("booking_result_fk" uuid_ops,"index" uuid_ops);--> statement-breakpoint
CREATE INDEX "ix_flight_leg_segment_departure_date_time" ON "dbo"."flight_leg_segment" USING btree ("departure_date_time" timestamp_ops,"booking_request_fk" timestamp_ops);--> statement-breakpoint
CREATE VIEW "dbo"."flight_booking_archive_with_exchange_rate" AS (SELECT b.pk, b.flight_query_fk, b.domestic, b.date_time, b.adult_count, b.child_count, b.infant_count, b.passenger_count, b.flight_booking_request_fk, b.record_locator, b.purchase_currency_code, b.purchase_total_amount, b.purchase_service_fee_amount, b.purchaser_country_code, b.fare_type, b.main_carrier, b.all_carriers, b.alliance, b.payment_type, b.purchase_expedited_ticket_delivery_fee, b.purchase_callback_fee, b.succeeded, b.phone_area_code, b.city_or_suburb, b.post_code, b.domain_code, b.affiliate, b.geolocated_country, b.child_record_locators, b.dj_search_count, b.hh_search_count, b.affiliate_medium, b.affiliate_campaign, b.affiliate_device, b.affiliate_cookie_drop, b.purchase_affiliate_commissionable_amount, b.email_address, b.donation, b.insurance, b.am_search_count, b.voucher_redeemed_amount, b.revenue, b.base_fare_type, b.is_search_force_conversion, b.purchaser_full_name, b.partner_donation, b.donation_charity, b.donation_project, b.paypal_email, b.promo_code, b.affiliate_sub_id, b.is_lowest_price, b.is_above_lowest_price_and_below_average_price, b.is_above_average_price, b.google_source, b.google_medium, b.google_campaign, b.cancelled, b.ev_search_count, b.yp_booking_count, b.am_booking_count, b.dj_booking_count, b.hh_booking_count, b.tf_search_count, b.tf_booking_count, b.itinerary, b.vy_search_count, b.sa_search_count, b.sa_booking_count, b.ds_search_count, b.office_id, b.purchase_total_amount / purchase_to_aud.actual_rate AS equiv_amount, b.voucher_redeemed_amount / purchase_to_aud.actual_rate AS equiv_voucher_amount, b.purchase_affiliate_commissionable_amount / purchase_to_aud.actual_rate AS affiliate_commissionable_equiv_amount, b.donation / purchase_to_aud.actual_rate AS donation_equiv_amount, b.insurance / purchase_to_aud.actual_rate AS insurance_equiv_amount, b.partner_donation / purchase_to_aud.actual_rate AS partner_donation_equiv_amount, destination.city_code AS destination_city, origin.city_code AS origin_city, q.attribute_to_affiliate, 'AUD'::text AS equiv_currency, q.query_date_time, purchase_to_aud.actual_rate, b.payment_surcharge, b.payment_surcharge / purchase_to_aud.actual_rate AS payment_surcharge_equiv_amount FROM dbo.flight_booking_archive b LEFT JOIN dbo.flight_query q ON b.flight_query_fk = q.pk LEFT JOIN dbo.flight_query_segment first_segment ON first_segment.flight_query_fk = q.pk AND first_segment.segment_number = 0 LEFT JOIN dbo.city_port origin ON first_segment.departure_port_fk = origin.pk LEFT JOIN dbo.city_port destination ON first_segment.arrival_port_fk = destination.pk LEFT JOIN dbo.exchange_rate purchase_to_aud ON purchase_to_aud.pk = (( SELECT all_rates.pk FROM dbo.exchange_rate all_rates WHERE all_rates.currency_code = b.purchase_currency_code::bpchar AND all_rates.as_at < b.date_time ORDER BY all_rates.as_at DESC LIMIT 1)));
*/