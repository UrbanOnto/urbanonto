from rdflib import Literal, XSD


def create_literal_with_lang(literal_string: str):
    literal = Literal(literal_string, lang='pl')
    return literal


def create_literal_with_type(literal_string: str, datatype=XSD.string):
    literal = Literal(literal_string, datatype=datatype)
    return literal
