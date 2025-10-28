extends Node2D

const GRAVITY 		:= 0.25
const RESISTANCE 	:= 0.005

@onready var dart: AnimatedSprite2D = $dart

var my_direction 	:= Vector2.ZERO
var impulse			:= 0.0
var height			:= 8.0
	
func set_direction( _my_direction : Vector2, _impulse : float ) -> void:
	my_direction = _my_direction
	impulse = _impulse
	print( my_direction )
	
func _physics_process(_delta: float) -> void:
	dart.offset.y = -height
	position += my_direction * impulse
	dart.rotation = (my_direction + Vector2(0.0,8.0 - height) * 0.025 ).angle()
	
	height = lerpf(height, 		0.0, GRAVITY)
	impulse = lerpf(impulse, 	1.0, RESISTANCE)
	
	if is_zero_approx(height):
		dart.animation = "hit"
		set_physics_process( false )
