import tkinter as tk

class Menu(tk.Tk):
    FONT = "Arial {size} bold"

    def __init__(self, width=720, height=720):
        super().__init__()

        self.wm_title("Minesweeper - Create")

        w_width = self.winfo_screenwidth()
        w_height = self.winfo_screenheight()

        self.geometry(f"{width}x{height}+{int((w_width - width)/2)}+{int((w_height - height)/2)}")
        self.option_add("*font", Menu.FONT.format(size=24))

        title = tk.Label(text="Minesweeper", font=Menu.FONT.format(size=32))
        title.pack()

        size = (384, 384)

        button_frame = tk.Frame(self, width=size[0], height=size[1])
        button_frame.place(relx=0.5, rely=0.5, anchor=tk.CENTER)
        Menu.create_button(button_frame, 1, 1, text="9x9", callback=lambda : print("e"), width=size[0]/2, height=size[1]/2)
        Menu.create_button(button_frame, 1, 2, text="24x24", width=size[0]/2, height=size[1]/2)
        Menu.create_button(button_frame, 2, 1, text="12x12", width=size[0]/2, height=size[1]/2)
        Menu.create_button(button_frame, 2, 2, text="?x?", width=size[0]/2, height=size[1]/2)

    @staticmethod
    def create_button(clazz, x, y, text="", callback=None, width=128, height=128):
        frame = tk.Frame(clazz, width=width, height=height)
        btn = tk.Button(frame, text=text, command=callback)

        frame.grid_propagate(False)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(0, weight=1)

        frame.grid(row=x, column=y)

        btn.grid(sticky="wens")


if __name__ == "__main__":
    menu = Menu()
    menu.mainloop()