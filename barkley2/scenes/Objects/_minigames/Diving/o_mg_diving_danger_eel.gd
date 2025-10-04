extends Area2D

@onready var das_eel: Area2D = $das_eel

var is_biting := false
var bite_tween : Tween

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		_bite()

func _bite() -> void:
	if not is_biting:
		if bite_tween: bite_tween.kill()
		bite_tween = create_tween()
		bite_tween.tween_callback( set.bind("is_biting", true) )
		bite_tween.tween_property( das_eel, "position:x", 24.0, 0.2 )
		bite_tween.tween_interval(1.0)
		bite_tween.tween_callback( set.bind("is_biting", false) )
		bite_tween.tween_property( das_eel, "position:x", 0.0, 1.0 )
		
func _physics_process(_delta : float) -> void:
	
	for body in das_eel.get_overlapping_bodies():
		if body is RigidBody2D:
			if body.name == "o_mg_diving_player":
				body.hurt()
				body.apply_central_impulse( global_position.direction_to(body.global_position) * 10000.0 )
