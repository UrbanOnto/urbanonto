from rdflib import URIRef

from excel_exporters.ontology_constants import ONTOLOGY_IRI


def create_iri_for_object_type(object_type_index: int) -> URIRef:
    object_type_iri = URIRef(ONTOLOGY_IRI + '#object_type' + '_' + str(object_type_index))
    return object_type_iri

