INSERT INTO ontology.name_link_types SELECT ROW_NUMBER() OVER () AS identifiers, names FROM ontology_sources.name_link_types;
