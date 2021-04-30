INSERT INTO ontology.topographic_object_name_manifestations
SELECT
	n.identifier			AS identifier,
	n.topographic_object_identifier AS topographic_object_identifier,
	TO_DATE(n.start_at,'YYYY')	AS start_at,
	TO_DATE(n.end_at,'YYYY')	AS end_at,
	n.name				AS name,
	n.historical_evidence		AS historical_evidence_identifier,
	nl.identifier			AS name_link_type_identifier
FROM ontology_sources.topographic_object_name_manifestations n
 LEFT JOIN ontology.name_link_types nl	ON (n.name_link_type = nl.name);
