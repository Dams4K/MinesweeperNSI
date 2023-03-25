extends Node2D

onready var camera2D = $Camera2D
onready var minesweeper = $Minesweeper

func _ready():
	self.camera2D.position = self.minesweeper.size * 64 / 2
