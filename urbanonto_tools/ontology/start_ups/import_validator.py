import sys

from ontology.orchestrators.excel_import_validation_orchestrator import orchestrate_import_validation

orchestrate_import_validation(excel_file_path=str(sys.argv[1]))
