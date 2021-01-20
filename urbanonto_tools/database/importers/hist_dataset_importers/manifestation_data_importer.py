import os

from database.importers.csv_importer import import_data_from_csv_to_db_table

manifestation_table_names = \
    [
        # 'location_dataset_types',
        #'topographic_objects',
        # 'functions',
        # 'topographic_types',
        # 'topographic_names',
        # 'locations',
        # 'topographic_object_function_manifestations',
        # 'topographic_object_type_manifestations',
        # 'topographic_object_name_manifestations',
        'topographic_object_location_manifestations'
    ]

def import_data_from_csv_files(cursor, manifestation_csv_files_folder_path: str):
    for manifestation_table_name in manifestation_table_names:
        import_data_from_csv_to_db_table(
            csv_file_path=os.path.join(manifestation_csv_files_folder_path,manifestation_table_name+'.csv'),
            cursor=cursor,
            table_name='ontology.'+manifestation_table_name)