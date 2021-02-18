--
-- PostgreSQL database dump
--

-- Dumped from database version 13.1
-- Dumped by pg_dump version 13.1

-- Started on 2020-12-21 15:59:45

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
-- TOC entry 915 (class 1255 OID 26947)
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
-- Name: Functions; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."Functions" (
    "Identifiers" integer NOT NULL,
    "IRIs" text NOT NULL,
    "Names" text NOT NULL
);


ALTER TABLE ontology."Functions" OWNER TO postgres;

--
-- TOC entry 3942 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE "Functions"; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology."Functions" IS 'The contents of this table will be imported from the ontology.';


--
-- TOC entry 216 (class 1259 OID 32783)
-- Name: HistoricalSources; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."HistoricalSources" (
    "Identifiers" integer NOT NULL,
    "Titles" text NOT NULL,
    "BibliographicData" text
);


ALTER TABLE ontology."HistoricalSources" OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 32826)
-- Name: TopographicObjectFunctionManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectFunctionManifestations" (
    "Identifiers" integer NOT NULL,
    "TopographicObjectIdentifiers" integer NOT NULL,
    "FunctionIdentifiers" integer NOT NULL,
    "StartsAt" date,
    "EndsAt" date,
    "HistoricalSourceIdentifiers" integer NOT NULL
);


ALTER TABLE ontology."TopographicObjectFunctionManifestations" OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 27144)
-- Name: TopographicObjectLocationManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectLocationManifestations" (
    "Identifiers" integer NOT NULL,
    "TopographicObjectIdentifiers" integer NOT NULL,
    "Locations" ontology.geometry NOT NULL,
    "StartsAt" date,
    "EndsAt" date,
    "HistoricalSourceIdentifiers" integer NOT NULL
);


ALTER TABLE ontology."TopographicObjectLocationManifestations" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 32841)
-- Name: TopographicObjectManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectManifestations" (
    "Identifiers" integer NOT NULL,
    "TopographicObjectIdentifiers" integer NOT NULL,
    "FunctionManifestationIdentifiers" integer,
    "LocationManifestationIdentifiers" integer,
    "MereologicalLinkManifestationIdentifiers" integer,
    "NameManifestationIdentifiers" integer,
    "TypeManifestationIdentifiers" integer,
    "StartsAt" date,
    "EndsAt" date
);


ALTER TABLE ontology."TopographicObjectManifestations" OWNER TO postgres;

--
-- TOC entry 3943 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "TopographicObjectManifestations"; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology."TopographicObjectManifestations" IS 'This is actually a view over other manifestation tables that aggregates them all.';


--
-- TOC entry 215 (class 1259 OID 32768)
-- Name: TopographicObjectMereologicalLinkManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectMereologicalLinkManifestations" (
    "Identifiers" integer NOT NULL,
    "StartsAt" date,
    "EndsAt" date,
    "WholeIdentifiers" integer NOT NULL,
    "PartIdentifiers" integer NOT NULL,
    "HistoricalSourceIdentifiers" integer NOT NULL
);


ALTER TABLE ontology."TopographicObjectMereologicalLinkManifestations" OWNER TO postgres;

--
-- TOC entry 205 (class 1259 OID 27093)
-- Name: TopographicObjectNameManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectNameManifestations" (
    "Identifiers" integer NOT NULL,
    "TopographicObjectIdentifiers" integer NOT NULL,
    "StartsAt" date,
    "EndsAt" date,
    "Names" text NOT NULL,
    "HistoricalSourceIdentifiers" integer NOT NULL
);


ALTER TABLE ontology."TopographicObjectNameManifestations" OWNER TO postgres;

--
-- TOC entry 206 (class 1259 OID 27113)
-- Name: TopographicObjectTypeManifestations; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjectTypeManifestations" (
    "Identifiers" integer NOT NULL,
    "TopographicObjectIdentifiers" integer NOT NULL,
    "StartsAt" date,
    "EndsAt" date,
    "TypeIdentifiers" integer,
    "HistoricalSourceIdentifiers" integer NOT NULL
);


ALTER TABLE ontology."TopographicObjectTypeManifestations" OWNER TO postgres;

--
-- TOC entry 204 (class 1259 OID 27088)
-- Name: TopographicObjects; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicObjects" (
    "Identifiers" integer NOT NULL,
    "AncestorIdentifiers" integer
);


ALTER TABLE ontology."TopographicObjects" OWNER TO postgres;

