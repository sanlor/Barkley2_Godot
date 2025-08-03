extends AnimatedSprite2D

signal rat_spawned

const O_ENEMY_RAT_DUMMY = preload("uid://b80c8ql127wud")

@onready var spawn_distance: 	Area2D = $spawn_distance
@onready var spawn_collision: 	CollisionShape2D = $spawn_distance/spawn_collision
@onready var cooldown_timer: Timer = $cooldown_timer
@onready var spawn_timer: 		Timer = $spawn_timer

@export var spawn_cooldown_time 	:= 10.0
@export var full_auto 				:= false				## keep spawing rats.
var can_spawn_rats					:= true

func _ready() -> void:
	if full_auto:
		spawn_timer.wait_time = spawn_cooldown_time
		spawn_timer.autostart = true
		spawn_timer.start()
		
	cooldown_timer.wait_time = spawn_cooldown_time
	hide()

func _on_spawn_distance_body_entered(body: Node2D) -> void:
	if cooldown_timer.is_stopped():
		if body is B2_Player_FreeRoam:
			if can_spawn_rats:
				spawn_collision.set_deferred("disabled", true)
				spawn_timer.start()
				show()
				play("eyes")

func _on_spawn_timer_timeout() -> void:
	if can_spawn_rats:
		var rat := O_ENEMY_RAT_DUMMY.instantiate()
		add_sibling( rat, true )
		rat.position = position
		rat_spawned.emit()
	hide()
	cooldown_timer.start()
	spawn_collision.set_deferred("disabled", false)
	
	if full_auto:
		spawn_timer.start()
