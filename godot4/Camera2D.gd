extends Camera2D

func _process(delta):
	if Input.is_action_just_released("zoom"):
		zoom *= 1.2
		
	if Input.is_action_just_released("dezoom"):
		zoom /= 1.2
		