--
-- TOC entry 3944 (class 0 OID 0)
-- Dependencies: 204
-- Name: COLUMN "TopographicObjects"."AncestorIdentifiers"; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON COLUMN ontology."TopographicObjects"."AncestorIdentifiers" IS 'This stores information about the object from which the current object was created. We assume that the former will be unique.';


--
-- TOC entry 207 (class 1259 OID 27118)
-- Name: TopographicTypes; Type: TABLE; Schema: ontology; Owner: postgres
--

CREATE TABLE ontology."TopographicTypes" (
    "Identifiers" integer NOT NULL,
    "IRIs" text NOT NULL,
    "Names" text NOT NULL
);


ALTER TABLE ontology."TopographicTypes" OWNER TO postgres;

--
-- TOC entry 3945 (class 0 OID 0)
-- Dependencies: 207
-- Name: TABLE "TopographicTypes"; Type: COMMENT; Schema: ontology; Owner: postgres
--

COMMENT ON TABLE ontology."TopographicTypes" IS 'The contents of this table will be imported from the ontology.';


--
-- TOC entry 3931 (class 0 OID 27126)
-- Dependencies: 208
-- Data for Name: Functions; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."Functions" ("Identifiers", "IRIs", "Names") FROM stdin;
\.


--
-- TOC entry 3934 (class 0 OID 32783)
-- Dependencies: 216
-- Data for Name: HistoricalSources; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."HistoricalSources" ("Identifiers", "Titles", "BibliographicData") FROM stdin;
\.


--
-- TOC entry 3935 (class 0 OID 32826)
-- Dependencies: 217
-- Data for Name: TopographicObjectFunctionManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectFunctionManifestations" ("Identifiers", "TopographicObjectIdentifiers", "FunctionIdentifiers", "StartsAt", "EndsAt", "HistoricalSourceIdentifiers") FROM stdin;
\.


--
-- TOC entry 3932 (class 0 OID 27144)
-- Dependencies: 209
-- Data for Name: TopographicObjectLocationManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectLocationManifestations" ("Identifiers", "TopographicObjectIdentifiers", "Locations", "StartsAt", "EndsAt", "HistoricalSourceIdentifiers") FROM stdin;
\.


--
-- TOC entry 3936 (class 0 OID 32841)
-- Dependencies: 218
-- Data for Name: TopographicObjectManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectManifestations" ("Identifiers", "TopographicObjectIdentifiers", "FunctionManifestationIdentifiers", "LocationManifestationIdentifiers", "MereologicalLinkManifestationIdentifiers", "NameManifestationIdentifiers", "TypeManifestationIdentifiers", "StartsAt", "EndsAt") FROM stdin;
\.


--
-- TOC entry 3933 (class 0 OID 32768)
-- Dependencies: 215
-- Data for Name: TopographicObjectMereologicalLinkManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectMereologicalLinkManifestations" ("Identifiers", "StartsAt", "EndsAt", "WholeIdentifiers", "PartIdentifiers", "HistoricalSourceIdentifiers") FROM stdin;
\.


--
-- TOC entry 3928 (class 0 OID 27093)
-- Dependencies: 205
-- Data for Name: TopographicObjectNameManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectNameManifestations" ("Identifiers", "TopographicObjectIdentifiers", "StartsAt", "EndsAt", "Names", "HistoricalSourceIdentifiers") FROM stdin;
\.


--
-- TOC entry 3929 (class 0 OID 27113)
-- Dependencies: 206
-- Data for Name: TopographicObjectTypeManifestations; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjectTypeManifestations" ("Identifiers", "TopographicObjectIdentifiers", "StartsAt", "EndsAt", "TypeIdentifiers", "HistoricalSourceIdentifiers") FROM stdin;
\.


--
-- TOC entry 3927 (class 0 OID 27088)
-- Dependencies: 204
-- Data for Name: TopographicObjects; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicObjects" ("Identifiers", "AncestorIdentifiers") FROM stdin;
\.


--
-- TOC entry 3930 (class 0 OID 27118)
-- Dependencies: 207
-- Data for Name: TopographicTypes; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology."TopographicTypes" ("Identifiers", "IRIs", "Names") FROM stdin;
\.


--
-- TOC entry 3744 (class 0 OID 27454)
-- Dependencies: 211
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: ontology; Owner: postgres
--

COPY ontology.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- TOC entry 3757 (class 2606 OID 32888)
-- Name: Functions Functions_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."Functions"
    ADD CONSTRAINT "Functions_IRIs_key" UNIQUE ("IRIs");


