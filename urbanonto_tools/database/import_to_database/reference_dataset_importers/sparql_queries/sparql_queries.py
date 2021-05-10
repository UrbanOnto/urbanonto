get_types_of_topographic_objects = \
"""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?type ?label
WHERE
{
?type rdfs:label ?label
FILTER (CONTAINS(str(?type), "object_type"))
FILTER (lang(?label) = "pl")
}
"""


get_functions_of_topographic_objects = \
"""
PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>

SELECT ?function ?label
WHERE
{
?function rdfs:label ?label .
?function a <http://purl.obolibrary.org/obo/BFO_0000034>
FILTER (lang(?label) = "pl")
}
"""