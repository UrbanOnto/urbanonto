import logging

from database.importers.database_connector import connect_to_db
from database.importers.import_orchestrator import orchestrate_import
from database.importers.reference_dataset_importers.reference_dataset_importer import import_reference_data

orchestrate_import(
    ontology_iri='http://purl.org/urbanonto',
    manifestation_csv_files_folder_path=r'D:\projects\ihpan\urbanonto\urbanonto_tools\database\data')