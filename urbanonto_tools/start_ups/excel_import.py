import sys

from excel_exporters.exporter import export_all_entities_from_excel_file_to_ontology

export_all_entities_from_excel_file_to_ontology(excel_file_path=str(sys.argv[1]), ontology_file_path=str(sys.argv[2]))

