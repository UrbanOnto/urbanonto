import tkinter
from tkinter.ttk import Label, Entry, Button


class DbGuiConfirmations:
    def __init__(self):
        self.__window = tkinter.Tk()
        self.__window.title('Confirm database update')
        self.__window.geometry('400x150')

        db_confirmation_label = tkinter.Label(text="Are you sure that you want to update database?")
        db_confirmation_label.grid(row=0, column=1)

        ok_button = tkinter.Button(text='Yes', command=self.__return_on_ok)
        cancel_button = tkinter.Button(text='No', command=self.__return_on_cancel)
        ok_button.grid(row=1, column=0)
        cancel_button.grid(row=2, column=2)

        self.__window.mainloop()

    def __return_on_ok(self):
        self.update = True
        self.__window.quit()

    def __return_on_cancel(self):
        self.update = False
        self.__window.quit()



