extends AnimatedSprite2D

func _ready() -> void:
	z_index = [-10,10].pick_random()
	speed_scale = randf_range(0.8,1.2)
