INSERT INTO ontology.location_datasets SELECT ROW_NUMBER() OVER () AS identifiers,names FROM ontology_sources.location_datasets;
