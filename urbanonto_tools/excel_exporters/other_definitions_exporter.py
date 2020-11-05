import re

from rdflib import URIRef, Graph, Literal, RDFS, RDF

from excel_exporters.export_helpers import create_iri_for_object_in_type
from excel_exporters.ontology_constants import HAS_OTHER_DEFINITION, SOURCE_CLASS
from excel_exporters.owl_axiom_creator import add_owl_annotation_axiom_to_graph
from excel_exporters.re_constants import *
from owl_handlers.register import Register
import logging
other_definitions_re = re.compile(DEFINITION_START + '(.+?)' + DEFINITION_SEPARATOR + '(.+?)' + DEFINITION_END)


def add_other_definitions_to_entity(excel_sheet_name: str, other_definitions_string: str, entity: URIRef, ontology: Graph):
    other_definitions = __get_other_definitions_from_string(other_definitions_string=other_definitions_string)
    for other_definition in other_definitions:
        other_definition_source_string = other_definition[0].strip()
        other_definition_source_iri_string = other_definition_source_string.replace(' ', '_')
        other_definition_source_label = Literal(other_definition_source_string)
        if other_definition_source_label in Register.labels_to_iris_map.keys():
            other_definition_source_iri = Register.labels_to_iris_map[other_definition_source_label]
        else:
            other_definition_source_iri = create_iri_for_object_in_type(type_local_fragment='source', index=other_definition_source_iri_string)
            ontology.add((other_definition_source_iri, RDF.type, SOURCE_CLASS))
            Register.labels_to_iris_map[other_definition_source_label] = other_definition_source_iri
        if other_definition_source_iri is None:
            logging.warning('Exporting other definitions from ' + excel_sheet_name + ' was not able to create iri for ' + other_definition_source_iri_string)
            continue
        other_definition_string = other_definition[1].strip()
        other_definition = Literal(other_definition_string)
        ontology.add((entity, HAS_OTHER_DEFINITION, other_definition))
        add_owl_annotation_axiom_to_graph(
            annotated_source_iri=entity,
            annotated_property=HAS_OTHER_DEFINITION,
            annotated_target_iri=other_definition,
            annotating_property=RDFS.isDefinedBy,
            annotation_value=other_definition_source_iri,
            graph=ontology)


def __get_other_definitions_from_string(other_definitions_string: str) -> list:
    other_definitions = list()
    matches = list(other_definitions_re.findall(other_definitions_string))
    for match in matches:
        other_definitions.append([match[0], match[1]])
    return other_definitions
