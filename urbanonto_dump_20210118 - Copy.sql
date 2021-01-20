--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2021-01-18 16:21:08

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
-- TOC entry 4 (class 2615 OID 24578)
-- Name: ontology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA ontology;


ALTER SCHEMA ontology OWNER TO postgres;

--
-- TOC entry 8 (class 2615 OID 26357)
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- TOC entry 5 (class 2615 OID 26627)
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- TOC entry 9 (class 2615 OID 26213)
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- TOC entry 3993 (class 0 OID 0)
-- Dependencies: 9
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- TOC entry 2 (class 3079 OID 27149)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA ontology;


--
-- TOC entry 3994 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- TOC entry 920 (class 1255 OID 26947)
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
-- TOC entry 208 (class 1259 OID 27126)
-- Name: functions; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.functions (
    identifiers integer NOT NULL,
    iris text NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.functions OWNER TO postgres;

--
-- TOC entry 3995 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE functions; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.functions IS 'The contents of this table will be imported from the ontology.';


--
-- TOC entry 3996 (class 0 OID 0)
-- Dependencies: 208
-- Name: COLUMN functions.iris; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology.functions.iris IS 'This is to store internationalized resource identifiers - see: https://tools.ietf.org/html/rfc3987.';


--
-- TOC entry 216 (class 1259 OID 32783)
-- Name: historical_sources; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.historical_sources (
    identifiers integer NOT NULL,
    titles text NOT NULL,
    bibliographic_data text
);


ALTER TABLE ontology.historical_sources OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 40968)
-- Name: location_dataset_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.location_dataset_types (
    identifiers integer NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.location_dataset_types OWNER TO postgres;

--
-- TOC entry 3997 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE location_dataset_types; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.location_dataset_types IS 'This table is to register all sources for geographic reference data.';


--
-- TOC entry 219 (class 1259 OID 40960)
-- Name: locations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.locations (
    identifiers integer NOT NULL,
    the_geom ontology.geometry NOT NULL,
    location_type_identifiers integer NOT NULL,
    names text
);


ALTER TABLE ontology.locations OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 41144)
-- Name: topographic_names; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_names (
    identifiers integer NOT NULL,
    names text NOT NULL,
    language_tags text
);


ALTER TABLE ontology.topographic_names OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 32826)
-- Name: topographic_object_function_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_function_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    function_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    historical_source_identifiers integer
);


ALTER TABLE ontology.topographic_object_function_manifestations OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 27144)
-- Name: topographic_object_location_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_location_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    historical_source_identifiers integer,
    location_identifiers integer NOT NULL
);


ALTER TABLE ontology.topographic_object_location_manifestations OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32841)
-- Name: topographic_object_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    function_manifestation_identifiers integer,
    location_manifestation_identifiers integer,
    mereological_link_manifestation_identifiers integer,
    name_manifestation_identifiers integer,
    type_manifestation_identifiers integer,
    starts_at date,
    ends_at date
);


ALTER TABLE ontology.topographic_object_manifestations OWNER TO postgres;

--
-- TOC entry 4001 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE topographic_object_manifestations; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.topographic_object_manifestations IS 'This is actually a view over other manifestation tables that aggregates them all.';


--
-- TOC entry 215 (class 1259 OID 32768)
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
-- TOC entry 205 (class 1259 OID 27093)
-- Name: topographic_object_name_manifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_object_name_manifestations (
    identifiers integer NOT NULL,
    topographic_object_identifiers integer NOT NULL,
    starts_at date,
    ends_at date,
    historical_source_identifiers integer,
    name_identifiers integer,
    CONSTRAINT topographic_object_name_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL))))
);


ALTER TABLE ontology.topographic_object_name_manifestations OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 27113)
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
-- TOC entry 204 (class 1259 OID 27088)
-- Name: topographic_objects; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_objects (
    identifiers integer NOT NULL,
    ancestor_identifiers integer
);


ALTER TABLE ontology.topographic_objects OWNER TO postgres;

--
-- TOC entry 4002 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN topographic_objects.ancestor_identifiers; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology.topographic_objects.ancestor_identifiers IS 'This stores information about the object from which the current object was created. We assume that the former will be unique.';


