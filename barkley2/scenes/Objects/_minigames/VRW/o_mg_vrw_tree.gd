extends AnimatedSprite2D

var rng := RandomNumberGenerator.new()

func _ready() -> void:
	rng.seed = hash( name )
	frame = rng.randi_range(0,5)
