import logging

from database.importers.database_connector import connect_to_db
from database.importers.hist_dataset_importers.manifestation_data_importer import import_manifestation_data
from database.importers.reference_dataset_importers.reference_dataset_importer import import_reference_data


def orchestrate_import(ontology_iri: str, manifestation_csv_files_folder_path: str):
    logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.INFO,datefmt='%m/%d/%Y %I:%M:%S %p')
    db_cursor = connect_to_db()
    # import_reference_data(cursor=db_cursor, ontology_iri=ontology_iri)
    import_manifestation_data(cursor=db_cursor,manifestation_csv_files_folder_path=manifestation_csv_files_folder_path)
    db_cursor.close()