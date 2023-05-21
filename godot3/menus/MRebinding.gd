tool
extends HBoxContainer

export var action: String
export var action_name: String setget set_action_name

onready var label = $"%Label"
onready var button = $"%Button"

func _ready():
	label.text = action_name

func set_action_name(v):
	action_name = v
	if label:
		label.text = action_name
