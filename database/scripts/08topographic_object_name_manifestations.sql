INSERT INTO ontology.topographic_object_name_manifestations
SELECT
	n.identifiers			AS identifiers,
	n.topographic_object_identifiers AS topographic_object_identifiers,
	TO_DATE(TO_CHAR(n.starts_at,'0999'),'YYYY')	AS starts_at,
	TO_DATE(TO_CHAR(n.ends_at,'0999'),'YYYY')	AS ends_at,
	n.names				AS names,
	n.historical_evidences		AS historical_evidence_identifiers,
	nl.identifiers			AS name_link_type_identifiers
FROM ontology_sources.topographic_object_name_manifestations n
 LEFT JOIN ontology.name_link_types nl	ON (n.name_link_types = nl.names);
