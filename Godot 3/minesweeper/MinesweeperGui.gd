extends Node2D

const MINESWEEPER_LABEL := preload("res://minesweeper/MinesweeperLabel.tscn")

export var minesweeper_path: NodePath

var minesweeper: Minesweeper

onready var tileMap: TileMap = $TileMap
onready var bombsTileMap: TileMap = $BombsTileMap
onready var labels = $Labels

func _ready():
	tileMap.clear()
	bombsTileMap.clear()
	
	if self.minesweeper_path == null:
		return
	self.minesweeper = get_node(self.minesweeper_path)
	
	for y in range(self.minesweeper.size.y):
		for x in range(self.minesweeper.size.x):
			tileMap.set_cell(x, y, 1)

func _process(delta):
	if Input.is_action_just_pressed("discover_tile"):
		var mouse_pos: Vector2 = get_global_mouse_position()
		var tile_pos: Vector2 = self.tileMap.world_to_map(mouse_pos)
		if self.minesweeper.is_valid_pos(tile_pos):
			if self.minesweeper.map.empty():
				var neighbors = self.minesweeper.get_neighbors(tile_pos)
				self.minesweeper.generate(neighbors)
			
			self.discover(tile_pos)

func discover(pos):
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
		
		var bombs_are_flagged = true
		for bomb_pos in neighbors_bombs:
			if not bomb_pos in self.minesweeper.flags:
				bombs_are_flagged = false
				break
		
		if bombs_are_flagged:
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
