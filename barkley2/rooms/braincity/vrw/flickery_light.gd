extends PointLight2D

func _physics_process(_delta: float) -> void:
	if randf() > 0.8:
		energy = randf_range(0.8,1.0)
