--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ontology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ontology;


ALTER SCHEMA ontology OWNER TO postgres;

--
-- Name: ontology_sources; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ontology_sources;


ALTER SCHEMA ontology_sources OWNER TO postgres;

--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: lastdate(); Type: FUNCTION; Schema: ontology; Owner: postgres
--

CREATE FUNCTION ontology.lastdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN    
   
  		NEW.last_date := current_timestamp;
    
        RETURN NEW;
 END;
$$;


ALTER FUNCTION ontology.lastdate() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: functions; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.functions (
    identifiers integer NOT NULL,
    iris text NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.functions OWNER TO postgres;

--
-- Name: TABLE functions; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.functions IS 'The contents of this table will be imported from the ontology.';


--
-- Name: COLUMN functions.iris; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology.functions.iris IS 'This is to store internationalized resource identifiers - see: https://tools.ietf.org/html/rfc3987.';


--
-- Name: geonode_topographic_object_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.geonode_topographic_object_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    functions text,
    the_geom public.geometry NOT NULL,
    whole_topographic_object_identifiers integer,
    names text,
    types text
);


ALTER TABLE ontology.geonode_topographic_object_manifestations OWNER TO postgres;

--
-- Name: historical_sources; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.historical_sources (
    identifiers integer NOT NULL,
    titles text NOT NULL,
    bibliographic_data text
);


ALTER TABLE ontology.historical_sources OWNER TO postgres;

--
-- Name: location_dataset_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.location_dataset_types (
    identifiers integer NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.location_dataset_types OWNER TO postgres;

--
-- Name: TABLE location_dataset_types; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.location_dataset_types IS 'This table is to register all sources for geographic reference data.';


--
-- Name: location_link_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.location_link_types (
    identifiers integer NOT NULL,
    names text NOT NULL,
    postgis_functions text
);


ALTER TABLE ontology.location_link_types OWNER TO postgres;

--
-- Name: locations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.locations (
    identifiers integer NOT NULL,
    the_geom public.geometry NOT NULL,
    location_type_identifiers integer NOT NULL,
    names text
);


ALTER TABLE ontology.locations OWNER TO postgres;

--
-- Name: name_link_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.name_link_types (
    identifiers integer NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.name_link_types OWNER TO postgres;

--
-- Name: topographic_object_function_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_function_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    function_identifiers integer NOT NULL,
    historical_source_identifiers integer
);


ALTER TABLE ontology.topographic_object_function_manifestations OWNER TO postgres;

--
-- Name: overlapping_function_manifestations; Type: VIEW; Schema: ontology; Owner: postgres
--

CREATE VIEW ontology.overlapping_function_manifestations AS
 SELECT topographic_object_function_manifestations.topographic_object_identifiers
   FROM ontology.topographic_object_function_manifestations;


ALTER TABLE ontology.overlapping_function_manifestations OWNER TO postgres;

--
-- Name: topographic_names; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_names (
    identifiers integer NOT NULL,
    names text NOT NULL,
    language_tags text
);


ALTER TABLE ontology.topographic_names OWNER TO postgres;

--
-- Name: topographic_object_location_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_location_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    location_identifiers integer NOT NULL,
    historical_source_identifiers integer,
    location_link_type_identifiers integer
);


ALTER TABLE ontology.topographic_object_location_manifestations OWNER TO postgres;

--
-- Name: topographic_object_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    function_manifestation_identifiers integer,
    location_manifestation_identifiers integer,
    mereological_link_manifestation_identifiers integer,
    name_manifestation_identifiers integer,
    type_manifestation_identifiers integer
);


ALTER TABLE ontology.topographic_object_manifestations OWNER TO postgres;

--
-- Name: TABLE topographic_object_manifestations; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.topographic_object_manifestations IS 'This table is an input to Geonode.
Actually it will be a materialised view over other manifestation tables that aggregates them all.';


