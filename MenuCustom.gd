extends CenterContainer

const MAIN = preload("res://Main.tscn")

onready var mine_slider = $Panel/VBoxContainer/HBoxContainer2/MineSlider
onready var mine_spinbox = $Panel/VBoxContainer/HBoxContainer2/MinePercentage
onready var validate_button = $Panel/VBoxContainer/ValidateButton
onready var size_x = $Panel/VBoxContainer/HBoxContainer/SizeX
onready var size_y = $Panel/VBoxContainer/HBoxContainer/SizeY
onready var main = MAIN.instance()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	mine_slider.share(mine_spinbox)


func _on_ValidateButton_pressed():
	var size = Vector2(size_x.value ,size_y.value)
	main.minesweeper_size = size
	var percentage = mine_spinbox.value
	main.minesweeper_percentage = percentage
	get_tree().root.add_child(main)
	get_tree().root.remove_child(self)
	queue_free()
