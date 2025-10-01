extends AnimatedSprite2D

func _ready() -> void:
	rand_anim()
	
func rand_anim() -> void:
	play("default", randf_range(0.2,1.3) )

func _on_animation_finished() -> void:
	rand_anim()
