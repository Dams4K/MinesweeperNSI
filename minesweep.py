import tkinter as tk
from random import randint


def discover(event):
    button = event.widget
    if button["image"] != 'pyimage1':
        for key, value in minesgrid.items():
            if value == button:
                x, y = key
    voisins = voisin(x,y)
    nb_mines = sum([minesweep[x1][y1] for x1,y1 in voisins])
    nb_drapeau = sum([1 for x1,y1 in voisins if minesgrid[(x1,y1)]["image"] == 'pyimage1'])
    if nb_mines == nb_drapeau:
        for x1,y1 in voisins:
            afficher_nb_mines(x1, y1)

        

def perdu():
    print("perdu")

def afficher_nb_mines(x,y):
    if minesgrid[(x,y)]['image'] != 'pyimage1':
        voisins = voisin(x,y)
        nb_mines = sum([minesweep[x1][y1] for x1,y1 in voisins])
        if nb_mines !=0:
            minesgrid[(x,y)] = tk.Button(root, image = pixel, text = nb_mines, justify="center", compound="c")
        else:
            minesgrid[(x,y)] = tk.Button(root, image = pixel, justify="center", compound="c")
        minesgrid[(x,y)].grid(row = x, column = y)
        minesgrid[(x,y)].bind("<Button-2>", discover)

def on_button_click(event):
    button = event.widget
    if button["image"] != 'pyimage1':
        for key, value in minesgrid.items():
            if value == button:
                x, y = key
                if minesweep[x][y] == 1:
                    perdu()
                afficher_nb_mines(x, y)
                break

def voisin(x,y):
    global w,h
    liste = [-1,0,1]
    voisins = []
    for i in liste:
        for j in liste:
            if 0<= x+i <= h-1 and 0<= y+j <= w-1:
                voisins.append((x+i, y+j))

    return voisins
            
def flag(event):
    button = event.widget
    if(button['image']=='pyimage1'):
        button.config(image='pyimage2')   
    else:
        button.config(image='pyimage1')
        



root = tk.Tk()

w = 9
h = 10

n = 20

Drapeau = tk.PhotoImage(master=root, file ='Drapeau.png') # 'pyimage1'
pixel = tk.PhotoImage(width=50, height=50, master=root)   # 'pyimage2'

minesweep = [[0 for i in range(w)]for j in range(h)]

for line in minesweep:
    for elt in range(len(line)):
        if randint(0,100) <= n:
            line[elt] = 1

for line in minesweep:
    print(line)


minesgrid = {}
for line in range(len(minesweep)):
    for column in range(len(minesweep[line])):
        minesgrid[(line, column)] = tk.Button(root,compound='c', image=pixel)
        minesgrid[(line, column)].grid(row = line, column = column)


for button in minesgrid.values():
    if button['text'] == "":
        button.bind("<Button-1>", on_button_click)
        button.bind("<Button-3>", flag)


root.mainloop()
    
