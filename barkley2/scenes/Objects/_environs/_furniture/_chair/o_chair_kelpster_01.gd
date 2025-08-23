extends B2_Environ

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(position)
	frame = rng.randi_range(0,2)
