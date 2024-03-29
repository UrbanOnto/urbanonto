from common.db_utils.database_connector import connect_to_db
from database_initial_population.import_to_database.importers.csv_files_importer import import_data_from_csv_files


def orchestrate_import(csv_files_folder_path: str, host: str, port: str, database: str, user: str, password: str):
    db_cursor = connect_to_db(host=host, port=port, database=database, user=user, password=password)
    import_data_from_csv_files(cursor=db_cursor, manifestation_csv_files_folder_path=csv_files_folder_path)
    db_cursor.close()
