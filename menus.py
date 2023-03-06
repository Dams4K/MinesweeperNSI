import tkinter as tk

class Menu(tk.Tk):
    FONT = "Arial {size} bold"

    def __init__(self, title="", size: tuple = (256, 256)):
        super().__init__()

        self.wm_title(title)
        width = size[0]
        height = size[1]

         # Unfortunately give the full width when there is multiple monitors
        w_width = self.winfo_screenwidth()
        w_height = self.winfo_screenheight()

        self.geometry(f"{width}x{height}+{int((w_width - width)/2)}+{int((w_height - height)/2)}")
        self.option_add("*font", Menu.FONT.format(size=24))
    
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
    menu = Menu("Test", (512, 512))
    menu.mainloop()