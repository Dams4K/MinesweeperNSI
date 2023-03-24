extends Node2D

export var minesweeper_path: NodePath

var minesweeper: Minesweeper

onready var tileMap: TileMap = $TileMap
onready var bombsTileMap: TileMap = $BombsTileMap

func _ready():
	tileMap.clear()
	bombsTileMap.clear()
	
	if self.minesweeper_path == null:
		return
	self.minesweeper = get_node(self.minesweeper_path)
	
	for y in range(self.minesweeper.size.y):
		for x in range(self.minesweeper.size.x):
			tileMap.set_cell(x, y, 1)

func discover(pos):
	self.tileMap.set_cellv(pos, 0)
	self.tileMap.update_bitmask_area(pos)
	
	if self.minesweeper.is_bomb(pos):
		self.bombsTileMap.set_cellv(pos, 0)
#	if tile_map.get_cell(pos[0], pos[1]) == GRASS_TILE:
#		tile_map.set_cell(pos[0], pos[1], 0)
#		tile_map.update_bitmask_area(Vector2(pos[0], pos[1]))
#		var voisins = voisin(pos)
#		var nb_mine_v = 0
#		for elt in voisins:
#			if minesweeper.minesgrid[elt[1]][elt[0]] == 1:
#				nb_mine_v += 1
#		if nb_mine_v == 0:
#			for elt in voisins:
#				discover(elt)
#		else:
#			tile_map_number.set_cell(pos[0], pos[1], 0, false, false, false, Vector2(nb_mine_v, 0))

func _process(delta):
	if Input.is_action_just_pressed("discover_tile"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_pos: Vector2 = self.tileMap.world_to_map(mouse_pos)
		if self.minesweeper.is_valid_pos(tile_pos):
			if self.minesweeper.map.empty():
				self.minesweeper.generate([tile_pos])
			
			self.discover(tile_pos)
