extends Node2D

onready var minesweeperGui = $MinesweeperGui

onready var canvas_layer = $CanvasLayer
onready var lose_menu = $CanvasLayer/LoseMenu
onready var win_menu = $CanvasLayer/WinMenu

onready var hud = $"%HUD"
onready var camera_controller = $"%CameraController"

var start_time: int
var stop_timer := false
var current_time: float

func _ready():
	Minesweeper.clear()
	lose_menu.hide()
	win_menu.hide()
	
	self.minesweeperGui.generate()
	
	start_time = OS.get_ticks_msec()


func _process(delta):
	if not stop_timer:
		current_time = stepify(float(OS.get_ticks_msec() - start_time) / 1000, 0.1)
		if int(current_time) == current_time:
			hud.timer_label.text = "%s.0s" % current_time
		else:
			hud.timer_label.text = "%ss" % current_time


func _on_MinesweeperGui_won():
	canvas_layer.show()
	win_menu.show()
	stop_timer = true

func _on_MinesweeperGui_lose():
	canvas_layer.show()
	lose_menu.show()
	camera_controller.shake()
	stop_timer = true


func _on_MinesweeperGui_flag_placed():
	hud.flag_placed += 1


func _on_MinesweeperGui_flag_removed():
	hud.flag_placed -= 1
