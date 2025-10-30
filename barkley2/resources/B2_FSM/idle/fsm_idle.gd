@icon("uid://cu0ttnwa0ykoc")
extends B2_FSM
class_name B2_FSM_Idle

@export_category("Enemy detection")
@export var enemy_detection_radius := 32.0

@export_category("Time to Wander")
@export var wanter_time := 20.0
var curr_wanter_time := 0.0

func _init() -> void:
	if my_STATE == B2_AI.STATE.NONE:
		my_STATE = B2_AI.STATE.IDLE

func enter() -> void:
	super()
	curr_wanter_time = wanter_time

func step() -> void:
	if enemy_actor:
		if my_actor.global_position.distance_to( enemy_actor.global_position ) < enemy_detection_radius:
			my_ai.state_transition( my_STATE, B2_AI.STATE.CHASE )
	
	if curr_wanter_time > 0.0:
		curr_wanter_time -= TIME_DECREASE
	else: my_ai.state_transition( my_STATE, B2_AI.STATE.CHASE )
	
	my_actor.curr_input 	= my_actor.curr_input.lerp(Vector2.ZERO,0.1)
	my_actor.curr_aim 		= my_actor.curr_aim.lerp(Vector2.ZERO,0.1)
