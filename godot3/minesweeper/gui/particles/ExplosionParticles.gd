extends Node2D

func restart():
	for child in get_children():
		if child is CPUParticles2D:
			child.restart()