--
-- TOC entry 3759 (class 2606 OID 27133)
-- Name: Functions Functions_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."Functions"
    ADD CONSTRAINT "Functions_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3767 (class 2606 OID 32790)
-- Name: HistoricalSources HistoricalSources_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."HistoricalSources"
    ADD CONSTRAINT "HistoricalSources_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3753 (class 2606 OID 27125)
-- Name: TopographicTypes TopgraphicTypes_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicTypes"
    ADD CONSTRAINT "TopgraphicTypes_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3769 (class 2606 OID 32830)
-- Name: TopographicObjectFunctionManifestations TopographicObjectFunctionManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectFunctionManifestations"
    ADD CONSTRAINT "TopographicObjectFunctionManifestations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3761 (class 2606 OID 27148)
-- Name: TopographicObjectLocationManifestations TopographicObjectLocations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectLocationManifestations"
    ADD CONSTRAINT "TopographicObjectLocations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3771 (class 2606 OID 32845)
-- Name: TopographicObjectManifestations TopographicObjectManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3765 (class 2606 OID 32772)
-- Name: TopographicObjectMereologicalLinkManifestations TopographicObjectMereologicalLinkManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectMereologicalLinkManifestations"
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifestations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3749 (class 2606 OID 27097)
-- Name: TopographicObjectNameManifestations TopographicObjectNameManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectNameManifestations"
    ADD CONSTRAINT "TopographicObjectNameManifestations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3751 (class 2606 OID 27117)
-- Name: TopographicObjectTypeManifestations TopographicObjectTypeManifestations_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectTypeManifestations"
    ADD CONSTRAINT "TopographicObjectTypeManifestations_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3747 (class 2606 OID 27092)
-- Name: TopographicObjects TopographicObjects_pkey; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjects"
    ADD CONSTRAINT "TopographicObjects_pkey" PRIMARY KEY ("Identifiers");


--
-- TOC entry 3755 (class 2606 OID 32890)
-- Name: TopographicTypes TopographicTypes_IRIs_key; Type: CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicTypes"
    ADD CONSTRAINT "TopographicTypes_IRIs_key" UNIQUE ("IRIs");


--
-- TOC entry 3783 (class 2606 OID 32831)
-- Name: TopographicObjectFunctionManifestations TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectFunctionManifestations"
    ADD CONSTRAINT "TopographicObjectFunctionMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY ("TopographicObjectIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers");


--
-- TOC entry 3785 (class 2606 OID 32877)
-- Name: TopographicObjectFunctionManifestations TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectFunctionManifestations"
    ADD CONSTRAINT "TopographicObjectFunctionManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY ("HistoricalSourceIdentifiers") REFERENCES ontology."HistoricalSources"("Identifiers") NOT VALID;


--
-- TOC entry 3784 (class 2606 OID 32836)
-- Name: TopographicObjectFunctionManifestations TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectFunctionManifestations"
    ADD CONSTRAINT "TopographicObjectFunctionManifestation_FunctionIdentifiers_fkey" FOREIGN KEY ("FunctionIdentifiers") REFERENCES ontology."Functions"("Identifiers");


