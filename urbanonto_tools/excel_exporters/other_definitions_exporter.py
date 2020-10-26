import re

from rdflib import URIRef, Graph, Literal, RDFS

from excel_exporters.export_helpers import create_iri_for_object_in_type
from excel_exporters.ontology_constants import HAS_OTHER_DEFINITION
from excel_exporters.owl_axiom_creator import add_owl_annotation_axiom_to_graph
from excel_exporters.re_constants import *

other_definitions_re = re.compile(DEFINITION_START + '(.+)' + DEFINITION_SEPARATOR + '(.+)' + DEFINITION_END)


def add_other_definitions_to_entity(excel_sheet_name: str, other_definitions_string: str, entity: URIRef,
                                    ontology: Graph, created_entities_register: dict):
    other_definitions = __get_other_definitions_from_string(other_definitions_string=other_definitions_string)
    for other_definition in other_definitions:
        other_definition_source_string = other_definition[0].strip()
        other_definition_source_iri_string = other_definition_source_string.replace(' ', '_')
        other_definition_source_label = other_definition_source_string
        if other_definition_source_label in created_entities_register:
            other_definition_source = created_entities_register[other_definition_source_label]
        else:
            other_definition_source = create_iri_for_object_in_type(type_local_fragment='source',
                                                                    index=other_definition_source_iri_string)
        if other_definition_source is None:
            print('Exporting other definitions from', excel_sheet_name, 'Cannot create iri for',
                  other_definition_source_iri_string)
            continue
        other_definition_string = other_definition[1].strip()
        other_definition = Literal(other_definition_string)
        ontology.add((entity, HAS_OTHER_DEFINITION, other_definition))
        add_owl_annotation_axiom_to_graph(
            annotated_source_iri=entity,
            annotated_property=HAS_OTHER_DEFINITION,
            annotated_target_iri=other_definition,
            annotating_property=RDFS.isDefinedBy,
            annotation_value=other_definition_source,
            graph=ontology)


def __get_other_definitions_from_string(other_definitions_string: str) -> list:
    other_definitions = list()
    matches = list(other_definitions_re.findall(other_definitions_string))
    for match in matches:
        other_definitions.append([match[0], match[1]])
    return other_definitions
