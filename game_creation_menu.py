import tkinter as tk
from menus import Menu
from custom_game_menu import CustomGameMenu
from minesweeper import Game

class GameCreationMenu(Menu):
    def __init__(self):
        super().__init__("Minesweeper - New Game", size=(720, 720))

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
        game = Game(minesweeper_size, mines_percentage)
        self.destroy()


if __name__ == "__main__":
    menu = GameCreationMenu()
    menu.mainloop()