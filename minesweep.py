import tkinter as tk
from random import randint


def afficher(x,y):
    nb_mines = voisin(x,y)
    minesgrid[(x,y)].config(text = f"{nb_mines}")

def on_button_click(event):
    button = event.widget
    for key, value in minesgrid.items():
        if value == button:
            x, y = key
            afficher(x, y)
            break

def voisin(x,y):
    global w,h
    liste = [-1,0,1]
    voisins = []
    for i in liste:
        for j in liste:
            if 0<= x+i <= h-1 and 0<= y+j <= w-1:
                voisins.append(minesweep[x+i][y+j])

    return sum(voisins)
            
def temp(event):
    button = event.widget
    for key, value in minesgrid.items():
        if value == button:
            x, y = key
    drapeau = tk.PhotoImage(file="Drapeau.png", master=root)
    if minesgrid[(x,y)]["image"] == drapeau:
        minesgrid[(x,y)]["image"] = pixel
    else:
        minesgrid[(x,y)]["image"] = drapeau

    print("drapeau")


root = tk.Tk()

w = 9
h = 10

n = 100

minesweep = [[0 for i in range(w)]for j in range(h)]

for line in minesweep:
    for elt in range(len(line)):
        if randint(0,100) <= n:
            line[elt] = 1

for line in minesweep:
    print(line)

pixel = tk.PhotoImage(width=50, height=50, master=root)
minesgrid = {}
for line in range(len(minesweep)):
    for column in range(len(minesweep[line])):
        minesgrid[(line, column)] = tk.Button(root,compound='c', image=pixel)
        minesgrid[(line, column)].grid(row = line, column = column)


for button in minesgrid.values():
    button.bind("<Button-1>", on_button_click)
    button.bind("<Button-3>", temp)


root.mainloop()
    
