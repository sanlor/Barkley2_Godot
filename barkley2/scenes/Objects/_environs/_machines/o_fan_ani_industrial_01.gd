extends B2_Environ

func _ready() -> void:
	play("default")
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	speed_scale = randf_range( 1, 3 )
