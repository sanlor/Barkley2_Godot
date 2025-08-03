extends AnimatedSprite2D

const O_ENEMY_RAT_DUMMY = preload("uid://b80c8ql127wud")

@onready var spawn_distance: 	Area2D = $spawn_distance
@onready var spawn_collision: 	CollisionShape2D = $spawn_distance/spawn_collision
@onready var cooldown_timer: Timer = $cooldown_timer
@onready var spawn_timer: 		Timer = $spawn_timer

@export var spawn_cooldown_time := 10.0

func _ready() -> void:
	cooldown_timer.wait_time = spawn_cooldown_time
	hide()

func _on_spawn_distance_body_entered(body: Node2D) -> void:
	if cooldown_timer.is_stopped():
		if body is B2_Player_FreeRoam:
			spawn_collision.set_deferred("disabled", true)
			spawn_timer.start()
			show()
			play("eyes")

func _on_spawn_timer_timeout() -> void:
	var rat := O_ENEMY_RAT_DUMMY.instantiate()
	add_sibling( rat, true )
	rat.position = position
	hide()
	cooldown_timer.start()
	spawn_collision.set_deferred("disabled", false)
