INSERT INTO ontology.location_link_types SELECT ROW_NUMBER() OVER () AS identifiers,names,postgis_functions FROM ontology_sources.location_link_types;
