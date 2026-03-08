extends Control

@onready var o_sewer_bridge_0_texture: 	TextureRect 		= $oSewerBridge0_texture
@onready var blocker: 					StaticBody2D 		= $blocker
@onready var collision_shape_2d: 		CollisionShape2D 	= $blocker/CollisionShape2D
@onready var animation_player: 			AnimationPlayer 	= $AnimationPlayer

@export var start_open := false

## TODO Add a way to "remember" the bridge state

func _ready() -> void:
	if start_open:
		execute_event_user_1()
	else:
		execute_event_user_0()

## open bridge
func execute_event_user_1() -> void:
	animation_player.play("open")
	collision_shape_2d.disabled = true
	
## close bridge
func execute_event_user_0() -> void:
	animation_player.play("close")
	collision_shape_2d.disabled = false
