extends Node2D

onready var minesweeperGui = $MinesweeperGui

onready var canvas_layer = $CanvasLayer
onready var lose_menu = $CanvasLayer/LoseMenu
onready var win_menu = $CanvasLayer/WinMenu

func _ready():
	Minesweeper.clear()
	lose_menu.hide()
	win_menu.hide()
	
	self.minesweeperGui.generate()


func _on_MinesweeperGui_won():
	canvas_layer.show()
	win_menu.show()

func _on_MinesweeperGui_lose():
	canvas_layer.show()
	lose_menu.show()
