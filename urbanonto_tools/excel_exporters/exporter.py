import pandas
from rdflib import Graph, Literal, URIRef, RDFS, OWL, RDF, SKOS, XSD

from excel_exporters.excel_file_constants import *
from excel_exporters.export_helpers import create_iri_for_object_in_type
from excel_exporters.function_exporter import add_functions_to_entity
from excel_exporters.mereology_exporter import add_parts_to_entity, add_wholes_to_entity
from excel_exporters.ontology_constants import *
from excel_exporters.other_definitions_exporter import add_other_definitions_to_entity
from owl_handlers.owl_importer import add_recursively_owl_imports_to_ontology
from owl_handlers.register import Register
import logging


def export_all_entities_from_excel_file_to_ontology(excel_file_path: str, ontology_file_path: str):
    logging.basicConfig(format='%(asctime)s %(message)s', level=logging.INFO, datefmt='%m/%d/%Y %I:%M:%S %p')
    ontology = Graph()
    ontology = ontology.parse(ontology_file_path, format='n3')
    ontology_with_imports = Graph()
    ontology_with_imports = ontology_with_imports.parse(ontology_file_path, format='n3')
    ontology_with_imports = add_recursively_owl_imports_to_ontology(ontology=ontology_with_imports, ontology_iri=URIRef('https://purl.org/urbanonto'))

    excel_sheet_dataframes = pandas.read_excel(excel_file_path, sheet_name=None, header=None)
    logging.info('There are ' + str(len(excel_sheet_dataframes)) + ' sheets in workbook.')
    ill_formed_sheet_count = 0
    object_type_count = 0
    for excel_sheet_name, excel_sheet_dataframe in excel_sheet_dataframes.items():
        if not excel_sheet_dataframe.shape == EXCEL_SHEET_SHAPE:
            logging.warning('Sheet ' + excel_sheet_name + ' is ill-formed.')
            ill_formed_sheet_count += 1
            continue
        object_type_count += 1
        object_type = create_iri_for_object_in_type(type_local_fragment=OBJECT_TYPE_LOCAL_FRAGMENT)

        for index, row in excel_sheet_dataframe.iterrows():
            __export_row(
                excel_sheet_name=excel_sheet_name,
                index=index,
                row=row,
                ontology=ontology,
                ontology_with_imports=ontology_with_imports,
                object_type=object_type)
    if ill_formed_sheet_count > 0:
        logging.warning(msg='There are ' + str(ill_formed_sheet_count) + ' ill-formed sheets in workbook.')
    ontology.commit()
    ontology.serialize(ontology_file_path, format='turtle')
    ontology.close()


def __split_cell_into_literals(cell: str, subject, predicate, lang: str, ontology: Graph):
    values = cell.split(',')
    for value in values:
        cell_value = Literal(value.strip(), lang=lang)
        ontology.add((subject, predicate, cell_value))