--
-- TOC entry 3778 (class 2606 OID 32791)
-- Name: TopographicObjectLocationManifestations TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectLocationManifestations"
    ADD CONSTRAINT "TopographicObjectLocationMani_TopographicObjectIdentifiers_fkey" FOREIGN KEY ("TopographicObjectIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 3779 (class 2606 OID 32796)
-- Name: TopographicObjectLocationManifestations TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectLocationManifestations"
    ADD CONSTRAINT "TopographicObjectLocationManif_HistoricalSourceIdentifiers_fkey" FOREIGN KEY ("HistoricalSourceIdentifiers") REFERENCES ontology."HistoricalSources"("Identifiers") NOT VALID;


--
-- TOC entry 3787 (class 2606 OID 32851)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_FunctionManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_FunctionManifestationIdentif_fkey" FOREIGN KEY ("FunctionManifestationIdentifiers") REFERENCES ontology."TopographicObjectFunctionManifestations"("Identifiers");


--
-- TOC entry 3788 (class 2606 OID 32856)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_LocationManifestationIdentif_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_LocationManifestationIdentif_fkey" FOREIGN KEY ("LocationManifestationIdentifiers") REFERENCES ontology."TopographicObjectLocationManifestations"("Identifiers");


--
-- TOC entry 3791 (class 2606 OID 32882)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_MereologicalLinkManifestatio_fkey" FOREIGN KEY ("MereologicalLinkManifestationIdentifiers") REFERENCES ontology."TopographicObjectMereologicalLinkManifestations"("Identifiers") NOT VALID;


--
-- TOC entry 3789 (class 2606 OID 32866)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_NameManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_NameManifestationIdentifiers_fkey" FOREIGN KEY ("NameManifestationIdentifiers") REFERENCES ontology."TopographicObjectNameManifestations"("Identifiers");


--
-- TOC entry 3786 (class 2606 OID 32846)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_TopographicObjectIdentifiers_fkey" FOREIGN KEY ("TopographicObjectIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers");


--
-- TOC entry 3790 (class 2606 OID 32871)
-- Name: TopographicObjectManifestations TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectManifestations"
    ADD CONSTRAINT "TopographicObjectManifestatio_TypeManifestationIdentifiers_fkey" FOREIGN KEY ("TypeManifestationIdentifiers") REFERENCES ontology."TopographicObjectTypeManifestations"("Identifiers");


--
-- TOC entry 3782 (class 2606 OID 32806)
-- Name: TopographicObjectMereologicalLinkManifestations TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectMereologicalLinkManifestations"
    ADD CONSTRAINT "TopographicObjectMereologicalL_HistoricalSourceIdentifiers_fkey" FOREIGN KEY ("HistoricalSourceIdentifiers") REFERENCES ontology."HistoricalSources"("Identifiers") NOT VALID;


--
-- TOC entry 3780 (class 2606 OID 32773)
-- Name: TopographicObjectMereologicalLinkManifestations TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectMereologicalLinkManifestations"
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifest_WholeIdentifiers_fkey" FOREIGN KEY ("WholeIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers");


--
-- TOC entry 3781 (class 2606 OID 32801)
-- Name: TopographicObjectMereologicalLinkManifestations TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectMereologicalLinkManifestations"
    ADD CONSTRAINT "TopographicObjectMereologicalLinkManifesta_PartIdentifiers_fkey" FOREIGN KEY ("PartIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 3773 (class 2606 OID 27098)
-- Name: TopographicObjectNameManifestations TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectNameManifestations"
    ADD CONSTRAINT "TopographicObjectNameManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY ("TopographicObjectIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 3774 (class 2606 OID 32811)
-- Name: TopographicObjectNameManifestations TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectNameManifestations"
    ADD CONSTRAINT "TopographicObjectNameManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY ("HistoricalSourceIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 3775 (class 2606 OID 27134)
-- Name: TopographicObjectTypeManifestations TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectTypeManifestations"
    ADD CONSTRAINT "TopographicObjectTypeManifest_TopographicObjectIdentifiers_fkey" FOREIGN KEY ("TopographicObjectIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 3777 (class 2606 OID 32816)
-- Name: TopographicObjectTypeManifestations TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectTypeManifestations"
    ADD CONSTRAINT "TopographicObjectTypeManifesta_HistoricalSourceIdentifiers_fkey" FOREIGN KEY ("HistoricalSourceIdentifiers") REFERENCES ontology."HistoricalSources"("Identifiers") NOT VALID;


--
-- TOC entry 3776 (class 2606 OID 27139)
-- Name: TopographicObjectTypeManifestations TopographicObjectTypeManifestations_TypeIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjectTypeManifestations"
    ADD CONSTRAINT "TopographicObjectTypeManifestations_TypeIdentifiers_fkey" FOREIGN KEY ("TypeIdentifiers") REFERENCES ontology."TopographicTypes"("Identifiers") NOT VALID;


--
-- TOC entry 3772 (class 2606 OID 32821)
-- Name: TopographicObjects TopographicObjects_AncestorIdentifiers_fkey; Type: FK CONSTRAINT; Schema: ontology; Owner: postgres
--

ALTER TABLE ONLY ontology."TopographicObjects"
    ADD CONSTRAINT "TopographicObjects_AncestorIdentifiers_fkey" FOREIGN KEY ("AncestorIdentifiers") REFERENCES ontology."TopographicObjects"("Identifiers") NOT VALID;


--
-- TOC entry 2578 (class 826 OID 32876)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: ontology; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA ontology GRANT ALL ON TABLES  TO PUBLIC;


-- Completed on 2020-12-21 15:59:47

--
-- PostgreSQL database dump complete
--

