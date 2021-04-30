-- DO POPRAWIENIA "functions" !!!

INSERT INTO ontology.topographic_object_function_manifestations
SELECT
	fm.identifier			AS identifier,
	fm.topographic_object_identifier AS topographic_object_identifier,
	TO_DATE(fm.start_at,'YYYY')	AS start_at,
	TO_DATE(fm.end_at,'YYYY')	AS end_at,
	f.identifier			AS function_identifier,
	fm.historical_evidence		AS historical_evidence_identifier
FROM ontology_sources.topographic_object_function_manifestations fm
 LEFT JOIN ontology.functions f		ON (fm.function = f.name);

-- INSERT INTO ontology.topographic_object_function_manifestations SELECT * FROM ontology.topographic_object_function_manifestations_filled_func();
