import pandas
import psycopg2
import psycopg2.extras as extras
import rdflib
from psycopg2._psycopg import cursor
import logging

from rdflib import Graph


def import_data_from_sparql_query_to_db_table(sparql_query: str, ontology: Graph, cursor: cursor, table_name: str, columns: list):
    results = ontology.query(sparql_query)
    tuples = list()
    count=0
    for result in results:
        tuple = [count]
        for i in range(0, len(results.vars)):
            tuple.append(result[i])
        tuples.append(tuple)
        count += 1
    columns_string = ','.join(list(columns))
    query = "INSERT INTO %s(%s) VALUES(%%s,%%s,%%s)" % (table_name, columns_string)
    try:
        extras.execute_batch(cursor, query, tuples, 100)
        cursor.connection.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        logging.warning(msg="Error: %s" % error)
        cursor.connection.rollback()
