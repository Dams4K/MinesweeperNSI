import tkinter as tk
from menus import Menu

class CustomGameMenu(Menu):
    def __init__(self):
        super().__init__(title="Minesweeper - Custom Game", size=(320, 160))


if __name__ == "__main__":
    menu = CustomGameMenu()
    menu.mainloop()