extends Control

onready var h_box_container = $HBoxContainer

onready var bombs_number_label = $"%BombsNumberLabel"
onready var timer_label = $"%TimerLabel"
onready var flags_label = $"%FlagsLabel"

onready var total_bombs = Minesweeper.theoretical_number_of_bombs()

var flag_placed = 0 setget set_flag_placed

func set_flag_placed(v):
	flag_placed = v
	flags_label.text = "%s/%s drapeaux placés" % [flag_placed, total_bombs]
	if flag_placed > total_bombs:
		flags_label.modulate = Color.red
	else:
		flags_label.modulate = Color.white

func _ready():
	Minesweeper.connect("generated", self, "_on_Minesweeper_generated")
	
	rect_min_size.y = h_box_container.rect_size.y
	update_hud()

func _on_Minesweeper_generated():
	total_bombs = Minesweeper.total_bombs
	update_hud()

func update_hud():
	set_flag_placed(len(Minesweeper.flags))
	bombs_number_label.text = "%s bombes" % total_bombs
