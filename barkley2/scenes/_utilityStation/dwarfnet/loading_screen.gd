extends TextureRect

var tiles_to_draw := 0

func _draw() -> void:
	if visible:
		var x := 336.0
		var y := 192.0
		
		@warning_ignore("integer_division")
		for i in 286:
			if i > tiles_to_draw:
				var rect := Rect2( Vector2( x, y), Vector2(16, 16) )
				draw_rect( rect, Color.BLACK, true )
				
				if x <= 0: 
					y -= 16.0
					x = 336.0
				else:
					x -= 16.0
