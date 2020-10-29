from rdflib import URIRef, Graph, Literal, RDFS, OWL, RDF

from excel_exporters.excel_file_constants import OBJECT_TYPE_LOCAL_FRAGMENT
from excel_exporters.export_helpers import create_iri_for_object_in_type
from excel_exporters.ontology_constants import IS_PART_OF_IRI, HAS_PART_IRI
from owl_handlers.owl_constructors import get_owl_some_values_restriction_to_graph
from owl_handlers.register import Register


def add_parts_to_entity(excel_sheet_name: str, parts_string: str, entity: URIRef, ontology: Graph):
    part_strings = parts_string.split(',')
    for part_string in part_strings:
        part = __get_mereology(mereology_string=part_string, ontology=ontology)
        some_values_restriction = get_owl_some_values_restriction_to_graph(owl_object_property=IS_PART_OF_IRI,
                                                                           value=part, ontology=ontology)
        ontology.add((entity, RDFS.subClassOf, some_values_restriction))
        # all_values_restriction = get_owl_all_values_restriction_to_graph(owl_object_property=IS_PART_OF_IRI,value=part, ontology=ontology)
        # ontology.add((object_type, RDFS.subClassOf, all_values_restriction))


def add_wholes_to_entity(excel_sheet_name: str, wholes_string: str, entity: URIRef, ontology: Graph):
    whole_strings = wholes_string.split(',')
    for whole_string in whole_strings:
        whole = __get_mereology(mereology_string=whole_string, ontology=ontology)
        some_values_restriction = get_owl_some_values_restriction_to_graph(owl_object_property=HAS_PART_IRI,
                                                                           value=whole, ontology=ontology)
        ontology.add((entity, RDFS.subClassOf, some_values_restriction))
        # all_values_restriction = get_owl_all_values_restriction_to_graph(owl_object_property=HAS_PART_IRI, value=whole, ontology=ontology)
        # ontology.add((object_type, RDFS.subClassOf, all_values_restriction))


def __get_mereology(mereology_string: str, ontology: Graph) -> URIRef:
    mereology_string_stripped = mereology_string.strip()
    mereology_label = Literal(mereology_string_stripped, lang='pl')
    if mereology_label in Register.labels_to_iris_map.keys():
        mereology = Register.labels_to_iris_map[mereology_label]
    else:
        mereology = create_iri_for_object_in_type(type_local_fragment=OBJECT_TYPE_LOCAL_FRAGMENT)
        ontology.add((mereology, RDF.type, OWL.Class))
        ontology.add((mereology, RDFS.label, mereology_label))
        Register.labels_to_iris_map.update({mereology_label: mereology})
    return mereology
