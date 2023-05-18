extends Control

const GAME = preload("res://minesweeper/Game.tscn")
const M_CUSTOM_GAME = preload("res://menus/MCustomGame.tscn")

export var default_minesweeper_size = Vector2.ONE * 9
export var default_minesweeper_percentage = 0.15

func _ready():
	Minesweeper.size = default_minesweeper_size
	Minesweeper.bombs_percentage = default_minesweeper_percentage

func _on_button9x9_pressed():
	Minesweeper.size = Vector2(9,9)
	get_tree().change_scene_to(GAME)
	
func _on_button15x15_pressed():
	Minesweeper.size = Vector2(15,15)
	get_tree().change_scene_to(GAME)

func _on_button24x24_pressed():
	Minesweeper.size = Vector2(24,24)
	get_tree().change_scene_to(GAME)

func _on_buttoncustom_pressed():
	get_tree().change_scene_to(M_CUSTOM_GAME)
