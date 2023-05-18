extends Node2D

export var topLeftTexture: Texture
export var topRightTexture: Texture
export var bottomLeftTexture: Texture
export var bottomRightTexture: Texture

onready var top_left_p = $TopLeftP
onready var top_right_p = $TopRightP
onready var bottom_left_p = $BottomLeftP
onready var bottom_right_p = $BottomRightP

func _ready():
	pass

func play():
	top_left_p.restart()
	top_right_p.restart()
	bottom_left_p.restart()
	bottom_right_p.restart()
