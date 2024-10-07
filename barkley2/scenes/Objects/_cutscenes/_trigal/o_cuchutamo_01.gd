@tool
extends B2_InteractiveActor

func _ready() -> void:
	ActorAnim.play("default")
	
	adjust_sprite_offset()
