import os

import pandas

def export_to_csv_files(folder_name: str, excel_file_name: str):
    excel_file_path = os.path.join(folder_name, excel_file_name)
    sheets = pandas.read_excel(io=excel_file_path,sheet_name=None)
    for sheet_name, sheet_data in sheets.items():
        sheet_data.to_csv(path_or_buf=os.path.join(folder_name, sheet_name + '.csv'), encoding='utf8', index=False)