extends Control

onready var h_box_container = $HBoxContainer

onready var bombs_number_label = $"%BombsNumberLabel"
onready var flags_label = $"%FlagsLabel"

var flag_placed = 0 setget set_flag_placed

func set_flag_placed(v):
	flag_placed = v
	flags_label.text = "%s/%s drapeaux placés" % [flag_placed, Minesweeper.number_of_bombs()]
	if flag_placed > Minesweeper.number_of_bombs():
		flags_label.modulate = Color.red
	else:
		flags_label.modulate = Color.white

func _ready():
	rect_min_size.y = h_box_container.rect_size.y
	set_flag_placed(0)
	bombs_number_label.text = "%s bombes" % Minesweeper.number_of_bombs()
