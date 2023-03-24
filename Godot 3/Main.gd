extends Node2D

const LAND_TILE = 0
const GRASS_TILE = 1
const FLAG_TILE = 2

const DEBUG = true

onready var tile_map_bomb = $"TileMap Bomb"
onready var tile_map_number = $"TileMap Number"
onready var tile_map: TileMap = $TileMap
onready var camera_2d = $Camera2D
onready var minesweeper = $Minesweeper

onready var generated = false

#func _ready():
#	tile_map.clear()
#	tile_map_bomb.clear()
#	tile_map_number.clear()
#	for y in range(minesweeper.size[1]):
#		minesweeper.minesgrid.append([])
#		for x in range(minesweeper.size[0]):
#			tile_map.set_cellv(Vector2(x, y), GRASS_TILE)
#			minesweeper.minesgrid[y].append(0)
#
#
#func _process(delta):
#	var pos = tile_map.world_to_map(get_local_mouse_position())
#	if Input.is_action_just_pressed("leftclick"):
#		if not generated:
#			minesweeper.generate_bombs()
#			generated = true
#			debug(minesweeper.minesgrid, DEBUG)
#		if minesweeper.minesgrid[pos[1]][pos[0]] == 1:
#			bombs()
#		else:
#			if tile_map.get_cell(pos[0], pos[1]) == LAND_TILE:
#				discover_voisins(pos)
#			else:
#				discover(pos)
#
#	if Input.is_action_just_pressed("rightclick"):
#		flag(pos)
#
#	if Input.is_action_just_pressed("centerclick"):
#		if tile_map.get_cell(pos[0], pos[1]) == LAND_TILE:
#				discover_voisins(pos)
#
#
#
#
#func flag(pos):
#	if tile_map.get_cell(pos[0], pos[1]) == GRASS_TILE:
#		tile_map.set_cell(pos[0], pos[1], FLAG_TILE)
#	elif tile_map.get_cell(pos[0], pos[1]) == FLAG_TILE:
#		tile_map.set_cell(pos[0], pos[1], GRASS_TILE)
#
#func bombs():
#	for y in range(minesweeper.size[1]):
#		for x in range(minesweeper.size[0]):
#			if minesweeper.minesgrid[y][x] == 1:
#				tile_map_bomb.set_cell(x, y, 0)
#
#func discover(pos):
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
#
#func discover_voisins(pos):
#	var voisins = voisin(pos)
#	var nb_mine_v = 0
#	var nb_drapeau = 0
#	for elt in voisins:
#		if minesweeper.minesgrid[elt[1]][elt[0]] == 1:
#			nb_mine_v += 1
#		if tile_map.get_cell(elt[0], elt[1]) == FLAG_TILE:
#			nb_drapeau += 1
#	print(nb_drapeau, nb_mine_v)
#	if nb_mine_v == nb_drapeau:
#		for elt in voisins:
#			discover(elt)
#
#
#func debug(tab, DEBUG):
#	if DEBUG:
#		for elt in tab:
#			print(elt)
#
#func voisin(pos):
#	var liste = [-1,0,1]
#	var voisins = []
#	for j in liste:
#		for i in liste:
#			if 0 <= (pos[0] + i)  and  (pos[0] + i < minesweeper.size[0]): 
#				if 0 <= (pos[1] + j) and (pos[1] + j < minesweeper.size[1]):   
#					voisins.append(Vector2(pos[0]+i, pos[1]+j))
#	return voisins
#
