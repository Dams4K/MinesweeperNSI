import tkinter as tk
from .menus import Menu

class GameCreationMenu(Menu):
    def __init__(self, callback):
        super().__init__("Minesweeper - New Game", size=(720, 720))
        self.callback = callback

        title = tk.Label(self, text="Minesweeper", font=Menu.FONT.format(size=32))
        title.pack()

        size = (384, 384)

        button_frame = tk.Frame(self, width=size[0], height=size[1])
        button_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        Menu.create_button(
            button_frame, 1, 1, text="9x9", width=size[0]/2, height=size[1]/2,
            command=lambda: self.create_game((9, 9))
        )
        Menu.create_button(
            button_frame, 1, 2, text="24x24", width=size[0]/2, height=size[1]/2,
            command=lambda: self.create_game((24, 24))
        )
        Menu.create_button(
            button_frame, 2, 1, text="12x12", width=size[0]/2, height=size[1]/2,
            command=lambda: self.create_game((12, 12))
        )
        Menu.create_button(
            button_frame, 2, 2, text="?x?", width=size[0]/2, height=size[1]/2,
            command=lambda: CustomGameMenu(callback=self.create_game)
        )

        credits_label = tk.Label(self, text="By: Linghun | Dams4K", font=Menu.FONT.format(size=8)) # Yes those are our nicknames
        credits_label.pack(side=tk.BOTTOM)
    
    def create_game(self, minesweeper_size: tuple, mines_percentage: float = 0.15):
        self.callback(minesweeper_size, mines_percentage)
        self.destroy()


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
    menu = GameCreationMenu()
    menu.mainloop()