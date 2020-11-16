import logging

from rdflib import Literal, Graph, RDFS, URIRef, XSD

from excel_exporters.excel_file_constants import *


def export_reference_data(
        data: str,
        iri: URIRef,
        ontology: Graph,
        reference_ontology: Graph,
        sheet_name: str,
        reference_type: str,
        reference_link_type: URIRef,
        datatype=None):
    reference_data_found = False
    if len(data) > 0:
        if datatype is None:
            data_label = Literal(data, lang='pl')
        else:
            data_label = Literal(data, datatype=datatype)
        reference_objects = list(reference_ontology.subjects(predicate=RDFS.label, object=data_label))
        if len(reference_objects) == 0:
            logging.warning(
                'Exporting from ' + sheet_name + ' I was not able to find name ' + data_label + ' of type ' + reference_type + ' mentioned in ' + sheet_name)
        else:
            if len(reference_objects) > 1:
                logging.warning(
                    'Exporting from ' + sheet_name + ' multiple objects of type ' + reference_type + ' were found for ' + data_label + ' in ' + sheet_name)
            else:
                reference_object = reference_objects[0]
                ontology.add((iri, reference_link_type, reference_object))
                reference_data_found = True
    return reference_data_found
