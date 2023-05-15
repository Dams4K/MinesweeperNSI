extends CenterContainer

const MAIN = preload("res://Main.tscn")

onready var mine_slider = $Panel/VBoxContainer/HBoxContainer2/MineSlider
onready var mine_spinbox = $Panel/VBoxContainer/HBoxContainer2/MinePercentage
onready var validate_button = $Panel/VBoxContainer/ValidateButton
onready var size_x = $Panel/VBoxContainer/HBoxContainer/SizeX
onready var size_y = $Panel/VBoxContainer/HBoxContainer/SizeY

func _ready():
	mine_slider.share(mine_spinbox)


func _on_ValidateButton_pressed():
	Minesweeper.size = Vector2(size_x.value ,size_y.value)
	Minesweeper.bombs_percentage = mine_spinbox.value
	get_tree().change_scene_to(MAIN)
