import tkinter as tk
from PIL import Image, ImageTk

class TileMap:
    def __init__(self, tileset_path):
        self.tileset: Image = Image.open(tileset_path)

    def get_image(self, l=False, r=False, t=False, b=False, tl=False, tr=False, bl=False, br=False):
        ts = self.tileset.size[1]/4

        x, y = 0, 0
        w, h = ts, ts

        if l == r == t == b == tl == tr == bl == br == False:
            x = y = 3
        elif l == r == t == b == tl == tr == bl == br == True:
            x = y = 1
        
        elif l == r == b == bl == br == True and t == tl == tr == False:
            x = 1
            y = 2
        elif l == r == t == tl == tr == True and b == bl == br == False:
            x = 1
            y = 0
        elif r == t == b == tr == br == True and l == tl == bl == False:
            x = 0
            y = 1
        elif l == t == b == tl == bl == True and r == tr == br == False:
            x = 2
            y = 1
        
        elif r == b == br == True and l == t == tl == tr == bl == False:
            x = y = 0
        elif l == b == bl == True and r == t == tl == tr == br == False:
            x = 2
            y = 0
        elif r == t == tr == True and l == b == tl == bl == br == False:
            x = 0
            y = 2
        elif l == t == tl == True and r == b == tr == br == bl == False:
            x = 2
            y = 2
        
        elif r == True and l == t == b == tl == tr == bl == br == False:
            x = 0
            y = 3
        elif l == r == True and t == b == tl == tr == bl == br == False:
            x = 1
            y = 3
        elif l == True and r == t == b == tl == tr == bl == br == False:
            x = 2
            y = 3
        
        elif b == True and l == r == t == tl == tr == bl == br == False:
            x = 3
            y = 0
        elif t == b == True and l == r == tl == tr == bl == br == False:
            x = 3
            y = 1
        elif t == True and l == r == b == tl == tr == bl == br == False:
            x = 3
            y = 2

        x *= ts
        y *= ts

        path = f"assets/tmp/{int(x)}-{int(y)}.png"
        img = self.tileset.crop((x, y, x+w, y+h)).save(path)

        return path

if __name__ == "__main__":
    m = tk.Tk()
    m.geometry("300x300")
    tilemap = TileMap("assets/tilemap.png")
    
    img0 = tilemap.get_image()
    img1 = tilemap.get_image(1, 1, 1, 1, 1, 1, 1, 1)
    
    img2 = tilemap.get_image(1, 1, 0, 1, 0, 0, 1, 1)
    img3 = tilemap.get_image(1, 1, 1, 0, 1, 1, 0, 0)

    img4 = tilemap.get_image(0, 1, 1, 1, 0, 1, 0, 1)
    img5 = tilemap.get_image(1, 0, 1, 1, 1, 0, 1, 0)

    img6 = tilemap.get_image(0, 1, 0, 1, 0, 0, 0, 1)
    img7 = tilemap.get_image(1, 0, 0, 1, 0, 0, 1, 0)
    
    img8 = tilemap.get_image(0, 1, 1, 0, 0, 1, 0, 0)
    img9 = tilemap.get_image(1, 0, 1, 0, 1, 0, 0, 0)

    img10 = tilemap.get_image(0, 1, 0, 0, 0, 0, 0, 0)
    img11 = tilemap.get_image(1, 1, 0, 0, 0, 0, 0, 0)
    img12 = tilemap.get_image(1, 0, 0, 0, 0, 0, 0, 0)

    img13 = tilemap.get_image(0, 0, 0, 1, 0, 0, 0, 0)
    img14 = tilemap.get_image(0, 0, 1, 1, 0, 0, 0, 0)
    img15 = tilemap.get_image(0, 0, 1, 0, 0, 0, 0, 0)

    tk.Button(image=img6).grid(row=0, column=0)
    tk.Button(image=img4).grid(row=1, column=0)
    tk.Button(image=img8).grid(row=2, column=0)
    tk.Button(image=img10).grid(row=3, column=0)
    
    tk.Button(image=img3).grid(row=0, column=1)
    tk.Button(image=img1).grid(row=1, column=1)
    tk.Button(image=img2).grid(row=2, column=1)
    tk.Button(image=img11).grid(row=3, column=1)
    
    tk.Button(image=img7).grid(row=0, column=2)
    tk.Button(image=img5).grid(row=1, column=2)
    tk.Button(image=img9).grid(row=2, column=2)
    tk.Button(image=img12).grid(row=3, column=2)
    
    tk.Button(image=img13).grid(row=0, column=3)
    tk.Button(image=img14).grid(row=1, column=3)
    tk.Button(image=img15).grid(row=2, column=3)
    tk.Button(image=img0).grid(row=3, column=3)
    m.mainloop()