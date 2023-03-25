extends Node

const ZOOM_SPEED = 0.1

export var camera_path: NodePath

var camera2D: Camera2D

var original_pos: Vector2 = Vector2.ZERO

func _ready():
	camera2D = get_node_or_null(camera_path)
	camera2D.current = true

func _input(event):
	if Input.is_action_just_released("zoom_in"):
		var before_mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		camera2D.zoom /= 1+ZOOM_SPEED
		var after_mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		camera2D.position -= after_mouse_pos - before_mouse_pos
		
	if Input.is_action_just_released("zoom_out"):
		var before_mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		camera2D.zoom /= 1-ZOOM_SPEED
		var after_mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		camera2D.position -= after_mouse_pos - before_mouse_pos
	
	if Input.is_action_pressed("move_camera") and event is InputEventMouseMotion:
		camera2D.position += event.relative * -1 * camera2D.zoom