--
-- Name: topographic_object_mereological_link_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_mereological_link_manifestations (
    identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    whole_identifiers integer NOT NULL,
    part_identifiers integer NOT NULL,
    historical_source_identifiers integer
);


ALTER TABLE ontology.topographic_object_mereological_link_manifestations OWNER TO postgres;

--
-- Name: topographic_object_name_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_name_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    name_identifiers integer,
    historical_source_identifiers integer,
    name_link_type_identifiers integer,
    CONSTRAINT topographic_object_name_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL))))
);


ALTER TABLE ontology.topographic_object_name_manifestations OWNER TO postgres;

--
-- Name: topographic_object_provenances; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_provenances (
    identifiers integer NOT NULL,
    ancestor_identifiers integer NOT NULL,
    predecessor_identifiers integer NOT NULL
);


ALTER TABLE ontology.topographic_object_provenances OWNER TO postgres;

--
-- Name: topographic_object_type_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_type_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    type_identifiers integer NOT NULL,
    historical_source_identifiers integer
);


ALTER TABLE ontology.topographic_object_type_manifestations OWNER TO postgres;

--
-- Name: topographic_objects; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_objects (
    identifiers integer NOT NULL
);


ALTER TABLE ontology.topographic_objects OWNER TO postgres;

--
-- Name: topographic_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_types (
    identifiers integer NOT NULL,
    iris text,
    names text NOT NULL
);


ALTER TABLE ontology.topographic_types OWNER TO postgres;

--
-- Name: TABLE topographic_types; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.topographic_types IS 'The contents of this table will be imported from the ontology.';


--
-- Name: COLUMN topographic_types.iris; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology.topographic_types.iris IS 'This is to store internationalized resource identifiers - see: https://tools.ietf.org/html/rfc3987.';


--
-- Name: date_mapping_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.date_mapping_sources (
    imprecise_dates text NOT NULL,
    precise_dates text NOT NULL
);


ALTER TABLE ontology_sources.date_mapping_sources OWNER TO postgres;

--
-- Name: TABLE date_mapping_sources; Type: COMMENT; Schema: ontology_sources; Owner: postgres
--

COMMENT ON TABLE ontology_sources.date_mapping_sources IS 'This table is to store mappings from precise to imprecise dates.';


--
-- Name: functions; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.functions (
    identifiers integer NOT NULL,
    iris text,
    names text
);


ALTER TABLE ontology_sources.functions OWNER TO postgres;

--
-- Name: historical_sources_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.historical_sources_sources (
    titles text,
    bibliographic_data text
);


ALTER TABLE ontology_sources.historical_sources_sources OWNER TO postgres;

--
-- Name: location_link_type_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.location_link_type_sources (
    names text NOT NULL,
    postgis_functions text
);


ALTER TABLE ontology_sources.location_link_type_sources OWNER TO postgres;

--
-- Name: TABLE location_link_type_sources; Type: COMMENT; Schema: ontology_sources; Owner: postgres
--

COMMENT ON TABLE ontology_sources.location_link_type_sources IS 'This table is to store link type data for locations, e.g., such links as ''close to'', ''away from'', etc.';


--
-- Name: locations_raw; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.locations_raw (
    identifiers integer NOT NULL,
    "the_geom_X_Y" public.geometry NOT NULL,
    names text
);


ALTER TABLE ontology_sources.locations_raw OWNER TO postgres;

--
-- Name: locations_refined; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.locations_refined (
    location_raw_identifiers integer NOT NULL,
    the_geom public.geometry NOT NULL,
    names text,
    the_geom_types text
);


ALTER TABLE ontology_sources.locations_refined OWNER TO postgres;

--
-- Name: name_link_type_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.name_link_type_sources (
    names text NOT NULL
);


ALTER TABLE ontology_sources.name_link_type_sources OWNER TO postgres;

--
-- Name: TABLE name_link_type_sources; Type: COMMENT; Schema: ontology_sources; Owner: postgres
--

COMMENT ON TABLE ontology_sources.name_link_type_sources IS 'This table is to store link type data for names, e.g., such links as ''is primary name of'', ''is a secondary name of'', ''is a common name of'', etc.';