--
-- TOC entry 207 (class 1259 OID 27118)
-- Name: topographic_types; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology.topographic_types (
    identifiers integer NOT NULL,
    iris text NOT NULL,
    names text NOT NULL
);


ALTER TABLE ontology.topographic_types OWNER TO postgres;

--
-- TOC entry 4003 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE topographic_types; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology.topographic_types IS 'The contents of this table will be imported from the ontology.';


--
-- TOC entry 4004 (class 0 OID 0)
-- Dependencies: 207
-- Name: COLUMN topographic_types.iris; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology.topographic_types.iris IS 'This is to store internationalized resource identifiers - see: https://tools.ietf.org/html/rfc3987.';


--
-- TOC entry 222 (class 1259 OID 41002)
-- Name: ontology.function; Type: TABLE; Schema: tiger; Owner: postgres
--

CREATE TABLE tiger."ontology.function" (
    identifiers bigint,
    iris text,
    names text
);


ALTER TABLE tiger."ontology.function" OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 40995)
-- Name: ontology.functions; Type: TABLE; Schema: tiger; Owner: postgres
--

CREATE TABLE tiger."ontology.functions" (
    index bigint,
    identifiers bigint,
    iris text,
    names text
);


ALTER TABLE tiger."ontology.functions" OWNER TO postgres;

--
-- TOC entry 3798 (class 2606 OID 32888)
-- Name: functions Functions_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.functions
    ADD CONSTRAINT "Functions_IRIs_key" UNIQUE (iris);


--
-- TOC entry 3800 (class 2606 OID 27133)
-- Name: functions Functions_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.functions
    ADD CONSTRAINT "Functions_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3812 (class 2606 OID 32790)
-- Name: historical_sources HistoricalSources_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.historical_sources
    ADD CONSTRAINT "HistoricalSources_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3794 (class 2606 OID 27125)
-- Name: topographic_types TopgraphicTypes_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_types
    ADD CONSTRAINT "TopgraphicTypes_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3814 (class 2606 OID 32830)
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManifestations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3802 (class 2606 OID 27148)
-- Name: topographic_object_location_manifestations TopographicObjectLocations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3818 (class 2606 OID 32845)
-- Name: topographic_object_manifestations TopographicObjectManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3808 (class 2606 OID 32772)
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifestations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3786 (class 2606 OID 27097)
-- Name: topographic_object_name_manifestations TopographicObjectNameManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifestations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3790 (class 2606 OID 27117)
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifestations_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3784 (class 2606 OID 27092)
-- Name: topographic_objects TopographicObjects_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_objects
    ADD CONSTRAINT "TopographicObjects_pkey" PRIMARY KEY (identifiers);


--
-- TOC entry 3796 (class 2606 OID 32890)
-- Name: topographic_types TopographicTypes_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_types
    ADD CONSTRAINT "TopographicTypes_IRIs_key" UNIQUE (iris);


--
-- TOC entry 3822 (class 2606 OID 40987)
-- Name: location_dataset_types location_dataset_types_names_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_dataset_types
    ADD CONSTRAINT location_dataset_types_names_key UNIQUE (names);


--
-- TOC entry 3824 (class 2606 OID 40975)
-- Name: location_dataset_types location_types_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.location_dataset_types
    ADD CONSTRAINT location_types_pkey PRIMARY KEY (identifiers);


--
-- TOC entry 3820 (class 2606 OID 40967)
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (identifiers);


--
-- TOC entry 3827 (class 2606 OID 41153)
-- Name: topographic_names topographic_names_names_language_tags_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_names
    ADD CONSTRAINT topographic_names_names_language_tags_key UNIQUE (names, language_tags);


--
-- TOC entry 3829 (class 2606 OID 41151)
-- Name: topographic_names topographic_names_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_names
    ADD CONSTRAINT topographic_names_pkey PRIMARY KEY (identifiers);


--
-- TOC entry 3816 (class 2606 OID 41139)
-- Name: topographic_object_function_manifestations topographic_object_function_m_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_m_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, function_identifiers, starts_at, ends_at);


--
-- TOC entry 3779 (class 2606 OID 40988)
-- Name: topographic_object_function_manifestations topographic_object_function_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- TOC entry 3780 (class 2606 OID 41208)
-- Name: topographic_object_function_manifestations topographic_object_function_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_function_manifestations
    ADD CONSTRAINT topographic_object_function_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- TOC entry 3804 (class 2606 OID 41141)
