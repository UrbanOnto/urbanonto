from ontology.modularisation.ontology_extractor import orchestrate_extraction

orchestrate_extraction(
    source_ontology_file=r'D:\projects\ihpan\ontology\ontohgis.ttl',
    top_class_uri_str='http://purl.org/ontohgis#object_40',
    extracted_ontology_file='ontohgis_settlement.ttl')
