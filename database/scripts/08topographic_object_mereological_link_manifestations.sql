INSERT INTO ontology.topographic_object_mereological_link_manifestations
SELECT
	ml.identifiers		AS identifiers,
	TO_DATE(TO_CHAR(ml.starts_at,'0999'),'YYYY')	AS starts_at,
	TO_DATE(TO_CHAR(ml.ends_at  ,'0999'),'YYYY')	AS ends_at,
	ml.whole_identifiers	AS whole_identifiers,
	ml.part_identifiers	AS part_identifiers,
	ml.historical_evidences	AS historical_evidence_identifiers
FROM ontology_sources.topographic_object_mereological_link_manifestations ml;
