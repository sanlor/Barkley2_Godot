extends AnimatedSprite2D

var lifespan 		:= 0.5
var type 			:= ""
var initial_scale 	:= Vector2(1.5, 0.5)

func _ready() -> void:
	if type.is_empty():
		frame = randi_range( 0, 2 )
	else:
		if type == "!" or type == "exclamation":
			frame = 0
		if type == "?" or type == "question":
			frame = 1
		if type == "anime":
			frame = 2
			
	scale 			= initial_scale
	modulate.a 		= 0
	
	var tween := create_tween()
	tween.parallel().tween_property(self, "modulate:a", 	1.0, 			0.25)
	tween.parallel().tween_property(self, "scale", 			Vector2.ONE, 	0.25)
	tween.tween_property(self, "position:y", position.y - 16, 				0.25).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_interval( lifespan )
	tween.tween_property(self, "modulate:a", 	0.0, 			0.5)
	tween.tween_callback( queue_free )
	
	
