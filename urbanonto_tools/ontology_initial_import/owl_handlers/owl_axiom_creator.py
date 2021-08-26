from rdflib import Graph, BNode, RDF, OWL, URIRef
from rdflib.term import Identifier


def add_owl_annotation_axiom_to_graph(
        annotated_source_iri: URIRef,
        annotated_target_iri: URIRef,
        annotated_property: URIRef,
        annotation_value: Identifier,
        annotating_property: URIRef,
        graph: Graph):
    owl_axiom = \
        BNode()

    graph.add(
        (owl_axiom, RDF.type, OWL.Axiom))

    graph.add(
        (owl_axiom, OWL.annotatedSource, annotated_source_iri))

    graph.add(
        (owl_axiom, OWL.annotatedProperty, annotated_property))

    graph.add(
        (owl_axiom, OWL.annotatedTarget, annotated_target_iri))

    graph.add(
        (owl_axiom, annotating_property, annotation_value))
