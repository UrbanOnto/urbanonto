import logging
from collections import Callable

from rdflib import Graph, RDFS, URIRef


def export_reference_data(
        reference_data: str,
        iri: URIRef,
        ontology: Graph,
        reference_ontology: Graph,
        sheet_name: str,
        reference_type: str,
        reference_link_type: URIRef,
        reference_object_function: Callable,
        literal_creator: Callable):
    reference_data_found = False
    if len(reference_data) > 0:
        reference_literal = literal_creator(literal_string=reference_data)
        reference_objects = list(reference_ontology.subjects(predicate=RDFS.label, object=reference_literal))
        if len(reference_objects) == 0:
            logging.warning(
                'Exporting from ' + sheet_name + ' I was not able to find name ' + reference_literal + ' of type ' + reference_type + ' mentioned in ' + sheet_name)
        else:
            if len(reference_objects) > 1:
                logging.warning(
                    'Exporting from ' + sheet_name + ' multiple objects of type ' + reference_type + ' were found for ' + reference_literal + ' in ' + sheet_name)
            else:
                reference_object = reference_objects[0]
                restriction = reference_object_function(owl_object_property=reference_link_type, value=reference_object,
                                                        ontology=ontology)
                ontology.add((iri, RDFS.subClassOf, restriction))
                reference_data_found = True
    return reference_data_found
