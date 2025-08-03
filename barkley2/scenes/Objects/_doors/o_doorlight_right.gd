@icon("res://barkley2/assets/icon/door_right.png")
extends B2_DoorLight

func push_player( body : B2_PlayerCombatActor, delta : float ):
	var push_vector :=  Vector2.LEFT
	body.external_velocity = push_vector * pushResist * delta
