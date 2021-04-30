-- CREATE TABLE ontology.publication_sources ( identifier text PRIMARY KEY, bibliographic_data text NOT NULL);

INSERT INTO ontology.publication_sources SELECT * FROM ontology_sources.publication_sources;
