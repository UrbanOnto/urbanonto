from database_initial_population.import_to_database.reference_dataset_importers.ontology_data_importer import import_data_from_ontology


def import_reference_data(cursor, ontology_iri: str):
    import_data_from_ontology(ontology_iri=ontology_iri, cursor=cursor)
