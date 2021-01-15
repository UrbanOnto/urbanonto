import logging

import pandas
from rdflib import RDFS, SKOS

from ontology.constants.excel_file_constants import *
from ontology.constants.ontology_constants import *
from ontology.excel_exporters import create_iri_for_object_in_type
from ontology.excel_exporters.function_exporter import add_functions_to_entity
from ontology.excel_exporters import add_parts_to_entity, add_wholes_to_entity
from ontology.excel_exporters.reference_data_exporter import export_reference_data
from ontology.owl_handlers.literal_creators import *
from ontology.owl_handlers.owl_importer import add_recursively_owl_imports_to_ontology
from ontology.owl_handlers.owl_restriction_getter import *
from ontology.owl_handlers.register import Register


def export_all_entities_from_excel_file_to_ontology(excel_file_path: str, ontology_iri: str,
                                                    include_en=False) -> Graph():
    ontology = Graph()
    ontology = ontology.parse(ontology_iri, format='n3')
    ontology_with_imports = Graph()
    ontology_with_imports = ontology_with_imports.parse(ontology_iri, format='n3')
    ontology_with_imports = add_recursively_owl_imports_to_ontology(ontology=ontology_with_imports,
                                                                    ontology_iri=URIRef('http://purl.org/urbanonto'))

    Register.update_register_from_ontology(ontology=ontology_with_imports)

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
        bdot10k_found = False
        for index, row in excel_sheet_dataframe.iterrows():
            object_type, bdot10k_found = \
                __export_pl_row(
                    sheet_name=excel_sheet_name,
                    index=index,
                    row=row,
                    ontology=ontology,
                    ontology_with_imports=ontology_with_imports,
                    object_type=object_type,
                    bdot10k_found=bdot10k_found)
            if include_en:
                __export_en_row(
                    sheet_name=excel_sheet_name,
                    index=index,
                    row=row,
                    ontology=ontology,
                    object_type=object_type)
        if not bdot10k_found:
            logging.warning(msg='No BDOT10k object found for ' + excel_sheet_name)
    if ill_formed_sheet_count > 0:
        logging.warning(msg='There are ' + str(ill_formed_sheet_count) + ' ill-formed sheets in workbook.')
    ontology.commit()
    return ontology


def __split_cell_into_literals(cell: str, subject, predicate, lang: str, ontology: Graph):
    values = cell.split(',')
    for value in values:
        cell_value = Literal(value.strip(), lang=lang)
        ontology.add((subject, predicate, cell_value))


