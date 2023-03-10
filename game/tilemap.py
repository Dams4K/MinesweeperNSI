import tkinter as tk
from PIL import Image, ImageTk

class TileMap:
    def __init__(self, tileset_path):
        self.tileset: Image = Image.open(tileset_path)

    def get_image(self, l=False, r=False, t=False, b=False, tl=False, tr=False, bl=False, br=False):
        ts = self.tileset.size[1]/5

        x, y = 0, 0
        w, h = ts, ts
        
        if l == r == b == bl == br == True:
            x = 1
            y = 0
        if l == r == t == tl == tr == True:
            x = 1
            y = 2
        if r == t == b == tr == br == True:
            x = 0
            y = 1
        if l == t == b == tl == bl == True:
            x = 2
            y = 1

        if r == b == br == True and l == t == tl == False:
            x = y = 0
        if l == b == bl == True and r == t == tr == False:
            x = 2
            y = 0
        if r == t == tr == True and l == b == bl == False:
            x = 0
            y = 2
        if l == t == tl == True and r == b == br == False:
            x = 2
            y = 2
        
        if r == True and l == t == b == False:
            x = 0
            y = 3
        if l == r == True and t == b == False:
            x = 1
            y = 3
        if l == True and r == t == b == False:
            x = 2
            y = 3
        
        if b == True and l == r == t == False:
            x = 3
            y = 0
        if t == b == True and l == r == False:
            x = 3
            y = 1
        if t == True and l == r == b == False:
            x = 3
            y = 2

        if r == b == True and l == t == tl == tr == bl == br == False:
            x = 4
            y = 0
        if l == b == True and r == t == tl == tr == bl == br == False:
            x = 7
            y = 0
        if r == t == True and l == b == tl == tr == bl == br == False:
            x = 4
            y = 3
        if l == t == True and r == b == tl == tr == bl == br == False:
            x = 7
            y = 3
        

        if l == r == b == bl == True and t == tl == tr == br == False:
            x = 5
            y = 0
        if l == r == b == br == True and t == tl == tr == bl == False:
            x = 6
            y = 0
        
        if r == t == b == tr == True and l == tl == bl == br == False:
            x = 4
            y = 1
        if r == t == b == tl == True and l == tr == bl == br == False:
            x = 4
            y = 2
        
        if l == t == b == tl == True and r == tr == bl == br == False:
            x = 7
            y = 1
        if l == t == b == tr == True and r == tl == bl == br == False:
            x = 7
            y = 2
        
        if l == r == t == tl == True and b == tr == bl == br == False:
            x = 5
            y = 3
        if l == r == t == tr == True and b == tl == bl == br == False:
            x = 6
            y = 3
        

        if l == r == t == b == tl == tr == bl == True and br == False:
            x = 5
            y = 1
        if l == r == t == b == tl == tr == br == True and bl == False:
            x = 6
            y = 1
        
        if l == r == t == b == tl == bl == br == True and tr == False:
            x = 5
            y = 2
        if l == r == t == b == tr == bl == br == True and tl == False:
            x = 6
            y = 2
        

        if r == t == b == True and l == tl == tr == bl == br == False:
            x = 4
            y = 4
        if l == r == t == b == True and tl == tr == bl == br == False:
            x = 5
            y = 4
        if l == r == t == b == True and tl == tr == bl == br == False:
            x = 6
            y = 4
        if l == t == b == True and r == tl == tr == bl == br == False:
            x = 7
            y = 4

        if l == r == b == True and t == tl == tr == bl == br == False:
            x = 8
            y = 0
        if l == r == t == b == True and tl == tr == bl == br == False:
            x = 8
            y = 1
        if l == r == t == b == True and bl == br == tl == tr == False:
            x = 8
            y = 2
        if l == r == t == True and b == bl == br == tl == tr == False:
            x = 8
            y = 3
        
        if l == r == t == b == True and tl == tr == bl == br == False:
            x = 8
            y = 4
        
        if l == r == t == b == tl == br == True and tr == bl == False:
            x = 9
            y = 0
        if l == r == t == b == tr == bl == True and tl == br == False:
            x = 9
            y = 1
        
        if l == r == t == b == br == True and tl == tr == bl == False:
            x = 9
            y = 2
        if l == r == t == b == tr == True and tl == bl == br == False:
            x = 9
            y = 3
        if l == r == t == b == tl == True and tr == bl == br == False:
            x = 10
            y = 3
        if l == r == t == b == bl == True and tr == tl == br == False:
            y = 10
            y = 2

        if l == r == t == b == tl == tr == bl == br == False:
            x = y = 3
        if l == r == t == b == tl == tr == bl == br == True:
            x = y = 1

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