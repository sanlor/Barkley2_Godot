@icon("uid://ve2133l2re3k")
extends B2_FSM
class_name B2_FSM_Wander

@export var wander_distance := 48.0

func _init() -> void:
	if my_STATE == B2_AI.STATE.NONE:
		my_STATE = B2_AI.STATE.WANDER
