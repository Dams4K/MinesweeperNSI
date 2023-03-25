tool
extends Node2D

const MINESWEEPER_LABEL := preload("res://minesweeper/MinesweeperLabel.tscn")

export var generate: bool = false setget set_generate

export var minesweeper_path: NodePath

var minesweeper: Minesweeper

onready var tileMap: TileMap = $TileMap
onready var bombsTileMap: TileMap = $BombsTileMap
onready var flagsTileMap: TileMap = $FlagsTileMap
onready var transitionTileMap: TileMap = $TransitionTileMap
onready var selectorTileMap: TileMap = $SelectorTileMap

onready var labels = $Labels

func set_generate(v):
	_ready()

func clear_tilemaps():
	tileMap.clear()
	bombsTileMap.clear()
	flagsTileMap.clear()
	transitionTileMap.clear()

func _ready():
	clear_tilemaps()
	self.minesweeper = get_node_or_null(self.minesweeper_path)
	
	for y in range(self.minesweeper.size.y):
		for x in range(self.minesweeper.size.x):
			tileMap.set_cell(x, y, 1)
			transitionTileMap.set_cell(x, y, 0)
	transitionTileMap.update_bitmask_region(Vector2.ZERO, self.minesweeper.size)

func _process(delta):
	if not Engine.editor_hint:
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_pos: Vector2 = self.tileMap.world_to_map(mouse_pos)
		selectorTileMap.clear()
		if self.minesweeper.is_valid_pos(tile_pos):
			var tile = self.tileMap.get_cellv(tile_pos)
			if tile == 1:
				selectorTileMap.set_cellv(tile_pos, 0)
			
			if Input.is_action_just_pressed("discover_tile"):
					if self.minesweeper.map.empty():
						var neighbors = self.minesweeper.get_neighbors(tile_pos)
						self.minesweeper.generate(neighbors)
					
					self.discover(tile_pos)
			elif Input.is_action_just_pressed("flag_tile"):
				if tile == 1:
					self.flag_tile(tile_pos)

func flag_tile(pos):
	if pos in self.minesweeper.flags:
		self.minesweeper.flags.erase(pos)
		self.flagsTileMap.set_cellv(pos, -1)
	else:
		self.minesweeper.flags.append(pos)
		self.flagsTileMap.set_cellv(pos, 0)

func discover(pos):
	if pos in self.minesweeper.flags:
		return
	
	self.tileMap.set_cellv(pos, 0)
	self.tileMap.update_bitmask_area(pos)
	
	if self.minesweeper.is_bomb(pos):
		self.bombsTileMap.set_cellv(pos, 0)
	else:
		var label = self.get_label(pos)
		var neighbors = self.minesweeper.get_neighbors(pos)
		var neighbors_bombs = self.minesweeper.get_bombs(neighbors)
		var neighbors_bombs_number = len(neighbors_bombs)
		
		if neighbors_bombs_number > 0:
			label.text = str(neighbors_bombs_number)
		else:
			label.text = ""
		
		var neighbors_flagged = 0
		for neighbor in neighbors:
			if neighbor in self.minesweeper.flags:
				neighbors_flagged += 1
				neighbors.erase(neighbor)
		
		if neighbors_flagged == neighbors_bombs_number:
			for neighbor in neighbors:
				var tile = self.tileMap.get_cellv(neighbor)
				if tile != 0:
					self.discover(neighbor)

func get_label(pos: Vector2):
	var label_name: String = "%s;%s" % [pos.x, pos.y]
	var label: Label = labels.get_node_or_null(label_name)
	if label == null:
		label = MINESWEEPER_LABEL.instance()
		label.name = label_name
		label.rect_position = pos * 64
		labels.add_child(label)
	return label
