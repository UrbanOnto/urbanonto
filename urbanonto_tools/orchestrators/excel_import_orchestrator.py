from excel_exporters.exporter import export_all_entities_from_excel_file_to_ontology
import logging


def orchestrate_import(excel_file_path: str, ontology_iri: str):
    logging.basicConfig(format='%(asctime)s %(message)s', level=logging.INFO, datefmt='%m/%d/%Y %I:%M:%S %p')
    ontology = export_all_entities_from_excel_file_to_ontology(excel_file_path=excel_file_path,
                                                               ontology_iri=ontology_iri)
    ontology.serialize(ontology_iri, format='turtle')
    ontology.close()

