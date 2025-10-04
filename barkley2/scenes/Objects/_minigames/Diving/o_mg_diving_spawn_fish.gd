@icon("uid://cmt7smcwl0080")
extends Area2D

const O_MG_DIVING_FISH := preload("uid://chquhdugt7oe1")

@onready var timer: Timer = $Timer

func _ready() -> void:
	z_index = -5

func spawn_fishy( player : RigidBody2D = null ) -> void:
	var fish := O_MG_DIVING_FISH.instantiate()
	if player:
		fish.my_player_target = player
	fish.global_position = global_position
	fish.my_spawn = self
	add_sibling.call_deferred( fish, true )

func _on_timer_timeout() -> void:
	var wait_time := randf_range(5,15)
	var player : RigidBody2D
	for body in get_overlapping_bodies():
		if body.name == "o_mg_diving_player":
			wait_time = randf_range(0,5)
			player = body
	
	spawn_fishy(player)
	timer.start( wait_time )

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		spawn_fishy(body)
		timer.start( randf_range(0,5) )
