extends Node2D

onready var minesweeperGui = $MinesweeperGui

onready var canvas_layer = $CanvasLayer
onready var lose_menu = $CanvasLayer/LoseMenu
onready var win_menu = $CanvasLayer/WinMenu

onready var hud = $"%HUD"
onready var camera_controller = $"%CameraController"

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
	camera_controller.shake()


func _on_MinesweeperGui_flag_placed():
	hud.flag_placed += 1


func _on_MinesweeperGui_flag_removed():
	hud.flag_placed -= 1
