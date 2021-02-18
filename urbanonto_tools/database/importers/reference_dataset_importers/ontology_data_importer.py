import logging

from rdflib import Graph

from database.importers.reference_dataset_importers.sparql_queries.sparql_queries import \
    get_types_of_topographic_objects, get_functions_of_topographic_objects
from database.importers.sparql_importer import import_data_from_sparql_query_to_db_table


def import_data_from_ontology(ontology_iri: str, cursor):
    logging.info(msg='Loading ' + ontology_iri)
    ontology = Graph()
    ontology.parse(ontology_iri, format='n3')

    import_data_from_sparql_query_to_db_table(
        sparql_query=get_types_of_topographic_objects,
        ontology=ontology,
        cursor=cursor,
        table_name='ontology.topographic_types',
        columns=['identifiers','iris','names'])

    import_data_from_sparql_query_to_db_table(
        sparql_query=get_functions_of_topographic_objects,
        ontology=ontology,
        cursor=cursor,
        table_name='ontology.functions',
        columns=['identifiers', 'iris', 'names'])