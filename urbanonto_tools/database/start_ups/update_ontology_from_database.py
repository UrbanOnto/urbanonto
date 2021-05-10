from database.import_to_database.db_utils.database_connector import connect_to_db
from database.import_to_database.update_orchestrator import database_update_orchestrator

database_update_orchestrator(
    host='hgis.ihpan.edu.pl',
    port='5432',
    database='house_work',
    user='garbacz',
    password='Mereolog13',
    ontology_iri='http://purl.org/urbanonto')