-- Name: topographic_object_location_manifestations topographic_object_location_m_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_m_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, location_identifiers, starts_at, ends_at);


--
-- TOC entry 3774 (class 2606 OID 40989)
-- Name: topographic_object_location_manifestations topographic_object_location_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- TOC entry 3775 (class 2606 OID 41209)
-- Name: topographic_object_location_manifestations topographic_object_location_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- TOC entry 3781 (class 2606 OID 40990)
-- Name: topographic_object_manifestations topographic_object_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_manifestations
    ADD CONSTRAINT topographic_object_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- TOC entry 3782 (class 2606 OID 40994)
-- Name: topographic_object_manifestations topographic_object_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_manifestations
    ADD CONSTRAINT topographic_object_manifestations_check1 CHECK ((NOT ((topographic_object_identifiers IS NULL) AND (function_manifestation_identifiers IS NULL) AND (location_manifestation_identifiers IS NULL) AND (mereological_link_manifestation_identifiers IS NULL) AND (name_manifestation_identifiers IS NULL) AND (type_manifestation_identifiers IS NULL)))) NOT VALID;


--
-- TOC entry 3810 (class 2606 OID 41143)
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereologic_whole_identifiers_part_identi_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereologic_whole_identifiers_part_identi_key UNIQUE (whole_identifiers, part_identifiers, starts_at, ends_at);


--
-- TOC entry 3777 (class 2606 OID 40991)
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereological_link_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereological_link_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- TOC entry 3778 (class 2606 OID 41210)
-- Name: topographic_object_mereological_link_manifestations topographic_object_mereological_link_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT topographic_object_mereological_link_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- TOC entry 3788 (class 2606 OID 41160)
-- Name: topographic_object_name_manifestations topographic_object_name_manif_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manif_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, starts_at, ends_at, name_identifiers);


--
-- TOC entry 3771 (class 2606 OID 41211)
-- Name: topographic_object_name_manifestations topographic_object_name_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- TOC entry 3792 (class 2606 OID 41162)
-- Name: topographic_object_type_manifestations topographic_object_type_manif_topographic_object_identifier_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manif_topographic_object_identifier_key UNIQUE (topographic_object_identifiers, starts_at, ends_at, type_identifiers);


--
-- TOC entry 3772 (class 2606 OID 40993)
-- Name: topographic_object_type_manifestations topographic_object_type_manifestations_check; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manifestations_check CHECK ((NOT ((starts_at IS NULL) AND (ends_at IS NULL)))) NOT VALID;


--
-- TOC entry 3773 (class 2606 OID 41212)
-- Name: topographic_object_type_manifestations topographic_object_type_manifestations_check1; Type: CHECK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ontology.topographic_object_type_manifestations
    ADD CONSTRAINT topographic_object_type_manifestations_check1 CHECK ((starts_at <= ends_at)) NOT VALID;


--
-- TOC entry 3825 (class 1259 OID 41001)
-- Name: ix_ontology.functions_index; Type: INDEX; Schema: tiger; Owner: postgres
--

CREATE INDEX "ix_ontology.functions_index" ON tiger."ontology.functions" USING btree (index);


--
-- TOC entry 3843 (class 2606 OID 32831)
-- Name: topographic_object_function_manifestations TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- TOC entry 3845 (class 2606 OID 32877)
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- TOC entry 3844 (class 2606 OID 32836)
-- Name: topographic_object_function_manifestations TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_function_manifestations
    ADD CONSTRAINT "TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey" FOREIGN KEY (function_identifiers) REFERENCES ontology.functions(identifiers);


--
-- TOC entry 3837 (class 2606 OID 32791)
-- Name: topographic_object_location_manifestations TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3838 (class 2606 OID 32796)
-- Name: topographic_object_location_manifestations TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT "TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- TOC entry 3847 (class 2606 OID 32851)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_FunctionManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_FunctionManifestationIdentif_fkey" FOREIGN KEY (function_manifestation_identifiers) REFERENCES ontology.topographic_object_function_manifestations(identifiers);


