extends TextureRect

@onready var blocker: StaticBody2D = $blocker
@onready var collision_shape_2d: CollisionShape2D = $blocker/CollisionShape2D

func _ready() -> void:
	execute_event_user_0()

## open bridge
func execute_event_user_1() -> void:
	show()
	collision_shape_2d.disabled = true
	
func execute_event_user_0() -> void:
	hide()
	collision_shape_2d.disabled = false
