extends CenterContainer

const GAME = "res://minesweeper/Game.tscn"
const M_SELECT_GAME = "res://menus/MSelectGame.tscn"

signal retry

func _on_GamemodeButton_pressed():
	get_tree().change_scene(M_SELECT_GAME)


func _on_RetryButton_pressed():
	get_tree().change_scene(GAME)