--
-- TOC entry 3848 (class 2606 OID 32856)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_LocationManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_LocationManifestationIdentif_fkey" FOREIGN KEY (location_manifestation_identifiers) REFERENCES ontology.topographic_object_location_manifestations(identifiers);


--
-- TOC entry 3851 (class 2606 OID 32882)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey" FOREIGN KEY (mereological_link_manifestation_identifiers) REFERENCES ontology.topographic_object_mereological_link_manifestations(identifiers) NOT VALID;


--
-- TOC entry 3849 (class 2606 OID 32866)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_NameManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_NameManifestationIdentifiers_fkey" FOREIGN KEY (name_manifestation_identifiers) REFERENCES ontology.topographic_object_name_manifestations(identifiers);


--
-- TOC entry 3846 (class 2606 OID 32846)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- TOC entry 3850 (class 2606 OID 32871)
-- Name: topographic_object_manifestations TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_manifestations
    ADD CONSTRAINT "TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey" FOREIGN KEY (type_manifestation_identifiers) REFERENCES ontology.topographic_object_type_manifestations(identifiers);


--
-- TOC entry 3842 (class 2606 OID 32806)
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- TOC entry 3840 (class 2606 OID 32773)
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey" FOREIGN KEY (whole_identifiers) REFERENCES ontology.topographic_objects(identifiers);


--
-- TOC entry 3841 (class 2606 OID 32801)
-- Name: topographic_object_mereological_link_manifestations TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_mereological_link_manifestations
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey" FOREIGN KEY (part_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3831 (class 2606 OID 27098)
-- Name: topographic_object_name_manifestations TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3832 (class 2606 OID 32811)
-- Name: topographic_object_name_manifestations TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT "TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3834 (class 2606 OID 27134)
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY (topographic_object_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3836 (class 2606 OID 32816)
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY (historical_source_identifiers) REFERENCES ontology.historical_sources(identifiers) NOT VALID;


--
-- TOC entry 3835 (class 2606 OID 27139)
-- Name: topographic_object_type_manifestations TopographicObjectTypeManifestations_TypeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_type_manifestations
    ADD CONSTRAINT "TopographicObjectTypeManifestations_TypeIdentifiers_fkey" FOREIGN KEY (type_identifiers) REFERENCES ontology.topographic_types(identifiers) NOT VALID;


--
-- TOC entry 3830 (class 2606 OID 32821)
-- Name: topographic_objects TopographicObjects_AncestorIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_objects
    ADD CONSTRAINT "TopographicObjects_AncestorIdentifiers_fkey" FOREIGN KEY (ancestor_identifiers) REFERENCES ontology.topographic_objects(identifiers) NOT VALID;


--
-- TOC entry 3852 (class 2606 OID 40976)
-- Name: locations locations_location_type_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.locations
    ADD CONSTRAINT locations_location_type_identifiers_fkey FOREIGN KEY (location_type_identifiers) REFERENCES ontology.location_dataset_types(identifiers) NOT VALID;


--
-- TOC entry 3839 (class 2606 OID 40981)
-- Name: topographic_object_location_manifestations topographic_object_location_manifesta_location_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_location_manifestations
    ADD CONSTRAINT topographic_object_location_manifesta_location_identifiers_fkey FOREIGN KEY (location_identifiers) REFERENCES ontology.locations(identifiers) NOT VALID;


--
-- TOC entry 3833 (class 2606 OID 41154)
-- Name: topographic_object_name_manifestations topographic_object_name_manifestations_name_identifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology.topographic_object_name_manifestations
    ADD CONSTRAINT topographic_object_name_manifestations_name_identifiers_fkey FOREIGN KEY (name_identifiers) REFERENCES ontology.topographic_names(identifiers) NOT VALID;


--
-- TOC entry 3998 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE location_dataset_types; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.location_dataset_types TO PUBLIC;


--
-- TOC entry 3999 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE locations; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.locations TO PUBLIC;


--
-- TOC entry 4000 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE topographic_names; Type: ACL; Schema: ontology; Owner: postgres
--

GRANT ALL ON TABLE ontology.topographic_names TO PUBLIC;


--
-- TOC entry 2603 (class 826 OID 32876)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: ontology; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology GRANT ALL ON TABLES  TO PUBLIC;


-- Completed on 2021-01-18 16:21:16

--
-- PostgreSQL database dump complete
--

