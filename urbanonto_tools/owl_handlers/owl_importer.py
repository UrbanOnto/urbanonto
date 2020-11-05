from rdflib import Graph, OWL, URIRef
import logging

def add_recursively_owl_imports_to_ontology(ontology: Graph, ontology_iri: URIRef) -> Graph:
    logging.info('Importing ontologies required by '  + str(ontology_iri))
    owl_imports = ontology.objects(predicate=OWL.imports, subject=ontology_iri)
    for owl_import in owl_imports:
        ontology.parse(owl_import, format='n3')
        ontology = \
            add_recursively_owl_imports_to_ontology(ontology=ontology, ontology_iri=owl_import)
    return ontology
