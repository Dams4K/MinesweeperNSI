extends Node

const CONFIG_PATH = "user://config.cfg"

var config := ConfigFile.new()

func _ready():
	var err = config.load(CONFIG_PATH)
	if err == OK:
		for action in InputMap.get_actions():
			var events = InputMap.get_action_list(action)
			if not events:
				continue
			
			var custom_event = config.get_value("Inputs", action, false)
			if custom_event is bool: # no custom event
				continue
			
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, custom_event)

func get_value(section, key, default_value):
	return config.get_value(section, key, default_value)

func set_value(section, key, value):
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)

func save_input_map():
	for action in InputMap.get_actions():
		var events = InputMap.get_action_list(action)
		if not events:
			continue
		
		config.set_value("Inputs", action, events[0])
	config.save(CONFIG_PATH)
