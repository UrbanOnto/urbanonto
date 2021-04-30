-- TRUNCATE TABLE ontology.topographic_object_function_manifestations CONTINUE IDENTITY RESTRICT;
-- TRUNCATE TABLE ontology."functions" CONTINUE IDENTITY CASCADE;

INSERT INTO ontology."functions" SELECT * FROM ontology_sources."functions";
