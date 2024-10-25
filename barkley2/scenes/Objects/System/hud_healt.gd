extends Label

var dummy_health 		:= 30.0
var dummy_max_health 	:= 69.0

func update_health_display():
	text = str(dummy_health) + "\n" + str(dummy_health)
	queue_redraw()
	
func _draw() -> void:
	draw_line( Vector2(0, 10), Vector2(22, 10), Color.WHITE, 2.0 )
