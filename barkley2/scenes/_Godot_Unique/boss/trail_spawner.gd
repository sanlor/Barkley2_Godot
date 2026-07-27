@tool
extends Timer

const TRAILNODE := preload("uid://d2wuigsigt1sn")

@onready var my_actor: B2_EnemyBoss = $"../.."
@export var fade_timer := 1.0
@export var fade_speed := 2.0

func _ready() -> void:
	start()

func _on_timeout() -> void:
	_spawn_trail()

func _spawn_trail() -> void:
	var trail := TRAILNODE.new()
	
	var sprite : AnimatedSprite2D = get_parent()
	var parent_texture := sprite.sprite_frames.get_frame_texture( sprite.animation, sprite.frame )
	
	trail.timer 		= fade_timer
	trail.speed 		= fade_speed
	trail.texture 		= parent_texture
	trail.centered 		= false
	trail.offset 		= sprite.offset
	trail.rotation 		= my_actor.rotation
	trail.scale			= sprite.scale
	trail.z_index 		= -1
	if B2_CManager.o_hoopz:
		trail.dir 		= my_actor.global_position.direction_to( B2_CManager.o_hoopz.global_position )
	trail.position 		= my_actor.position
	my_actor.add_sibling( trail, true )
