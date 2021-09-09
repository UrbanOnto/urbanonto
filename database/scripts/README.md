# urbanonto ontology scripts

ontology_sources2ontology.sql script is used to translate raw data from ontology_sources schema into clean data inside ontology schema.
d2rq_mapping_urbanonto.ttl is a [D2RQ](http://d2rq.org) mapping file to be used by a [D2RQ](http://d2rq.org) script to get RDF data out of the database.
To get the rdf dump from the database run dump-rdf -o urbanonto.ttl mapping_urbanonto.ttl.
