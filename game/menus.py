import tkinter as tk

class Menu(tk.Tk):
    FONT = "Arial {size} bold"

    def __init__(self, title="", size: tuple = (256, 256), center=False):
        super().__init__()

        self.wm_title(title)
        width = size[0]
        height = size[1]

        # Unfortunately give the full width when there is multiple monitors
        w_width = self.winfo_screenwidth()
        w_height = self.winfo_screenheight()

        pos = ""
        if center:
            pos = f"+{int((w_width - width)/2)}+{int((w_height - height)/2)}"
        self.geometry(f"{width}x{height}" + pos)

        self.option_add("*font", Menu.FONT.format(size=16))
    
    @staticmethod
    def create_button(clazz, row, column, width=128, height=128, **kwargs):
        hover_img_path = kwargs.pop("hover_img_path", None)

        frame = tk.Frame(clazz, width=width, height=height, highlightthickness=-10)
        btn = tk.Button(frame, bd=-2, highlightthickness=0, **kwargs)

        frame.grid_propagate(False)
        frame.columnconfigure(0, weight=1)
        frame.rowconfigure(0, weight=1)

        frame.grid(row=row, column=column, padx=(0, 0), pady=(0, 0))

        if hover_img_path is not None:
            btn.bind("<Enter>", lambda e: Menu.on_hover(e, hover_img_path))
            btn.bind("<Leave>", lambda e: Menu.on_leave(e))

        btn.grid(sticky="wens")
        return btn
    
    @staticmethod
    def on_hover(event, img_path):
        btn = event.widget
        img = btn["image"]

        print(btn["image"], img_path)
    
    @staticmethod
    def on_leave(event):
        pass


if __name__ == "__main__":
    menu = Menu("Test", (512, 512))
    menu.mainloop()