extends RigidBody2D
class_name B2_CombatActor

signal stop_animation ## Stop all active animations (Walking, attacking, dodging, etc)

@export var health 		:= 100.0

func apply_damage( _damage : float) -> void:
	push_warning("Method not setup for node %s." % name)

func cinema_lookat( target_node : Node2D ) -> void:
	var _direction := position.direction_to( target_node.position ).round()
	cinema_look( _direction )
	
func cinema_look( _direction : Vector2 ) -> void:
	push_warning("Method not setup for node %s." % name)
	
func cinema_moveto( _target_spot : Vector2, _speed : String ) -> void:
	push_warning("Method not setup for node %s." % name)
