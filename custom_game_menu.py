import tkinter as tk
from menus import Menu

class CustomGameMenu(Menu):
    def __init__(self, callback: callable):
        size = (400, 170)
        super().__init__(title="Minesweeper - Custom Game", size=size)

        self.callback = callback

        settings_frame = tk.Frame(self, width=size[0], height=size[1])
        settings_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)

        tk.Label(settings_frame, text="Column:").grid(row=0, column=0)
        tk.Label(settings_frame, text="Rows:").grid(row=1, column=0)

        self.width_entry = tk.Entry(settings_frame)
        self.width_entry.insert(0, "9")
        self.width_entry.grid(row=0, column=1)

        self.height_entry = tk.Entry(settings_frame)
        self.height_entry.insert(0, "9")
        self.height_entry.grid(row=1, column=1)

        self.mines_percentage_scale = tk.Scale(settings_frame, from_=0, to=1, resolution=0.01, orient=tk.HORIZONTAL, label="Mines percentage", font=Menu.FONT.format(size=12))
        self.mines_percentage_scale.set(0.15)
        self.mines_percentage_scale.grid(row=2, column=0, columnspan=2, sticky="we")

        Menu.create_button(settings_frame, 3, 0, text="Cancel", height = 32, command=self.destroy)
        Menu.create_button(settings_frame, 3, 1, text="Confirm", height = 32, command=self.send_informations)

    def send_informations(self):
        size = (
            int(self.width_entry.get()),
            int(self.height_entry.get())
        )

        self.callback(size, float(self.mines_percentage_scale.get()))
        self.destroy()


if __name__ == "__main__":
    menu = CustomGameMenu(None)
    menu.mainloop()