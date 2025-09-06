@tool
extends AnimatedSprite2D

@onready var o_chu_cyberspear_effect: GPUParticles2D = $o_chu_cyberspear_effect

func _ready() -> void:
	o_chu_cyberspear_effect.texture.region.position.x = 80.0 * float(frame)
