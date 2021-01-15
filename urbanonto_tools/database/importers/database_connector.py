import psycopg2
import logging

from psycopg2._psycopg import cursor


def connect_to_db()\
    -> cursor:
    conn = None
    logging.info(msg='Trying to connect to database')
    try:
        conn = \
            psycopg2.connect(
                host='localhost',
                port='5433',
                database='urbanonto',
                user='postgres',
                password='sagan1')

        cur = conn.cursor()
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)
    finally:
        if conn is not None:
            return cur

connect_to_db()