from rdflib import URIRef

ONTOLOGY_IRI = 'https://purl.org/urbanonto'
IS_PART_OF_IRI = URIRef('http://www.cidoc-crm.org/cidoc-crm/P46i_forms_part_of')
HAS_PART_IRI = URIRef('http://www.cidoc-crm.org/cidoc-crm/P46_is_composed_of')
HAS_FUNCTION = URIRef('http://purl.org/ontohgis#hasProperFunction')
HAS_OTHER_DEFINITION = URIRef('https://purl.org/urbanonto#isAlsoDefinedBy')