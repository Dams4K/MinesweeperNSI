extends Node2D

onready var camera2D = $Camera2D
onready var minesweeper = $Minesweeper
onready var minesweeperGui = $MinesweeperGui

var minesweeper_size = Vector2.ONE * 9
var minesweeper_percentage = 0.15

func _ready():
	self.minesweeper.size = minesweeper_size
	self.minesweeper.bombs_percentage = minesweeper_percentage
	self.camera2D.position = self.minesweeper.size * 64 / 2
	self.minesweeperGui.generate()
