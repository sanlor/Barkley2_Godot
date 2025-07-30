extends AnimatedSprite2D

@onready var light: PointLight2D = $light

func _on_frame_changed() -> void:
	if frame == 0:
		light.color = Color.CYAN
	elif frame == 1:
		light.color = Color.LIME
