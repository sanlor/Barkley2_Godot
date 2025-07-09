extends AnimatedSprite2D

func _ready() -> void:
	speed_scale = randf_range(0.6,1.4)

func _on_animation_finished() -> void:
	play("loop")
