extends AnimatedSprite2D

@export var play_back := false

func _ready() -> void:
	if play_back:
		play_backwards("default")
	else:
		play("default")
