from rdflib import Graph, URIRef, OWL, RDFS


def orchestrate_extraction(source_ontology_file: str, top_class_uri_str: str, extracted_ontology_file: str):
    source_ontology = Graph()
    source_ontology = source_ontology.parse(source=source_ontology_file, format='n3')
    top_class = URIRef(top_class_uri_str)

    extracted_ontology = extract_ontology_module_from_top_class(source_ontology=source_ontology, top_class=top_class)
    extracted_ontology.serialize(extracted_ontology_file,format='turtle')

def extract_ontology_module_from_top_class(source_ontology: Graph, top_class: URIRef) -> Graph:
    extracted_ontology = Graph()

    extracted_ontology = \
        __add_neighbourhood_to_class(
            owl_class=top_class,
            source_ontology=source_ontology,
            extracted_ontology=extracted_ontology)

    for subclass in source_ontology.transitive_subjects(predicate=RDFS.subClassOf,object=top_class):
        extracted_ontology = \
            __add_neighbourhood_to_class(
                owl_class=subclass,
                source_ontology=source_ontology,
                extracted_ontology=extracted_ontology)

    return extracted_ontology


def __add_neighbourhood_to_class(owl_class: URIRef, source_ontology: Graph, extracted_ontology: Graph) -> Graph:
    for predicate, object in source_ontology.predicate_objects(subject=owl_class):
        extracted_ontology.add((owl_class, predicate, object))

    for subject, predicate in source_ontology.subject_predicates(object=owl_class):
        extracted_ontology.add((subject, predicate, owl_class))

    return extracted_ontology