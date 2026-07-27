@tool
extends Sprite2D

var timer 	:= 1.0
var speed 	:= 2.0
var dir		:= Vector2.ZERO

func _ready() -> void:
	var t := create_tween()
	t.tween_property(self, "modulate", Color.TRANSPARENT, timer)
	t.tween_callback( queue_free )

func _physics_process(_delta: float) -> void:
	position -= dir * speed
