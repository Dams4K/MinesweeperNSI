tool
extends TileMap

const MAX_ITERATIONS = 50

export var noise: OpenSimplexNoise
export var rules: Texture
var rules_image: Image

func _ready():
	if rules:
		rules_image = rules.get_data()
		rules_image.lock()

func set_grass(x: int, y: int):
	return set_grassv(Vector2(x, y))

func set_grassv(position, it: int = 0):
	if not rules_image:
		return
	
	if noise.get_noise_2dv(position * 64) < 0:
		set_cellv(position, 0, false, false, false, Vector2((randi() % rules_image.get_width() - 1) + 1, 0))
	else:
		set_cellv(position, 0)
#	var pos_x = randi() % rules_image.get_width()
#	var color = rules_image.get_pixel(pos_x, 0)
#
#	var max_number = int(ceil(256 / (color.r * 256 + 1)))
#	print(max_number)
#	if randi() % max_number == 0 or it >= MAX_ITERATIONS:
#		set_cellv(position, 0, false, false, false, Vector2(pos_x, 0))
#	else:
#		set_grassv(position, it + 1)
#func set_cell(x: int, y: int, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
#	return self.set_cellv(Vector2(x, y), tile, flip_x, flip_y, transpose, autotile_coord)
#
#func set_cellv(position: Vector2, tile: int, flip_x: bool = false, flip_y: bool = false, transpose: bool = false, autotile_coord: Vector2 = Vector2( 0, 0 )):
#	set_cellv(position, tile)
