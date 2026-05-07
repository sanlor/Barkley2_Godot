## Actor moves torward the target and changes state after reaching a certain distance.
@icon("uid://dadcamgwa58ra")
extends B2_FSM
class_name B2_FSM_GO_NEAR_PLAYER

@export var target_distance_from_player := 64.0 ## Minimum distance from the player.
@export var next_action : B2_FSM

func _init() -> void:
	my_STATE = B2_AI.STATE.CHASE
	
func _target_reached() -> void:
	my_ai.state_transition( my_STATE, B2_AI.STATE.READY_ATTACK ) dfg
