extends AnimatedSprite2D

func _ready() -> void:
	speed_scale = randf_range( 0.55, 1.25 )
	modulate.a = randf_range( 0.5, 0.95 )

func _on_animation_finished() -> void:
	queue_free()
