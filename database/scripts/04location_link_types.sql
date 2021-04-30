INSERT INTO ontology.location_link_types SELECT ROW_NUMBER() OVER () AS identifier,name,postgis_function FROM ontology_sources.location_link_types;
