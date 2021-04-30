
INSERT INTO ontology.topographic_object_location_manifestations
SELECT
	lm.identifiers			AS identifiers,
	lm.topographic_object_identifiers AS topographic_object_identifiers,
	TO_DATE(TO_CHAR(lm.starts_at,'0999'),'YYYY')	AS starts_at,
	TO_DATE(TO_CHAR(lm.ends_at  ,'0999'),'YYYY')	AS ends_at,
	lm.location_identifiers		AS location_identifiers,
	lm.historical_evidences		AS historical_evidence_identifiers,
	lt.identifiers			AS location_link_type_identifiers
FROM ontology_sources.topographic_object_location_manifestations lm
 LEFT JOIN ontology.location_link_types lt	ON (lm.location_link_type_names = lt.names);
