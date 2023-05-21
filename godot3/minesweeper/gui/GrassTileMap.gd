extends TileMap

export var noise: OpenSimplexNoise
export var full_grass_value: float = 0.0

func _ready():
	clear()
	if noise:
		noise.seed = randi()

func set_grass(x: int, y: int):
	return set_grassv(Vector2(x, y))

func set_grassv(position, it: int = 0):
	if noise.get_noise_2dv(position * cell_size) < full_grass_value:
		set_cellv(position, 0, bool(randi() % 2), bool(randi() % 2), false, random_tile(0))
	else:
		set_cellv(position, 0)

func random_tile(id: int) -> Vector2:
	var p := Vector2.ZERO
	var s := tile_set.tile_get_region(id).size / tile_set.autotile_get_size(id)
	var total := 0
	for y in range(s.y):
		for x in range(s.x):
			total += tile_set.autotile_get_subtile_priority(id, Vector2(x, y))
	var selected := randi() % total
	var current := 0
	for y in range(s.y):
		for x in range(s.x):
			p = Vector2(x, y)
			current += tile_set.autotile_get_subtile_priority(id, p)
			if current > selected:
				return p
	return p
