extends B2_FSM_Stop
class_name B2_FSM_Stop_DarkRat

@export var chance_to_chase 	:= 0.0025 ## If randf() is smaller than this value, start chasing. Check on every step.
@export var look_sfx			:= "explosiverat_stopandlook"

func enter() -> void:
	super()
	## Face a random direction
	my_actor.curr_input = Vector2.LEFT.rotated( randf_range(0,TAU) )
	my_actor.play_local_sound( look_sfx )

func step() -> void:
	my_actor.curr_input = Vector2.ZERO
	
	if randf() < chance_to_chase:
		my_ai.state_transition( my_STATE, B2_AI.STATE.CHASE )
