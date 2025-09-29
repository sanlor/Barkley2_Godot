extends Camera2D

func _physics_process(delta: float) -> void:
	#position += 200.0 * Input.get_vector( "Left","Right", "Up", "Down" ) * delta
	#
	#if Input.is_action_just_pressed("Weapon <"):
		#zoom += Vector2.ONE * 0.25
	#elif Input.is_action_just_pressed("Weapon >"):
		#zoom -= Vector2.ONE * 0.25
	pass
