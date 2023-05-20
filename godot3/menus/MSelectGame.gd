extends Control

const GAME = "res://minesweeper/gui/Game.tscn"
const M_CUSTOM_GAME = "res://menus/MCustomGame.tscn"

export var default_minesweeper_size = Vector2.ONE * 9
export var default_minesweeper_percentage = 0.15

onready var grass_tile_map = $GrassTileMap

func _ready():
	Minesweeper.size = default_minesweeper_size
	Minesweeper.bombs_percentage = default_minesweeper_percentage

func _on_button9x9_pressed():
	Minesweeper.size = Vector2(9,9)
	get_tree().change_scene(GAME)
	
func _on_button15x15_pressed():
	Minesweeper.size = Vector2(15,15)
	get_tree().change_scene(GAME)

func _on_button24x24_pressed():
	Minesweeper.size = Vector2(24,24)
	get_tree().change_scene(GAME)

func _on_buttoncustom_pressed():
	get_tree().change_scene(M_CUSTOM_GAME)


func _on_Control_resized():
	if not grass_tile_map:
		return
	
	for y in range(int(get_viewport_rect().size.y / grass_tile_map.cell_size.y) + 1):
		for x in range(int(get_viewport_rect().size.x / grass_tile_map.cell_size.x) + 1):
			if grass_tile_map.get_cell(x, y) == -1:
				grass_tile_map.set_grass(x, y)
