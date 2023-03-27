extends Control

const MAIN = preload("res://Main.tscn")

onready var button9x9 = $VBoxContainer/GridContainer/button9x9
onready var button15x15 = $VBoxContainer/GridContainer/button15x15
onready var button24x24 = $VBoxContainer/GridContainer/button24x24
onready var buttoncustom = $VBoxContainer/GridContainer/buttoncustom
onready var main = MAIN.instance()


func _on_button9x9_pressed():
	var size = Vector2(9,9)
	main.minesweeper_size = size
	get_tree().root.add_child(main)
	get_tree().root.remove_child(self)
	queue_free()
	
func _on_button15x15_pressed():
	var size = Vector2(15,15)
	main.minesweeper_size = size
	get_tree().root.add_child(main)
	get_tree().root.remove_child(self)
	queue_free()

func _on_button24x24_pressed():
	var size = Vector2(24,24)
	main.minesweeper_size = size
	get_tree().root.add_child(main)
	get_tree().root.remove_child(self)
	queue_free()

func _on_buttoncustom_pressed():
	get_tree().change_scene("res://MenuCustom.tscn")
