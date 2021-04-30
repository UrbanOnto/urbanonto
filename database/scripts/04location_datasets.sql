INSERT INTO ontology.location_datasets SELECT ROW_NUMBER() OVER () AS identifier,name FROM ontology_sources.location_datasets;
