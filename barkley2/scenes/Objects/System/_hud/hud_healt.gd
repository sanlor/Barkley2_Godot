extends Label

var dummy_health 		:= 30.0
var dummy_max_health 	:= 69.0
var alp 				:= 0.0
## TODO the original game has some fuckary related to this. it changes intensity based on the player health.
var textColor 			:= Color8(112 + int(128.0 * alp), 0, 0) 

func update_health_display():
	text = str(dummy_health) + "\n" + str(dummy_max_health)
	apply_color()
	queue_redraw()

func apply_color():
	modulate = textColor

func _draw() -> void:
	draw_line( Vector2(0, 10), Vector2(22, 10), Color.WHITE, 2.0 )
