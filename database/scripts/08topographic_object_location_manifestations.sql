
INSERT INTO ontology.topographic_object_location_manifestations
SELECT
	lm.identifier			AS identifier,
	lm.topographic_object_identifier AS topographic_object_identifier,
	TO_DATE(lm.start_at,'YYYY')	AS start_at,
	TO_DATE(lm.end_at,'YYYY')	AS end_at,
	lm.location_identifier		AS location_identifier,
	lm.historical_evidence		AS historical_evidence_identifier,
	lt.identifier			AS location_link_type_identifier
FROM ontology_sources.topographic_object_location_manifestations lm
 LEFT JOIN ontology.location_link_types lt	ON (lm.location_link_type = lt.name);
