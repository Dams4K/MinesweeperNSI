extends CenterContainer

const GAME = "res://minesweeper/gui/Game.tscn"

onready var mines_slider = $Panel/VBoxContainer/Percentage/MinesSlider
onready var mines_percentage = $Panel/VBoxContainer/Percentage/MinesPercentage

onready var validate_button = $Panel/VBoxContainer/ValidateButton
onready var width_spin_box = $Panel/VBoxContainer/WidthContainer/WidthSpinBox

onready var height_spin_box = $Panel/VBoxContainer/HeightContainer/HeightSpinBox

func _ready():
	mines_slider.share(mines_percentage)


func _on_ValidateButton_pressed():
	Minesweeper.size = Vector2(width_spin_box.value, height_spin_box.value)
	Minesweeper.bombs_percentage = mines_percentage.value
	get_tree().change_scene(GAME)
