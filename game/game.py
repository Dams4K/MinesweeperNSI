import tkinter as tk
from random import randint
from .menus import Menu
from .tilemap import TileMap
import time

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
        self.mines_percentage = mines_percentage
        self.generated = False

        self.DRAPEAU = tk.PhotoImage(master=self, file ='Drapeau.png')
        self.MINE_IMAGE = tk.PhotoImage(master=self, file ='assets/bomb.png')
        self.tilemap = TileMap("assets/tilemap.png")
        self.tilemap_imgs = {}

        window_size = (min(1280, self.btn_size*size[0]), min(720, self.btn_size*size[1]))
        game_frame = tk.Frame(self, width=window_size[0], height=window_size[1])
        game_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        self.geometry(f"{min(1280, self.btn_size*size[0])}x{min(720, self.btn_size*size[1])}")

        self.minesweeper = [[0 for i in range(size[0])] for j in range(size[1])]
        self.discovered_tiles = set()
        self.found_mines = 0

        self.minesgrid = {}
        for row in range(len(self.minesweeper)):
            for column in range(len(self.minesweeper[row])):
                btn = Menu.create_button(game_frame, row, column, compound=tk.CENTER, width=self.btn_size, height=self.btn_size)
                
                if (row%2 == 0 and column%2 ==0) or (row%2 == 1 and column%2 == 1):
                    btn.config(bg=Game.GREEN1)
                else:
                    btn.config(bg=Game.GREEN2)
                
                
                btn.bind("<Button-1>", self.on_button_click)
                btn.bind("<Button-3>", self.flag)
                self.minesgrid[(column, row)] = btn

    def generate_mines(self, void_tiles: set):
        self.generated = True
        boxes_number = self.size[0] * self.size[1]
        mines_to_place = min(int(boxes_number * self.mines_percentage), boxes_number-1)
        self.placed_mines = 0

        counter = mines_to_place*3

        while mines_to_place > 0:
            counter -= 1
            rand_x = randint(0, self.size[0]-1)
            rand_y = randint(0, self.size[1]-1)

            voisins: set = set(self.voisin(rand_x, rand_y))
            voisins.add((rand_y, rand_x))
            print(voisins, void_tiles, len(voisins.difference(void_tiles)), len(voisins))

            if self.minesweeper[rand_y][rand_x] != 1 and (len(voisins.difference(void_tiles)) == len(voisins) or counter < 1) and (rand_y, rand_x) not in void_tiles:
                self.minesweeper[rand_y][rand_x] = 1
                mines_to_place -= 1
                self.placed_mines += 1

        print("\n".join(str(e) for e in self.minesweeper))

    def update_tilemap(self):
        for pos, button in self.minesgrid.items():
            y, x = pos
            if self.is_brown(button) and self.minesweeper[y][x] != 1:
                vb = self.voisin_brown(x, y)
                img_path = self.tilemap.get_image(**vb)
                self.tilemap_imgs.setdefault(img_path, tk.PhotoImage(master=self, file=img_path))

                button.config(image=self.tilemap_imgs[img_path])


    def want_to_discover(self, event):
        self.discover(event.widget)
        self.update_tilemap()
    
    def discover(self, button):
        if button["image"] == self.DRAPEAU.name:
            return
        
        for key, value in self.minesgrid.items():
            if value == button:
                y, x = key
        
        voisins = self.voisin(x, y)

        nb_mines = sum([self.minesweeper[y1][x1] for y1, x1 in voisins])
        nb_drapeau = sum([1 for y1, x1 in voisins if self.minesgrid[(y1, x1)]["image"] == self.DRAPEAU.name])
        
        if nb_mines == nb_drapeau:
            for y1, x1 in voisins:
                button_near = self.minesgrid[(y1, x1)]
                if not self.is_brown(button_near):
                    self.open_case(x1, y1)
        
        if self.placed_mines == self.size[0]*self.size[1]-len(self.discovered_tiles):
            self.gagne()

    def open_case(self, x, y):
        button = self.minesgrid[(y, x)]
        if button['image'] != self.DRAPEAU.name:
            if self.minesweeper[y][x] != 1:
                voisins = self.voisin(x, y)
                nb_mines = sum([self.minesweeper[y1][x1] for y1, x1 in voisins])
                
                if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
                    button.config(bg=Game.BROWN1)
                else:
                    button.config(bg=Game.BROWN2)

                if nb_mines == 0:
                    self.discover(button)
                else:
                    button.config(text=nb_mines)

                button.unbind("<Button-1>")
                button.bind("<Button-1>", self.want_to_discover)
                self.discovered_tiles.add((y, x))
            else:
                self.perdu(x, y)

    def perdu(self, x, y):
        # show mines
        for y in range(len(self.minesweeper)):
            for x in range(len(self.minesweeper[y])):
                if self.minesweeper[y][x] == 1:
                    self.bomb(x, y)

        self.end_callback(self, False, 0, self.found_mines, self.placed_mines)
        print("perdu")

    def gagne(self):
        print("gagné")
        self.end_callback(self, True, 0, 0, self.placed_mines)

    def on_button_click(self, event):
        button = event.widget

        for key, value in self.minesgrid.items():
            if value == button:
                y, x = key

                if not self.generated:
                    self.generate_mines({(y, x)})

                if button["image"] != self.DRAPEAU.name:
                    self.open_case(x, y)
        
        self.update_tilemap()
    
    def is_brown(self, button):
        return button["bg"] in [Game.BROWN1, Game.BROWN2]

    def voisin_brown(self, x, y):
        v = {
            "l": False,
            "r": False,
            "t": False,
            "b": False,
            "tl": False,
            "tr": False,
            "bl": False,
            "br": False
        }

        for y0, x0 in self.voisin(x, y):
            brown = self.is_brown(self.minesgrid[(y0, x0)])
            if not brown:
                continue

            j = x0 - x
            i = y0 - y

            if i == -1 and j == 0:
                v["l"] = True
            elif i == 1 and j == 0:
                v["r"] = True
            elif i == 0 and j == -1:
                v["t"] = True
            elif i == 0 and j == 1:
                v["b"] = True

            elif i == j == -1:
                v["tl"] = True
            elif i == j == 1:
                v["br"] = True
            elif i == -j == -1:
                v["bl"] = True
            elif i == -j == 1:
                v["tr"] = True
        return v


    def voisin(self, x, y):
        liste = [-1,0,1]
        voisins = []

        for j in liste:
            for i in liste:
                if 0 <= x+i < self.size[0] and 0 <= y+j < self.size[1]:
                    voisins.append((y+j, x+i))

        return voisins
                
    def flag(self, event):
        button = event.widget
        for key, value in self.minesgrid.items():
            if value == button:
                y, x = key
        if button["bg"] in [Game.GREEN1, Game.GREEN2]:
            if(button['image'] == self.DRAPEAU.name):
                button.config(image='')
                if self.minesweeper[y][x] == 1:
                    self.found_mines -=1
                    print("mines :", self.found_mines)
            else:
                button.config(image=self.DRAPEAU.name)
                if self.minesweeper[y][x] == 1:
                    self.found_mines +=1
                    print("mines :", self.found_mines)
        

    def bomb(self, x, y):
        button = self.minesgrid[(y, x)]
        if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
            button.config(bg=Game.BROWN1, image=self.MINE_IMAGE.name)
        else:
            button.config(bg=Game.BROWN2, image=self.MINE_IMAGE.name)
         

