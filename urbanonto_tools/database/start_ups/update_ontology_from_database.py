from database.import_to_database.db_utils.database_connector import connect_to_db
from database.import_to_database.update_orchestrator import database_update_orchestrator

database_update_orchestrator(
    host='***',
    port='***',
    database='***',
    user='***',
    password='***',
    ontology_iri='***')