def __export_row(excel_sheet_name: str, index, row, ontology: Graph, ontology_with_imports: Graph, object_type: URIRef):
    pl_row_value = str(row[1]).replace('nan', '')
    en_row_value = str(row[2]).replace('nan', '')

    if index == NAME_ROW_NO:
        if len(pl_row_value) > 0:
            name_pl_literal = Literal(pl_row_value, lang='pl')
            if name_pl_literal in Register.labels_to_iris_map.keys():
                object_type = Register.labels_to_iris_map[name_pl_literal]
            else:
                ontology.add((object_type, RDF.type, OWL.Class))
                ontology.add((object_type, RDFS.label, name_pl_literal))
                Register.labels_to_iris_map.update({name_pl_literal: object_type})
        else:
            logging.warning('No PL name in ' + excel_sheet_name)
        if len(en_row_value) > 0:
            name_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.label, name_en_literal))
        else:
            logging.info('No EN name in ' + excel_sheet_name)
    if index == DEFINITION_ROW_NO:
        if len(pl_row_value) > 0:
            def_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.isDefinedBy, def_pl_literal))
        else:
            logging.warning('No PL definition in ' + excel_sheet_name)
        if len(en_row_value) > 0:
            def_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.isDefinedBy, def_en_literal))
        else:
            logging.info('No EN definition in ' + excel_sheet_name)
    if index == MAIN_FUNCTION_ROW_NO:
        if len(pl_row_value) > 0:
            add_functions_to_entity(
                functions_string=pl_row_value,
                object_type=object_type,
                function_property=HAS_FUNCTION,
                ontology=ontology,
                ontology_with_imports=ontology_with_imports,
                excel_sheet_name=excel_sheet_name)
        else:
            logging.info('No proper function in ' +  excel_sheet_name)

    if index == ADDITIONAL_FUNCTION_ROW_NO:
        if len(pl_row_value) > 0:
            add_functions_to_entity(
                functions_string=pl_row_value,
                object_type=object_type,
                function_property=HAS_IMPROPER_FUNCTION,
                ontology=ontology,
                ontology_with_imports=ontology_with_imports,
                excel_sheet_name=excel_sheet_name)
    if index == PART_ROW_NO:
        if len(pl_row_value) > 0:
            add_parts_to_entity(
                excel_sheet_name=excel_sheet_name,
                parts_string=pl_row_value,
                entity=object_type,
                ontology=ontology)
    if index == WHOLE_ROW_NO:
        if len(pl_row_value) > 0:
            add_wholes_to_entity(
                excel_sheet_name=excel_sheet_name,
                wholes_string=pl_row_value,
                entity=object_type,
                ontology=ontology)
    if index == COMMENT_ROW_NO:
        if len(pl_row_value) > 0:
            comment_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.comment, comment_pl_literal))
        else:
            logging.info('No PL comment in ' + excel_sheet_name)
        if len(en_row_value) > 0:
            comment_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.comment, comment_en_literal))
        else:
            logging.info('No EN comment in ' + excel_sheet_name)
    if index == SYNONYM_PL_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='pl',
                                       ontology=ontology)
    if index == SYNONYM_EN_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='en',
                                       ontology=ontology)
    if index == SYNONYM_LAT_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='la',
                                       ontology=ontology)
    if index == SYNONYM_DE_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='de',
                                       ontology=ontology)
    if index == SYNONYM_FR_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='fr',
                                       ontology=ontology)
    if index == SYNONYM_RUS_ROW_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.altLabel, lang='ru',
                                       ontology=ontology)
    if index == SIMILAR_TERMS_NO:
        if len(pl_row_value) > 0:
            __split_cell_into_literals(cell=pl_row_value, subject=object_type, predicate=SKOS.hiddenLabel, lang='pl',
                                       ontology=ontology)
        if len(en_row_value) > 0:
            __split_cell_into_literals(cell=en_row_value, subject=object_type, predicate=SKOS.hiddenLabel, lang='en',
                                       ontology=ontology)
    if index == OTHER_DEF_ROW_NO:
        if len(pl_row_value) > 0:
            # add_other_definitions_to_entity(
            #     excel_sheet_name=excel_sheet_name,
            #     other_definitions_string=pl_row_value,
            #     entity=object_type, ontology=ontology)
            other_def_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.seeAlso, other_def_pl_literal))
        # if len(en_row_value) > 0:
        #     other_def_en_literal = Literal(en_row_value, lang='en')
        #     ontology.add((object_type, RDFS.seeAlso, other_def_en_literal))
    if index == BDOT_L1_ROW_NO or index == BDOT_L2_ROW_NO or index == BDOT_L3_ROW_NO:
        if len(pl_row_value) > 0:
            bdot_label = Literal(pl_row_value, datatype=XSD.string)
            bdot_objects = list(ontology_with_imports.subjects(predicate=RDFS.label, object=bdot_label))
            if len(bdot_objects) == 0:
                logging.warning('Exporting from ' + excel_sheet_name + ' I was not able to find BDOT name ' + bdot_label + ' mentioned in ' + excel_sheet_name)
            else:
                if len(bdot_objects) > 1:
                    logging.warning('Exporting from ' + excel_sheet_name + ' multiple BDOT10K objects were found for ' + bdot_label + ' in ' + excel_sheet_name)
                else:
                    bdot_object = bdot_objects[0]
                    ontology.add((object_type, RDFS.subClassOf, bdot_object))
        # else:
        #     logging.warning('No BDOT10K class in', excel_sheet_name)
    if index == WIKIDATA_ROW_NO:
        if len(pl_row_value) > 0:
            wikidata_id_literal = Literal('https://www.wikidata.org/wiki/' + pl_row_value, datatype=XSD.url)
            ontology.add((object_type, RDFS.seeAlso, wikidata_id_literal))

    if index == AUTHOR_ROW_NO:
        if len(pl_row_value) > 0:
            author = create_iri_for_object_in_type(type_local_fragment='person', index=pl_row_value)
            if author is None:
                return
            ontology.add((author, RDF.type, URIRef('http://www.cidoc-crm.org/cidoc-crm/E21_Person')))
            ontology.add((object_type, URIRef('http://purl.org/dc/terms/creator'), author))
        else:
            logging.warning('No author in ' + excel_sheet_name)