--
-- Name: topographic_object_function_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_function_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    functions text NOT NULL,
    historical_source_titles text NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_function_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_location_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_location_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    location_link_type_names text NOT NULL,
    historical_sources text NOT NULL,
    locations text NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_location_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_mereological_link_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources (
    "	topographic_object_identifiers" integer NOT NULL,
    starts_at text,
    ends_at text,
    whole_identifiers integer NOT NULL,
    part_identifiers integer NOT NULL,
    historical_sources text NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_name_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_name_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    names text NOT NULL,
    name_link_types text NOT NULL,
    historical_sources text NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_name_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_provenances; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_provenances (
    ancestor_identifiers integer NOT NULL,
    predecessor_identifiers integer NOT NULL,
    historical_sources text NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_provenances OWNER TO postgres;

--
-- Name: topographic_object_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_sources (
    identifiers integer NOT NULL,
    default_names text
);


ALTER TABLE ontology_sources.topographic_object_sources OWNER TO postgres;

--
-- Name: COLUMN topographic_object_sources.default_names; Type: COMMENT; Schema: ontology_sources; Owner: postgres
--

COMMENT ON COLUMN ontology_sources.topographic_object_sources.default_names IS 'This attribute stores any name for a topographic object in order to help a human to add manifestation-level data.';


--
-- Name: topographic_object_type_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_type_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    types text NOT NULL,
    historical_sources text
);


ALTER TABLE ontology_sources.topographic_object_type_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_types; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_types (
    identifiers integer NOT NULL,
    iris text NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology_sources.topographic_types OWNER TO postgres;

--
-- Name: functions Functions_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.functions
    ADD CONSTRAINT "Functions_IRIs_key" UNIQUE (iris);


--
-- Name: functions Functions_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.functions
    ADD CONSTRAINT "Functions_pkey" PRIMARY KEY (identifiers);


--
-- Name: historical_sources HistoricalSources_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.historical_sources
    ADD CONSTRAINT "HistoricalSources_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_types TopgraphicTypes_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_types
    ADD CONSTRAINT "TopgraphicTypes_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManifestations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_location_manifestations TopographicObjectLocations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_manifestations TopographicObjectManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifestations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_name_manifestations TopographicObjectNameManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifestations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifestations_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_objects TopographicObjects_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_objects
    ADD CONSTRAINT "TopographicObjects_pkey" PRIMARY KEY (identifiers);


--
-- Name: topographic_types TopographicTypes_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_types
    ADD CONSTRAINT "TopographicTypes_IRIs_key" UNIQUE (iris);


--
-- Name: geonode_topographic_object_manifestations geonode_topographic_object_manifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.geonode_topographic_object_manifestations
    ADD CONSTRAINT geonode_topographic_object_manifestations_pkey PRIMARY KEY (identifiers);


--
-- Name: location_dataset_types location_dataset_types_names_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_dataset_types
    ADD CONSTRAINT location_dataset_types_names_key UNIQUE (names);


--
-- Name: location_link_types location_link_types_names_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_link_types
    ADD CONSTRAINT location_link_types_names_key UNIQUE (names);


--
-- Name: location_link_types location_link_types_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_link_types
    ADD CONSTRAINT location_link_types_pkey PRIMARY KEY (identifiers);


--
-- Name: location_dataset_types location_types_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_dataset_types
    ADD CONSTRAINT location_types_pkey PRIMARY KEY (identifiers);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (identifiers);


--
-- Name: name_link_types name_link_types_names_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.name_link_types
    ADD CONSTRAINT name_link_types_names_key UNIQUE (names);


--
-- Name: name_link_types name_link_types_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.name_link_types
    ADD CONSTRAINT name_link_types_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_names topographic_names_names_language_tags_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_names
    ADD CONSTRAINT topographic_names_names_language_tags_key UNIQUE (names, language_tags);


--
-- Name: topographic_names topographic_names_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_names
    ADD CONSTRAINT topographic_names_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_function_manifestations topographic_object_function_m_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_m_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, function_identifiers, starts_at, ends_at);


--
-- Name: topographic_object_function_manifestations topographic_object_function_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- Name: topographic_object_function_manifestations topographic_object_function_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- Name: topographic_object_location_manifestations topographic_object_location_m_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_m_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, location_identifiers, starts_at, ends_at);


