extends Area2D

const MAX_DIST 		:= 32
const MAX_SPEED 	:= 0.8
const ACCEL 		:= 0.05

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer

var my_spawn : Area2D
var my_player_target : RigidBody2D
var wander_target_pos := Vector2.ZERO

var speed 			:= 0.0
var dir				:= Vector2.ZERO
var going_home 		:= false

func _ready() -> void:
	animated_sprite_2d.speed_scale = randf_range(0.8,1.2)
	get_new_wander_target()
	
func get_new_wander_target() -> void:
	wander_target_pos = my_spawn.global_position + Vector2( randf_range(-MAX_DIST,MAX_DIST), randf_range(-MAX_DIST,MAX_DIST) * randf() )
	
func _physics_process(delta: float) -> void:
	if not my_player_target and not going_home:
		animated_sprite_2d.flip_h = position.direction_to(wander_target_pos).x < 0
		position = position.lerp( wander_target_pos, 1.0 * delta)
		
		if position.distance_to( wander_target_pos ) < 5.0:
			get_new_wander_target()
			
	elif my_player_target and not going_home:
		animated_sprite_2d.flip_h = position.direction_to(my_player_target.position).x < 0
		position += position.direction_to( my_player_target.position ) * speed
		speed = clampf( speed + ACCEL, 0.0, MAX_SPEED )
		
	elif going_home:
		animated_sprite_2d.flip_h = position.direction_to(my_spawn.global_position).x < 0
		position += position.direction_to( my_spawn.global_position ) * speed
		speed = clampf( speed + ACCEL, 0.0, MAX_SPEED )
		
		if position.distance_to( my_spawn.global_position ) < 5.0:
			queue_free()

func _on_timer_timeout() -> void:
	going_home = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		my_player_target = body
