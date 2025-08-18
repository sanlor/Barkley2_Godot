extends PointLight2D

func _ready() -> void:
	var t := create_tween()
	energy = 0.0
	t.tween_property(self, "energy", 1.0, 0.25).set_ease(Tween.EASE_OUT	)
	t.tween_property(self, "energy", 0.0, 0.50).set_ease(Tween.EASE_IN	)
	t.tween_callback( queue_free )
