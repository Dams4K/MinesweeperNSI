extends Node2D

onready var camera2D = $Camera2D
onready var minesweeperGui = $MinesweeperGui

onready var lose_menu = $CanvasLayer/LoseMenu
onready var win_menu = $CanvasLayer/WinMenu

func _ready():
	Minesweeper.clear()
	lose_menu.hide()
	win_menu.hide()
	
	self.camera2D.position = Minesweeper.size * 64 / 2
	
	var viewport_rect = get_viewport_rect()
	var width_zoom = (Minesweeper.size.x + 2) * 64 / viewport_rect.size.x
	var height_zoom = (Minesweeper.size.y + 2) * 64 / viewport_rect.size.y
	self.camera2D.zoom = Vector2.ONE * max(width_zoom, height_zoom)
	
	self.minesweeperGui.generate()


func _on_MinesweeperGui_won():
	win_menu.show()

func _on_MinesweeperGui_lose():
	lose_menu.show()
