extends Node2D

onready var dirt_particles = $DirtParticles
onready var smoke_particles = $SmokeParticles

func restart():
	dirt_particles.restart()
	smoke_particles.restart()
	yield(get_tree().create_timer(0.5), "timeout")
	queue_free()
