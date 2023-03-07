import tkinter as tk
from menus import Menu

class CustomGameMenu(Menu):
    def __init__(self, callback: callable):
        super().__init__(title="Minesweeper - Custom Game", size=(320, 100))

        self.callback = callback

        tk.Label(self, text="Rows:").grid(row=0, column=0)
        tk.Label(self, text="Column:").grid(row=1, column=0)

        self.width_entry = tk.Entry(self)
        self.width_entry.insert(0, "9")
        self.width_entry.grid(row=0, column=1)

        self.height_entry = tk.Entry(self)
        self.height_entry.insert(0, "9")
        self.height_entry.grid(row=1, column=1)

        Menu.create_button(self, 2, 0, text="Cancel", height = 32, command=self.destroy)
        Menu.create_button(self, 2, 1, text="Confirm", height = 32, command=self.send_informations)

    def send_informations(self):
        size = (
            int(self.width_entry.get()),
            int(self.height_entry.get())
        )

        self.callback(size)
        self.destroy()


if __name__ == "__main__":
    menu = CustomGameMenu(None)
    menu.mainloop()