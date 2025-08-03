@icon("res://barkley2/assets/b2_original/images/merged/icon_parent_2.png")
#extends B2_HoopzCombatActor_Base
extends B2_Player_TurnBased
class_name B2_Player_TurnBased_Control

## Class used to receive commands from B2_CombatCinemaPlayer
## Acts much like the B2_Actor class, but focus on combat.

func aim_at( _aim_target : Vector2 ) -> void:
	aim_target = _aim_target
	aim_target_changed.emit()
	
func move_to( _move_target : Vector2 ) -> void:
	move_target = _move_target
	move_target_changed.emit()

## Cinema functions
func cinema_look( _direction : Vector2 ) -> void:
	push_warning("Method not setup for node %s." % name)
	
func cinema_moveto( _target_spot : Vector2, _speed : String ) -> void:
	push_warning("Method not setup for node %s." % name)
