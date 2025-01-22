@icon("res://barkley2/assets/b2_original/images/merged/icon_parent_2.png")
extends B2_CinemaCombatActor_Base
class_name B2_CinemaCombatActor_Control

## Class used to receive commands from B2_CombatCinemaPlayer
## Acts much like the B2_Actor class, but focus on combat.

func aim_at( _aim_target : Vector2 ) -> void:
	aim_target = _aim_target
	aim_target_changed.emit()
	
func move_to( _move_target : Vector2 ) -> void:
	move_target = _move_target
	move_target_changed.emit()
