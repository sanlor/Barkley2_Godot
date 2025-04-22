@tool
extends Node2D

@onready var target: 		AnimatedSprite2D = $target

@export var my_color:		Color

var t := 0.0

func _ready() -> void:
	target.modulate = my_color

func _physics_process(delta: float) -> void:
	queue_redraw()
	target.rotation += 1.0 * delta
	t += delta
	
func _draw() -> void:
	#draw_circle( Vector2.ZERO, 8, my_color, false, 1.0 )
	draw_dashed_line( target.global_position.normalized() * 8.0, target.global_position, my_color, 0.5, 1.0 * sin(t) + PI, false )
