--CREATE TABLE ontology.historical_evidences (
--	identifier int4 PRIMARY KEY,
--	pages_from text NULL,
--	pages_to text NULL,
--	publication_identifier text NOT NULL,
--	CONSTRAINT historical_evidences_un UNIQUE (pages_from, pages_to, publication_identifier),
--	CONSTRAINT historical_evidences_fk FOREIGN KEY (publication_identifier) REFERENCES ontology.publication_sources(identifier)
--);

INSERT INTO ontology.historical_evidences SELECT * FROM ontology_sources.historical_evidences;
