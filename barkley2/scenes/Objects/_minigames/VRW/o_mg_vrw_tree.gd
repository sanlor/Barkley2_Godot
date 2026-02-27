extends AnimatedSprite2D
class_name B2_Minigame_VRW_Tree

var clones : Array[Node2D]

var rng := RandomNumberGenerator.new()

func begin() -> void:
	frame = rng.randi_range(0,5)
