import logging

from database.importers.database_connector import connect_to_db
from database.importers.reference_dataset_importers.reference_dataset_importer import import_reference_data


def orchestrate_import(ontology_iri='http://purl.org/urbanonto'):
    logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.INFO,datefmt='%m/%d/%Y %I:%M:%S %p')
    db_cursor = connect_to_db()
    import_reference_data(cursor=db_cursor, ontology_iri=ontology_iri)
    db_cursor.close()