--
-- Name: topographic_object_location_manifestations topographic_object_location_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- Name: topographic_object_location_manifestations topographic_object_location_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- Name: topographic_object_manifestations topographic_object_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_manifestations
    ADD CONSTRAINT topographic_object_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- Name: topographic_object_manifestations topographic_object_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_manifestations
    ADD CONSTRAINT topographic_object_manifestations_check1 CHECK ((NOT ((topographic_object_identifiers IS NULL) AND (function_manifestation_identifiers IS NULL) AND (location_manifestation_identifiers IS NULL) AND (mereological_link_manifestation_identifiers IS NULL) AND (name_manifestation_identifiers IS NULL) AND (type_manifestation_identifiers IS NULL)))) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereologic_whole_identifiers_part_identi_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereologic_whole_identifiers_part_identi_key UNIQUE (whole_identifiers, part_identifiers, starts_at, ends_at);


--
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereological_link_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereological_link_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereological_link_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereological_link_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- Name: topographic_object_name_manifestations topographic_object_name_manif_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manif_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, starts_at, ends_at, name_identifiers);


--
-- Name: topographic_object_name_manifestations topographic_object_name_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- Name: topographic_object_provenances topographic_object_provenances_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_type_manifestations topographic_object_type_manif_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manif_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, starts_at, ends_at, type_identifiers);


--
-- Name: topographic_object_type_manifestations topographic_object_type_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- Name: topographic_object_type_manifestations topographic_object_type_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- Name: date_mapping_sources date_maps_historical_dates_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.date_mapping_sources
    ADD CONSTRAINT date_maps_historical_dates_key UNIQUE (imprecise_dates);


--
-- Name: functions functions_iris_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.functions
    ADD CONSTRAINT functions_iris_key UNIQUE (iris);


--
-- Name: functions functions_names_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.functions
    ADD CONSTRAINT functions_names_key UNIQUE (names);


--
-- Name: functions functions_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.functions
    ADD CONSTRAINT functions_pkey PRIMARY KEY (identifiers);


--
-- Name: historical_sources_sources historical_sources_titles_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.historical_sources_sources
    ADD CONSTRAINT historical_sources_titles_key UNIQUE (titles);


--
-- Name: location_link_type_sources location_link_type_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.location_link_type_sources
    ADD CONSTRAINT location_link_type_sources_pkey PRIMARY KEY (names);


--
-- Name: locations_raw locations_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.locations_raw
    ADD CONSTRAINT locations_pkey PRIMARY KEY (identifiers);


--
-- Name: locations_raw locations_the_geom_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.locations_raw
    ADD CONSTRAINT locations_the_geom_key UNIQUE ("the_geom_X_Y");


--
-- Name: name_link_type_sources name_link_type_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.name_link_type_sources
    ADD CONSTRAINT name_link_type_sources_pkey PRIMARY KEY (names);


--
-- Name: topographic_object_function_manifestation_sources topographic_object_function_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_function_manifestation_sources
    ADD CONSTRAINT topographic_object_function_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestation_sources topographic_object_mereological_link_manifestation_source_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources
    ADD CONSTRAINT topographic_object_mereological_link_manifestation_source_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_name_manifestation_sources topographic_object_name_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_name_manifestation_sources
    ADD CONSTRAINT topographic_object_name_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_sources topographic_object_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_sources
    ADD CONSTRAINT topographic_object_sources_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_type_manifestation_sources topographic_object_type_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_type_manifestation_sources
    ADD CONSTRAINT topographic_object_type_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_types topographic_types_iris_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_types
    ADD CONSTRAINT topographic_types_iris_key UNIQUE (iris);


