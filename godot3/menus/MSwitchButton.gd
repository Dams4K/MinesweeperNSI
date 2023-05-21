tool
extends HBoxContainer

export var text: String setget set_text
export var config_section: String
export var config_key: String
export var enabled := true

export var enabled_text: String = "Activé"
export var disabled_text: String = "Désactivé"

onready var label = $"%Label"
onready var button = $"%Button"

func _ready():
	enabled = Config.get_value(config_section, config_key, enabled)
	update_button()
	label.text = text

func set_text(v):
	text = v
	if label:
		label.text = text


func _on_Button_pressed():
	enabled = not enabled
	update_button()
	Config.set_value(config_section, config_key, enabled)

func update_button():
	if enabled:
		button.text = enabled_text
		button.theme_type_variation = "ButtonGreen"
	else:
		button.text = disabled_text
		button.theme_type_variation = "ButtonRed"
