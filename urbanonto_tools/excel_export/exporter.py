import numpy
import pandas
import rdflib
import xlrd
from rdflib import Graph, Literal, URIRef, RDFS, OWL, RDF, SKOS, XSD
import re

from excel_export.excel_file_constants import *


def export_all_entities_from_excel_file_to_ontology(excel_file_path: str, ontology_file_path: str):
    main_ontology = Graph()
    import_ontology = Graph()
    main_ontology = main_ontology.parse(ontology_file_path, format='n3')
    import_ontology = import_ontology.parse('../data/bdot10k.ttl',format='n3')
    excel_sheet_dataframes = pandas.read_excel(excel_file_path, sheet_name=None, header=None)
    object_count = 0
    for excel_sheet_dataframe in excel_sheet_dataframes.values():
        entity = URIRef('https://purl.org/urbanonto#object_type' + '_' + str(object_count))
        main_ontology.add((entity,RDF.type, OWL.Class))
        object_count += 1
        for index, row in excel_sheet_dataframe.iterrows():
            pl_row_value = str(row[1]).replace('nan','')
            en_row_value = str(row[2]).replace('nan','')
            if index == NAME_ROW_NO:
                if len(pl_row_value) > 0:
                    name_pl_literal = Literal(pl_row_value,lang='pl')
                    main_ontology.add((entity, RDFS.label,name_pl_literal))
                if len(en_row_value) > 0:
                    name_en_literal = Literal(en_row_value,lang='en')
                    main_ontology.add((entity, RDFS.label, name_en_literal))
            if index == DEFINITION_ROW_NO:
                if len(pl_row_value) > 0:
                    def_pl_literal = Literal(pl_row_value,lang='pl')
                    main_ontology.add((entity, RDFS.isDefinedBy,def_pl_literal))
                if len(en_row_value) > 0:
                    def_en_literal = Literal(en_row_value,lang='en')
                    main_ontology.add((entity, RDFS.isDefinedBy, def_en_literal))
            if index == COMMENT_ROW_NO:
                if len(pl_row_value) > 0:
                    comment_pl_literal = Literal(pl_row_value,lang='pl')
                    main_ontology.add((entity, RDFS.comment,comment_pl_literal))
                if len(en_row_value) > 0:
                    comment_en_literal = Literal(en_row_value,lang='en')
                    main_ontology.add((entity, RDFS.comment, comment_en_literal))
            if index == SYNONYM_PL_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='pl',ontology=main_ontology)
            if index == SYNONYM_EN_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='en',ontology=main_ontology)
            if index == SYNONYM_LAT_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='la',ontology=main_ontology)
            if index == SYNONYM_DE_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='de',ontology=main_ontology)
            if index == SYNONYM_FR_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='fr',ontology=main_ontology)
            if index == SYNONYM_RUS_ROW_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value,subject=entity,predicate=SKOS.altLabel,lang='ru',ontology=main_ontology)
            if index == SIMILAR_TERMS_NO:
                if len(pl_row_value) > 0:
                    __split_cell_into_literals(cell=pl_row_value, subject=entity, predicate=SKOS.hiddenLabel, lang='pl', ontology=main_ontology)
                if len(en_row_value) > 0:
                    __split_cell_into_literals(cell=en_row_value, subject=entity, predicate=SKOS.hiddenLabel, lang='en', ontology=main_ontology)
            if index == OTHER_DEF_ROW_NO:
                if len(pl_row_value) > 0:
                    other_def_pl_literal = Literal(pl_row_value,lang='pl')
                    main_ontology.add((entity, RDFS.seeAlso,other_def_pl_literal))
                if len(en_row_value) > 0:
                    other_def_en_literal = Literal(en_row_value,lang='en')
                    main_ontology.add((entity, RDFS.seeAlso, other_def_en_literal))
            if index == BDOT_ROW_NO:
                if len(pl_row_value) > 0:
                    bdot_label = Literal(pl_row_value, datatype=XSD.string)
                    bdot_objects = list(import_ontology.subjects(predicate=RDFS.label,object=bdot_label))
                    if len(bdot_objects) == 0:
                        print('Was not able to find BDOT name', bdot_label)
                    else:
                        if len(bdot_objects) > 1:
                            print('Multiple BDOT10K objects found for',bdot_label)
                        else:
                            bdot_object = bdot_objects[0]
                            main_ontology.add((entity,RDFS.subClassOf,bdot_object))
            if index == WIKIDATA_ROW_NO:
                if len(pl_row_value) > 0:
                    wikidata_id_literal = Literal('https://www.wikidata.org/wiki/' + pl_row_value,datatype=XSD.url)
                    main_ontology.add((entity, RDFS.seeAlso, wikidata_id_literal))

            if index == AUTHOR_ROW_NO:
                if len(pl_row_value) > 0:
                    author_literal = Literal(pl_row_value,datatype=XSD.url)
                    main_ontology.add((entity, URIRef('http://purl.org/dc/terms/creator'), author_literal))


    main_ontology.commit()
    main_ontology.serialize(ontology_file_path, format='turtle')
    main_ontology.close()


def __split_cell_into_literals(cell: str, subject, predicate, lang: str, ontology: Graph):
    values = cell.split(',')
    for value in values:
        object = Literal(value.strip(), lang=lang)
        ontology.add((subject,predicate,object))





