@tool
extends B2_EnemyCombatActor

@onready var gpu_particles_2d: 			GPUParticles2D 			= $GPUParticles2D

func _after_damage() -> void:
	pass

func _after_death() -> void:
	gpu_particles_2d.emitting = true
