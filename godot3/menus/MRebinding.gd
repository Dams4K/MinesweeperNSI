tool
extends HBoxContainer

const MOUSE_NAMES = {
	BUTTON_LEFT: "Mouse Left",
	BUTTON_RIGHT: "Mouse Right",
	BUTTON_MIDDLE: "Mouse Middle",
}

export var action: String
export var action_name: String setget set_action_name

var is_listening = false

onready var label = $"%Label"
onready var button = $"%Button"

func _ready():
	label.text = action_name

func _process(delta):
	if is_listening:
		button.text = "Appuyez sur une touche"
	else:
		update_button()

func _input(event):
	if not is_listening:
		return
	
	if event is InputEventKey:
		is_listening = false
		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, event)
		Config.save_input_map()
	elif event is InputEventMouseButton:
		is_listening = false
		var index = event.button_index
		if MOUSE_NAMES.has(index):
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, event)
		Config.save_input_map()

func update_button():
	var actions = InputMap.get_action_list(action)
	if actions:
		var action = actions[0]
		if action is InputEventKey:
			button.text = OS.get_scancode_string(action.scancode)
		elif action is InputEventMouseButton:
			var index = action.button_index
			if MOUSE_NAMES.has(index):
				button.text = MOUSE_NAMES[index]

func set_action_name(v):
	action_name = v
	if label:
		label.text = action_name

func _on_Button_pressed():
	is_listening = not is_listening