--
-- Name: topographic_types topographic_types_names_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_types
    ADD CONSTRAINT topographic_types_names_key UNIQUE (names);


--
-- Name: topographic_types topographic_types_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_types
    ADD CONSTRAINT topographic_types_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_function_manifestations TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey" FOREIGN KEY (function_identifiers) REFERENCES ontology.functions(identifiers);


--
-- Name: topographic_object_location_manifestations TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- Name: topographic_object_location_manifestations TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_FunctionManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_FunctionManifestationIdentif_fkey" FOREIGN KEY (function_manifestation_identifiers) REFERENCES ontology.topographic_object_function_manifestations(identifiers);


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_LocationManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_LocationManifestationIdentif_fkey" FOREIGN KEY (location_manifestation_identifiers) REFERENCES ontology.topographic_object_location_manifestations(identifiers);


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey" FOREIGN KEY (mereological_link_manifestation_identifiers) REFERENCES ontology.topographic_object_mereological_link_manifestations(identifiers) NOT VALID;


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_NameManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_NameManifestationIdentifiers_fkey" FOREIGN KEY (name_manifestation_identifiers) REFERENCES ontology.topographic_object_name_manifestations(identifiers);


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- Name: topographic_object_manifestations TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey" FOREIGN KEY (type_manifestation_identifiers) REFERENCES ontology.topographic_object_type_manifestations(identifiers);


