extends AnimatedSprite2D

@export var is_on_land := false

func _ready() -> void:
	if is_on_land:
		frame = randi_range(0,2)
	else:
		frame = randi_range(3,5)
