import argparse
import logging

from database.export_from_excel.excel_exporter import export_to_csv_files
from database.import_to_database.import_orchestrator import orchestrate_import


# if __name__ == "__main__":
#     parser = argparse.ArgumentParser(description='Export data from Excel to postgres database')
#     parser.add_argument('--folder', help='Path to folder', metavar='FOLDER')
#     parser.add_argument('--file', help='File name', metavar='FILE')
#     parser.add_argument('--user', help='User name', metavar='USER')
#     parser.add_argument('--password', help='Password', metavar='PASSWORD')
#     args = parser.parse_args()
#
#     logging.basicConfig(format='%(levelname)s %(asctime)s %(message)s', level=logging.WARNING ,datefmt='%m/%d/%Y %I:%M:%S %p')
#
#     export_to_csv_files(
#         folder_name=args.folder,
#         excel_file_name=args.file)
#
#     orchestrate_import(
#         csv_files_folder_path=args.folder,
#         host='hgis.ihpan.edu.pl',
#         port='5432',
#         database='house_work',
#         user=args.user,
#         password=args.password)

export_to_csv_files(
    folder_name=r'***',
    excel_file_name='***')

orchestrate_import(
    csv_files_folder_path=r'***',
    host='***',
    port='***',
    database='***',
    user='***',
    password='***')


