extends CenterContainer

signal retry

func _on_GamemodeButton_pressed():
	get_tree().change_scene("res://Menu.tscn")


func _on_RetryButton_pressed():
	get_tree().change_scene("res://Main.tscn")
