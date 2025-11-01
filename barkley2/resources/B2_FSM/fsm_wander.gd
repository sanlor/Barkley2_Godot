@icon("uid://ve2133l2re3k")
extends B2_FSM
class_name B2_FSM_Wander

@export var wander_distance 	:= 48.0
var my_target					:= Vector2.ZERO

func _init() -> void:
	my_STATE = B2_AI.STATE.WANDER

func step() -> void:
	push_warning("NOT ADDED YET")
	my_ai.state_transition( my_STATE, B2_AI.STATE.IDLE )
