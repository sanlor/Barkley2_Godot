## FSM Stop
# Should not be instanciated directly, only extended.
@abstract
@icon("uid://c0a8mxfkhbqid")
extends B2_FSM
class_name B2_FSM_Stop

func _init() -> void:
	my_STATE = B2_AI.STATE.STOP
