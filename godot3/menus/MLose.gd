extends CenterContainer

const GAME = preload("res://minesweeper/Game.tscn")
const M_SELECT_GAME = preload("res://menus/MSelectGame.tscn")

signal retry

func _on_GamemodeButton_pressed():
	get_tree().change_scene_to(M_SELECT_GAME)


func _on_RetryButton_pressed():
	get_tree().change_scene_to(GAME)
