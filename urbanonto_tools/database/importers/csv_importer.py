import numpy
import pandas
import psycopg2
import psycopg2.extras as extras
from psycopg2._psycopg import cursor
import logging


def import_data_from_csv_to_db_table(csv_file_path: str, cursor: cursor, table_name: str):
    dataframe = pandas.read_csv(csv_file_path)
    # dataframe.fillna(value='NULL',inplace=True)
    original_tuples = [tuple(x) for x in dataframe.to_numpy()]
    new_tuples = []
    for original_tuple in original_tuples:
        new_tuple = list()
        for item in original_tuple:
            if isinstance(item, float):
                if str(item) == 'nan':
                    new_tuple.append(None)
                else:
                    new_tuple.append(int(item))
            else:
                new_tuple.append(item)
        new_tuples.append(new_tuple)
    cols = ','.join(list(dataframe.columns))
    query  = "INSERT INTO %s(%s) VALUES %%s" % (table_name, cols)
    try:
        extras.execute_values(cursor, query, new_tuples)
        cursor.connection.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.warning(msg="Error: %s" % error)
        cursor.connection.rollback()


