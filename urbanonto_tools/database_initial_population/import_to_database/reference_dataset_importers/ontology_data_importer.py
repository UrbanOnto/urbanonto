import logging

from rdflib import Graph, URIRef

from database_initial_population.import_to_database.reference_dataset_importers.sparql_queries.sparql_queries import \
    get_types_of_topographic_objects, get_functions_of_topographic_objects
from database_initial_population.import_to_database.sparql_importer import import_data_from_sparql_query_to_db_table
from ontology_initial_import.owl_handlers.owl_importer import add_recursively_owl_imports_to_ontology


def import_data_from_ontology(ontology_iri: str, cursor):
    logging.info(msg='Loading ' + ontology_iri)
    ontology = Graph()
    ontology.parse(ontology_iri, format='n3')
    ontology = \
        add_recursively_owl_imports_to_ontology(
            ontology=ontology,
            ontology_iri=URIRef(ontology_iri))

    import_data_from_sparql_query_to_db_table(
        sparql_query=get_types_of_topographic_objects,
        ontology=ontology,
        cursor=cursor,
        table_name='test.topographic_types',
        columns=['iri', 'name'],
        resolve_conflict=True)

    import_data_from_sparql_query_to_db_table(
        sparql_query=get_functions_of_topographic_objects,
        ontology=ontology,
        cursor=cursor,
        table_name='test.functions',
        columns=['iri', 'name'],
        resolve_conflict=True)
