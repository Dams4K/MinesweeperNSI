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
            x = y = ts * 3
        elif l == r == t == b == tl == tr == bl == br == True:
            x = y = ts
        elif l == r == b == bl == br == True and t == tl == tr == False:
            x = ts
            y = ts * 2
        elif l == r == t == tl == tr == True and b == bl == br == False:
            x = ts
        elif r == t == b == tr == br == True and l == tl == bl == False:
            y = ts
        elif l == t == b == tl == bl == True and r == tr == br == False:
            x = ts * 2
            y = ts
        

        return ImageTk.PhotoImage(self.tileset.crop((x, y, x+w, y+h)))

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
    
    tk.Button(image=None).grid(row=0, column=0)
    tk.Button(image=img4).grid(row=1, column=0)
    tk.Button(image=None).grid(row=2, column=0)
    tk.Button(image=None).grid(row=3, column=0)
    
    tk.Button(image=img3).grid(row=0, column=1)
    tk.Button(image=img1).grid(row=1, column=1)
    tk.Button(image=img2).grid(row=2, column=1)
    tk.Button(image=None).grid(row=3, column=1)
    
    tk.Button(image=None).grid(row=0, column=2)
    tk.Button(image=img5).grid(row=1, column=2)
    tk.Button(image=None).grid(row=2, column=2)
    tk.Button(image=None).grid(row=3, column=2)
    
    tk.Button(image=None).grid(row=0, column=3)
    tk.Button(image=None).grid(row=1, column=3)
    tk.Button(image=None).grid(row=2, column=3)
    tk.Button(image=img0).grid(row=3, column=3)
    m.mainloop()