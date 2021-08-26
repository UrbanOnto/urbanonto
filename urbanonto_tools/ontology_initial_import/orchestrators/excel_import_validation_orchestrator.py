import logging

from ontology_initial_import.excel_exporters.exporter import export_all_entities_from_excel_file_to_ontology


def orchestrate_import_validation(excel_file_path: str):
    logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.WARNING,
                        datefmt='%m/%d/%Y %I:%M:%S %p')
    ontology = export_all_entities_from_excel_file_to_ontology(excel_file_path=excel_file_path,
                                                               ontology_iri='http://purl.org/urbanonto')
    ontology.close()
