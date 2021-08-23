from database.import_to_database.db_utils.database_connector import connect_to_db
from database.import_to_database.reference_dataset_importers.ontology_data_importer import import_data_from_ontology


def database_update_orchestrator(ontology_iri: str, host: str, port: str, database: str, user: str, password: str):
    db_cursor = connect_to_db(host=host, port=port, database=database, user=user, password=password)
    import_data_from_ontology(ontology_iri=ontology_iri, cursor=db_cursor, )
    db_cursor.close()
