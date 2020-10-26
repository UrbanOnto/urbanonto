from rdflib import URIRef
import validators
from rdflib.term import _is_valid_uri

from excel_exporters.ontology_constants import ONTOLOGY_IRI


def create_iri_for_object_type(object_type_index: int) -> URIRef:
    iri_string = ONTOLOGY_IRI + '#object_type' + '_' + str(object_type_index)
    iri = create_iri(iri_string=iri_string)
    return iri


def create_iri(iri_string: str) -> URIRef:
    iri_is_valid = _is_valid_uri(iri_string)
    if iri_is_valid:
        return URIRef(iri_string)
    else:
        print('Cannot create iri from', iri_string)
        return None

