extends AnimatedSprite2D

@export var is_on_land := true

func _ready() -> void:
	if is_on_land:
		frame = randi_range(0,5)
	else:
		frame = randi_range(6,11)
