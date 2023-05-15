extends Node2D

onready var camera2D = $Camera2D
onready var minesweeperGui = $MinesweeperGui
onready var lose_menu = $CanvasLayer/LoseMenu

func _ready():
	Minesweeper.clear()
	lose_menu.hide()
	self.camera2D.position = Minesweeper.size * 64 / 2
	self.minesweeperGui.generate()


func _on_MinesweeperGui_won():
	pass


func _on_MinesweeperGui_lose():
	lose_menu.show()
