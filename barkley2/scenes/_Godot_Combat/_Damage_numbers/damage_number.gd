extends Label
## Damage indicator from the combat prototype

var velocity = Vector2()
var friction = 0.999
var linger_time := 2.0
var force		:= 50.0

func setup(source : Node2D, damage, _linger_time := 2.0, _force := 50.0) -> void:
	if damage is String:
		text			= damage
	else:
		text 				= String.num(damage, 2)
	global_position 	= source.global_position
	global_position.y 	-= 16.0
	linger_time = _linger_time
	force = _force

func _ready():
	velocity = Vector2.UP.rotated( randf_range( -PI / 8.0, PI / 8.0 ) ) * force * randf_range( 0.8, 1.2 )
	position -= size / 2.0
	var t := create_tween()
	t.tween_interval( 0.25 )
	t.tween_property( self, "modulate", Color.TRANSPARENT, randf_range(linger_time / 3.0, linger_time) ).set_trans(Tween.TRANS_BOUNCE)
	t.tween_callback( queue_free )
	scale *= randf_range( 1.0, 1.5 )

func _process( delta ):
	position += velocity * delta
	velocity *= friction
