from common.db_utils.database_connector import connect_to_db
from common.guis.db_connection_gui import DbGuiConnections
from database_initial_population.import_to_database.reference_dataset_importers.ontology_data_importer import \
    import_data_from_ontology


def synchronise_ontology_with_database():
    gui = DbGuiConnections()
    cursor = connect_to_db(host=gui.host,port=gui.port,database=gui.database,user=gui.user,password=gui.password)
    import_data_from_ontology(cursor=cursor, ontology_iri='http://purl.org/urbanonto')


if __name__ == '__main__':
    synchronise_ontology_with_database()
