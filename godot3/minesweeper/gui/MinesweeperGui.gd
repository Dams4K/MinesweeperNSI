tool
extends Node2D

signal flag_placed
signal flag_removed

const DIGGING_PARTICLES := preload("res://minesweeper/gui/particles/DiggingParticles.tscn")
const EXPLISION_PARTICLES := preload("res://minesweeper/gui/particles/ExplosionParticles.tscn")

signal won
signal lose

export var generate: bool = false setget set_generate

onready var grassTileMap: TileMap = $GrassTileMap
onready var dirtTileMap: TileMap = $DirtTileMap
onready var bombsTileMap: TileMap = $BombsTileMap
onready var flagsTileMap: TileMap = $FlagsTileMap
onready var transitionTileMap: TileMap = $TransitionTileMap
onready var selectorTileMap: TileMap = $SelectorTileMap

onready var particles = $Particles

var clean_tiles_to_discover = []
var tiles_to_discover = []

var font: Font
var color_codes = [
	Color("00aad4"),
	Color("00d4aa"),
	Color("2ca05a"),
	Color("44aa00"),
	Color("88aa00"),
	Color("d4aa00"),
	Color("d45500"),
	Color("aa0000"),
]

var strings_to_draw = {}

func set_generate(v):
	generate()


func _ready():
	font = DynamicFont.new()
	font.font_data = load("res://assets/fonts/Roboto/Roboto-Black.ttf")
	font.size = 96

func clear_tilemaps():
	if grassTileMap: grassTileMap.clear()
	if dirtTileMap: dirtTileMap.clear()
	if bombsTileMap: bombsTileMap.clear()
	if flagsTileMap: flagsTileMap.clear()
	if transitionTileMap: transitionTileMap.clear()


func generate():
	clear_tilemaps()
	if grassTileMap and grassTileMap.noise:
		grassTileMap.noise.seed = randi()
	
	if grassTileMap:
		for y in range(Minesweeper.size.y):
			for x in range(Minesweeper.size.x):
				grassTileMap.set_grass(x, y)
				if transitionTileMap: transitionTileMap.set_cell(x, y, 0)
	
	if transitionTileMap:
		transitionTileMap.update_bitmask_region(Vector2.ZERO, Minesweeper.size)


func _process(delta):
	if not Engine.editor_hint:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_pos: Vector2 = selectorTileMap.world_to_map(mouse_pos)
		selectorTileMap.clear()
		if Minesweeper.is_valid_pos(tile_pos):
			var not_digged = dirtTileMap.get_cellv(tile_pos) == -1
			if not_digged:
				selectorTileMap.set_cellv(tile_pos, 0)
			
			if Input.is_action_just_pressed("auto_discover") and not Minesweeper.map.empty():
				clean_tiles_to_discover.append(tile_pos)
			if Input.is_action_just_pressed("discover_tile"):
				if Minesweeper.map.empty():
					var neighbors = Minesweeper.get_neighbors(tile_pos)
					Minesweeper.generate(neighbors)
				
				tiles_to_discover.append(tile_pos)
			
			if Input.is_action_just_pressed("flag_tile"):
				if not_digged:
					flag_tile(tile_pos)
					
	var i = min(Minesweeper.size.x, Minesweeper.size.y)
	while tiles_to_discover and i > 0:
		i -= 1
		var tile_pos = tiles_to_discover.pop_front()
		discover(tile_pos)
		if tiles_to_discover == []:
			update() # redraw
			dirtTileMap.update_bitmask_region(Vector2.ZERO, Minesweeper.size - Vector2.ONE)
	
	i = min(Minesweeper.size.x, Minesweeper.size.y)
	while clean_tiles_to_discover and i > 0:
		i -= 1
		var tile_pos = clean_tiles_to_discover.pop_front()
		clean_discover(tile_pos)
		if clean_tiles_to_discover == []:
			update() # redraw
			dirtTileMap.update_bitmask_region(Vector2.ZERO, Minesweeper.size - Vector2.ONE)

func _draw():
	for number in strings_to_draw:
		for pos in strings_to_draw[number]:
			var string = str(number)
			var c = ord(string)
			var global_pos = dirtTileMap.map_to_world(pos)
			global_pos.x -= (font.get_char_tx_size(c).x - dirtTileMap.cell_size.x) / 2
			global_pos.y += (font.get_char_tx_size(c).y + dirtTileMap.cell_size.y) / 2
			
			draw_string(font, global_pos, string, color_codes[number-1])

func flag_tile(pos):
	if pos in Minesweeper.flags:
		Minesweeper.flags.erase(pos)
		flagsTileMap.set_cellv(pos, -1)
		emit_signal("flag_removed")
	else:
		Minesweeper.flags.append(pos)
		flagsTileMap.set_cellv(pos, 0)
		emit_signal("flag_placed")

func clean_discover(pos):
	if pos in Minesweeper.flags:
		return
	elif dirtTileMap.get_cellv(pos) != 0:
		return
	
	var neighbors = Minesweeper.get_neighbors(pos)
	var neighbors_bombs = Minesweeper.get_bombs_from(neighbors)
	var neighbors_bombs_number = len(neighbors_bombs)

	if neighbors_bombs_number > 0:
		var strings_pos = strings_to_draw.get(neighbors_bombs_number, [])
		if not pos in strings_pos:
			strings_pos.append(pos)
		strings_to_draw[neighbors_bombs_number] = strings_pos
	
	var neighbors_flagged = 0
	var will_be_discovered = []
	for neighbor in neighbors:
		if neighbor in Minesweeper.flags:
			neighbors_flagged += 1
		else:
			will_be_discovered.append(neighbor)

	if neighbors_flagged == neighbors_bombs_number:
		for neighbor in will_be_discovered:
			var tile = dirtTileMap.get_cellv(neighbor)
			if tile != 0 and not neighbor in dirtTileMap.get_used_cells_by_id(0) and not neighbor in tiles_to_discover and not neighbor in clean_tiles_to_discover:
				tiles_to_discover.append(neighbor)

func discover(pos):
	if pos in Minesweeper.flags:
		return
	
	if Minesweeper.is_bomb(pos):
		emit_signal("lose")
		for bomb_pos in Minesweeper.get_bombs():
			dirtTileMap.set_cellv(bomb_pos, 0)
			flagsTileMap.set_cellv(bomb_pos, -1)
			bombsTileMap.set_cellv(bomb_pos, 0)
		
		if Config.get_value("Particles", "explosion", true):
			var particle = EXPLISION_PARTICLES.instance()
			particles.add_child(particle)
			particle.position = dirtTileMap.map_to_world(pos) + Vector2.ONE * dirtTileMap.cell_size / 2
			particle.restart()
	elif dirtTileMap.get_cellv(pos) != 0:
		dirtTileMap.set_cellv(pos, 0, false, false, false, Vector2.ONE)
		if Config.get_value("Particles", "digging", true):
			var particle = DIGGING_PARTICLES.instance()
			particles.add_child(particle)
			particle.position = dirtTileMap.map_to_world(pos) + Vector2.ONE * dirtTileMap.cell_size / 2
			particle.restart()
		
		clean_tiles_to_discover.append(pos)
		
		if len(dirtTileMap.get_used_cells_by_id(0)) == Minesweeper.number_of_tiles() - Minesweeper.number_of_bombs():
			emit_signal("won")
