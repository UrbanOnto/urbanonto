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
    the_geom public.geometry(Geometry,2180) NOT NULL,
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
-- Name: location_datasets; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.location_datasets (
    names text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.location_datasets OWNER TO postgres;

--
-- Name: location_datasets_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.location_datasets_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.location_datasets_identifiers_seq OWNER TO postgres;

--
-- Name: location_datasets_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.location_datasets_identifiers_seq OWNED BY ontology_sources.location_datasets.identifiers;


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
    "the_geom_X_Y" text NOT NULL,
    names text,
    location_datasets text
);


ALTER TABLE ontology_sources.locations_raw OWNER TO postgres;

--
-- Name: locations_refined; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.locations_refined (
    location_raw_identifiers integer NOT NULL,
    the_geom public.geometry(Geometry,2180) NOT NULL
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
    historical_sources text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_function_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_function_manifestation_sourc_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_function_manifestation_sourc_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_function_manifestation_sourc_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_function_manifestation_sourc_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_function_manifestation_sourc_identifiers_seq OWNED BY ontology_sources.topographic_object_function_manifestation_sources.identifiers;


--
-- Name: topographic_object_location_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_location_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    location_link_type_names text,
    historical_sources text,
    identifiers integer NOT NULL,
    location_identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_location_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_location_manifestation_sourc_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_location_manifestation_sourc_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_location_manifestation_sourc_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_location_manifestation_sourc_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_location_manifestation_sourc_identifiers_seq OWNED BY ontology_sources.topographic_object_location_manifestation_sources.identifiers;


--
-- Name: topographic_object_mereological_link_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources (
    starts_at text,
    ends_at text,
    whole_identifiers integer NOT NULL,
    part_identifiers integer NOT NULL,
    historical_sources text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_mereological_link_manifestat_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_mereological_link_manifestat_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_mereological_link_manifestat_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_mereological_link_manifestat_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_mereological_link_manifestat_identifiers_seq OWNED BY ontology_sources.topographic_object_mereological_link_manifestation_sources.identifiers;


--
-- Name: topographic_object_name_manifestation_sources; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_name_manifestation_sources (
    topographic_object_identifiers integer NOT NULL,
    starts_at text,
    ends_at text,
    names text NOT NULL,
    name_link_types text NOT NULL,
    historical_sources text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_name_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_name_manifestation_sources_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_name_manifestation_sources_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_name_manifestation_sources_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_name_manifestation_sources_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_name_manifestation_sources_identifiers_seq OWNED BY ontology_sources.topographic_object_name_manifestation_sources.identifiers;


--
-- Name: topographic_object_provenances; Type: TABLE; Schema: ontology_sources; Owner: postgres
--

CREATE TABLE ontology_sources.topographic_object_provenances (
    ancestor_identifiers integer NOT NULL,
    predecessor_identifiers integer NOT NULL,
    historical_sources text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_provenances OWNER TO postgres;

--
-- Name: topographic_object_provenances_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_provenances_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_provenances_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_provenances_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_provenances_identifiers_seq OWNED BY ontology_sources.topographic_object_provenances.identifiers;


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
    historical_sources text,
    identifiers integer NOT NULL
);


ALTER TABLE ontology_sources.topographic_object_type_manifestation_sources OWNER TO postgres;

--
-- Name: topographic_object_type_manifestation_sources_identifiers_seq; Type: SEQUENCE; Schema: ontology_sources; Owner: postgres
--

CREATE SEQUENCE ontology_sources.topographic_object_type_manifestation_sources_identifiers_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ontology_sources.topographic_object_type_manifestation_sources_identifiers_seq OWNER TO postgres;

--
-- Name: topographic_object_type_manifestation_sources_identifiers_seq; Type: SEQUENCE OWNED BY; Schema: ontology_sources; Owner: postgres
--

ALTER SEQUENCE ontology_sources.topographic_object_type_manifestation_sources_identifiers_seq OWNED BY ontology_sources.topographic_object_type_manifestation_sources.identifiers;


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
-- Name: location_datasets identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.location_datasets ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.location_datasets_identifiers_seq'::regclass);


--
-- Name: topographic_object_function_manifestation_sources identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_function_manifestation_sources ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_function_manifestation_sourc_identifiers_seq'::regclass);


--
-- Name: topographic_object_location_manifestation_sources identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_location_manifestation_sources ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_location_manifestation_sourc_identifiers_seq'::regclass);


--
-- Name: topographic_object_mereological_link_manifestation_sources identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_mereological_link_manifestation_sources ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_mereological_link_manifestat_identifiers_seq'::regclass);


--
-- Name: topographic_object_name_manifestation_sources identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_name_manifestation_sources ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_name_manifestation_sources_identifiers_seq'::regclass);


--
-- Name: topographic_object_provenances identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_provenances ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_provenances_identifiers_seq'::regclass);


--
-- Name: topographic_object_type_manifestation_sources identifiers; Type: DEFAULT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_type_manifestation_sources ALTER COLUMN identifiers SET DEFAULT nextval('ontology_sources.topographic_object_type_manifestation_sources_identifiers_seq'::regclass);


--
-- Data for Name: functions; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.functions (identifiers, iris, names) FROM stdin;
\.


--
-- Data for Name: geonode_topographic_object_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.geonode_topographic_object_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, functions, the_geom, whole_topographic_object_identifiers, names, types) FROM stdin;
\.


--
-- Data for Name: historical_sources; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.historical_sources (identifiers, titles, bibliographic_data) FROM stdin;
\.


--
-- Data for Name: location_dataset_types; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.location_dataset_types (identifiers, names) FROM stdin;
\.


--
-- Data for Name: location_link_types; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.location_link_types (identifiers, names, postgis_functions) FROM stdin;
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.locations (identifiers, the_geom, location_type_identifiers, names) FROM stdin;
\.


--
-- Data for Name: name_link_types; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.name_link_types (identifiers, names) FROM stdin;
\.


--
-- Data for Name: topographic_names; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_names (identifiers, names, language_tags) FROM stdin;
\.


--
-- Data for Name: topographic_object_function_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_function_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, function_identifiers, historical_source_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_location_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_location_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, location_identifiers, historical_source_identifiers, location_link_type_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, function_manifestation_identifiers, location_manifestation_identifiers, mereological_link_manifestation_identifiers, name_manifestation_identifiers, type_manifestation_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_mereological_link_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_mereological_link_manifestations (identifiers, starts_at, ends_at, whole_identifiers, part_identifiers, historical_source_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_name_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_name_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, name_identifiers, historical_source_identifiers, name_link_type_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_provenances; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_provenances (identifiers, ancestor_identifiers, predecessor_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_object_type_manifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_object_type_manifestations (identifiers, topographic_object_identifiers, starts_at, ends_at, type_identifiers, historical_source_identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_objects; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_objects (identifiers) FROM stdin;
\.


--
-- Data for Name: topographic_types; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.topographic_types (identifiers, iris, names) FROM stdin;
\.


--
-- Data for Name: date_mapping_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.date_mapping_sources (imprecise_dates, precise_dates) FROM stdin;
\.


--
-- Data for Name: functions; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.functions (identifiers, iris, names) FROM stdin;
1	http://purl.org/ontohgis#function6	funkcja administracyjna
2	http://purl.org/urbanonto/function16	funkcja budowlana
3	http://purl.org/urbanonto/function33	funkcja bycia elementem środowiska przyrodniczego
4	http://purl.org/urbanonto/function24	funkcja bycia miejscem spotkań
5	http://purl.org/ontohgis#object_402	funkcja bycia miejscem wymiany handlowej
6	http://purl.org/ontohgis#object_400	funkcja bycia miejscem zamieszkania
7	http://purl.org/ontohgis#object_403	funkcja bycia siedzibą urzędu
8	http://purl.org/urbanonto/function19	funkcja dobroczynna
9	http://purl.org/urbanonto/function28	funkcja dokumentująca
10	http://purl.org/urbanonto/function15	funkcja edukacyjna
11	http://purl.org/urbanonto/function23	funkcja estetyczna
12	http://purl.org/ontohgis#function13	funkcja gastronomiczna
13	http://purl.org/ontohgis#function8	funkcja gospodarcza
14	http://purl.org/ontohgis#function4	funkcja gospodarcza - gospodarka leśna
15	http://purl.org/ontohgis#function14	funkcja hotelowa
16	http://purl.org/urbanonto/function29	funkcja informacyjna
17	http://purl.org/urbanonto/function30	funkcja izolacyjna
18	http://purl.org/ontohgis#function9	funkcja komunikacyjna
19	http://purl.org/urbanonto/function34	funkcja kontrolna
20	http://purl.org/urbanonto/function21	funkcja kulturalna
21	http://purl.org/urbanonto/function22	funkcja magazynowa
22	http://purl.org/ontohgis#function3	funkcja mieszkalna
23	http://purl.org/ontohgis#function5	funkcja obronna
24	http://purl.org/ontohgis#function10	funkcja obsługi kuracjuszy
25	http://purl.org/urbanonto/function31	funkcja ochronna
26	http://purl.org/urbanonto/function27	funkcja ochrony przyrody
27	http://purl.org/urbanonto/function26	funkcja ochrony zdrowia
28	http://purl.org/ontohgis#object_401	funkcja odgraniczenia przestrzeni wewnętrznej od przestrzeni zewnętrznej
29	http://purl.org/urbanonto/function18	funkcja opiekuńcza
30	http://purl.org/urbanonto/function32	funkcja polityczna
31	http://purl.org/ontohgis#object_404	funkcja produkcyjna
32	http://purl.org/ontohgis#function2	funkcja przemysłowa
33	http://purl.org/urbanonto/function25	funkcja reprezentacyjna
34	http://purl.org/ontohgis#function1	funkcja rolnicza
35	http://purl.org/urbanonto/function20	funkcja rozrywkowa
36	http://purl.org/ontohgis#function12	funkcja sakralna
37	http://purl.org/ontohgis#object_405	funkcja transportowa
38	http://purl.org/urbanonto/function17	funkcja wychowawcza
39	http://purl.org/ontohgis#function7	funkcja wypoczynkowa
40	http://purl.org/ontohgis#function11	funkcja zapewnienia odpoczynku i noclegu dla turystów
41	http://purl.org/ontohgis#object_406	funkcja zarządzania terytorium państwa i jego obywatelami
\.


--
-- Data for Name: historical_sources_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.historical_sources_sources (titles, bibliographic_data) FROM stdin;
#Garbacz_2021	Garbacz, Czym jest tramwaj
#Kunkel_1989	Kunkel, R. M. (1989) ‘Kaplica św. Małgorzaty na Zamku Warszawskim’, Kronika Zamkowa, (2 (20)), pp. 22–28.
#Kunkel_2006	Kunkel, R. M. (2006) Architektura gotycka na Mazowszu. Warszawa.
#KZSP_SW	Łoziński, J. Z. and Rottermund, A. (eds) (1993) Katalog Zabytków Sztuki. Miasto Warszawa. Część 1: Stare Miasto. Warszawa (Katalog Zabytków Sztuki w Polsce. Seria Nowa, Tom XI).
#NKDM3	Sułkowska-Kuraś, I. and Kuraś, S. (eds) (2000) Nowy Kodeks Dyplomatyczny Mazowsza. Część 3: Dokumenty z lat 1356-1381. Warszawa.
#Knapinski_1949	Knapiński, W. (1949) Notaty do dziejów kościołów warszawskich. Warszawa: Wydawnictwo Państwowego Instytutu Historii Sztuki (Materiały do dziejów kultury i sztuki).
#Jarzębski_1974	Jarzębski, A. (1974) Gościniec abo krotkie opisanie Warszawy. Edited by W. Tomkiewicz. Warszawa.
#Mrozowski_2020	Mrozowski, K. (2020) Przestrzeń i obywatele Starej Warszawy od schyłku XV wieku do 1569 roku. Warszawa.
#Księga_Pamiątkowa_TUR_1900	Księga Pamiątkowa TUR (1900) Księga Pamiątkowa warszawskiego oddziału Towarzystwa Ubezpieczeń "Rossya". Warszawa
#Herbst_1949	Herbst, S. (1949) Ulica Marszałkowska. Warszawa
#Kurier_1849	„Kurier Warszawski” 1849, nr 292 (5 listopada), s. 1547
#Kalendarz_1874,1876	#Kalendarz_1874,1876 Józefa Ungra Kalendarz Warszawski Popularno-Naukowy na Rok 1874, 1876. Warszawa
#Przegląd_Techniczny_1904	"Przegląd Techniczny" 1904, t. 42, nr 17
#Bieniecki_1972	Bieniecki, Z. (1972) Dom własny rzeźbiarza warszawskiego Jana Józefa Manzla, "Rocznik Warszawski", t. 11, s. 173-204.
#Wikipedia	Wikipedia
#Omilanowska_2004_a	Omilanowska, M. (2004) Świątynie handlu. Warszawska architektura komercyjna doby wielkomiejskiej. Warszawa, p. 162-169
#Omilanowska_2004_b	Omilanowska, M. (2004) Świątynie handlu. Warszawska architektura komercyjna doby wielkomiejskiej. Warszawa, p. 92
#Omilanowska_2004_c	Omilanowska, M. (2004) Świątynie handlu. Warszawska architektura komercyjna doby wielkomiejskiej. Warszawa, p. 160
#Majewski_2003_a	Majewski, J.S. (2003) Warszawa nieodbudowana. Metropolia Belle Epoque. Warszawa, p. 298
#Majewski_2003_b	Majewski, J.S. (2003) Warszawa nieodbudowana. Metropolia Belle Epoque. Warszawa, p. 90-93
#Majewski_2003_c	Majewski, J.S. (2003) Warszawa nieodbudowana. Metropolia Belle Epoque. Warszawa, p. 174-176
#Majewski_2003_d	Majewski, J.S. (2003) Warszawa nieodbudowana. Metropolia Belle Epoque. Warszawa, p. 45-49
#Machlejd_2006	Machlejd, K. (2006) Saga ulrichowsko-machlejdowska. Warszawa, p. 47
#Gagatnicki_1893	Gagatnicki, A. (1893) Kościół Wszystkich Świętych w Warszawie. Warszawa
#Marcinkowski_2013_a	Marcinkowski, R. (2013) Ilustrowany atlas dawnej Warszawy. Warszawa, p. 132-133
#Szwankowski_1952_a	Szwankowski, E. (1952) Warszawa. Rozwój urbanistyczny i architektoniczny. Warszawa, p. 257
#Przewodnik_1893_a	Przewodnik (1893) Ilustrowany przewodnik po Warszawie. Warszawa, p. 218-219
#Madajczyk_2009	Madajczyk, A. (2009) ‘Z dziejów budowy kościoła pw. świętych Michała i Floriana’, in Sołtan, A., Wiśniewska, J., and Zwierz, K. (eds) Świątynie prawego brzegu. Kościół katolicki w dziejach prawobrzeżnej Warszawy. Warszawa, pp. 125–137
#Zbior_Korotyńskich_72/1001/0/5/24	72/201/0/ - Zbiór Korotyńskich, seria 5 - 'Grupa V - Kościoły, klasztory, zgromadzenia religijne, cmentarze', sygn. 24 - 'Kościół św. Floriana na Pradze'
#Łupienko_2017	Aleksander Łupienko, Ewangelicki zakątek w dziewiętnastowiecznej Warszawie. Nieruchomości parafii św. Trójcy wokół placu Ewangelickiego, "Kronika Warszawy", nr 1, p. 55-76
#Szwankowski_1970_a	Szwankowski, E. (1970) Ulice i place Warszawy. Warszawa, p. 139.
#Jaroszewski_1975	Jaroszewski, T.S. (1975) Pałac Szlenkierów. Warszawa
#Szwankowski_1970_b	Szwankowski, E. (1970) Ulice i place Warszawy. Warszawa, p. 274.
#Troczewski_1897	Troczewski, E. (1897) ‘Rotunda “Golgoty” [ul. Karowa w Warszawie]’. Available at: https://fbc.pionier.net.pl/details/oai:mbc.cyfrowemazowsze.pl:52944.
#GmachDawnejPanoramy	‘Gmach dawnej Panoramy, dawny Teatr Artystów, Karowa 18a’ (no date) Fundacja warszawa1939.pl. Available at: http://www.warszawa1939.pl/obiekt/karowa-18a (Accessed: 16 March 2021).
#WarsztatySamochodoweDynasy	‘Warsztaty samochodowe, dawna Panorama, Oboźna - Dynasy’ (no date) Fundacja warszawa1939.pl. Available at: http://www.warszawa1939.pl/obiekt/obozna-panorama (Accessed: 16 March 2021).
#Słowo_184_1904	Słowo R. 23, Nr 184 (1904) ‘[Wiadomości] Z miasta, Z budownictwa’, 11 August, p. 3.
#MiejskieElewatory	‘Miejskie Elewatory Zbożowe, Bema 60a’ (no date) Fundacja warszawa1939.pl. Available at: http://www.warszawa1939.pl/obiekt/bema-60a (Accessed: 16 March 2021).
#Gmachy_1928	DO UZUPEŁNIENIA!
#Sosna_KatSobor	Sosna, A. (no date) ‘Warszawa. Katedralny Sobór św. Aleksandra Newskiego’, Prawosławne cerkwie na starych pocztówkach chram.com.pl. Available at: http://www.chram.com.pl/katedralny-sobor-sw-aleksandra-newskiego-2/ (Accessed: 18 March 2021).
#Schiller-Walicka_2016	Schiller-Walicka, J. (2016) ‘Cesarski Uniwersytet Warszawski: Między edukacją a polityką 1869-1917’, in Kizwalter, T. (ed.) Dzieje Uniwersytetu Warszawskiego 1816−1915. Warszawa (Monumenta Universitatis Varsoviensis, 1), pp. 557–703. Available at: http://www.wuw.pl/data/include/cms/monumenta-ebook/pdf/Dzieje-Uniwersytetu-Warszawskiego-1816-1915.pdf.
#Szwarc_2016	Szwarc, A. (2016) ‘Akademia Medyko-Chirurgiczna i Szkoła Głowna 1857-1869’, in Kizwalter, T. (ed.) Dzieje Uniwersytetu Warszawskiego 1816−1915. Warszawa (Monumenta Universitatis Varsoviensis, 1), pp. 415–555. Available at: http://www.wuw.pl/data/include/cms/monumenta-ebook/pdf/Dzieje-Uniwersytetu-Warszawskiego-1816-1915.pdf.
#Marcinkowski_2013_b	Marcinkowski, R. (2013) Ilustrowany atlas dawnej Warszawy. Warszawa, p. 75
#Warszawikia	https://warszawa.wikia.org
#Warszawa1939	warszawa1939.pl
#PlanWarszawy1920	Plan Warszawy, Wyd. M. Arcta [1920]
#Jaroszewski_1996	Jaroszewski, T.S. (1996) Architektura rezydencjonalna wielkiej burżuazji warszawskiej w latach 1864-1914, w: idem, Od klasycyzmu do nowoczesności. O architekturze polskiej XVIII, XIX i XX wieku. Warszawa
#Przegląd_Techniczny_1907	"Przegląd Techniczny" 1907, t. 45, nr 4
#Markiewicz_et_al_2012	T. Markiewicz, T.W. Świątek, K. Wittels (2012). Polacy z wyboru. Rodziny pochodzenia niemieckiego w Warszawie w XIX i XX wieku. Warszawa, p. 147-149
#Sobieszczański_1967	Sobieszczański, F.M. (1967) Warszawa. Wybór publikacji, t. 1. Warszawa, p. 371.
#Świątkowski_1852	Świątkowski, H. (1852) Taryffa domów miasta Warszawy i Pragi... Warszawa.
#Szwankowski_1970_c	Szwankowski, E. (1970) Ulice i place Warszawy. Warszawa, p. 27.
#Majewski_2009_a	Majewski, J.S. (2009) Warszawa nieodbudowana. Królestwo Polskie w latach 1815-1840. Warszawa, p. 165-166
\.


--
-- Data for Name: location_datasets; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.location_datasets (names, identifiers) FROM stdin;
#GoogleMaps	1
#Lindley	2
#Mapa_1835	3
#Wedel	4
#Fotomapa1935	5
#Perthees	6
#Mrozowski_2020	7
#Plan1808	8
#Plan1768	9
#Lindely	10
#AHPMazowsze	11
#Fotoplan1935	12
Plan Warszawy, Wyd. M. Arcta [1920]	13
\.


--
-- Data for Name: location_link_type_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.location_link_type_sources (names, postgis_functions) FROM stdin;
dokładnie	\N
przybliżona	\N
prawdopodobna	\N
obok	\N
obok prawdopodobna	\N
dookoła	\N
dookoła prawdopodobnie	\N
między	\N
między prawdopodobnie	\N
wśród	\N
wśród prawdopodobnie	\N
wzdłuż	\N
wzdłuż prawdopodobnie	\N
w poprzek	\N
w poprzek prawdopodobnie	\N
nad	\N
nad prawdopodobnie	\N
pod	\N
pod prawdopodobnie	\N
za	\N
za prawdopodobnie	\N
przed	\N
przed prawdopodobnie	\N
na lewo od	\N
na prawo od	\N
na północ od	\N
na południe od	\N
na wschód od	\N
na zachód od	\N
na północny wschód od	\N
na północny zachód od	\N
na południowy wschód od	\N
na południowy zachód od	\N
\.


--
-- Data for Name: locations_raw; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.locations_raw (identifiers, "the_geom_X_Y", names, location_datasets) FROM stdin;
1	52.25068853563155, 21.012523999846863	Baszta Biała	\N
2	52.248166445133876, 21.01419457829904	kaplica św. Małgorzaty	\N
3	52.24821124787931, 21.012453430954597	zespół klasztorny augustianów-eremitów	\N
4	52.24842528487927, 21.012473730092783	kościół św. Marcina	\N
5	52.24807416256469, 21.012982208427154	kamienica stanowiąca część klasztoru augustianów-eremitów (Piwna 7, nr hip. 114)	\N
6	52.2518100, 21.0074700	kościół św. Jerzego w Warszawie	\N
7	52.2258433, 20.9601870	Miejskie Elewatory Zbożowe, ul. Bema 60a	#GoogleMaps
8	52.2525400, 21.0135800	przeprawa przez Wisłę, okolice dzisiejszej ulicy Mostowej	\N
10	52.2476295, 21.0516535	Rogatka Grochowska II	#GoogleMaps
11	52°15′07″N, 20°58′22″E	Cmentarz Powązkowski	#Mapa_1835
12	52°15′07″N, 20°58′22″E	Cmentarz Powązkowski	\N
13	52°15′07″N, 20°58′22″E	Cmentarz Powązkowski	#Wedel
14	52°15′07″N, 20°58′22″E	Cmentarz Powązkowski	#Lindley
15	52°15′07″N, 20°58′22″E	Cmentarz Powązkowski	#Fotomapa1935
16	52.23415596845132, 21.009869238945598	Gmach Towarzystwa Ubezpieczeń "Rossya"	#GoogleMaps
17	52.23718111160122, 21.008166500209537	Gmach Domu Mody "Bogusław Herse"	#Fotomapa1935
18	52.238237048080045, 20.99258047850341	Kościół p.w. św. Karola Boromeusza	#GoogleMaps
19	52.237242454177654, 21.0058460847311	Pałac Jakuba Janasza	#GoogleMaps
20	52.23735827563949, 20.990022682063692	Kamienica Jana Józefa Manzla przy ul. Chłodnej nr hip. 927B	#Lindley
21	52.22956699726129, 20.989652752987514	Hala hurtowa na placu Witkowskiego/Kazimierza Wielkiego	#Fotomapa1935
22	52.23327292582196, 20.992696497985396	Ogród handlowy Ulrichów, nr hip. 1117	#Lindley
23	52.23327292582196, 20.992696497985396	Ogród handlowy Ulrichów, nr hip. 1117	#Fotomapa1935
24	52.23545458846053, 21.003340853060365	Kościół p.w. Wszystkich Świętych w Warszawie	#GoogleMaps
25	52.22656228161761, 21.00750922871147	Kościół p.w. św. Piotra i Pawła w Warszawie	#GoogleMaps
26	52.238090962416095, 21.00537339346967	Ujeżdżalnia przy ul. Królewskiej	#Lindley
27	52.23971218509781, 21.002782030135094	Gościnny Dwór	#Lindley
28	52.238930359884925, 20.99761073117185	Hale Mirowskie	#GoogleMaps
29	52.234823429714076, 21.007183507764008	Kamienica Bractwa Subiektów Handlowych, nr hip. 1414a	#Fotomapa1935
30	52.23435688674018, 21.00865842612838	Kamienica Braci Zambonich (neogotycka), nr hip. 1379	#Lindley
31	52.22639868943129, 20.994626600929006	Dworzec Kaliski	#Fotomapa1935
32	52.25594900439654, 21.05439649913739	Zajezdnia tramwajowa na Pradze	#Fotomapa1935
33	52.25093523770945, 21.04833495591725	Dworzec Terespolski	#Fotomapa1935
38	52.251844588418436, 21.03082724008169	kościół św. Michała Archanioła i Floriana	#GoogleMaps
39	52.22273147313137, 21.01977618464994	Mokotowska	\N
40	52.238100755089185, 21.010635518811753	Kamienica zboru luterańskiego, nr hip. 1066J (Kredytowa 4)	#GoogleMaps
41	52.23845190722721, 21.010877293117264	Dom parafialny zboru luterańskiego, nr hip. 1066J (Plac Ewangelicki)	#Fotomapa1935
42	52.226299675701036, 21.005056457786562	Ogród pomologiczny, nr hip. 1600A	#Lindley
43	52.23728815274099, 21.01000653183161	Pałac Szlenkierów, nr hip. 5294	#GoogleMaps
44	52.22501798356567, 20.989582549994676	Rogatki jerozolimskie, nr hip. 1582F	#Lindley
45	52.24257954434774, 21.017115120566146	Rotunda na Karowej (teren obecnej ul. Karowej 18a)	#Lindley
46	52.239244, 21.022134	Rotunda na Dynasach	#GoogleMaps
47	52.24142860372724, 21.02519130870737	Miejska Fabryka Betonu ul. Dobra 72	#Lindley
48	52.26331058316724, 21.050856071052756	Stacja Warszawa Stalowa	#Fotomapa1935
49	52.25887944977987, 21.059582945360745	Bazylika na Kawęczyńskiej	#Fotomapa1935
50	52.259414662266934, 21.057474729027064	Szkoła (ul. Otwocka)	#Fotomapa1935
52	52.24062638411823, 21.018540750077108	kampus UW przy Krakowskim Przedmieściu	#Lindley
53	52.23791889182027, 21.01809453202634	Pałac Staszica	#GoogleMaps
54	52.24935910656511, 21.013318306179304	budynki pojezuickie na Starym Mieście, dawny Wydział Lekarski UW	\N
55	52.2256811355311, 21.028325911245236	Aleksandryjsko-Maryjski Instytut Wychowania Panien (dawny Instytut Szlachecki) ul. Wiejska 6/8	\N
56	52.24084963268228, 21.020307226587303	Pałac Kazimierzowski	#GoogleMaps
57	52.23954196986328, 21.01856065604423	Budynek Pomuzealny UW	#GoogleMaps
58	52.250551725206, 21.00961916414927	Szpital św. Ducha	\N
59	52.25045812687483, 21.010536479671806	Brama Nowomiejska	\N
60	52.25065230214322, 21.009143072071787	Kościół św. Ducha	#Lindley
61	52.250481526479305, 21.009011643824405	Klasztor paulinów	#Plan1808
62	52.25019498313577, 21.010934787708283	Ulica Nowomiejska	#Plan1768
63	52.25019498313577, 21.010934787708283	Ulica Nowomiejska	#Lindley
64	52.250817329928665, 21.00976802677931	Łaźnia przy Bramie Nowomiejskiej	\N
65	52.248838598136985, 21.010261553244913	Pierwsza linia murów miejskich	\N
66	52.24878132205401, 21.0100798352685	Druga linia murów miejskich	\N
67	52.2506225019082, 21.010155711140786	Barbakan	\N
68	52.24974809013082, 21.01029518601187	Szeroki Dunaj	#Lindley
69	52.249510805464894, 21.010751161557437	Łaźnia wójtowska	\N
70	52.249624111102214, 21.010858449922647	Wąski Dunaj	#Lindley
71	52.24911423345034, 21.00981507058835	Brama Poboczna	\N
72	52.25073699715617, 21.01134382023915	Krzywe Koło	#Lindley
73	52.25136097839556, 21.009318752429305	Kościół św. Jacka	#Lindley
74	52.2518806823811, 21.009953094863114	Klasztor dominikanów	#Lindley
75	52.25173782596747, 21.009544057986144	Zespół klasztorny dominikanów	#Lindley
76	52.249792352214676, 21.011320471606787	Kamienica "Pod świętą Anną"	#Lindley
77	52.25070521631351, 21.010189609986327	Piwnica Gdańska	#Lindley
78	52.25153691626514, 21.00827987716609	Freta	#Lindley
79	52.25153691626514, 21.00827987716609	Freta	#Lindely
80	52.25153691626514, 21.00827987716609	Freta	#Lindley
81	52.25204758708843, 21.0078976623851	Freta Nowomiejskie	#Lindley
82	52.250865615363665, 21.009117930037608	Północne przedmieście Starej Warszawy	#Lindely
83	52.252982749574194, 21.008326339498016	Nowa Warszawa	\N
84	52.252059944813695, 21.008991527320315	Ulica zatylna za południową pierzeją rynku Nowego Miasta	#AHPMazowsze
85	52.25280213094547, 21.008117127123352	Rynek Nowego Miasta	#Lindley
95	52.25280213094547, 21.008117127123352	Rynek Nowego Miasta	#Lindley
86	52.252148613719605, 21.007151531902206	Hala Świętojerska	#Fotomapa1935
87	52.25113055262903, 21.00295655698398	Jurydyka Świętojerska	\N
88	52.25217816997082, 20.98417036507179	Jurydyka Parysowska	\N
89	52.25237521121917, 20.984052347870062	Plac Parysowski	#Lindley
90	52.24760501997195, 21.010162725437123	Jurydyka Zadzikowska	\N
91	52.24766742289438, 21.010227098456248	Ulica Kapitulna	#Lindley
92	52.245883978423315, 21.001295342357515	Arsenał	#Lindley
93	52.246166444012545, 21.002159013697447	Zespół klasztorny brygidek	#Fotoplan1935
94	52.258758, 20.995367	Dworzec Gdański	\N
96	52.233730531103376, 21.01055892371011	Dom firmy Gebethner i Wolff, nr hip. 6391	#Fotoplan1935
97	52.23758561997814, 21.009777521153445	Kamienica Goldstanda, nr hip. 1066C	#GoogleMaps
98	52.22714990480268, 20.988840695471286	Zakłady metalurgiczne Hantkego, nr hip. 1147K	#Lindley
99	52.237423366147155, 20.981047536855506	Browar Hermana Junga, nr hip. 849	#Lindley
100	52.2355812231545, 20.980690161199597	Rogatki wolskie	#Lindley
101	52.2151723770801, 21.03584618435141	pawilon Łaźni Łazienki	\N
102	52.215090207828574, 21.035148810023923	pawilon Łaźni Łazienki zachodnie skrzydło	\N
\.


--
-- Data for Name: locations_refined; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.locations_refined (location_raw_identifiers, the_geom) FROM stdin;
\.


--
-- Data for Name: name_link_type_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.name_link_type_sources (names) FROM stdin;
nazwa podstawowa
nazwa oboczna
\.


--
-- Data for Name: topographic_object_function_manifestation_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_function_manifestation_sources (topographic_object_identifiers, starts_at, ends_at, functions, historical_sources, identifiers) FROM stdin;
1	1379	1560	funkcja obronna	#Garbacz_2021	66
10	1780	1823	funkcja hotelowa	#KZSP_SW	67
10	1780	1823	funkcja bycia miejscem wymiany handlowej	#KZSP_SW	68
10	1814	1816	funkcja edukacyjna	#KZSP_SW	69
10	1860	1864	funkcja edukacyjna	#KZSP_SW	70
29	1900	1950	funkcja gospodarcza	#Księga_Pamiątkowa_TUR_1900	71
30	1899	1944	funkcja bycia miejscem wymiany handlowej	#Herbst_1949	72
31	1849	2000	funkcja sakralna	#Kurier_1849	73
32	1875	2000	funkcja mieszkalna	#Kalendarz_1874,1876	74
33	1841	1944	funkcja mieszkalna	#Bieniecki_1972	75
34	1908	1942	funkcja bycia miejscem wymiany handlowej	#Omilanowska_2004_a	76
35	1805	1944	funkcja gospodarcza	#Majewski_2003_a	77
36	1893	2000	funkcja sakralna	#Gagatnicki_1893	78
37	1886	1944	funkcja sakralna	#Przewodnik_1893_a	79
38	1877	1944	funkcja gospodarcza	#Marcinkowski_2013_a	80
39	1823	1877	funkcja rozrywkowa	#Marcinkowski_2013_a	81
40	1841	1939	funkcja bycia miejscem wymiany handlowej	#Omilanowska_2004_b	82
41	1902	2000	funkcja bycia miejscem wymiany handlowej	#Omilanowska_2004_c	83
42	1911	1954	funkcja administracyjna	#Majewski_2003_b	84
42	1911	1954	funkcja bycia miejscem zamieszkania	#Majewski_2003_b	85
43	1894	1944	funkcja bycia miejscem zamieszkania	#Majewski_2003_c	86
44	1902	1915	funkcja gastronomiczna	#Majewski_2003_d	87
51	1911	2000	funkcja gospodarcza	#Łupienko_2017	88
51	1911	1945	funkcja dobroczynna	#Łupienko_2017	89
52	1912	1944	funkcja administracyjna	#Łupienko_2017	90
53	1870	1936	funkcja gospodarcza	#Szwankowski_1970_a	91
54	1883	2000	funkcja administracyjna	#Jaroszewski_1975	92
49	1902	1907	funkcja rozrywkowa	#GmachDawnejPanoramy	93
114	1880	1915	funkcja komunikacyjna	#Marcinkowski_2013_b	94
115	1824	1900	funkcja obronna	#Wikipedia	95
115	1900	1945	funkcja bycia miejscem wymiany handlowej	#Wikipedia	96
116	1906	1950	funkcja bycia miejscem wymiany handlowej	#Przegląd_Techniczny_1907	97
116	1906	1950	funkcja administracyjna	#Przegląd_Techniczny_1907	98
117	1916	2000	funkcja bycia miejscem wymiany handlowej	#Jaroszewski_1996	99
119	1784	1944	funkcja bycia miejscem zamieszkania	#Świątkowski_1852	100
120	1818	1942	funkcja kontrolna	#Majewski_2009_a	101
121	1683	1775	funkcja rozrywkowa	\N	102
122	1775	1795	funkcja bycia miejscem spotkań	\N	103
\.


--
-- Data for Name: topographic_object_location_manifestation_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_location_manifestation_sources (topographic_object_identifiers, starts_at, ends_at, location_link_type_names, historical_sources, identifiers, location_identifiers) FROM stdin;
1	1379	1560	dokładnie	#Garbacz_2021	430	1
2	1525	1830	obok	#Kunkel_1989	431	2
3	1356	1864	dokładnie	#KZSP_SW	432	3
4	1356	1400	dokładnie	#KZSP_SW	433	4
5	1356	1441	wśród	#KZSP_SW	434	3
6	1356	\N	obok	#KZSP_SW	435	4
7	1400	1478	dokładnie	#KZSP_SW	436	4
8	1494	1631	dokładnie	#KZSP_SW	437	4
9	1631	1944	dokładnie	#KZSP_SW	438	4
10	1441	1864	wśród	#KZSP_SW	439	3
11	1650	1864	dokładnie	#KZSP_SW	440	5
12	1650	1864	wśród	#KZSP_SW	441	3
13	1650	1864	wśród	#KZSP_SW	442	3
14	1701	1864	wśród	#KZSP_SW	443	3
15	1483	1864	obok	#Knapinski_1949	444	4
16	1780	1864	wśród	#KZSP_SW	445	3
17	1339	1453	dokładnie	#Kunkel_2006	446	6
18	1453	1819	dokładnie	#Kunkel_2006	447	6
19	1450	1818	obok	#Kunkel_2006	448	6
21	1892	1939	dokładnie	#MiejskieElewatory	449	7
24	1522	1569	przybliżona	#Mrozowski_2020	450	8
24	1643	\N	przybliżona	#Jarzębski_1974	451	8
25	1823	2000	dokładnie	\N	452	9
26	1823	1961	dokładnie	\N	453	10
26	1961	2000	dokładnie	\N	454	34
29	1900	2020	\N	\N	455	16
30	1897	1939	dookoła	\N	456	17
31	1849	2000	dokładnie	\N	457	18
32	1875	2000	\N	\N	458	19
33	1841	1964	przybliżona	#Bieniecki_1972	459	20
34	1908	1947	przybliżona	#Omilanowska_2004_a	460	21
35	1805	1906	dookoła	#Majewski_2003_a	461	22
35	1906	1944	dookoła	#Machlejd_2006	462	23
36	1893	2000	dokładnie	#Gagatnicki_1893	463	24
37	1886	1944	przybliżona	#Przewodnik_1893_a	464	25
37	1945	2000	przybliżona	#Szwankowski_1952_a	465	25
38	1877	1944	przybliżona	#Marcinkowski_2013_a	466	26
39	1823	1877	przybliżona	#Marcinkowski_2013_a	467	26
40	1841	1939	przybliżona	#Omilanowska_2004_b	468	27
41	1902	2000	dokładnie	#Omilanowska_2004_c	469	28
42	1911	1954	przybliżona	#Majewski_2003_b	470	29
43	1894	1944	przybliżona	#Majewski_2003_c	471	30
44	1902	1915	przybliżona	#Majewski_2003_d	472	31
45	1925	1944	dokładnie	\N	473	32
46	1866	1939	dokładnie	\N	474	33
20	1643	\N	przybliżona	#Jarzębski_1974	475	35
22	1499	1553	prawdopodobna	#Mrozowski_2020	476	36
23	1565	1567	prawdopodobna	#Mrozowski_2020	477	37
47	1819	1897	dokładnie	#Kunkel_2006	478	6
48	1888	1844	dokładnie	#Zbior_Korotyńskich_72/1001/0/5/24	479	38
51	1911	2000	dokładnie	#Łupienko_2017	480	40
52	1912	1944	przybliżona	#Łupienko_2017	481	41
53	1870	1936	dookoła	#Szwankowski_1970_a	482	42
54	1883	2000	dokładnie	#Jaroszewski_1975	483	43
55	1818	1942	przybliżona	#Szwankowski_1970_b	484	44
49	1897	1907	dokładnie	#GmachDawnejPanoramy	485	45
56	1907	1910	dokładnie	#GmachDawnejPanoramy	486	45
57	1910	1913	dokładnie	#GmachDawnejPanoramy	487	45
58	1913	1921	dokładnie	#GmachDawnejPanoramy	488	45
59	1921	1939	dokładnie	#GmachDawnejPanoramy	489	45
60	1896	1913	dokładnie	#WarsztatySamochodoweDynasy	490	46
61	1913	1938	dokładnie	#WarsztatySamochodoweDynasy	491	46
62	1938	1939	dokładnie	#WarsztatySamochodoweDynasy	492	46
63	1939	2000	dokładnie	\N	493	46
64	1897	1904	dokładnie	#Słowo_184_1904	494	47
65	1901	1995	dokładnie	\N	495	48
66	1923	2000	dokładnie	\N	496	49
67	1926	200	dokładnie	\N	497	50
68	1894	1915	przybliżona	#Sosna_KatSobor	498	51
69	1915	1918	przybliżona	#Sosna_KatSobor	499	51
70	1918	1926	przybliżona	#Sosna_KatSobor	500	51
71	1869	1915	przybliżona	#Schiller-Walicka_2016	501	52
73	1857	1858	dokładnie	#Szwarc_2016	502	54
72	1862	1869	dokładnie	#Szwarc_2016	503	52
73	1858	1862	dokładnie	#Szwarc_2016	504	53
74	1861	1862	dokładnie	#Szwarc_2016	505	55
72	1862	1869	dokładnie	#Szwarc_2016	506	53
75	1862	1894	dokładnie	#Szwarc_2016	507	56
76	1865	\N	dokładnie	#Szwarc_2016	508	57
77	1388	1821	przybliżona	\N	509	58
78	1350	1825	przybliżona	\N	510	59
79	1388	2000	dokładnie	\N	511	60
80	1662	1807	dokładnie	\N	512	61
80	1815	1819	dokładnie	\N	513	61
81	1300	1825	dokładnie	\N	514	62
81	1825	2000	dokładnie	\N	515	63
82	1376	\N	prawdopodobna	\N	516	64
83	1325	1350	dokładnie	\N	517	65
83	1350	\N	dokładnie	\N	518	65
84	1450	\N	dokładnie	\N	519	66
85	1548	1818	dokładnie	\N	520	67
86	1300	2000	dokładnie	\N	521	68
87	1408	1552	prawdopodobna	\N	522	69
88	1300	1804	dokładnie	\N	523	70
88	1804	2000	dokładnie	\N	524	70
89	1617	1804	dokładnie	\N	525	71
90	1300	2000	dokładnie	\N	526	72
91	1606	1944	dokładnie	\N	527	73
92	1638	1864	dokładnie	\N	528	74
93	1606	2000	dokładnie	\N	529	75
94	1466	2000	dokładnie	\N	530	76
95	1818	1944	dokładnie	\N	531	77
96	1864	1944	dokładnie	\N	532	74
97	1300	1408	dokładnie	\N	533	78
97	1408	1791	dokładnie	\N	534	79
97	1791	2000	dokładnie	\N	535	80
98	1408	1791	dokładnie	\N	536	81
99	1408	1791	dokładnie	\N	537	82
100	1408	1791	dokładnie	\N	538	83
101	1408	1650	prawdopodobna	\N	539	84
99	1300	1408	dokładnie	\N	540	82
102	1408	2000	dokładnie	\N	541	85
103	1913	1944	dokładnie	\N	542	86
104	1350	1791	przybliżona	\N	543	87
105	1600	1791	przybliżona	\N	544	88
106	1600	1943	dokładnie	\N	545	89
107	1638	1791	przybliżona	\N	546	90
108	1638	2000	dokładnie	\N	547	91
109	1643	2000	dokładnie	\N	548	92
110	1615	1892	dokładnie	\N	549	93
111	1903	1944	dokładnie	\N	550	93
112	1615	1892	przybliżona	\N	551	93
113	1615	1807	przybliżona	\N	552	93
114	1880	1915	przybliżona	#Marcinkowski_2013_b	553	94
115	1824	1945	przybliżona	#Wikipedia	554	95
116	1906	1950	przybliżona	#Jaroszewski_1996	555	96
117	1916	2000	dokładnie	#Jaroszewski_1996	556	97
118	1870	1944	przybliżona	#Markiewicz_et_al_2012	557	98
119	1784	1944	przybliżona	#Sobieszczański_1967	558	99
120	1818	1942	przybliżona	#Szwankowski_1970_c	559	100
121	1683	1775	dokładnie	\N	560	101
122	1775	2000	dokładnie	\N	561	101
123	1846	1919	dokładnie	\N	562	102
124	1919	1947	dokładnie	\N	563	102
\.


--
-- Data for Name: topographic_object_mereological_link_manifestation_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_mereological_link_manifestation_sources (starts_at, ends_at, whole_identifiers, part_identifiers, historical_sources, identifiers) FROM stdin;
1379	1560	1	1	#Garbacz_2021	1
1356	1400	3	4	#KZSP_SW	2
1356	1441	3	5	#KZSP_SW	3
1356	\N	3	6	#KZSP_SW	4
1400	1478	3	7	#KZSP_SW	5
1494	1631	3	8	#KZSP_SW	6
1631	1864	3	9	#KZSP_SW	7
1441	1864	3	10	#KZSP_SW	8
1752	1864	3	11	#KZSP_SW	9
1650	1864	3	12	#KZSP_SW	10
1650	1864	3	13	#KZSP_SW	11
1701	1864	3	14	#KZSP_SW	12
1483	1864	3	15	#KZSP_SW	13
1780	1864	3	16	#KZSP_SW	14
1865	1869	72	76	#Szwarc_2016	15
1350	1800	83	78	\N	16
1548	1800	78	85	\N	17
1617	1804	83	89	\N	18
1606	1944	93	91	\N	19
1638	2000	93	92	\N	20
1615	1892	110	112	\N	21
1615	1807	110	113	\N	22
1846	1919	122	123	\N	23
1919	1946	122	124	\N	24
\.


--
-- Data for Name: topographic_object_name_manifestation_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_name_manifestation_sources (topographic_object_identifiers, starts_at, ends_at, names, name_link_types, historical_sources, identifiers) FROM stdin;
1	1379	1560	Baszta Biała	nazwa podstawowa	#Garbacz_2021	287
2	1525	1830	Kaplica św. Małgorzaty	nazwa podstawowa	#Kunkel_1989	288
2	1769	\N	baszta, w której antiquitates była kaplica, a teraz schowanie kuchenne	nazwa oboczna	#Kunkel_1989	289
2	1763	\N	Wieża Szlachecka	nazwa oboczna	#Kunkel_1989	290
2	1525	1830	Kaplica (Zamkowa?) Mansjonarzy pw. św. Małgorzaty	nazwa oboczna	#Kunkel_2006	291
3	1356	1864	zespół klasztorny augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	292
4	1356	\N	kościół pw. Świętego Ducha, św. Marcina i św. Doroty w Warszawie	nazwa oboczna	#NKDM3	293
5	1356	\N	klasztor augustianów-eremitów w Warszawie	nazwa podstawowa	#NKDM3	294
6	1356	\N	cmentarz przy kościele augustianów-eremitów w Warszawie	nazwa podstawowa	#NKDM3	295
4	1372	\N	kościół św. Marcina w Warszawie	nazwa podstawowa	#NKDM3	296
4	1356	1400	kościół św. Marcina w Warszawie/Starej Warszawie	nazwa podstawowa	#KZSP_SW	297
7	1400	1478	kościół św. Marcina w Starej Warszawie	nazwa podstawowa	#KZSP_SW	298
8	1494	1631	kościół św. Marcina w Starej Warszawie	nazwa podstawowa	#KZSP_SW	299
9	1631	1944	kościół św. Marcina w Starej Warszawie	nazwa podstawowa	#KZSP_SW	300
5	1356	1441	klasztor augustianów-eremitów w Warszawie/Starej Warszawie	nazwa podstawowa	#KZSP_SW	301
10	1441	1752	klasztor augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	302
11	1650	1864	kamienica stanowiąca część klasztoru augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	303
12	1650	1864	kuchnia przy klasztorze augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	304
13	1650	1864	stajnia przy klasztorze augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	305
14	1701	1864	nowicjat przy klasztorze augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	306
6	1483	\N	cmentarz przy kościele św. Marcina w Starej Warszawie	nazwa podstawowa	#Knapinski_1949	307
15	1483	\N	studnia na cmentarzu przy wejściu do kościoła św. Marcina	nazwa podstawowa	#Knapinski_1949	308
15	1780	1864	studnia przy kościele św. Marcina	nazwa oboczna	#KZSP_SW	309
13	1780	1864	stajnia przy klasztorze augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	310
16	1780	1864	wozownia przy klasztorze augustianów-eremitów w Starej Warszawie	nazwa podstawowa	#KZSP_SW	311
17	1339	1383	kościół św. Jerzego w Warszawie	nazwa podstawowa	#Kunkel_2006	312
17	1383	1453	kościół św. Jerzego w Warszawie kanoników regularnych w Czerwiński	nazwa oboczna	#Kunkel_2006	313
18	1453	1819	kościół św. Jerzego w Warszawie kanoników regularnych w Czerwiński	nazwa oboczna	#Kunkel_2006	314
19	1450	1818	klasztor kanoników regularnych z Czerwińska przy kościele św. Jerzego w Warszawie	nazwa podstawowa	#Kunkel_2006	315
47	1823	1897	dawny kościół św. Jerzego w Warszawie dzierżawiony przez fabrykę odlewów Braci Evans	nazwa oboczna	#Kunkel_2006	316
20	1643	\N	spichlerz zbożowy na Skaryszewie prawdopodobnie należący do Adama Kazanowskiego	nazwa podstawowa	#Jarzębski_1974	317
21	1892	1939	Miejskie Elewatory Zbożowe	nazwa podstawowa	#MiejskieElewatory	318
22	1499	1553	laterificium	nazwa oboczna	#Mrozowski_2020	319
23	1565	1566	platea ad porta civilem tendens alias do przysthawniei	nazwa oboczna	#Mrozowski_2020	320
23	1567	\N	via publica ad portum civilem	nazwa oboczna	#Mrozowski_2020	321
24	1522	1550	platea versus navigium	nazwa oboczna	#Mrozowski_2020	322
24	1567	\N	platea Przewozna	nazwa oboczna	#Mrozowski_2022	323
24	1566	\N	na ulicy do przewozu jadacz	nazwa oboczna	#Mrozowski_2023	324
24	1643	\N	przewóz	nazwa oboczna	#Jarzębski_1974	325
25	1823	2000	Rogatka Grochowska I	nazwa podstawowa	\N	326
26	1823	1961	Rogatka Grochowska II	nazwa podstawowa	\N	327
26	1961	2000	Rogatka Grochowska II	nazwa podstawowa	\N	328
25	1823	1915	Rogatka Moskiewska	nazwa oboczna	\N	329
26	1823	1915	Rogatka Moskiewska	nazwa oboczna	\N	330
27	1790	2000	Cmentarz Powązkowski	nazwa podstawowa	\N	331
27	1790	2000	Powązki	nazwa oboczna	\N	332
29	1900	1950	Gmach Towarzystwa Ubezpieczeń "Rossya"	nazwa podstawowa	#Księga_Pamiątkowa_TUR_1900	333
29	1950	2020	Dom "Pod Sedesami"	nazwa podstawowa	\N	334
30	1897	1939	Gmach Domu Mody "Bogusław Herse"	nazwa podstawowa	#Herbst_1949	335
31	1849	2000	Kościół p.w. św. Karola Boromeusza	nazwa podstawowa	#Kurier_1849	336
31	\N	2000	Kościół parafialny parafii św. Andrzeja	nazwa oboczna	#Wikipedia	337
32	1875	2000	Pałac Jakuba Janasza	nazwa podstawowa	#Kalendarz_1874,1876	338
32	1875	2000	Pałac Janaszów-Czackich	nazwa oboczna	#Wikipedia	339
33	1841	1964	Kamienica Jana Józefa Manzla przy ul. Chłodnej nr hip. 927B	nazwa podstawowa	#Bieniecki_1972	340
34	1908	1947	Hala hurtowa na placu Witkowskiego/Kazimierza Wielkiego	nazwa podstawowa	#Omilanowska_2004_a	341
35	1805	1944	Ogród handlowy Ulrichów, nr hip. 1117	nazwa podstawowa	#Majewski_2003_a	342
36	1893	2000	Kościół p.w. Wszystkich Świętych w Warszawie	nazwa podstawowa	#Gagatnicki_1893	343
37	1886	1944	Kościół p.w. św. Piotra i Pawła w Warszawie	nazwa podstawowa	#Przewodnik_1893_a	344
38	1877	1944	Gmach giełdy warszawskiej	nazwa podstawowa	#Marcinkowski_2013_a	345
39	1823	1877	Ujeżdżalnia przy ul. Królewskiej	nazwa podstawowa	#Marcinkowski_2013_a	346
40	1841	1939	Gościnny Dwór	nazwa podstawowa	#Omilanowska_2004_b	347
41	1902	2000	Hale Mirowskie	nazwa podstawowa	#Omilanowska_2004_c	348
42	1911	1954	Kamienica Bractwa Subiektów Handlowych, nr hip. 1414a	nazwa podstawowa	#Majewski_2003_b	349
43	1894	1944	Kamienica Braci Zambonich (neogotycka), nr hip. 1379	nazwa podstawowa	#Majewski_2003_c	350
44	1902	1915	Dworzec Kaliski	nazwa podstawowa	#Majewski_2003_d	351
45	1925	1944	Zajezdnia Praga	nazwa podstawowa	\N	352
46	1866	1918	Dworzec Terespolski	nazwa podstawowa	\N	353
46	1871	1918	Dworzec Brzeski	nazwa oboczna	\N	354
46	1918	1939	Dworzec Wschodni	nazwa podstawowa	\N	355
48	1888	1901	kościół praski w Warszawie	nazwa oboczna	#Madajczyk_2009	356
48	1888	1901	kościół św. Michała Archanioła i Floriana	nazwa podstawowa	#Madajczyk_2009	357
48	1888	1946	kościół św. Floriana na Pradze	nazwa oboczna	#Zbior_Korotyńskich_72/1001/0/5/24	358
51	1911	2000	Kamienica zboru luterańskiego, nr hip. 1066J (Kredytowa 4)	nazwa podstawowa	#Łupienko_2017	359
51	1911	2000	Kamienica dochodowa gminy Ewangelicko-Augsburskiej	nazwa oboczna	#Łupienko_2017	360
52	1912	1944	Dom parafialny zboru luterańskiego, nr hip. 1066J (Plac Ewangelicki)	nazwa podstawowa	#Łupienko_2017	361
53	1870	1936	Ogród pomologiczny, nr hip. 1600A	nazwa podstawowa	#Szwankowski_1970_a	362
54	1883	2000	Pałac Szlenkierów, nr hip. 5294	nazwa podstawowa	#Jaroszewski_1975	363
55	1818	1942	Rogatki jerozolimskie, nr hip. 1582F	nazwa podstawowa	#Szwankowski_1970_b	364
49	1897	\N	Rotunda "Golgoty"	nazwa oboczna	#Troczewski_1897	365
49	1897	1907	Gmach dawnej Panoramy	nazwa oboczna	#GmachDawnejPanoramy	366
59	1921	1939	dawny Teatr Artystów	nazwa oboczna	#GmachDawnejPanoramy	367
60	1896	1913	dawna Panorama	nazwa oboczna	#WarsztatySamochodoweDynasy	368
62	1938	1939	warsztat samochodowy	nazwa oboczna	#WarsztatySamochodoweDynasy	369
64	1904	\N	fabryka wyrobów betonowych	nazwa oboczna	#Słowo_184_1904	370
65	1901	1995	Stacja Warszawa Stalowa	nazwa podstawowa	\N	371
66	1923	2000	Bazylika Najświętszego Serca Jezusowego	nazwa podstawowa	\N	372
67	1926	1939	Szkoła powszechna przy Otwockiej 3	nazwa podstawowa	#Gmachy_1928	373
68	1894	1915	Katedralny Sobór św. Aleksandra Newskiego	nazwa podstawowa	#Sosna_KatSobor	374
69	1915	1918	kościół garnizonowy św. Henryka	nazwa podstawowa	#Sosna_KatSobor	375
70	1918	1926	Sobór św. Aleksandra Newskiego	nazwa podstawowa	#Sosna_KatSobor	376
71	1869	1917	Cesarski Uniwersytet Warszawski	nazwa podstawowa	#Schiller-Walicka_2016	377
73	1857	1862	Akademia Medyko-Chirurgiczna	nazwa podstawowa	#Szwarc_2016	378
72	1862	1869	Szkoła Główna w Warszawie	nazwa podstawowa	#Szwarc_2016	379
73	1857	1862	Cesarsko-Królewska Akademia Medyko-Chirurgiczna	nazwa oboczna	#Szwarc_2016	380
74	1861	1862	Kursy Przygotowawcze	nazwa podstawowa	#Szwarc_2016	381
75	1862	\N	Biblioteka Główna	nazwa podstawowa	#Szwarc_2016	382
76	1865	\N	Muzeum Starożytności	nazwa podstawowa	#Szwarc_2016	383
77	1388	1821	Szpital św. Ducha	nazwa podstawowa	\N	384
78	1350	1825	Brama nowomiejska	nazwa podstawowa	\N	385
79	1388	2000	Kościół św. Ducha	nazwa podstawowa	\N	386
80	1662	1807	Klasztor paulinów	nazwa podstawowa	\N	387
81	1408	2000	Ulica Nowomiejska	nazwa podstawowa	\N	388
82	1376	\N	Łaźnia	nazwa podstawowa	\N	389
83	1325	\N	Mury miejskie	nazwa podstawowa	\N	390
84	1450	\N	Mury miejskie	nazwa podstawowa	\N	391
85	1548	1818	Barbakan	nazwa podstawowa	\N	392
86	1300	1800	Dunaj	nazwa podstawowa	\N	393
86	1800	2000	Szeroki Dunaj	nazwa podstawowa	\N	394
87	1408	1552	Stara łaźnia	nazwa podstawowa	\N	395
87	1408	1552	Łaźnia wójtowska	nazwa oboczna	\N	396
88	1300	1800	Dunaj	nazwa podstawowa	\N	397
88	1300	1800	versus Dunay	nazwa podstawowa	\N	398
88	1300	1800	platea Iudeorum	nazwa podstawowa	\N	399
88	1800	2000	Wąski Dunaj	nazwa podstawowa	\N	400
89	1617	1804	Brama Poboczna	nazwa podstawowa	\N	401
90	1300	2000	Krzywe Koło	nazwa podstawowa	\N	402
90	1300	1600	Krzywa	nazwa oboczna	\N	403
89	1617	1804	Furta Nowa	nazwa oboczna	\N	404
89	1617	1804	Furta Boczna	nazwa oboczna	\N	405
91	1606	1944	Kościół św. Jacka	nazwa podstawowa	\N	406
92	1638	1864	Klasztor dominikański	nazwa podstawowa	\N	407
94	1825	2000	Kamienica Książąt Mazowieckich	nazwa oboczna	\N	408
95	1818	1944	"Piwnica Gdańska"	nazwa podstawowa	\N	409
96	1864	1944	Sierociniec dla chłopców	nazwa podstawowa	\N	410
97	1300	2000	Freta	nazwa podstawowa	\N	411
98	1408	1791	Freta Nowomiejskie	nazwa podstawowa	\N	412
100	1408	1791	Nowa Warszawa	nazwa podstawowa	\N	413
100	1408	1791	Warszawa Nowa	nazwa oboczna	\N	414
100	1408	1791	Nowe Miasto Warszawa	nazwa oboczna	\N	415
102	1408	1793	circulus	nazwa podstawowa	\N	416
102	1408	2000	rynek	nazwa podstawowa	\N	417
102	1408	2000	Rynek Nowego Miasta	nazwa podstawowa	\N	418
102	1408	2000	rynek nowomiejski	nazwa oboczna	\N	419
103	1913	1944	Hala Świętojerska	nazwa podstawowa	\N	420
104	1350	1791	Jurydyka Świętojerska	nazwa podstawowa	\N	421
105	1600	1791	Parysów	nazwa oboczna	\N	422
105	1600	1791	Jurydyka Parysowska	nazwa podstawowa	\N	423
106	1600	1943	Plac Parysowski	nazwa podstawowa	\N	424
107	1638	1791	Jurydyka Zadzikowska	nazwa podstawowa	\N	425
107	1638	1791	Kapitulna	nazwa oboczna	\N	426
108	1638	2000	Kapitulna	nazwa podstawowa	\N	427
108	1638	1700	Szpadnia	nazwa oboczna	\N	428
109	1643	2000	Arsenał	nazwa podstawowa	\N	429
110	1615	1807	Klasztor brygidek	nazwa podstawowa	\N	430
111	1903	1944	Pasaż Simmonsa	nazwa podstawowa	\N	431
113	1615	1807	Kościół Św. Trójcy	nazwa podstawowa	\N	432
114	1880	1900	Dworzec Nadwiślański	nazwa oboczna	#Marcinkowski_2013_b	433
114	1880	1900	Główny Dworzec Kolei Nadwiślańskiej	nazwa podstawowa	#Warszawikia	434
114	1900	1915	Dworzec Kowelski	nazwa podstawowa	#Warszawa1939	435
114	1915	2000	Dworzec Gdański	nazwa podstawowa	#Wikipedia	436
115	1824	1945	Plac Broni	nazwa podstawowa	#Wikipedia	437
116	1906	1950	Dom firmy Gebethner i Wolff, nr hip. 6391	nazwa podstawowa	#Jaroszewski_1996	438
116	1906	1950	Dom księgarni nakładowej "Gebethner i Wolff" w Warszawie	nazwa oboczna	#Przegląd_Techniczny_1907	439
117	1916	2000	Kamienica Goldstanda, nr hip. 1066C	nazwa podstawowa	#Jaroszewski_1996	440
118	1870	1944	Zakłady metalurgiczne Hantkego, nr hip. 1147K	nazwa podstawowa	#Markiewicz_et_al_2012	441
119	1867	1890	Browar Hermana Junga, nr hip. 849	nazwa podstawowa	#Sobieszczański_1967	442
119	1784	1850	Browar i kamienica Winklera, nr hip. 849	nazwa podstawowa	#Sobieszczański_1967	443
119	1850	1867	Browar i kamienica Aleksandra Łęckiego, nr hip. 849	nazwa podstawowa	#Sobieszczański_1967	444
120	1818	1942	Rogatki wolskie	nazwa podstawowa	#Szwankowski_1970_c	445
121	1683	1775	Łaźnia	nazwa podstawowa	\N	446
122	1775	2000	Pałac na Wyspie	nazwa podstawowa	\N	447
122	1775	2000	Pałac na Wodzie	nazwa oboczna	\N	448
123	1846	1919	Cerkiew św. Aleksandra Newskiego	nazwa podstawowa	\N	449
\.


--
-- Data for Name: topographic_object_provenances; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_provenances (ancestor_identifiers, predecessor_identifiers, historical_sources, identifiers) FROM stdin;
1	1	#Garbacz_2021	16
4	7	#KZSP_SW	17
7	8	#KZSP_SW	18
8	9	#KZSP_SW	19
5	10	#KZSP_SW	20
17	18	#Kunkel_2006	21
39	38	#Marcinkowski_2013_a	22
18	47	#Kunkel_2006	23
49	56	#GmachDawnejPanoramy	24
56	57	#GmachDawnejPanoramy	25
57	58	#GmachDawnejPanoramy	26
58	59	#GmachDawnejPanoramy	27
60	61	#WarsztatySamochodoweDynasy	28
61	62	#WarsztatySamochodoweDynasy	29
62	63	\N	30
68	69	#Sosna_KatSobor	31
69	70	#Sosna_KatSobor	32
73	72	#Szwarc_2016	33
74	72	#Szwarc_2016	34
72	71	#Schiller-Walicka_2016	35
96	93	\N	36
121	122	\N	37
123	124	\N	38
\.


--
-- Data for Name: topographic_object_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_sources (identifiers, default_names) FROM stdin;
1	Baszta Biała
2	kaplica św. Małgorzaty
3	zespół klasztorny augustianów-eremitów w Starej Warszawie
4	kościół św. Marcina w Warszawie/Starej Warszawie
5	klasztor augustianów-eremitów w Warszawie/Starej Warszawie
6	cmentarz przy kościele św. Marcina w Starej Warszawie
7	kościół św. Marcina w Starej Warszawie
8	kościół św. Marcina w Starej Warszawie
9	kościół św. Marcina w Starej Warszawie
10	klasztor augustianów-eremitów w Starej Warszawie
11	kamienica stanowiąca część klasztoru augustianów-eremitów w Starej Warszawie
12	kuchnia przy klasztorze augustianów-eremitów w Starej Warszawie
13	stajnia przy klasztorze augustianów-eremitów w Starej Warszawie
14	nowicjat przy klasztorze augustianów-eremitów w Starej Warszawie
15	studnia na cmentarzu przy wejściu do kościoła św. Marcina
16	wozownia przy klasztorze augustianów-eremitów w Starej Warszawie
17	kościół św. Jerzego w Warszawie
18	kościół św. Jerzego w Warszawie
19	klasztor kanoników regularnych z Czerwińska przy kościele św. Jerzego w Warszawie
20	spichlerz zbożowy na Skaryszewie prawdopodobnie należący do Adama Kazanowskiego
21	Miejskie elewatory zbożowe
22	cegielnia miejska Starej Warszawy
23	przystań miejska Starej Warszawy
24	przeprawa łodziami w Starej Warszawie
25	Rogatka Grochowska I
26	Rogatka Grochowska II
27	Cmentarz Powązkowski
28	Furta koło Baszty Białej
29	Gmach Towarzystwa Ubezpieczeń "Rossya"
30	Gmach Domu Mody "Bogusław Herse"
31	Kościół p.w. św. Karola Boromeusza
32	Pałac Jakuba Janasza
33	Kamienica Jana Józefa Manzla przy ul. Chłodnej nr hip. 927B
34	Hala hurtowa na placu Witkowskiego/Kazimierza Wielkiego
35	Ogród handlowy Ulrichów, nr hip. 1117
36	Kościół p.w. Wszystkich Świętych w Warszawie
37	Kościół p.w. św. Piotra i Pawła w Warszawie
38	Gmach giełdy warszawskiej
39	Ujeżdżalnia przy ul. Królewskiej
40	Gościnny Dwór
41	Hale Mirowskie
42	Kamienica Bractwa Subiektów Handlowych, nr hip. 1414a
43	Kamienica Braci Zambonich (neogotycka), nr hip. 1379
44	Dworzec Kaliski
45	Zajezdnia tramwajowa na Pradze
46	Dworzec Terespolski
47	dawny kościół św. Jerzego w Warszawie
48	kościół św. Michała Archanioła i Floriana
49	Rotunda przy Karowej
50	Mokotowska
51	Kamienica zboru luterańskiego, nr hip. 1066J (Kredytowa 4)
52	Dom parafialny zboru luterańskiego, nr hip. 1066J (Plac Ewangelicki)
53	Ogród pomologiczny, nr hip. 1600A
54	Pałac Szlenkierów, nr hip. 5294
55	Rogatki jerozolimskie, nr hip. 1582F
56	Rotunda przy Karowej
57	Rotunda przy Karowej
58	Rotunda przy Karowej
59	Rotunda przy Karowej
60	Rotunda na Dynasach
61	Rotunda na Dynasach
62	Rotunda na Dynasach
63	Rotunda na Dynasach
64	Miejska Fabryka Betonu
65	Stacja Warszawa Stalowa
66	Bazylika na Kawęczyńskiej
67	Szkoła (ul. Otwocka)
68	Katedralny Sobór św. Aleksandra Newskiego
69	kościół garnizonowy św. Henryka dwóch konfesji (rzymskokatolicki i ewangelicki)
70	dawny Katedralny Sobór św. Aleksandra Newskiego
71	Cesarski Uniwersytet Warszawski
72	Szkoła Główna
73	Akademia Medyko-Chirurgiczna w Warszawie
74	Kursy Przygotowawcze w Instytucie Szlacheckim
75	Biblioteka Główna
76	Muzeum Starożytności
77	Szpital św. Ducha
78	Brama Nowomiejska
79	Kościół św. Ducha
80	Klasztor paulinów
81	Ulica Nowomiejska
82	Łaźnia przy Bramie Nowomiejskiej
83	Pierwsza linia murów miejskich
84	Druga linia murów miejskich
85	Barbakan
86	Szeroki Dunaj
87	Łaźnia wójtowska
88	Wąski Dunaj
89	Brama Poboczna
90	Krzywe Koło
91	Kościół św. Jacka
92	Klasztor dominikanów
93	Zespół klasztorny dominikanów
94	Kamienica "Pod świętą Anną"
95	"Piwnica Gdańska"
96	Sierociniec dla chłopców Warszawskiego Towarzystwa Dobroczynnego
97	Freta
98	Freta Nowomiejskie
99	Północne przedmieście Starej Warszawy
100	Nowa Warszawa
101	Ulica tylna za południową pierzeją rynku Nowego Miasta
102	Rynek Nowego Miasta
103	Hala Świętojerska
104	Jurydyka Świętojerska
105	Jurydyka Parysowska
106	Plac Parysowski
107	Jurydyka Zadzikowska
108	Ulica Kapitulna
109	Arsenał Królewski w Warszawie
110	Zespół klasztorny brygidek
111	Pasaż Simmonsa
112	Klasztor brygidek
113	Kościół Św. Trójcy
114	Dworzec Gdański
115	Plac Broni
116	Dom firmy Gebethner i Wolff, nr hip. 6391
117	Kamienica Goldstanda, nr hip. 1066C
118	Zakłady metalurgiczne Hantkego, nr hip. 1147K
119	Browar Hermana Junga, nr hip. 849
120	Rogatki wolskie
121	Pawilon Łaźni
122	Pałac na Wodzie
123	cerkiew św. Aleksandra Newskiego
124	kaplica w skrzydle Pałacu na Wodzie
\.


--
-- Data for Name: topographic_object_type_manifestation_sources; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_object_type_manifestation_sources (topographic_object_identifiers, starts_at, ends_at, types, historical_sources, identifiers) FROM stdin;
1	1379	1560	baszta	#Garbacz_2021	94
2	1526	1839	budynek gospodarczy	#Kunkel_1989	95
3	1356	1864	zespół sakralny lub klasztorny	#KZSP_SW	96
5	1356	1441	klasztor	#KZSP_SW	97
6	1356	\N	cmentarz	#KZSP_SW	98
10	1441	1864	klasztor	#KZSP_SW	99
11	1650	1864	klasztor	#KZSP_SW	100
12	1650	1864	budynek gospodarczy	#KZSP_SW	101
13	1650	1864	stajnia	#KZSP_SW	102
14	1701	1864	dom zakonny	#KZSP_SW	103
16	1780	1864	parking	#KZSP_SW	104
47	1819	1897	fabryka	#Kunkel_2006	105
19	1450	1818	klasztor	#Kunkel_2006	106
20	1643	\N	elewator	#Jarzębski_1974	107
21	1892	1939	elewator	#MiejskieElewatory	108
23	1565	1569	port wodny	#Mrozowski_2020	109
24	1522	1569	przeprawa łodziami	#Mrozowski_2020	110
24	1643	\N	przeprawa łodziami	#Jarzębski_1974	111
25	1823	1916	rogatka	\N	112
26	1823	1916	rogatka	\N	113
27	1790	2000	cmentarz	\N	114
34	1908	1942	hala targowa	#Omilanowska_2004_a	115
35	1805	1944	ogród	#Majewski_2003_a	116
40	1841	1939	hala targowa	#Omilanowska_2004_b	117
41	1902	2000	hala targowa	#Omilanowska_2004_c	118
45	1925	1944	zajezdnia tramwajowa	\N	119
46	1866	1939	dworzec kolejowy	\N	120
50	1770	2000	ulica	\N	121
53	1870	1936	park	#Szwankowski_1970_a	122
55	1818	1942	rogatka	#Szwankowski_1970_b	123
49	1897	1907	galeria sztuki	#GmachDawnejPanoramy	124
56	1907	1910	teatr	#GmachDawnejPanoramy	125
57	1910	1913	hala sportowa	#GmachDawnejPanoramy	126
58	1913	1921	kino	#GmachDawnejPanoramy	127
59	1921	1939	teatr	#GmachDawnejPanoramy	128
60	1896	1913	galeria sztuki	#WarsztatySamochodoweDynasy	129
61	1913	1938	teatr	#WarsztatySamochodoweDynasy	130
62	1938	1939	warsztat	#WarsztatySamochodoweDynasy	131
63	1939	2000	ruina zabytkowa	\N	132
64	1904	\N	fabryka	#Słowo_184_1904	133
67	1926	2000	szkoła	#Gmachy_1928	134
68	1894	1915	cerkiew	#Sosna_KatSobor	135
71	1869	1917	szkoła wyższa kompleks	#Schiller-Walicka_2016	136
73	1857	1862	szkoła wyższa budynek	#Szwarc_2016	137
72	1862	1869	szkoła wyższa kompleks	#Szwarc_2016	138
74	1861	1862	szkoła XIX wieku	#Szwarc_2016	139
75	1862	1894	biblioteka	#Szwarc_2016	140
76	1865	\N	muzeum	#Szwarc_2016	141
77	1388	1821	szpital przednowoczesny	\N	142
78	1350	1825	brama miejska	\N	143
80	1662	1807	klasztor	\N	144
80	1807	1815	zabudowania koszarowe	\N	145
80	1815	1819	klasztor	\N	146
81	1300	2000	ulica	\N	147
83	1325	\N	mury miejskie	\N	148
84	1450	\N	mury miejskie	\N	149
85	1548	1818	barbakan	\N	150
86	1300	\N	ulica	\N	151
88	1300	2000	ulica	\N	152
89	1617	1804	brama miejska	\N	153
90	1300	2000	ulica	\N	154
92	1638	1864	klasztor	\N	155
93	1606	2000	zespół sakralny lub klasztorny	\N	156
97	1300	1408	ulica	\N	157
98	1408	1791	ulica	\N	158
97	1408	1791	ulica	\N	159
97	1791	2000	ulica	\N	160
101	1408	1650	ulica	\N	161
102	1408	2000	rynek	\N	162
103	1913	1944	hala targowa	\N	163
104	1350	1791	jurydyka	\N	164
105	1600	1791	jurydyka	\N	165
106	1600	1943	plac	\N	166
107	1638	1791	jurydyka	\N	167
108	1638	2000	ulica	\N	168
109	1643	1832	arsenał	\N	169
109	1938	1945	archiwum	\N	170
110	1615	1807	zespół sakralny lub klasztorny	\N	171
110	1807	1892	zabudowania koszarowe	\N	172
111	1903	1944	hala targowa	\N	173
112	1615	1807	klasztor	\N	174
112	1807	1892	zabudowania koszarowe	\N	175
114	1880	1915	dworzec kolejowy	#Marcinkowski_2013_b	176
115	1824	1945	plac	#Wikipedia	177
118	1870	1944	fabryka	#Markiewicz_et_al_2012	178
119	1784	1944	manufaktura	#Sobieszczański_1967	179
119	1784	1944	fabryka	#Sobieszczański_1967	180
120	1818	1942	rogatka	#Szwankowski_1970_c	181
122	1775	1795	pałac	\N	182
123	1846	1919	cerkiew	\N	183
124	1919	1947	kaplica wolnostojąca	\N	184
\.


--
-- Data for Name: topographic_types; Type: TABLE DATA; Schema: ontology_sources; Owner: postgres
--

COPY ontology_sources.topographic_types (identifiers, iris, names) FROM stdin;
1	http://purl.org/urbanonto/object_type_69b23a38-e994-4b30-bf29-a685aeef3154	altana
2	http://purl.org/urbanonto/object_type_d0b5eb87-17c1-45ef-9bcd-b39adb85cba0	ambulatorium
3	http://purl.org/urbanonto/object_type_b25af316-d50a-4761-832c-6d967f745b9e	archiwum
4	http://purl.org/urbanonto/object_type_1825216a-68dd-4ae7-b53c-4736713f7f45	areszt śledczy
5	http://purl.org/urbanonto/object_type_3e00cb4c-a6c0-4394-b5b4-4ff577a15376	arsenał
6	http://purl.org/urbanonto/object_type_05373902-6260-4373-96f9-685cee4f414a	bagno
7	http://purl.org/urbanonto/object_type_ec9130a7-541f-4128-a892-c9bd391811f6	bank
8	http://purl.org/urbanonto/object_type_db09afe5-a9f2-4ad4-82ca-143b0f26f525	barbakan
9	http://purl.org/urbanonto/object_type_3b34975a-f1cb-4b37-ae68-74f0052adad2	basen
10	http://purl.org/urbanonto/object_type_ef25d27e-e146-48ad-bd4b-8454ae28bb25	bastion
11	http://purl.org/urbanonto/object_type_1b9fe3b6-652b-4397-8f0c-998b585e4e87	baszta
12	http://purl.org/urbanonto/object_type_65810a6e-2526-4cc8-9a2d-c733569c228a	baza eksploatacyjna
13	http://purl.org/urbanonto/object_type_b4a41d80-d378-4adb-becb-8a7fab1d46b0	biblioteka
14	http://purl.org/urbanonto/object_type_8862f8fa-fe60-4649-bcf8-45c98fdd9e1f	blok zabudowy
15	http://purl.org/urbanonto/object_type_5e55b798-5e07-470b-bab7-b84e718a5baa	boisko
16	http://purl.org/urbanonto/object_type_51b2b48a-fbcc-4adf-a0a9-fd90c2066bd7	brama
17	http://purl.org/urbanonto/object_type_7f9933d6-facf-498a-8cab-b21a4eb4aae4	brama miejska
18	http://purl.org/urbanonto/object_type_8c55d74c-fac9-4cd5-bb7f-bb01064e9a4d	bród
19	http://purl.org/urbanonto/object_type_8bff2978-7a4b-49d3-b94d-a393ad30f914	budynek gospodarczy
20	http://purl.org/urbanonto/object_type_36983569-cabe-4309-8f18-107316903411	budynek ogrodu zoologicznego lub botanicznego
21	http://purl.org/urbanonto/object_type_48187b44-8d1c-4cb0-98f5-eeb6a0a68ecb	budynek produkcyjny zwierząt hodowlanych
22	http://purl.org/urbanonto/object_type_f28683d3-bb10-4e88-8284-21a49e02b67b	bursa szkolna
23	http://purl.org/urbanonto/object_type_e63f65ef-61a0-4602-be34-90e52a067c70	cerkiew
24	http://purl.org/urbanonto/object_type_aff2095e-7ba5-4ce5-be60-1e408f4b80d7	cmentarz
25	http://purl.org/urbanonto/object_type_32815407-9ac8-488f-8414-cccae56e9913	cytadela
26	http://purl.org/urbanonto/object_type_cdc73205-dd22-4341-a13a-b358492ff9ce	dok
27	http://purl.org/urbanonto/object_type_d871b6fe-5868-42e7-aa78-e07a766a5044	dom dla bezdomnych
28	http://purl.org/urbanonto/object_type_0c9034c3-77a1-47d9-9067-a0e080ecfa43	dom dziecka
29	http://purl.org/urbanonto/object_type_f92d1dbd-7de9-47e9-8bf9-b78f27363604	dom jednoizbowy
30	http://purl.org/urbanonto/object_type_f73326e1-216a-4bc9-8894-cbbd00112e1d	dom jednorodzinny
31	http://purl.org/urbanonto/object_type_8b3ac720-b349-4d3b-92c4-48527594d39b	dom opieki spolecznej
32	http://purl.org/urbanonto/object_type_884f8bff-26cc-47df-9361-d27da38cd102	dom parafialny
33	http://purl.org/urbanonto/object_type_2429ab72-0013-4f2a-ac34-0a9c363c42e7	dom pogrzebowy
34	http://purl.org/urbanonto/object_type_7e689c7a-2810-4911-916f-b57dfb26ad53	dom publiczny
35	http://purl.org/urbanonto/object_type_8ee8e450-074b-4c22-a215-77cc9fa4b6ea	dom studencki
36	http://purl.org/urbanonto/object_type_6a76d684-39d1-4d14-92cd-ce80a9ef063a	dom towarowy lub handlowy
37	http://purl.org/urbanonto/object_type_c95a340c-2e28-4ca9-8f13-5349a1b4c46b	dom zakonny
38	http://purl.org/urbanonto/object_type_eabbcd66-5bb1-40c7-9e76-11ca4baa799d	droga wodna
39	http://purl.org/urbanonto/object_type_b08cee61-c162-4cb8-98fd-03a0508ab11e	dworzec kolejowy
40	http://purl.org/urbanonto/object_type_11f78853-134a-45d0-8090-efd8f28965bf	działka
41	http://purl.org/urbanonto/object_type_18e149fe-1b19-452d-b230-781dcdee378b	działka miejska
42	http://purl.org/urbanonto/object_type_92391a0e-941b-42e1-a499-ce45065592c1	dzwonnica
43	http://purl.org/urbanonto/object_type_d9ebb9bd-da35-41e7-8bd6-eebf4ed49e02	dźwig
44	http://purl.org/urbanonto/object_type_f7c6e7fe-157b-4fbd-88ca-dbb5cff42b2b	elektrownia
45	http://purl.org/urbanonto/object_type_41963db6-b35f-4aaa-8040-a059b388900f	elewator
46	http://purl.org/urbanonto/object_type_5083acfb-3f36-4587-83d3-6c27f1412381	esplanada forteczna
47	http://purl.org/urbanonto/object_type_ee09c17f-1029-40e9-a2ef-f8989ee51ed1	estakada
48	http://purl.org/urbanonto/object_type_824432d0-3ccc-46df-81ec-7b54d0509262	fabryka
49	http://purl.org/urbanonto/object_type_0f482fa3-04a0-423b-ab1f-4cdfad888b52	falochron
50	http://purl.org/urbanonto/object_type_f18f587f-e4d9-42cb-aca6-363a3a58738b	filharmonia
51	http://purl.org/urbanonto/object_type_4b2f4d68-7662-4205-bfc8-66c1fc921819	fontanna wolnostojąca
52	http://purl.org/urbanonto/object_type_6e66c5e3-4652-4ccf-a626-492169a1122b	forteca
53	http://purl.org/urbanonto/object_type_b4293a32-e17d-4159-bbe7-117f71ab946c	fosa
54	http://purl.org/urbanonto/object_type_81d08218-f988-46ba-a0b1-924cbb26abb5	furta
55	http://purl.org/urbanonto/object_type_7da67352-7841-46a2-9be0-663de41b9198	furta miejska
56	http://purl.org/urbanonto/object_type_b9b7e14a-8aa7-4b36-8622-e3928471bda3	galeria sztuki
57	http://purl.org/urbanonto/object_type_d873fdcf-acfb-4c52-9d84-e8fc55b0dfbc	garbary
58	http://purl.org/urbanonto/object_type_6d39053a-c3f0-47a3-96d2-2cf7f0a4742d	gmina kupiecka
59	http://purl.org/urbanonto/object_type_b86f5c8e-6c96-45cc-9e16-0ad58bc97a37	gospodarstwo hodowlane
60	http://purl.org/urbanonto/object_type_331f9036-04b2-4125-bd35-adb38e5f073b	grób
61	http://purl.org/urbanonto/object_type_ff500912-4b0f-41b3-a2cd-9a3d164c8620	hala sportowa
62	http://purl.org/urbanonto/object_type_c33318ac-c375-4821-a0c1-af7a63cd8ffb	hala targowa
63	http://purl.org/urbanonto/object_type_5b9cd873-3972-4aa9-9e76-51e6dab898bf	hala widowiskowa
64	http://purl.org/urbanonto/object_type_897b9a9c-459f-4199-911e-2f25d56c9514	hala wystawowa
65	http://purl.org/urbanonto/object_type_f5804075-2f0d-46b3-a25e-c92739d33920	hotel
66	http://purl.org/urbanonto/object_type_ee995979-23be-4441-9c9c-40382dc12698	hotel robotniczy
67	http://purl.org/urbanonto/object_type_8f04af49-8661-4738-9aa1-452f068525db	internat
68	http://purl.org/urbanonto/object_type_74c7a3cf-61fb-43b5-8d9a-5d7a1c4afca6	jatki
69	http://purl.org/urbanonto/object_type_a9d9bb77-753f-44f2-a5d8-51a50eb3300e	jaz
70	http://purl.org/urbanonto/object_type_290ba842-d297-43b3-8df2-12a4c0f2fcdd	jaz ruchomy lub zastawka piętrząca
71	http://purl.org/urbanonto/object_type_0616e71f-f911-4b5b-8ddf-8e076b5e2ec2	jezioro
72	http://purl.org/urbanonto/object_type_a1b65f34-6349-4f88-8f33-2a0441e46203	jurydyka
73	http://purl.org/urbanonto/object_type_7a898e45-2e35-487c-9629-89e6789d5055	kamień graniczny
74	http://purl.org/urbanonto/object_type_0233a2a4-5a1d-442c-b59d-0728dd0981b0	kamień milowy
75	http://purl.org/urbanonto/object_type_99c5ed94-8a14-485c-8b18-542786dd08b1	kanał
76	http://purl.org/urbanonto/object_type_93d03b33-4643-46c0-916c-e5b9af97e7ae	kaplica wolnostojąca
77	http://purl.org/urbanonto/object_type_697a8778-030b-4d2e-9b4c-27041e61661c	kapliczka
78	http://purl.org/urbanonto/object_type_58008b80-aa5a-4cb2-bab0-0af4921f5ff7	kasyno
79	http://purl.org/urbanonto/object_type_963423b9-952e-42ea-9937-8399bec3d890	kino
80	http://purl.org/urbanonto/object_type_23aeb250-4d72-42b1-b9a0-3e387f676563	klasztor
81	http://purl.org/urbanonto/object_type_f4bb30da-bd08-477d-bae8-8b36f22d38be	kompleks szkolny
82	http://purl.org/urbanonto/object_type_201bdb3b-da22-43c4-9490-2b43e3fb136c	kram
83	http://purl.org/urbanonto/object_type_ddf57aca-9884-4d25-b1b1-d3a6efb64074	krematorium
84	http://purl.org/urbanonto/object_type_71b46985-b115-496b-a175-fc55a0ac5175	krzyż przydrożny
85	http://purl.org/urbanonto/object_type_bbab1b1a-ec1a-405d-a0a9-f540e368a7a6	kwartał podatkowy
86	http://purl.org/urbanonto/object_type_8b69df44-0b5c-4287-be30-8b7e1c8c8918	kładka
87	http://purl.org/urbanonto/object_type_7dfd403b-e0e1-4ea2-bb4a-3bb91c04ac57	leprozorium
88	http://purl.org/urbanonto/object_type_3ab8e3ca-5ab2-4134-83de-661777db85b1	linia metra
89	http://purl.org/urbanonto/object_type_83ae40c8-4d52-40e1-a11e-82a1a94ac610	magazyn
90	http://purl.org/urbanonto/object_type_a0c1f8ff-4e16-4bd2-8816-3e5e7d5f9cb4	manufaktura
91	http://purl.org/urbanonto/object_type_a2025e3d-976a-4c3d-95e3-e74184efd88f	meczet
92	http://purl.org/urbanonto/object_type_34ed19dc-7a2b-4742-afe3-cbd800c865af	miejsce poboru opłat
93	http://purl.org/urbanonto/object_type_d2dd4918-bb62-4dfc-9a4c-c7054718a419	miejsce straceń
94	http://purl.org/urbanonto/object_type_df3e96d3-6c4d-49f8-8e04-67dcbf9c9b34	molo
95	http://purl.org/urbanonto/object_type_d2b7a392-1cab-49e6-a022-2297d55c23bb	most
96	http://purl.org/urbanonto/object_type_fa60ddfe-78ff-45fd-ba24-51010f9236b6	mury miejskie
97	http://purl.org/urbanonto/object_type_4d5b12d9-19b6-4397-891e-c476ea81b139	muzeum
98	http://purl.org/urbanonto/object_type_c792cd5f-83ca-4582-b0e3-10fdffcf95ab	młyn
99	http://purl.org/urbanonto/object_type_df211709-40b8-4feb-a6ac-1993ac18842f	nasyp
100	http://purl.org/urbanonto/object_type_b2c135a0-216c-4270-84a9-98552c4398c0	obiekt o znaczeniu historycznym
101	http://purl.org/urbanonto/object_type_cc2c53be-6de4-4094-ada0-b64ef0ae5290	obserwatorium
102	http://purl.org/urbanonto/object_type_77ce613a-c3b3-4727-8bc1-75df777e5ff4	oczyszczalnia ścieków
103	http://purl.org/urbanonto/object_type_1ac81bf3-defc-4dd0-ab89-38cc0635eeac	oficyna
104	http://purl.org/urbanonto/object_type_b43c3dec-2187-4ca3-9b5f-85accf59ac5b	ogród
105	http://purl.org/urbanonto/object_type_6076fcc5-3de4-4034-95e7-b582bb684634	opactwo
106	http://purl.org/urbanonto/object_type_5d4c1dcf-d7d4-441c-a931-7503ae4b43eb	opera
107	http://purl.org/urbanonto/object_type_1466742f-15b9-4426-8ab8-f21c4b304d4f	ostroga
108	http://purl.org/urbanonto/object_type_ed6625b1-dbe2-4e50-9792-abb26dde60bf	otulina wokół miasta
109	http://purl.org/urbanonto/object_type_ab6e4665-8e6e-4e88-8198-413da99e6341	palatium
110	http://purl.org/urbanonto/object_type_cace123e-7364-43b7-b756-eebe60ac4c0f	parcela
111	http://purl.org/urbanonto/object_type_ebb07674-ca92-49a0-9da3-90f840122383	park
112	http://purl.org/urbanonto/object_type_ce2166ef-bf8f-48f3-953a-cd110d8fb7ce	parking
113	http://purl.org/urbanonto/object_type_ff051b75-7b62-44d6-aa04-2c97fa75662f	pawilon
114	http://purl.org/urbanonto/object_type_d67cf313-5537-45e2-ae74-7b4ba44e3078	pałac
115	http://purl.org/urbanonto/object_type_d61883a4-c2f9-4b56-b243-b62de3abef82	pensjonat
116	http://purl.org/urbanonto/object_type_f0ada8e8-043a-487f-bcd8-b6f393161e08	peron
117	http://purl.org/urbanonto/object_type_704aafb3-2bce-4597-8258-62ba38c9a1a1	pierzeja
118	http://purl.org/urbanonto/object_type_93c8cca0-8c87-414b-839a-992f2a538da1	plac
119	http://purl.org/urbanonto/object_type_60a698e6-6a31-4bdd-bf9c-1aaa277d8f33	plac zabaw
120	http://purl.org/urbanonto/object_type_67c791d9-5864-4b3b-89e5-ee80389ab761	placówka badawcza
121	http://purl.org/urbanonto/object_type_fd7ae0ff-63fb-459a-b535-58a428511747	planty
122	http://purl.org/urbanonto/object_type_5dfec8a3-84f9-4aac-b687-1cbd030f4dbb	podgrodzie
123	http://purl.org/urbanonto/object_type_488f8944-e0bd-47dd-8230-610fdc15d49d	poligon wojskowy
124	http://purl.org/urbanonto/object_type_1a276b47-16bd-4b07-a642-e76acabe34d9	pomnik
125	http://purl.org/urbanonto/object_type_b1c02f41-b3f1-40e9-9793-c730b56cf7f3	pomost albo molo
126	http://purl.org/urbanonto/object_type_046dbc93-7f3a-4da6-a37b-2eef43c9071b	port wodny
127	http://purl.org/urbanonto/object_type_fa269f67-4b0c-42c9-b9ef-d719a5a3957f	posesja
128	http://purl.org/urbanonto/object_type_55033dcd-e6fe-443f-b615-1ea420555c92	przedszkole
129	http://purl.org/urbanonto/object_type_0d1690ae-e388-41d4-aff2-31bf937cc373	przejście podziemne
130	http://purl.org/urbanonto/object_type_632d5c8c-f305-4cbe-996d-ad321c2b09ec	przeprawa promowa
131	http://purl.org/urbanonto/object_type_a333898b-73f1-4ba7-8078-e34e35019f60	przeprawa łodziami
132	http://purl.org/urbanonto/object_type_d2abb593-b436-4f8e-963d-333e470aad7c	przewód gazowy
133	http://purl.org/urbanonto/object_type_74eff5a9-f958-4033-a6d0-e4fb63ce33a8	przewód kanalizacyjny
134	http://purl.org/urbanonto/object_type_eca60c6f-b783-450a-9404-ee82f5710573	przewód wodociągowy
135	http://purl.org/urbanonto/object_type_1441eb43-4105-4f33-813c-31f459a2528b	przytułek
136	http://purl.org/urbanonto/object_type_b8354224-3b8c-41cb-9b2b-855bea6a0e5c	pręgierz
137	http://purl.org/urbanonto/object_type_4bd6e285-753f-459e-9b5b-1a1657291685	rakarnia
138	http://purl.org/urbanonto/object_type_31b9b0e9-68bc-46c0-bb6c-6ba3f85f10c3	restauracja
139	http://purl.org/urbanonto/object_type_c11cb20d-1a61-4312-a780-c45fa09951a0	rezydencja ambasadora
140	http://purl.org/urbanonto/object_type_59e9a63d-a1e6-43ef-bfcf-ed895159b97a	rezydencja biskupia
141	http://purl.org/urbanonto/object_type_94baa37c-07ed-4159-8e62-0bd69515a313	rezydencja prezydencka
142	http://purl.org/urbanonto/object_type_5f621828-99bb-4747-99d6-6242dcb669fb	rogatka
143	http://purl.org/urbanonto/object_type_00dde5ae-0004-499f-bccd-251870d4006c	rozmierzenie lokacyjne
144	http://purl.org/urbanonto/object_type_e73317ef-21fc-441c-919a-925844d2950d	rozszerzenie miasta
145	http://purl.org/urbanonto/object_type_8d82a136-413f-453c-a096-2b6a2ffaa32b	ruina zabytkowa
146	http://purl.org/urbanonto/object_type_16c35144-0a87-4e5f-9235-741e90a76bc5	rynek
147	http://purl.org/urbanonto/object_type_5ec5f208-d56f-421c-9e83-93776dd0119e	rzeka
148	http://purl.org/urbanonto/object_type_c14f0fef-4ea1-4713-865e-9b1d99c5a6de	sala gimnastyczna
149	http://purl.org/urbanonto/object_type_30fc0b77-30ec-4697-9e8d-1f2cf40eef50	schody
150	http://purl.org/urbanonto/object_type_a6144c18-5df4-4be9-9b8e-4e2f55159265	sieć kolejowa
151	http://purl.org/urbanonto/object_type_0f4926a1-a1ee-44b9-a09b-03c0bc396802	silos
152	http://purl.org/urbanonto/object_type_8ca9ab1b-c79c-4bb9-b500-4da2bf350312	skarb
153	http://purl.org/urbanonto/object_type_1315a9b9-2fe9-4668-8b4c-311dbbb54c97	stacja meteorologiczna
154	http://purl.org/urbanonto/object_type_7d38c51a-72e0-43b0-a380-222a72f32d49	stacja metra
155	http://purl.org/urbanonto/object_type_bf299d66-61ed-4b3b-9340-811737a1dbf6	stacja paliw
156	http://purl.org/urbanonto/object_type_e676bd90-924a-4cc4-ae60-f1e14458b793	stacja pomp
157	http://purl.org/urbanonto/object_type_3fbc4842-0936-4ea2-b89d-299a7cda71ad	stadion
158	http://purl.org/urbanonto/object_type_4b313ab4-5059-46a7-b62e-000c7f813666	stajnia
159	http://purl.org/urbanonto/object_type_397b780a-e5fe-464b-8f45-610a265c75ab	staw
160	http://purl.org/urbanonto/object_type_f78faf6d-0612-490b-b0d9-8cbe13f7dbb7	straż pożarna
161	http://purl.org/urbanonto/object_type_256ce112-40b9-4dfd-a357-0648e04bf76d	strumień, potok lub struga
162	http://purl.org/urbanonto/object_type_7aba2cf5-9d79-4e1d-ac7d-46a8aa3ad7fd	strzelnica
163	http://purl.org/urbanonto/object_type_cb053831-abf1-4007-b84c-a3bb6d807392	synagoga
164	http://purl.org/urbanonto/object_type_cf52d40b-be95-4124-8e06-296e97cf499e	szkoła
165	http://purl.org/urbanonto/object_type_38b9b000-aee9-4d98-aee8-315a89689a87	szkoła XIX wieku
166	http://purl.org/urbanonto/object_type_a2e81396-a1cd-47dc-97d0-6634e02ba079	szkoła wyższa budynek
167	http://purl.org/urbanonto/object_type_d0008f3a-5765-4541-a619-636f66883974	szkoła wyższa kompleks
168	http://purl.org/urbanonto/object_type_b1e40e54-a8ec-446d-9385-7b3f30e7d569	szkoła średniowieczna i nowożytna
169	http://purl.org/urbanonto/object_type_8a287e70-01a2-454d-8e28-85f356330169	szkoła-kompleks
170	http://purl.org/urbanonto/object_type_4768086f-2542-429f-8c3a-e3644a5ce11a	szpital
171	http://purl.org/urbanonto/object_type_f47316c0-1c09-488a-9b19-0063d480ff87	szpital przednowoczesny
172	http://purl.org/urbanonto/object_type_ed4a36df-dc84-4dab-bebe-8542138bffc8	szubienica
173	http://purl.org/urbanonto/object_type_9a254e82-8067-4730-8dfd-cdecab5e86a3	szuwary
174	http://purl.org/urbanonto/object_type_0944c025-a8e5-48c0-8311-e7955821f889	sąd
175	http://purl.org/urbanonto/object_type_38da8ae6-c644-4b33-a311-29e7da8b6805	słodownia
176	http://purl.org/urbanonto/object_type_f02e5f79-8a07-482f-b284-7873fd5f1b1a	teatr
177	http://purl.org/urbanonto/object_type_e0f1a553-9560-48d7-9998-89bff76410e5	teren składowania odpadów komunalnych
178	http://purl.org/urbanonto/object_type_02332631-d6e9-43f2-87d9-eb411e79317f	teren składowania odpadów przemysłowych
179	http://purl.org/urbanonto/object_type_a8dc449a-b349-4738-9c02-d6676469550b	teren zabudowany
180	http://purl.org/urbanonto/object_type_9fec63be-9676-4208-94cb-b99f0010b365	tunel
181	http://purl.org/urbanonto/object_type_bcb1ecf1-8ebe-49ec-8a98-1b7e34a10e11	ulica
182	http://purl.org/urbanonto/object_type_fd67ba75-80e0-40ef-b56e-638f83e28c98	urząd pocztowy
183	http://purl.org/urbanonto/object_type_ee761b98-ba78-434f-8cd7-2b2a97a325e0	warsztat
184	http://purl.org/urbanonto/object_type_10cfedcb-03fa-4a62-adee-bb39ff3ead43	wartownia
185	http://purl.org/urbanonto/object_type_8a7aec41-061d-4dbe-96d4-ba85a0d0c4e4	wał przeciwpowodziowy lub grobla
186	http://purl.org/urbanonto/object_type_07078b2a-5f06-4a53-af73-ce15ca4c2ddb	wiadukt
187	http://purl.org/urbanonto/object_type_ab4e294f-7a2d-43be-8310-d3eca632042a	wiata
188	http://purl.org/urbanonto/object_type_941cfb75-1e17-47dc-8770-b83d7b6d93d6	wieża ciśnień
189	http://purl.org/urbanonto/object_type_1c6cc03a-8ae3-4e42-95d1-adfcb0c702b5	woda płynąca
190	http://purl.org/urbanonto/object_type_606bc22a-6984-4aff-b96c-c20f19408004	zabudowania koszarowe
191	http://purl.org/urbanonto/object_type_ef771798-bbf8-4085-b150-70c3be4d3bfb	zabytek nieużytkowy
192	http://purl.org/urbanonto/object_type_99f0f5af-ae0e-4b88-a3c9-6f51d1106dc4	zajezdnia autobusowa
193	http://purl.org/urbanonto/object_type_d91808d7-cbc7-4575-848c-15a876b9fc95	zajezdnia tramwajowa
194	http://purl.org/urbanonto/object_type_e6f87ce4-9177-4f06-bb36-a74f90982ad7	zajezdnia trolejbusowa
195	http://purl.org/urbanonto/object_type_afb82a6a-5a23-42a7-a32c-5a0fc425daa9	zakład karny
196	http://purl.org/urbanonto/object_type_2130ef99-e232-48f5-bc0c-4b9ab7a6590d	zakład poprawczy
197	http://purl.org/urbanonto/object_type_ba7c2dc2-0855-4c45-819d-3da8922ca7ca	zapora
198	http://purl.org/urbanonto/object_type_88ddadf7-708d-4ce2-87a2-7692fb4401f0	założenie pałacowe
199	http://purl.org/urbanonto/object_type_bdbb9fe6-963f-4b98-9e94-73be11c8bfdd	zbiornik zaporowy
200	http://purl.org/urbanonto/object_type_b5f8193a-7aa4-450b-bdaf-6a28b8c99b6c	zespół pałacowy
201	http://purl.org/urbanonto/object_type_1f7aca78-5242-408b-add8-7d5438a1fefc	zespół sakralny lub klasztorny
202	http://purl.org/urbanonto/object_type_d0a27d3e-2799-4636-8124-fb376f29b7a7	zespół szpitalny
203	http://purl.org/urbanonto/object_type_9d678687-6418-46af-9851-e69437bad487	zespół zamkowy
204	http://purl.org/urbanonto/object_type_7bd3ee64-e701-48f8-ab7e-f5788cf0163c	śluza
205	http://purl.org/urbanonto/object_type_838abf8a-3981-4eab-86f3-42ac9b5600b2	żłobek
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Name: location_datasets_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.location_datasets_identifiers_seq', 13, true);


--
-- Name: topographic_object_function_manifestation_sourc_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_function_manifestation_sourc_identifiers_seq', 103, true);


--
-- Name: topographic_object_location_manifestation_sourc_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_location_manifestation_sourc_identifiers_seq', 563, true);


--
-- Name: topographic_object_mereological_link_manifestat_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_mereological_link_manifestat_identifiers_seq', 24, true);


--
-- Name: topographic_object_name_manifestation_sources_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_name_manifestation_sources_identifiers_seq', 449, true);


--
-- Name: topographic_object_provenances_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_provenances_identifiers_seq', 38, true);


--
-- Name: topographic_object_type_manifestation_sources_identifiers_seq; Type: SEQUENCE SET; Schema: ontology_sources; Owner: postgres
--

SELECT pg_catalog.setval('ontology_sources.topographic_object_type_manifestation_sources_identifiers_seq', 184, true);


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
-- Name: location_datasets location_datasets_names_key; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.location_datasets
    ADD CONSTRAINT location_datasets_names_key UNIQUE (names);


--
-- Name: location_datasets location_datasets_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.location_datasets
    ADD CONSTRAINT location_datasets_pkey PRIMARY KEY (identifiers);


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
-- Name: topographic_object_function_manifestation_sources topographic_object_function_manifestation_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_function_manifestation_sources
    ADD CONSTRAINT topographic_object_function_manifestation_sources_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_location_manifestation_sources topographic_object_location_manifestation_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_location_manifestation_sources
    ADD CONSTRAINT topographic_object_location_manifestation_sources_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_mereological_link_manifestation_sources topographic_object_mereological_link_manifestation_source_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_mereological_link_manifestation_sources
    ADD CONSTRAINT topographic_object_mereological_link_manifestation_source_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_mereological_link_manifestation_sources topographic_object_mereological_link_manifestation_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_mereological_link_manifestation_sources
    ADD CONSTRAINT topographic_object_mereological_link_manifestation_sources_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_name_manifestation_sources topographic_object_name_manifestation_sources_check; Type: CHECK CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ontology_sources.topographic_object_name_manifestation_sources
    ADD CONSTRAINT topographic_object_name_manifestation_sources_check CHECK (((starts_at IS NOT NULL) OR (ends_at IS NOT NULL))) NOT VALID;


--
-- Name: topographic_object_name_manifestation_sources topographic_object_name_manifestation_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_name_manifestation_sources
    ADD CONSTRAINT topographic_object_name_manifestation_sources_pkey PRIMARY KEY (identifiers);


--
-- Name: topographic_object_provenances topographic_object_provenances_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_provenances
    ADD CONSTRAINT topographic_object_provenances_pkey PRIMARY KEY (identifiers);


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
-- Name: topographic_object_type_manifestation_sources topographic_object_type_manifestation_sources_pkey; Type: CONSTRAINT; Schema: ontology_sources; Owner: postgres
--

ALTER TABLE ONLY ontology_sources.topographic_object_type_manifestation_sources
    ADD CONSTRAINT topographic_object_type_manifestation_sources_pkey PRIMARY KEY (identifiers);


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
    ADD CONSTRAINT topographic_object_function_manif_historical_source_titles_fkey FOREIGN KEY (historical_sources) REFERENCES ontology_sources.historical_sources_sources(titles) NOT VALID;


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

