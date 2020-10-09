from rdflib import BNode, URIRef, Graph, RDF, OWL


def get_owl_has_value_restriction(owl_object_property: URIRef, value: URIRef, ontology: Graph) -> tuple:
    value_restriction = BNode()

    ontology.add((value_restriction, RDF.type, OWL.restriction))
    ontology.add((value_restriction, OWL.onProperty, owl_object_property))
    ontology.add((value_restriction, OWL.hasValue, value))

    return value_restriction, ontology