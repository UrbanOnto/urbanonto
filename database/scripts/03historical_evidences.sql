--CREATE TABLE ontology.historical_evidences (
--	identifiers int4 PRIMARY KEY,
--	pages_from text NULL,
--	pages_to text NULL,
--	publication_identifiers text NOT NULL,
--	CONSTRAINT historical_evidences_un UNIQUE (pages_from, pages_to, publication_identifiers),
--	CONSTRAINT historical_evidences_fk FOREIGN KEY (publication_identifiers) REFERENCES ontology.publication_sources(identifiers)
--);

INSERT INTO ontology.historical_evidences SELECT * FROM ontology_sources.historical_evidences;
