import tkinter as tk
from random import randint
from menus import Menu

class Game(Menu):
    GREEN1 = "DarkOliveGreen2"
    GREEN2 = "DarkOliveGreen3"

    BROWN1 = "NavajoWhite2"
    BROWN2 = "NavajoWhite3"

    def __init__(self, size: tuple = (9, 9), mines_percentage: float = 0.15):
        super().__init__(title="Minesweeper")

        self.btn_size = 64
        self.size = size
        self.geometry(f"{min(1280, self.btn_size*size[0])}x{min(720, self.btn_size*size[1])}")

        self.drapeau = tk.PhotoImage(master=self, file ='Drapeau.png') # 'pyimage1'
        self.pixel = tk.PhotoImage(master=self, width=50, height=50)   # 'pyimage2'

        self.minesweeper = [[0 for i in range(size[0])] for j in range(size[1])]

        boxes_number = size[0] * size[1]
        mines_to_place = min(int(boxes_number * mines_percentage), boxes_number-1)

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
                    self.minesgrid[(row, column)] = Menu.create_button(self, row, column, compound='c', width=self.btn_size, height=self.btn_size, image=self.pixel, bg=Game.GREEN1, bd=0)
                else:
                    self.minesgrid[(row, column)] = Menu.create_button(self, row, column, compound='c', width=self.btn_size, height=self.btn_size, image=self.pixel, bg=Game.GREEN2, bd=0)


        for button in self.minesgrid.values():
            if button['text'] == "" or button["color"] in ["salmon2", "salmon3"]:
                button.bind("<Button-1>", self.on_button_click)
                button.bind("<Button-3>", self.flag)
    
    def discover(self, event):
        button = event.widget
        if button["image"] != 'pyimage1':
            for key, value in self.minesgrid.items():
                if value == button:
                    x, y = key
        voisins = self.voisin(x,y)
        nb_mines = sum([self.minesweeper[x1][y1] for x1,y1 in voisins])
        nb_drapeau = sum([1 for x1,y1 in voisins if self.minesgrid[(x1,y1)]["image"] == 'pyimage1'])
        if nb_mines == nb_drapeau:
            for x1,y1 in voisins:
                self.afficher_nb_mines(x1, y1)

    def perdu(self):
        print("perdu")

    def afficher_nb_mines(self, x, y):
        if self.minesgrid[(x,y)]['image'] != 'pyimage1':
            if self.minesweeper[x][y] == 1:
                self.perdu()
            voisins = self.voisin(x,y)
            nb_mines = sum([self.minesweeper[x1][y1] for x1,y1 in voisins])
            if nb_mines !=0:
                #self.minesgrid[(x,y)] = tk.Button(root, image = pixel, text = nb_mines, justify="center", compound="c")
                if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
                    self.minesgrid[(x,y)].config(bg=Game.BROWN1, text = nb_mines)
                else:
                    self.minesgrid[(x,y)].config(bg=Game.BROWN2, text = nb_mines)
            else:
                if (x%2 == 0 and y%2 ==0) or (x%2 == 1 and y%2 == 1):
                    self.minesgrid[(x,y)].config(bg=Game.BROWN1)
                else:
                    self.minesgrid[(x,y)].config(bg=Game.BROWN2)
            self.minesgrid[(x,y)].grid(row = x, column = y)
            self.minesgrid[(x,y)].bind("<Button-2>", self.discover)

    def on_button_click(self, event):
        button = event.widget
        if button["image"] != 'pyimage1':
            for key, value in self.minesgrid.items():
                if value == button:
                    x, y = key
                    self.afficher_nb_mines(x, y)
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
        if(button['image']=='pyimage1'):
            button.config(image='pyimage2')   
        else:
            button.config(image='pyimage1')
            
if __name__ == "__main__":
    game = Game()
    game.mainloop()
