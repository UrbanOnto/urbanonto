--CLEAR DOWN
TRUNCATE TABLE ontology.location_datasets;
TRUNCATE TABLE ontology.topographic_object_function_manifestations,ontology.topographic_object_location_manifestations,ontology.topographic_object_mereological_link_manifestations,ontology.topographic_object_name_manifestations,ontology.topographic_object_provenances,ontology.topographic_object_type_manifestations,ontology.topographic_objects,ontology.historical_evidences,ontology.publication_sources,ontology.topographic_types,ontology.functions;
TRUNCATE TABLE ontology.topographic_object_name_manifestations,ontology.name_link_types;
TRUNCATE TABLE ontology.topographic_object_location_manifestations,ontology.locations;
TRUNCATE TABLE ontology.topographic_object_location_manifestations,ontology.location_link_types;

--ONTOLOGY REFERENCE DATA
INSERT INTO ontology."functions" SELECT * FROM ontology_sources."functions" ORDER BY identifier;
INSERT INTO ontology.topographic_types SELECT * FROM ontology_sources.topographic_types ORDER BY identifier;

--HISTORICAL EVIDENCE DATA
INSERT INTO ontology.publication_sources SELECT * FROM ontology_sources.publication_sources ORDER BY identifier;
INSERT INTO ontology.historical_evidences SELECT * FROM ontology_sources.historical_evidences ORDER BY identifier;

--LOCATION REFERENCE DATA
--REFRESH MATERIALIZED VIEW ontology.topographic_object_function_manifestations_filled;
INSERT INTO ontology.location_datasets SELECT ROW_NUMBER() OVER () AS identifier,name FROM ontology_sources.location_datasets;
INSERT INTO ontology.location_link_types SELECT ROW_NUMBER() OVER () AS identifier,name,postgis_function FROM ontology_sources.location_link_types;
INSERT INTO ontology.locations SELECT DISTINCT lrr.identifier,lrr.the_geom FROM ontology_sources.locations_refined_raw lrr ORDER BY identifier;

--NAME REFERENCE DATA
INSERT INTO ontology.name_link_types SELECT ROW_NUMBER() OVER () AS identifier, name FROM ontology_sources.name_link_types;
--TOPOGRAPHIC OBJECT ANCHOR DATA
INSERT INTO ontology.topographic_objects SELECT identifier FROM ontology_sources.topographic_objects ORDER BY identifier;

--MANIFESTATION DATA
INSERT INTO ontology.topographic_object_function_manifestations
SELECT
 fm.identifier AS identifier,
 fm.topographic_object_identifier AS topographic_object_identifier,
 TO_DATE(ontology_sources.get_precise_date(fm.start_at)::TEXT, 'YYYY') AS start_at,
 TO_DATE(ontology_sources.get_precise_date(fm.end_at)::TEXT, 'YYYY') AS end_at,
 f.identifier AS function_identifier,
 fm.historical_evidence AS historical_evidence_identifier
FROM ontology_sources.topographic_object_function_manifestations fm
LEFT JOIN ontology.functions f ON (fm.function = f.name)
ORDER BY fm.identifier;

INSERT INTO ontology.topographic_object_location_manifestations
SELECT
 lm.identifier AS identifier,
 lm.topographic_object_identifier AS topographic_object_identifier,
 TO_DATE(ontology_sources.get_precise_date(lm.start_at)::TEXT, 'YYYY') AS start_at,
 TO_DATE(ontology_sources.get_precise_date(lm.end_at)::TEXT, 'YYYY') AS end_at,
 lrr.identifier AS location_identifier,
 lm.historical_evidence AS historical_evidence_identifier,
 lt.identifier AS location_link_type_identifier
FROM ontology_sources.topographic_object_location_manifestations lm
LEFT JOIN	ontology.location_link_types lt ON (lm.location_link_type = lt.name)
INNER JOIN	ontology_sources.locations_refined_raw lrr on (lm.location_identifier=lrr.raw_id)
ORDER BY lm.identifier;

INSERT INTO ontology.topographic_object_mereological_link_manifestations
SELECT
 ml.identifier AS identifier,
 TO_DATE(ontology_sources.get_precise_date(ml.start_at)::TEXT, 'YYYY') AS start_at,
 TO_DATE(ontology_sources.get_precise_date(ml.end_at)::TEXT, 'YYYY') AS end_at,
 ml.whole_identifier AS whole_identifier,
 ml.part_identifier AS part_identifier,
 ml.historical_evidence AS historical_evidence_identifier
FROM ontology_sources.topographic_object_mereological_link_manifestations ml
ORDER BY ml.identifier;

INSERT INTO ontology.topographic_object_name_manifestations
SELECT
 n.identifier AS identifier,
 n.topographic_object_identifier AS topographic_object_identifier,
 TO_DATE(ontology_sources.get_precise_date(n.start_at)::TEXT, 'YYYY') AS start_at,
 TO_DATE(ontology_sources.get_precise_date(n.end_at)::TEXT, 'YYYY') AS end_at,
 n.name AS name,
 n.historical_evidence AS historical_evidence_identifier,
 nl.identifier AS name_link_type_identifier
FROM ontology_sources.topographic_object_name_manifestations n
LEFT JOIN ontology.name_link_types nl ON (n.name_link_type = nl.name)
ORDER BY n.identifier;

INSERT INTO ontology.topographic_object_type_manifestations
SELECT
 t.identifier AS identifier,
 t.topographic_object_identifier AS topographic_object_identifier,
 TO_DATE(ontology_sources.get_precise_date(t.start_at)::TEXT, 'YYYY') AS start_at,
 TO_DATE(ontology_sources.get_precise_date(t.end_at)::TEXT, 'YYYY') AS end_at,
 tt.identifier AS type_identifier,
 t.historical_evidence AS historical_evidence_identifier
FROM ontology_sources.topographic_object_type_manifestations t
LEFT JOIN ontology.topographic_types tt ON (t.type = tt.name)
ORDER BY t.identifier;

--PROVENANCE DATA
INSERT INTO ontology.topographic_object_provenances
SELECT
 o.identifier AS identifier,
 o.ancestor_identifier AS ancestor_identifier,
 o.successor_identifier AS successor_identifier,
 o.historical_evidence AS historical_evidence_identifier
FROM ontology_sources.topographic_object_provenances o
ORDER BY o.identifier;

REFRESH MATERIALIZED VIEW ontology.topographic_object_function_manifestations_filled;
REFRESH MATERIALIZED VIEW ontology.topographic_object_location_manifestations_filled;
REFRESH MATERIALIZED VIEW ontology.topographic_object_name_manifestations_filled;
REFRESH MATERIALIZED VIEW ontology.topographic_object_type_manifestations_filled;
REFRESH MATERIALIZED VIEW ontology.geonode_topographic_object_manifestations;
