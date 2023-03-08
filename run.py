from game import *

def create_game():
    return GameCreationMenu(launch_game)


def launch_game(minesweeper_size: tuple, mines_percentage: float = 0.15):
    game = Game(end_game, minesweeper_size, mines_percentage)

def end_game(game_menu: Game, win: bool, time: float = 0, remaining_mines: int = 0, mines_to_place: int = 0):
    if win:
        pass
    else:
        lose = Lose(create_game, game_menu, time, remaining_mines, mines_to_place)

if __name__ == "__main__":
    creation_menu = create_game()
    creation_menu.mainloop()