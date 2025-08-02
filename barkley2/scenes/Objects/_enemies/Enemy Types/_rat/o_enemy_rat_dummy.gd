extends CharacterBody2D

const O_ENEMY_DARK_RAT = preload("uid://bw704hnw70nik")

@onready var actor_anim: AnimatedSprite2D = $ActorAnim

func _physics_process(delta: float) -> void:
	if actor_anim.frame < 5:
		position.y += 50.0 * delta

func _on_animation_finished() -> void:
	var rat := O_ENEMY_DARK_RAT.instantiate()
	rat.position = position
	add_sibling( rat, true )
	queue_free()
