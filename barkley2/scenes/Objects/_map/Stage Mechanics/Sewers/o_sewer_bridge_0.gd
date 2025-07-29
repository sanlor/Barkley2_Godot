extends TextureRect

@onready var blocker: StaticBody2D = $blocker
@onready var collision_shape_2d: CollisionShape2D = $blocker/CollisionShape2D

@export var start_open := false

## TODO Add a way to "remember" the bridge state

func _ready() -> void:
	if start_open:
		execute_event_user_1()
	else:
		execute_event_user_0()

## open bridge
func execute_event_user_1() -> void:
	show()
	collision_shape_2d.disabled = true
	
func execute_event_user_0() -> void:
	hide()
	collision_shape_2d.disabled = false