class Lose(Menu):
    def __init__(self, callback, game_menu: Game, time=0, found_mines = 0, mines_to_place = 0):
        self.mines_to_place = mines_to_place
        self.time = time
        self.found_mines = found_mines

        self.callback = callback
        self.game_menu = game_menu

        size=(512,512)

        super().__init__( "Game Over", size)


        lose_frame = tk.Frame(self, width=size[0], height=size[1])
        lose_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        tk.Label(lose_frame, text="Oh no ! You have lost :(", font=Menu.FONT.format(size=32)).grid(row=0, column=0)
        
        lose_buttons = tk.Frame(lose_frame, width=size[0], height=size[1]/2)
        lose_buttons.grid(row = 1, column = 0)
        Menu.create_button(lose_buttons, 0, 0, text="New Game", height = 32, command=lambda: self.new_game(True))
        Menu.create_button(lose_buttons, 0, 1, text="Quit", height = 32, command=lambda: self.new_game(False))

        lose_stats = tk.Frame(lose_frame, width=size[0], height=size[1]/2)
        lose_stats.grid(row = 2, column = 0)
        tk.Label(lose_stats, text=f"{found_mines}/{mines_to_place} discovered mines.").grid(row=0,column=0)


    def new_game(self, replay: bool):
        if replay:
            self.callback()
        self.destroy()
        self.game_menu.destroy()
            
if __name__ == "__main__":
    game = Game()
    game.mainloop()

class Win(Menu):
    def __init__(self, callback, game_menu: Game, time=0, mines_to_place = 0):
        self.mines_to_place = mines_to_place
        self.time = time

        self.callback = callback
        self.game_menu = game_menu

        size=(512,512)

        super().__init__( "Game Over", size)


        win_frame = tk.Frame(self, width=size[0], height=size[1])
        win_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        tk.Label(win_frame, text="Yeaah ! You have won :)", font=Menu.FONT.format(size=32)).grid(row=0, column=0)
        
        win_buttons = tk.Frame(self, width=size[0], height=size[1])
        win_buttons.place(relx=0.5, rely=0.6, anchor=tk.CENTER)
        Menu.create_button(win_buttons, 0, 0, text="New Game", height = 32, command=lambda: self.new_game(True))
        Menu.create_button(win_buttons, 0, 1, text="Quit", height = 32, command=lambda: self.new_game(False))

    def new_game(self, replay: bool):
        if replay:
            self.callback()
        self.destroy()
        self.game_menu.destroy()
            
if __name__ == "__main__":
    game = Game()
    game.mainloop()
