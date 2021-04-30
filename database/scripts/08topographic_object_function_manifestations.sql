-- DO POPRAWIENIA "functions" !!!

INSERT INTO ontology.topographic_object_function_manifestations
SELECT
	fm.identifiers			AS identifiers,
	fm.topographic_object_identifiers AS topographic_object_identifiers,
	TO_DATE(TO_CHAR(fm.starts_at,'0999'),'YYYY')	AS starts_at,
	TO_DATE(TO_CHAR(fm.ends_at  ,'0999'),'YYYY')	AS ends_at,
	f.identifiers			AS function_identifiers,
	fm.historical_evidences		AS historical_evidence_identifiers
FROM ontology_sources.topographic_object_function_manifestations fm
 LEFT JOIN ontology.functions f		ON (fm.functions = f.names);

-- INSERT INTO ontology.topographic_object_function_manifestations SELECT * FROM ontology.topographic_object_function_manifestations_filled_func();
