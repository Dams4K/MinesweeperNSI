extends Node2D

onready var dirt_particles = $DirtParticles
onready var smoke_particles = $SmokeParticles

func restart():
	dirt_particles.restart()
	smoke_particles.restart()


func _on_Timer_timeout():
	queue_free()
