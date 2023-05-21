extends Node

const CONFIG_PATH = "user://config.cfg"

var config := ConfigFile.new()

func _ready():
	config.load(CONFIG_PATH)

func get_value(section, key, default_value):
	return config.get_value(section, key, default_value)

func set_value(section, key, value):
	config.set_value(section, key, value)
	config.save(CONFIG_PATH)
