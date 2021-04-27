import logging

from database.import_to_database.db_utils.database_connector import connect_to_db
from database.import_to_database.importers.csv_files_importer import import_data_from_csv_files


def orchestrate_import(manifestation_csv_files_folder_path: str, host: str, port: str, database: str, user: str, password: str):
    logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.INFO,datefmt='%m/%d/%Y %I:%M:%S %p')
    db_cursor = connect_to_db(host=host, port=port, database=database,user=user, password=password)
    import_data_from_csv_files(cursor=db_cursor, manifestation_csv_files_folder_path=manifestation_csv_files_folder_path)
    db_cursor.close()