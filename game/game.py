import tkinter as tk
from random import randint
from .menus import Menu

class Game(Menu):
    GREEN1 = "DarkOliveGreen2"
    GREEN2 = "DarkOliveGreen3"

    BROWN1 = "NavajoWhite2"
    BROWN2 = "NavajoWhite3"

    def __init__(self, end_callback: callable, size: tuple = (9, 9), mines_percentage: float = 0.15):
        super().__init__(title="Minesweeper")
        self.end_callback = end_callback
        self.btn_size = 64
        self.size = size
        
        window_size = (min(1280, self.btn_size*size[0]), min(720, self.btn_size*size[1]))
        game_frame = tk.Frame(self, width=window_size[0], height=window_size[1])
        game_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        self.geometry(f"{min(1280, self.btn_size*size[0])}x{min(720, self.btn_size*size[1])}")

        self.drapeau = tk.PhotoImage(master=self, file ='Drapeau.png') # 'pyimage1'
        self.pixel = tk.PhotoImage(master=self, width=50, height=50)   # 'pyimage2'
        self.bombimage = tk.PhotoImage(master=self, file ='assets/bomb.png') # 'pyimage3'

        self.minesweeper = [[0 for i in range(size[0])] for j in range(size[1])]

        boxes_number = size[0] * size[1]
        mines_to_place = min(int(boxes_number * mines_percentage), boxes_number-1)
        self.placed_mines = mines_to_place

        print(mines_to_place)
        while mines_to_place > 0:
            rand_x = randint(0, size[0]-1)
            rand_y = randint(0, size[1]-1)
            if self.minesweeper[rand_y][rand_x] != 1:
                self.minesweeper[rand_y][rand_x] = 1
                mines_to_place -= 1

        print("\n".join(str(e) for e in self.minesweeper))

        self.minesgrid = {}
        for row in range(len(self.minesweeper)):
            for column in range(len(self.minesweeper[row])):
                if (row%2 == 0 and column%2 ==0) or (row%2 == 1 and column%2 == 1):
                    self.minesgrid[(row, column)] = Menu.create_button(game_frame, row, column, compound=tk.CENTER, width=self.btn_size, height=self.btn_size, image=self.pixel, bg=Game.GREEN1, bd=0)
                else:
                    self.minesgrid[(row, column)] = Menu.create_button(game_frame, row, column, compound=tk.CENTER, width=self.btn_size, height=self.btn_size, image=self.pixel, bg=Game.GREEN2, bd=0)


        for button in self.minesgrid.values():
            if button['text'] == "" or button["color"] in [Game.BROWN1, Game.BROWN2]:
                button.bind("<Button-1>", self.on_button_click)
                button.bind("<Button-3>", self.flag)
    
    def want_to_discover(self, event):
        self.discover(event.widget)
        
    def discover(self, button):
        if button["image"] == 'pyimage1':
            return
        
        for key, value in self.minesgrid.items():
            if value == button:
                x, y = key
        
        voisins = self.voisin(x, y)

        nb_mines = sum([self.minesweeper[x1][y1] for x1,y1 in voisins])
        nb_drapeau = sum([1 for x1,y1 in voisins if self.minesgrid[(x1,y1)]["image"] == 'pyimage1'])
        if nb_mines == nb_drapeau:
            for x1,y1 in voisins:
                button_near = self.minesgrid[(x1, y1)]
                if not button_near["bg"] in [Game.BROWN1, Game.BROWN2]:

                    self.afficher_nb_mines(x1, y1)
                    self.discover(button_near)

    def perdu(self, x, y):
        for x in range(len(self.minesweeper)):
            for y in range(len(self.minesweeper[x])):
                if self.minesweeper[x][y] == 1:
                    self.bomb(x,y)

        
        self.end_callback(self, False, 0, 0, self.placed_mines)
        print("perdu")

    def afficher_nb_mines(self, x, y):
        if self.minesgrid[(x,y)]['image'] != 'pyimage1':
            if self.minesweeper[x][y] != 1:
                
                voisins = self.voisin(x,y)
                nb_mines = sum([self.minesweeper[x1][y1] for x1,y1 in voisins])

                button = self.minesgrid[(x,y)]
                if nb_mines != 0:
                    if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
                        button.config(bg=Game.BROWN1, text = nb_mines)
                    else:
                        button.config(bg=Game.BROWN2, text = nb_mines)
                else:
                    if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
                        button.config(bg=Game.BROWN1)
                    else:
                        button.config(bg=Game.BROWN2)
                
                    self.discover(button)
                self.minesgrid[(x,y)].bind("<Button-2>", self.want_to_discover)

    def on_button_click(self, event):
        button = event.widget
        if button["image"] != 'pyimage1':
            if button["bg"] in [Game.BROWN1, Game.BROWN2]:
                self.discover(button)
            else:
                for key, value in self.minesgrid.items():
                    if value == button:
                        x, y = key
                        if self.minesweeper[x][y] ==0:
                            self.afficher_nb_mines(x, y)
                        else:
                            self.perdu(x,y)
                        break
        

    def voisin(self, x, y):
        liste = [-1,0,1]
        voisins = []
        for i in liste:
            for j in liste:
                if 0<= x+i <= self.size[1]-1 and 0<= y+j <= self.size[0]-1:
                    voisins.append((x+i, y+j))

        return voisins
                
    def flag(self, event):
        button = event.widget
        if button["bg"] in [Game.GREEN1, Game.GREEN2]:
            if(button['image']=='pyimage1'):
                button.config(image='pyimage2')   
            else:
                button.config(image='pyimage1')

    def bomb(self,x,y):
        button = self.minesgrid[(x,y)]
        if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
            button.config(bg=Game.BROWN1, image='pyimage3')
        else:
            button.config(bg=Game.BROWN2, image='pyimage3')
         

class Lose(Menu):
    def __init__(self, callback, game_menu: Game, time=0, remaining_mines = 0, mines_to_place = 0):
        self.mines_to_place = mines_to_place
        self.time = time
        self.remaining_mines = remaining_mines

        self.callback = callback
        self.game_menu = game_menu

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
        self.callback()
        self.destroy()
        self.game_menu.destroy()
            
if __name__ == "__main__":
    game = Game()
    game.mainloop()