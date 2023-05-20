tool
extends Node2D

const DIGGING_PARTICLE := preload("res://minesweeper/gui/DiggingParticles.tscn")
const MINESWEEPER_LABEL := preload("res://minesweeper/gui/MinesweeperLabel.tscn")

signal won
signal lose

export var generate: bool = false setget set_generate

onready var grassTileMap: TileMap = $GrassTileMap
onready var dirtTileMap: TileMap = $DirtTileMap
onready var bombsTileMap: TileMap = $BombsTileMap
onready var flagsTileMap: TileMap = $FlagsTileMap
onready var transitionTileMap: TileMap = $TransitionTileMap
onready var selectorTileMap: TileMap = $SelectorTileMap

onready var labels = $Labels
onready var particles = $Particles

var tiles_to_discover = []
var tiles_discovered = []

func set_generate(v):
	generate()


func clear_tilemaps():
	if grassTileMap: grassTileMap.clear()
	if dirtTileMap: dirtTileMap.clear()
	if bombsTileMap: bombsTileMap.clear()
	if flagsTileMap: flagsTileMap.clear()
	if transitionTileMap: transitionTileMap.clear()


func generate():
	clear_tilemaps()
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
			
			if Input.is_action_just_pressed("discover_tile"):
				if Minesweeper.map.empty():
					var neighbors = Minesweeper.get_neighbors(tile_pos)
					Minesweeper.generate(neighbors)
				
				tiles_to_discover.append(tile_pos)
			elif Input.is_action_just_pressed("flag_tile"):
				if not_digged:
					self.flag_tile(tile_pos)
	
	while tiles_to_discover:
		var tile_to_discover = tiles_to_discover.pop_front()
		bombsTileMap.set_cellv(tile_to_discover, 0)
		yield(get_tree().create_timer(0.001), "timeout")
		bombsTileMap.set_cellv(tile_to_discover, -1)
		self.discover(tile_to_discover)


func flag_tile(pos):
	if pos in Minesweeper.flags:
		Minesweeper.flags.erase(pos)
		flagsTileMap.set_cellv(pos, -1)
	else:
		Minesweeper.flags.append(pos)
		flagsTileMap.set_cellv(pos, 0)


func discover(pos):
	if pos in Minesweeper.flags:
		return
	
	if dirtTileMap.get_cellv(pos) != 0:
		dirtTileMap.set_cellv(pos, 0)
		dirtTileMap.update_bitmask_area(pos)
		var particle = DIGGING_PARTICLE.instance()
	#	var particle = DIG_PARTICLE.instance()
		particles.add_child(particle)
		particle.position = dirtTileMap.map_to_world(pos) + Vector2.ONE * dirtTileMap.cell_size / 2
		particle.restart()
	
	if Minesweeper.is_bomb(pos):
		emit_signal("lose")
		for bomb_pos in Minesweeper.get_bombs():
			dirtTileMap.set_cellv(bomb_pos, 0)
			flagsTileMap.set_cellv(bomb_pos, -1)
			bombsTileMap.set_cellv(bomb_pos, 0)
		dirtTileMap.update_bitmask_region(Vector2.ZERO, Minesweeper.size - Vector2.ONE)
	else:
		var label = self.get_label(pos)
		var neighbors = Minesweeper.get_neighbors(pos)
		var neighbors_bombs = Minesweeper.get_bombs_from(neighbors)
		var neighbors_bombs_number = len(neighbors_bombs)
		
		if neighbors_bombs_number > 0:
			label.text = str(neighbors_bombs_number)
		else:
			label.text = ""
		
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
				if tile != 0 and not neighbor in dirtTileMap.get_used_cells_by_id(0) and not neighbor in tiles_to_discover:
					tiles_to_discover.append(neighbor)
		
		if len(dirtTileMap.get_used_cells_by_id(0)) == Minesweeper.number_of_tiles() - Minesweeper.number_of_mines():
			emit_signal("won")


func get_label(pos: Vector2):
	var label_name: String = "%s;%s" % [pos.x, pos.y]
	var label: Label = labels.get_node_or_null(label_name)
	if label == null:
		label = MINESWEEPER_LABEL.instance()
		label.name = label_name
		label.rect_position = pos * dirtTileMap.cell_size
		label.rect_min_size = dirtTileMap.cell_size
		labels.add_child(label)
	return label
