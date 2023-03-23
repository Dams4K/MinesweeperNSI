extends Node
onready var label = $Label

const percent = 0.20

export var size = Vector2(9,9)
export var minesgrid = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
	
	
func place_mine():
	var mine_to_place = int(size[0]*size[1]*percent)
	while mine_to_place >= 0:
		var y = randi()%int(size[1])
		var x = randi()%int(size[0])
		while minesgrid[y][x] == 1:
			y = randi()%int(size[1])
			x = randi()%int(size[0])
		minesgrid[y][x] = 1
		mine_to_place -= 1
	return true
	

	
	
