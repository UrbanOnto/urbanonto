import pandas
import psycopg2
import psycopg2.extras as extras
from psycopg2._psycopg import cursor
import logging


def import_data_from_csv_to_db_table(csv_file_path: str, cursor: cursor, table_name: str):
    dataframe = pandas.read_csv(csv_file_path)
    tuples = [tuple(x) for x in dataframe.to_numpy()]
    cols = ','.join(list(dataframe.columns))
    query = "INSERT INTO %s(%s) VALUES(%%s,%%s,%%s)" % (table_name, cols)
    try:
        extras.execute_batch(cursor, query, tuples, 100)
        cursor.connection.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.info (msg="Error: %s" % error)
        cursor.connection.rollback()
