extends AnimatedSprite2D

var speed 		:= 3.0 * randf_range(0.85, 1.15)
var anim_time 	:= 3.0 * randf_range(0.85, 1.15)
var amplitude 	:= 10.0 * randf_range(0.85, 1.15)
var time := 0.0

func _ready() -> void:
	frame = 0
	modulate = Color.WHITE
	offset = Vector2.ZERO
	var tween := create_tween()
	tween.tween_property( self, "frame", 8, 		anim_time )
	tween.parallel().tween_property( self, "modulate:a", 0.0, 	anim_time )
	tween.parallel().tween_property( self, "offset:y", -100.0, anim_time )
	tween.tween_callback( queue_free )
	
func _process(delta: float) -> void:
	time += delta * speed
	offset.x = sin( time ) * amplitude
