extends Node2D

const GRASS_TILE = Vector2i(1, 4)

@onready var tile_map = $TileMap
@onready var camera_2d = $Camera2D
@onready var minesweeper = $Minesweeper



func _ready():
	tile_map.clear()
	for y in range(minesweeper.size[1]):
		for x in range(minesweeper.size[0]):
				tile_map.set_cell(0, Vector2i(x,y),2, Vector2i(1,4))

func _process(delta):
	if Input.is_action_just_pressed("clickgauche"):
		var pos = tile_map.local_to_map(get_local_mouse_position())
		var ac = tile_map.get_cell_atlas_coords(0,pos)
		
		var cells: Array[Vector2i] = []
		if ac == GRASS_TILE:
			for j in [-1, 0, 1]:
				for i in [-1, 0, 1]:
					var x = pos.x + i
					var y = pos.y + j
					var cell_pos = Vector2i(x, y)
					var cell = tile_map.get_cell_atlas_coords(0, cell_pos)
					
					if not cell in [GRASS_TILE, Vector2i(-1, -1)] or cell_pos == pos:
						cells.append(cell_pos)
						
			tile_map.set_cells_terrain_connect(0, cells, 0, 0)

			
	