--
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey" FOREIGN KEY (whole_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey" FOREIGN KEY (part_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestations TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestations TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifestations_TypeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifestations_TypeIdentifiers_fkey" FOREIGN KEY (type_identifiers) REFERENCES ontology.topographic_types(identifiers) NOT VALID;


--
-- Name: locations locations_location_type_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.locations
    ADD CONSTRAINT locations_location_type_identifiers_fkey FOREIGN KEY (location_type_identifiers) REFERENCES ontology.location_dataset_types(identifiers) NOT VALID;


--
-- Name: topographic_object_location_manifestations topographic_object_location_manifest_link_type_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifest_link_type_identifiers_fkey FOREIGN KEY (location_link_type_identifiers) REFERENCES ontology.location_link_types(identifiers) NOT VALID;


--
-- Name: topographic_object_location_manifestations topographic_object_location_manifesta_location_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifesta_location_identifiers_fkey FOREIGN KEY (location_identifiers) REFERENCES ontology.locations(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestations topographic_object_name_manifes_name_link_type_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manifes_name_link_type_identifiers_fkey FOREIGN KEY (name_link_type_identifiers) REFERENCES ontology.name_link_types(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestations topographic_object_name_manifestations_name_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manifestations_name_identifiers_fkey FOREIGN KEY (name_identifiers) REFERENCES ontology.topographic_names(identifiers) NOT VALID;


--
-- Name: topographic_object_provenances topographic_object_provenances_ancestor_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_ancestor_identifiers_fkey FOREIGN KEY (ancestor_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- Name: topographic_object_provenances topographic_object_provenances_predecessor_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_predecessor_identifiers_fkey FOREIGN KEY (predecessor_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- Name: locations_refined locations_refined_location_raw_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.locations_refined
    ADD CONSTRAINT locations_refined_location_raw_identifiers_fkey FOREIGN KEY (location_raw_identifiers) REFERENCES ontology_sources.locations_raw(identifiers) NOT VALID;


--
-- Name: topographic_object_function_manifestation_sources topographic_object_function_m_topographic_object_identifie_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_function_manifestation_sources
    ADD CONSTRAINT topographic_object_function_m_topographic_object_identifie_fkey FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_function_manifestation_sources topographic_object_function_manif_historical_source_titles_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_function_manifestation_sources
    ADD CONSTRAINT topographic_object_function_manif_historical_source_titles_fkey FOREIGN KEY (historical_source_titles) REFERENCES ontology_sources.historical_sources_sources(titles) NOT VALID;


--
-- Name: topographic_object_function_manifestation_sources topographic_object_function_manifestation_source_functions_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_function_manifestation_sources
    ADD CONSTRAINT topographic_object_function_manifestation_source_functions_fkey FOREIGN KEY (functions) REFERENCES ontology_sources.functions(names) NOT VALID;


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_m_topographic_object_identifie_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_m_topographic_object_identifie_fkey FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_manif_location_link_type_names_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_manif_location_link_type_names_fkey FOREIGN KEY (location_link_type_names) REFERENCES ontology_sources.location_link_type_sources(names) NOT VALID;


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_manifestation_source_locations_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_manifestation_source_locations_fkey FOREIGN KEY (locations) REFERENCES ontology_sources.locations_raw("the_geom_X_Y") NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestation_sources topographic_object_mereological_link_man_whole_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_mereological_link_manifestation_sources
    ADD CONSTRAINT topographic_object_mereological_link_man_whole_identifiers_fkey FOREIGN KEY (whole_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestation_sources topographic_object_mereological_link_mani_part_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_mereological_link_manifestation_sources
    ADD CONSTRAINT topographic_object_mereological_link_mani_part_identifiers_fkey FOREIGN KEY (part_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestation_sources topographic_object_name_manif_topographic_object_identifie_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_name_manifestation_sources
    ADD CONSTRAINT topographic_object_name_manif_topographic_object_identifie_fkey FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_name_manifestation_sources topographic_object_name_manifestation_name_link_type_names_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_name_manifestation_sources
    ADD CONSTRAINT topographic_object_name_manifestation_name_link_type_names_fkey FOREIGN KEY (name_link_types) REFERENCES ontology_sources.name_link_type_sources(names) NOT VALID;


--
-- Name: topographic_object_provenances topographic_object_provenances_ancestor_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_ancestor_identifiers_fkey FOREIGN KEY (ancestor_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_provenances topographic_object_provenances_predecessor_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_predecessor_identifiers_fkey FOREIGN KEY (predecessor_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_type_manifestation_sources topographic_object_type_manif_topographic_object_identifie_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_type_manifestation_sources
    ADD CONSTRAINT topographic_object_type_manif_topographic_object_identifie_fkey FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology_sources.topographic_object_sources(identifiers) NOT VALID;


--
-- Name: topographic_object_type_manifestation_sources topographic_object_type_manifestation_s_historical_sources_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_type_manifestation_sources
    ADD CONSTRAINT topographic_object_type_manifestation_s_historical_sources_fkey FOREIGN KEY (historical_sources) REFERENCES ontology_sources.historical_sources_sources(titles) NOT VALID;


--
-- Name: topographic_object_type_manifestation_sources topographic_object_type_manifestation_sources_types_fkey; Type: FK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_type_manifestation_sources
    ADD CONSTRAINT topographic_object_type_manifestation_sources_types_fkey FOREIGN KEY (types) REFERENCES ontology_sources.topographic_types(names) NOT VALID;


--
-- Name: TABLE geonode_topographic_object_manifestations; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.geonode_topographic_object_manifestations TO PUBLIC;


--
-- Name: TABLE location_dataset_types; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.location_dataset_types TO PUBLIC;


--
-- Name: TABLE location_link_types; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.location_link_types TO PUBLIC;


--
-- Name: TABLE locations; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.locations TO PUBLIC;


--
-- Name: TABLE name_link_types; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.name_link_types TO PUBLIC;


--
-- Name: TABLE overlapping_function_manifestations; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.overlapping_function_manifestations TO PUBLIC;


--
-- Name: TABLE topographic_names; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.topographic_names TO PUBLIC;


--
-- Name: TABLE topographic_object_provenances; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.topographic_object_provenances TO PUBLIC;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: ontology; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology GRANT ALL ON TABLES  TO PUBLIC;


--
-- PostgreSQL database dump complete
--

