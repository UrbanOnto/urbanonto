from rdflib import URIRef, Graph, Literal, RDFS
import logging

from owl_handlers.owl_constructors import get_owl_has_value_restriction_to_graph


def add_functions_to_entity(
        excel_sheet_name: str,
        functions_string: str,
        object_type: URIRef,
        function_property: URIRef,
        ontology: Graph,
        ontology_with_imports: Graph):
    functions = functions_string.split(',')
    for function in functions:
        function_stripped = function.strip()
        function_label = Literal(function_stripped, lang='pl')
        function_objects = list(ontology_with_imports.subjects(predicate=RDFS.label, object=function_label))
        if len(function_objects) == 0:
            logging.warning('Exporting from ' + excel_sheet_name + ' I was not able to find function with name ' + function)
        else:
            if len(function_objects) > 1:
                logging.warning('Exporting from ' + excel_sheet_name + ' multiple functions were found for name ' + function)
            else:
                function_object = function_objects[0]
                owl_value_restriction_for_function = \
                    get_owl_has_value_restriction_to_graph(
                        owl_object_property=function_property,
                        value=function_object,
                        ontology=ontology)
                ontology.add((object_type, RDFS.subClassOf, owl_value_restriction_for_function))
