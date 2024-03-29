extends Node2D

const ZOOM_SPEED = 0.1

export var camera_path: NodePath
export var cell_size = 128
export var shake_amount = 25

var camera2D: Camera2D

var max_zoom = 100
var min_zoom = 0.125

var shaking = false

onready var shaking_timer = $ShakingTimer
onready var grass_tile_map = $GrassTileMap

func _ready():
	camera2D = get_node_or_null(camera_path)
	camera2D.current = true
	
	center_camera()
	
	var viewport_rect = get_viewport_rect()
	var width_zoom = (Minesweeper.size.x + 2) * cell_size / viewport_rect.size.x
	var height_zoom = (Minesweeper.size.y + 2) * cell_size / viewport_rect.size.y
	camera2D.zoom = Vector2.ONE * max(width_zoom, height_zoom)
	max_zoom = max(width_zoom, height_zoom) * 2
	
	update_tilemap()

func _process(delta):
	if shaking:
		camera2D.set_offset(Vector2(
			rand_range(-1.0, 1.0) * shake_amount,
			rand_range(-1.0, 1.0) * shake_amount
		))

func _input(event):
	if Input.is_action_just_released("zoom_in"):
		var mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		if set_camera_zoom(1+ZOOM_SPEED):
			camera2D.position += mouse_pos - mouse_pos / (1+ZOOM_SPEED)
		
	if Input.is_action_just_released("zoom_out"):
		var mouse_pos: Vector2 = camera2D.get_local_mouse_position()
		if set_camera_zoom(1-ZOOM_SPEED):
			camera2D.position += mouse_pos - mouse_pos / (1-ZOOM_SPEED)
	
	if Input.is_action_pressed("move_camera") and event is InputEventMouseMotion:
		camera2D.position += event.relative * -1 * camera2D.zoom
		
	if Input.is_action_pressed("center_camera"):
		center_camera()
	
	camera2D.position.x = clamp(camera2D.position.x, get_center_position().x - get_viewport_rect().size.x * max_zoom / 2, get_center_position().x + get_viewport_rect().size.x * max_zoom / 2)
	camera2D.position.y = clamp(camera2D.position.y, get_center_position().y - get_viewport_rect().size.y * max_zoom / 2, get_center_position().y + get_viewport_rect().size.y * max_zoom / 2)
	
	update_tilemap()

func set_camera_zoom(new_zoom):
	var value = clamp(camera2D.zoom.x / new_zoom, min_zoom, max_zoom)
	if stepify(camera2D.zoom.x, 0.02) != stepify(value, 0.02):
		camera2D.zoom = Vector2.ONE * value
		return true
	return false

func center_camera():
	camera2D.position = get_center_position()

func get_center_position():
	return Minesweeper.size * cell_size / 2


func shake():
	shaking = true
	shaking_timer.start()

func update_tilemap():
	var pos = camera2D.position - get_viewport_rect().size * camera2D.zoom / 2
	var size = get_viewport_rect().size * camera2D.zoom
	pos -= grass_tile_map.cell_size
	size += grass_tile_map.cell_size * 2
	
	var start_y = max(pos.y, -12 * grass_tile_map.cell_size.y)
	var end_y = min(pos.y + size.y, (12 + Minesweeper.size.y) * grass_tile_map.cell_size.y)
	var start_x = max(pos.x, -12 * grass_tile_map.cell_size.x)
	var end_x = min(pos.x + size.x, (12 + Minesweeper.size.x) * grass_tile_map.cell_size.x)
	for y in range(start_y, end_y, grass_tile_map.cell_size.y):
		for x in range(start_x, end_x, grass_tile_map.cell_size.x):
			var tile_pos = Vector2(int(x / grass_tile_map.cell_size.x), int(y / grass_tile_map.cell_size.y))
			if grass_tile_map.get_cellv(tile_pos) == -1:
				grass_tile_map.set_grassv(tile_pos)

func _draw():
	var pos = camera2D.position - get_viewport_rect().size * camera2D.zoom / 2
	var size = get_viewport_rect().size * camera2D.zoom 

func _on_ShakingTimer_timeout():
	shaking = false
	camera2D.set_offset(Vector2.ZERO)
