import logging
import os

import numpy
import pandas
import psycopg2
from psycopg2._psycopg import cursor

table_names_map = \
    {
        'date_mappings': 'date_mappings',
        'functions': 'functions',
        'types': 'topographic_types',
        'topographic_objects': 'topographic_objects',
        'name_link_types': 'name_link_types',
        'location_link_types': 'location_link_types',
        'location_datasets': 'location_datasets',
        'publications': 'publication_sources',
        'historical_evidences': 'historical_evidences',
        'locations_raw': 'locations_raw',
        'location_manifestations': 'topographic_object_location_manifestations',
        'function_manifestations': 'topographic_object_function_manifestations',
        'name_manifestations': 'topographic_object_name_manifestations',
        'mereological_manifestations': 'topographic_object_mereological_link_manifestations',
        'object_provenances': 'topographic_object_provenances'
    }

def import_data_from_csv_files(cursor, manifestation_csv_files_folder_path: str):
    psycopg2.extensions.register_adapter(numpy.int64, psycopg2._psycopg.AsIs)
    psycopg2.extensions.register_adapter(float, nan_to_null)
    for csv_file_name, db_table_name in table_names_map.items():
        import_data_from_csv_to_db_table(
            csv_file_path=os.path.join(manifestation_csv_files_folder_path,csv_file_name+'.csv'),
            cursor=cursor,
            table_name='ontology_sources.'+db_table_name)


def import_data_from_csv_to_db_table(csv_file_path: str, cursor: cursor, table_name: str):
    logging.info(msg='Truncating table: %s' % table_name)
    trunc_query = "TRUNCATE %s CASCADE" % (table_name)
    try:
        cursor.execute(query=trunc_query)
        cursor.connection.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.warning(msg="Error: %s" % error)
        cursor.connection.rollback()

    dataframe = pandas.read_csv(csv_file_path)
    if {'start_at_input', 'end_at_input'}.issubset(set(dataframe.columns)):
        dataframe.drop(columns=['start_at_input', 'end_at_input'], inplace=True)
    dataframe.dropna(axis = 0, how = 'all', inplace = True)

    original_tuples = [tuple(x) for x in dataframe.to_numpy()]
    cols = ','.join(list(dataframe.columns))
    success = True
    for original_tuple in original_tuples:
        query = "INSERT INTO %s(%s) VALUES" % (table_name, cols)
        query_value_pattern = ','.join(('s')*len(dataframe.columns))
        query_value_pattern = query_value_pattern.replace('s','%s')
        query = query + ' (' + query_value_pattern + ')'
        try:
            cursor.execute(query, original_tuple)
            cursor.connection.commit()
        except (Exception, psycopg2.DatabaseError) as error:
            logging.warning(msg="Error: %s" % error)
            cursor.connection.rollback()
            success=False

    if success:
        logging.info(msg='Table %s was successfully imported' % table_name)
    else:
        logging.warning(msg='There were problems with importing table %s' % table_name)


def nan_to_null(f,
        _NULL=psycopg2.extensions.AsIs('NULL'),
        _Float=psycopg2.extensions.Float):
    if not numpy.isnan(f):
        return _Float(f)
    return _NULL

