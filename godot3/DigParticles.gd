tool
extends Node2D

export var texture: Texture setget set_texture

func set_texture(v):
	texture = v
	_ready()

func _ready():
	for child in get_children():
		if not child is CPUParticles2D:
			continue
		
		var atlas_texture = child.texture
		atlas_texture.altas = texture
