import logging

from database.export_from_excel.excel_exporter import export_to_csv_files
from database.import_to_database.import_orchestrator import orchestrate_import

export_to_csv_files(
    excel_folder_name=r'D:\projects\ihpan\urbanonto\database\inputs\db_csv_files',
    excel_file_name='urbanonto_inputs_202104261547.xlsx',
    version='urbanonto_inputs_202104261547')

orchestrate_import(
    manifestation_csv_files_folder_path=r'D:\projects\ihpan\urbanonto\database\inputs\db_csv_files',
    host='localhost',
    port='5432',
    database='urbanonto',
    user='postgres',
    password='sagan1')


