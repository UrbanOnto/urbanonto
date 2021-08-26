import tkinter
from tkinter.ttk import Label, Entry, Button


class DbGuiConnections:
    def __init__(self):
        self.host = str()
        self.port = str()
        self.database = str()
        self.user = str()
        self.password = str()

        self.__window = tkinter.Tk()
        self.__window.title('Provide database connection details')
        self.__window.geometry('400x150')

        db_host_label = tkinter.Label(text="Host:")
        self.__db_host_entry = tkinter.Entry()
        db_host_label.grid(row=0, column=0)
        self.__db_host_entry.grid(row=0, column=1)

        db_port_label = tkinter.Label(text="Post:")
        self.__db_port_entry = tkinter.Entry()
        db_port_label.grid(row=1, column=0)
        self.__db_port_entry.grid(row=1, column=1)

        db_database_label = tkinter.Label(text="Database name:")
        self.__db_database_entry = tkinter.Entry()
        db_database_label.grid(row=2, column=0)
        self.__db_database_entry.grid(row=2, column=1)

        db_user_label = tkinter.Label(text="User name")
        self.__db_user_entry = tkinter.Entry()
        db_user_label.grid(row=3, column=0)
        self.__db_user_entry.grid(row=3, column=1)

        db_password_label = tkinter.Label(text="Password")
        self.__db_password_entry = tkinter.Entry(show='*')
        db_password_label.grid(row=4, column=0)
        self.__db_password_entry.grid(row=4, column=1)

        ok_button = tkinter.Button(text='Ok', command=self.__return_on_ok)
        cancel_button = tkinter.Button(text='Cancel', command=self.__return_on_cancel)
        ok_button.grid(row=1, column=2)
        cancel_button.grid(row=3, column=2)

        self.__window.mainloop()

    def __return_on_ok(self):
        self.host = self.__db_host_entry.get()
        self.port = self.__db_port_entry.get()
        self.database = self.__db_database_entry.get()
        self.user = self.__db_user_entry.get()
        self.password = self.__db_password_entry.get()
        self.__window.quit()

    def __return_on_cancel(self):
        self.__window.quit()



