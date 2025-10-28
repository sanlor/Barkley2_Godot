@icon("uid://dadcamgwa58ra")
extends B2_FSM
class_name B2_FSM_Chase

@export var enemy_detection_radius := 48.0

func _init() -> void:
	if my_STATE == B2_AI.STATE.NONE:
		my_STATE = B2_AI.STATE.CHASE

func step() -> void:
	if enemy_actor:
		if my_actor.global_position.distance_to( enemy_actor.global_position ) > enemy_detection_radius:
			my_ai.state_transition( my_STATE, B2_AI.STATE.IDLE )
			print( "idle" )
