extends CenterContainer

const GAME = "res://minesweeper/gui/Game.tscn"
const M_SELECT_GAME = "res://menus/MSelectGame.tscn"

onready var width_spin_box = $"%WidthSpinBox"
onready var height_spin_box = $"%HeightSpinBox"
onready var mines_slider = $"%MinesSlider"
onready var mines_percentage = $"%MinesPercentage"

onready var grass_tile_map = $GrassTileMap

func _ready():
	_on_Control_resized()
	mines_slider.share(mines_percentage)


func _on_ValidateButton_pressed():
	Minesweeper.size = Vector2(clamp(width_spin_box.value, 2, 100), clamp(height_spin_box.value, 2, 100))
	Minesweeper.bombs_percentage = mines_percentage.value
	get_tree().change_scene(GAME)


func _on_Control_resized():
	if not grass_tile_map:
		return
	
	for y in range(int(get_viewport_rect().size.y / grass_tile_map.cell_size.y) + 1):
		for x in range(int(get_viewport_rect().size.x / grass_tile_map.cell_size.x) + 1):
			if grass_tile_map.get_cell(x, y) == -1:
				grass_tile_map.set_grass(x, y)


func _on_BackButton_pressed():
	get_tree().change_scene(M_SELECT_GAME)
