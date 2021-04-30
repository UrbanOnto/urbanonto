INSERT INTO ontology.topographic_object_provenances
SELECT
	o.identifier		AS identifier,
	o.ancestor_identifier	AS ancestor_identifier,
	o.predecessor_identifier AS predecessor_identifier,
	o.historical_evidence	AS historical_evidence_identifier
FROM ontology_sources.topographic_object_provenances o
