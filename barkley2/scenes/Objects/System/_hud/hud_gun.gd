@tool
extends ColorRect

## Holy shit. It has begun...
## There is no way im going to port the gun system at this point
## 02/03/25 today is the day...

var offset_x := Vector2(2.0, 0.0)
var offset_y := Vector2(0.0, 2.0)

var intensity := 1.0

func _draw() -> void:
	var jump_x := 8.0
	var jump_y := 8.0
	var r := randf_range(0.75,1.25)
	for x in 8:
		@warning_ignore("narrowing_conversion")
		draw_line( Vector2(x * jump_x, 0) - offset_x, Vector2(x * jump_x, 28) - offset_x, Color8(0, 72, 72, 128 * r) * intensity, 1.0 )
	for y in 4:
		@warning_ignore("narrowing_conversion")
		draw_line( Vector2(0, y * jump_y) - offset_y, Vector2(53, y * jump_y) - offset_y, Color8(0, 72, 72, 128 * r) * intensity, 1.0 )
