INSERT INTO ontology.name_link_types SELECT ROW_NUMBER() OVER () AS identifier, name FROM ontology_sources.name_link_types;
