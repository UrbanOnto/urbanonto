INSERT INTO ontology.topographic_object_type_manifestations
SELECT
	t.identifier			AS identifier,
	t.topographic_object_identifier AS topographic_object_identifier,
	TO_DATE(t.start_at,'YYYY')	AS start_at,
	TO_DATE(t.end_at,'YYYY')	AS end_at,
	tt.identifier			AS type_identifier,
	t.historical_evidence		AS historical_evidence_identifier
FROM ontology_sources.topographic_object_type_manifestations t
 LEFT JOIN ontology.topographic_types tt ON (t.type = tt.name);
