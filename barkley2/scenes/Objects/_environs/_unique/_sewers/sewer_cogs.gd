extends AnimatedSprite2D

@export var speed := 1.0

func _ready() -> void:
	if name.ends_with("A"):
		play("default",speed)
	else:
		play("default",-speed)