def __export_pl_row(sheet_name: str, index, row, ontology: Graph, ontology_with_imports: Graph, object_type: URIRef,
                    bdot10k_found: bool) -> tuple:
    pl_row_value = str(row[1]).replace('nan', '')

    if index == NAME_ROW_NO:
        if len(pl_row_value) > 0:
            name_pl_literal = Literal(pl_row_value, lang='pl')
            if name_pl_literal in Register.labels_to_iris_map.keys():
                object_type = Register.labels_to_iris_map[name_pl_literal]
                logging.warning(
                    msg='Object type with label ' + pl_row_value + ' already exists in ontology. Is this intended?')
            else:
                ontology.add((object_type, RDF.type, OWL.Class))
                ontology.add((object_type, RDFS.label, name_pl_literal))
                Register.labels_to_iris_map.update({name_pl_literal: object_type})
        else:
            logging.warning('No PL name in ' + sheet_name)

    if index == DEFINITION_ROW_NO:
        if len(pl_row_value) > 0:
            def_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.isDefinedBy, def_pl_literal))
        else:
            logging.warning('No PL definition in ' + sheet_name)

    if index == MAIN_FUNCTION_ROW_NO:
        if len(pl_row_value) > 0:
            add_functions_to_entity(
                functions_string=pl_row_value,
                object_type=object_type,
                function_property=HAS_FUNCTION,
                ontology=ontology,
                ontology_with_imports=ontology_with_imports,
                excel_sheet_name=sheet_name)
        else:
            logging.info('No proper function in ' + sheet_name)

    if index == ADDITIONAL_FUNCTION_ROW_NO:
        if len(pl_row_value) > 0:
            add_functions_to_entity(
                functions_string=pl_row_value,
                object_type=object_type,
                function_property=HAS_IMPROPER_FUNCTION,
                ontology=ontology,
                ontology_with_imports=ontology_with_imports,
                excel_sheet_name=sheet_name)

    if index == FORM_ROW_NO:
        export_reference_data(
            iri=object_type,
            reference_data=pl_row_value,
            ontology=ontology,
            reference_ontology=ontology_with_imports,
            sheet_name=sheet_name,
            reference_type='forma',
            reference_link_type=HAS_FORM,
            reference_object_function=get_owl_some_values_restriction,
            literal_creator=create_literal_with_lang)

    if index == PART_ROW_NO:
        if len(pl_row_value) > 0:
            add_parts_to_entity(
                excel_sheet_name=sheet_name,
                parts_string=pl_row_value,
                entity=object_type,
                ontology=ontology)

    if index == WHOLE_ROW_NO:
        if len(pl_row_value) > 0:
            add_wholes_to_entity(
                excel_sheet_name=sheet_name,
                wholes_string=pl_row_value,
                entity=object_type,
                ontology=ontology)

    if index == LEGAL_STATUS_ROW_NO:
        export_reference_data(
            iri=object_type,
            reference_data=pl_row_value,
            ontology=ontology,
            reference_ontology=ontology_with_imports,
            sheet_name=sheet_name,
            reference_type='status prawny',
            reference_link_type=HAS_STATUS,
            reference_object_function=get_owl_has_value_restriction,
            literal_creator=create_literal_with_lang)

    if index == COMMENT_ROW_NO:
        if len(pl_row_value) > 0:
            comment_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.comment, comment_pl_literal))
        else:
            logging.info('No PL comment in ' + sheet_name)

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

    if index == OTHER_DEF_ROW_NO:
        if len(pl_row_value) > 0:
            other_def_pl_literal = Literal(pl_row_value, lang='pl')
            ontology.add((object_type, RDFS.seeAlso, other_def_pl_literal))

    if index == BDOT_L1_ROW_NO or index == BDOT_L2_ROW_NO or index == BDOT_L3_ROW_NO:
        bdot10k_locally_found = \
            export_reference_data(
                reference_data=pl_row_value,
                iri=object_type,
                ontology=ontology,
                reference_ontology=ontology_with_imports,
                sheet_name=sheet_name,
                reference_link_type=RDFS.subClassOf,
                reference_type='BDOT10K',
                reference_object_function=get_null_restriction,
                literal_creator=create_literal_with_type)

        if not bdot10k_found:
            bdot10k_found = bdot10k_locally_found

    if index == WIKIDATA_ROW_NO:
        if len(pl_row_value) > 0:
            wikidata_id_literal = Literal('https://www.wikidata.org/wiki/' + pl_row_value, datatype=XSD.url)
            ontology.add((object_type, RDFS.seeAlso, wikidata_id_literal))

    if index == AUTHOR_ROW_NO:
        if len(pl_row_value) > 0:
            author = create_iri_for_object_in_type(type_local_fragment='person', index=pl_row_value)
            if author is None:
                return object_type, bdot10k_found
            ontology.add((author, RDF.type, URIRef('http://www.cidoc-crm.org/cidoc-crm/E21_Person')))
            ontology.add((object_type, URIRef('http://purl.org/dc/terms/creator'), author))
        else:
            logging.warning('No author in ' + sheet_name)

    return object_type, bdot10k_found


def __export_en_row(sheet_name: str, index, row, ontology: Graph, object_type: URIRef):
    en_row_value = str(row[2]).replace('nan', '')

    if index == NAME_ROW_NO:
        if len(en_row_value) > 0:
            name_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.label, name_en_literal))
        else:
            logging.info('No EN name in ' + sheet_name)

    if index == DEFINITION_ROW_NO:
        if len(en_row_value) > 0:
            def_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.isDefinedBy, def_en_literal))
        else:
            logging.info('No EN definition in ' + sheet_name)

    if index == COMMENT_ROW_NO:
        if len(en_row_value) > 0:
            comment_en_literal = Literal(en_row_value, lang='en')
            ontology.add((object_type, RDFS.comment, comment_en_literal))
        else:
            logging.info('No EN comment in ' + sheet_name)

    if index == SIMILAR_TERMS_NO:
        if len(en_row_value) > 0:
            __split_cell_into_literals(cell=en_row_value, subject=object_type, predicate=SKOS.hiddenLabel, lang='en',
                                       ontology=ontology)
