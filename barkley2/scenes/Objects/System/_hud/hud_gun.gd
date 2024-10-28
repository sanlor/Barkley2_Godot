extends ColorRect

## Holy shit. It has begun...
## There is no way im going to port the gun system at this point

var offset_x := Vector2(2.0, 0.0)
var offset_y := Vector2(0.0, 2.0)

func _draw() -> void:
	var jump_x := 8.0
	var jump_y := 8.0
	for x in 8:
		draw_line( Vector2(x * jump_x, 0) - offset_x, Vector2(x * jump_x, 28) - offset_x, Color8(0, 72, 72, 128), 1.0 )
	for y in 4:
		draw_line( Vector2(0, y * jump_y) - offset_y, Vector2(53, y * jump_y) - offset_y, Color8(0, 72, 72, 128), 1.0 )
