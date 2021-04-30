INSERT INTO ontology.topographic_object_type_manifestations
SELECT
	t.identifiers			AS identifiers,
	t.topographic_object_identifiers AS topographic_object_identifiers,
	TO_DATE(TO_CHAR(t.starts_at,'0999'),'YYYY')	AS starts_at,
	TO_DATE(TO_CHAR(t.ends_at,'0999'),'YYYY')	AS ends_at,
	tt.identifiers			AS type_identifiers,
	t.historical_evidences		AS historical_evidence_identifiers
FROM ontology_sources.topographic_object_type_manifestations t
 LEFT JOIN ontology.topographic_types tt ON (t.types = tt.names);
