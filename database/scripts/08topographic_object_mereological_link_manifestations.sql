INSERT INTO ontology.topographic_object_mereological_link_manifestations
SELECT
	ml.identifier		AS identifier,
	TO_DATE(ml.start_at,'YYYY')	AS start_at,
	TO_DATE(ml.end_at  ,'YYYY')	AS end_at,
	ml.whole_identifier	AS whole_identifier,
	ml.part_identifier	AS part_identifier,
	ml.historical_evidence	AS historical_evidence_identifier
FROM ontology_sources.topographic_object_mereological_link_manifestations ml;
