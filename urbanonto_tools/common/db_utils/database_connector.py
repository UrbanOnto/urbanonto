import logging

import psycopg2
from psycopg2._psycopg import cursor


def connect_to_db(host: str, port: str, database: str, user: str, password: str) -> cursor:
    conn = None
    logging.info(msg='Trying to connect to database_initial_population')
    try:
        conn = \
            psycopg2.connect(
                host=host,
                port=port,
                database=database,
                user=user,
                password=password)

        cursor = conn.cursor()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            return cursor
