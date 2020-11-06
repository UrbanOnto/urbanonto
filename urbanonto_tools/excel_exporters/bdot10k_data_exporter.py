import logging

from rdflib import Literal, Graph, RDFS, URIRef, XSD

from excel_exporters.excel_file_constants import *


def export_bdot10k_data(index: int, data: str, iri: URIRef, ontology: Graph, bdot10k_ontology: Graph, sheet_name: str):
    bdot10k_data_found = False
    if index == BDOT_L1_ROW_NO or index == BDOT_L2_ROW_NO or index == BDOT_L3_ROW_NO:
        if len(data) > 0:
            bdot_label = Literal(data, datatype=XSD.string)
            bdot_objects = list(bdot10k_ontology.subjects(predicate=RDFS.label, object=bdot_label))
            if len(bdot_objects) == 0:
                logging.warning('Exporting from ' + sheet_name + ' I was not able to find BDOT name ' + bdot_label + ' mentioned in ' + sheet_name)
            else:
                if len(bdot_objects) > 1:
                    logging.warning('Exporting from ' + sheet_name + ' multiple BDOT10K objects were found for ' + bdot_label + ' in ' + sheet_name)
                else:
                    bdot_object = bdot_objects[0]
                    ontology.add((iri, RDFS.subClassOf, bdot_object))
                    bdot10k_data_found = True
    return bdot10k_data_found
