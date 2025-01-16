@icon("res://barkley2/assets/icon/door_left.png")
extends B2_DoorLight

func push_player( body : B2_Player, delta : float ):
	var push_vector :=  Vector2.RIGHT
	body.external_velocity = push_vector * pushResist * delta
