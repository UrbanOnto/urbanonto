from rdflib import URIRef, Graph, RDF, OWL, RDFS, Literal


class Register:
    labels_to_iris_map = dict()
    no_label_iris = set()

    @staticmethod
    def create_class_using_iri(iri: URIRef, ontology: Graph):
        ontology.add((iri, RDF.type, OWL.Class))

    @staticmethod
    def create_class_using_iri_and_label(iri: URIRef, label_string, ontology: Graph):
        label = Literal(label_string)
        if label in Register.labels_to_iris_map.keys():
            return
        ontology.add((iri, RDF.type, OWL.Class))
        ontology.add((iri, RDFS.label, label))
        Register.labels_to_iris_map[label] = iri

    @staticmethod
    def update_register_from_ontology(ontology: Graph):
        for subject, predicate, object in ontology:
            if predicate == RDFS.label:
                Register.labels_to_iris_map.update({object: subject})
