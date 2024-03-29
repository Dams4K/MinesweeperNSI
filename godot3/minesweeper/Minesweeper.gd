extends Node

signal generated

const MAX_TRIES = 100

export var bombs_percentage = 0.20
export var size = Vector2(9,9)

var map: Array = []
var flags: Array = []

var total_bombs: int = -1

enum TILES_TYPE {
	UNDEFINED,
	BOMB,
	SAFE
}

func _ready():
	randomize()

func generate(safe_tiles: Array = []):
	generate_map()
	generate_bombs(safe_tiles)
	emit_signal("generated")

func generate_map() -> void:
	for y in range(self.size.y):
		self.map.append([])
		for x in range(self.size.x):
			self.map[y].append(0)

func generate_bombs(safe_tiles: Array = []) -> void:
	var mines_to_place = theoretical_number_of_bombs()
	var tries = 0
	
	while mines_to_place > 0 and tries < MAX_TRIES:
		var pos := Vector2(randi() % int(size.x), randi() % int(size.y))
		if not self.is_bomb(pos) and not pos in safe_tiles:
			self.map[pos.y][pos.x] = TILES_TYPE.BOMB
			mines_to_place -= 1
			tries = 0
		tries += 1
		
		if tries == MAX_TRIES-1:
			print_debug("failed to keep a tile safe")
	
	total_bombs = theoretical_number_of_bombs() - mines_to_place

func get_tile(pos: Vector2) -> int:
	if not self.is_valid_pos(pos):
		return TILES_TYPE.UNDEFINED
	if self.is_bomb(pos):
		return TILES_TYPE.BOMB
	else:
		return TILES_TYPE.SAFE

func get_neighbors(pos: Vector2) -> Array:
	var neighbors = []
	for j in [-1, 0, 1]:
		for i in [-1, 0, 1]:
			var neighbor_pos = Vector2(pos.x + i, pos.y + j)
			if self.is_valid_pos(neighbor_pos):
				neighbors.append(neighbor_pos)
	return neighbors

func get_bombs() -> Array:
	var bombs = []
	for y in range(len(self.map)):
		for x in range(len(self.map[y])):
			var pos = Vector2(x, y)
			if is_bomb(pos):
				bombs.append(pos)
	return bombs

func get_bombs_from(positions: Array) -> Array:
	var bombs = []
	for position in positions:
		if self.is_bomb(position):
			bombs.append(position)
	return bombs

func number_of_tiles() -> int:
	return self.size.x * self.size.y

func theoretical_number_of_bombs() -> int:
	return int(self.size.x * self.size.y * self.bombs_percentage)

func is_bomb(pos: Vector2) -> bool:
	return is_valid_pos(pos) and self.map[pos.y][pos.x] == TILES_TYPE.BOMB

func is_valid_pos(pos: Vector2) -> bool:
	var valid_x = 0 <= pos.x and pos.x < self.size.x
	var valid_y = 0 <= pos.y and pos.y < self.size.y
	return valid_x and valid_y


func clear() -> void:
	self.map = []
	self.flags = []
