@tool
extends Node2D

var t := 0.0	## Time offset
var c := 0.0	## Color offset

func _physics_process(delta: float) -> void:
	t += 7.0 * delta
	var offset := 0.0
	for i : Node2D in get_children():
		i.position.y = 3.0 * sin(t + offset)
		offset += 0.5
		
		i.self_modulate = Color.from_hsv( wrapf(c, 0.0, 1.0) + (offset * 0.2), 1.0, 1.0 )
		#i.self_modulate = Color( wrapf(c, 0, 255), 128, 255 )
		c += delta * 0.1
