from rdflib import BNode, URIRef, Graph, RDF, OWL


def get_owl_has_value_restriction_to_graph(owl_object_property: URIRef, value: URIRef, ontology: Graph) -> URIRef:
    value_restriction = BNode()

    ontology.add((value_restriction, RDF.type, OWL.Restriction))
    ontology.add((value_restriction, OWL.onProperty, owl_object_property))
    ontology.add((value_restriction, OWL.hasValue, value))

    return value_restriction


def get_owl_some_values_restriction_to_graph(owl_object_property: URIRef, value: URIRef, ontology: Graph) -> URIRef:
    some_values_restriction = BNode()

    ontology.add((some_values_restriction, RDF.type, OWL.Restriction))
    ontology.add((some_values_restriction, OWL.onProperty, owl_object_property))
    ontology.add((some_values_restriction, OWL.someValuesFrom, value))

    return some_values_restriction


def get_owl_all_values_restriction_to_graph(owl_object_property: object, value: object, ontology: object) -> object:
    all_values_restriction = BNode()

    ontology.add((all_values_restriction, RDF.type, OWL.Restriction))
    ontology.add((all_values_restriction, OWL.onProperty, owl_object_property))
    ontology.add((all_values_restriction, OWL.allValuesFrom, value))

    return all_values_restriction