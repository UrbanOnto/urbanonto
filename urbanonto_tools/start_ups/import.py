from orchestrators.excel_import_orchestrator import orchestrate_import

orchestrate_import(excel_file_path=r'../data/definitions', ontology_iri=r'../data/urbanonto.ttl')