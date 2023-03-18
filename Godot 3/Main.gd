extends Node2D

const GRASS_TILE = 1

onready var tile_map: TileMap = $TileMap
onready var camera_2d = $Camera2D
onready var minesweeper = $Minesweeper



func _ready():
	tile_map.clear()
	for y in range(minesweeper.size[1]):
		for x in range(minesweeper.size[0]):
			tile_map.set_cellv(Vector2(x, y), GRASS_TILE)

func _process(delta):
	if Input.is_action_just_pressed("leftclick"):
		var pos = tile_map.world_to_map(get_local_mouse_position())
		var ac = tile_map.get_cell(pos[0], pos[1])
		
		var cells = []
		if ac == GRASS_TILE:
			tile_map.set_cell(pos[0], pos[1], 0)
			tile_map.update_bitmask_area(Vector2(pos[0], pos[1]))
#			for j in [-1, 0, 1]:
#				for i in [-1, 0, 1]:
#					var x = pos.x + i
#					var y = pos.y + j
#					var cell_pos = Vector2(x, y)
#					var cell = tile_map.get_cell_autotile_coord(cell_pos[0], cell_pos[1])
#
#					if not cell in [GRASS_TILE, Vector2(-1, -1)] or cell_pos == pos:
#						cells.append(cell_pos)
#
#
#			tile_map.set_cell(pos.x, pos.y, 0)
#			tile_map.update_bitmask_area(pos)

			
	
