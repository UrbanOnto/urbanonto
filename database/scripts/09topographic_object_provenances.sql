INSERT INTO ontology.topographic_object_provenances
SELECT
	o.identifiers		AS identifiers,
	o.ancestor_identifiers	AS ancestor_identifiers,
	o.predecessor_identifiers AS predecessor_identifiers,
	o.historical_evidences	AS historical_evidence_identifiers
FROM ontology_sources.topographic_object_provenances o
