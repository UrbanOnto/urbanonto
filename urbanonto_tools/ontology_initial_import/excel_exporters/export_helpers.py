import logging
import uuid

from rdflib import URIRef
from rdflib.term import _is_valid_uri

from ontology_initial_import.constants.ontology_constants import ONTOLOGY_IRI


def create_iri_for_object_in_type(type_local_fragment: str, index=None) -> URIRef:
    if index is None:
        index = str(uuid.uuid4())
    iri_string = ONTOLOGY_IRI + '/' + type_local_fragment + '_' + str(index)
    iri = __create_iri(iri_string=iri_string)
    return iri


def __create_iri(iri_string: str) -> URIRef:
    iri_is_valid = _is_valid_uri(iri_string)
    if iri_is_valid:
        return URIRef(iri_string)
    else:
        logging.warning(msg='Cannot create iri from ' + iri_string)
        return None
