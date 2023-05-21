extends CenterContainer

const M_SELECT_GAME = "res://menus/MSelectGame.tscn"

onready var grass_tile_map = $GrassTileMap

func _ready():
	_on_MSettings_resized()

func _on_BackButton_pressed():
	get_tree().change_scene(M_SELECT_GAME)


func _on_MSettings_resized():
	if not grass_tile_map:
		return
	
	for y in range(int(get_viewport_rect().size.y / grass_tile_map.cell_size.y) + 1):
		for x in range(int(get_viewport_rect().size.x / grass_tile_map.cell_size.x) + 1):
			if grass_tile_map.get_cell(x, y) == -1:
				grass_tile_map.set_grass(x, y)
