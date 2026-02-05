extends AnimatedSprite2D

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	frame = wrapi( frame + 1, 0, 6)
	flip_h = frame == 6
