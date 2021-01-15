import os

from database.importers.csv_importer import import_data_from_csv_to_db_table

manifestation_table_names = \
    [
        'topographic_objects',
        'topographic_object_function_manifestations',
        'topographic_object_type_manifestations'
    ]

def import_manifestation_data(cursor, manifestation_csv_files_folder_path: str):
    for manifestation_table_name in manifestation_table_names:
        import_data_from_csv_to_db_table(
            csv_file_path=os.path.join(manifestation_csv_files_folder_path,manifestation_table_name+'.csv'),
            cursor=cursor,
            table_name='ontology.'+manifestation_table_name)