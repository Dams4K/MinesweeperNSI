import tkinter as tk
from menus import Menu
import subprocess

# Il manque l'affichage des stats (time, remaining_mines/mines_to_place)
# sachant que les 2 premières des 3 n'existes pas encore dans minesweeper.py
class Lose(Menu):
    def __init__(self, time=0, remaining_mines = 0, mines_to_place = 0):
        self.mines_to_place = mines_to_place
        self.time = time
        self.remaining_mines = remaining_mines

        size=(512,512)

        super().__init__( "Game Over", size)


        lose_frame = tk.Frame(self, width=size[0], height=size[1])
        lose_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        tk.Label(lose_frame, text="Oh no ! You have lose :(", font=Menu.FONT.format(size=32)).grid(row=0, column=0)
        
        lose_buttons = tk.Frame(self, width=size[0], height=size[1])
        lose_buttons.place(relx=0.5, rely=0.6, anchor=tk.CENTER)
        Menu.create_button(lose_buttons, 0, 0, text="New Game", height = 32, command=self.new_game)
        Menu.create_button(lose_buttons, 0, 1, text="Quit", height = 32, command=self.destroy)

    def new_game(self):
        self.destroy()
        subprocess.call(["python", "MinesweeperNSI/game_creation_menu.py"])

        

        
        
        





if __name__ == "__main__":
    lose = Lose()
    lose.mainloop()