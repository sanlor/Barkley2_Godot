@icon("uid://c4falt3d7l7sx")
extends B2_FSM
class_name B2_FSM_Ready_Attack

@export var attack_delay := 20.0
var curr_attack_delay := 0.0

func _init() -> void:
	if my_STATE == B2_AI.STATE.NONE:
		my_STATE = B2_AI.STATE.READY_ATTACK

func enter() -> void:
	super() ## 28/10/25 Cool, first time using "super"
	curr_attack_delay = attack_delay
	
func step() -> void:
	if curr_attack_delay > 0.0:
		curr_attack_delay -= TIME_DECREASE
		if enemy_actor:
			my_actor.curr_aim = my_actor.curr_aim.lerp( my_actor.global_position.direction_to(enemy_actor.global_position), 0.1 )
		print(curr_attack_delay)
		print(my_actor.curr_aim)
	else:
		my_ai.state_transition( my_STATE, B2_AI.STATE.ATTACK )
		
	my_actor.curr_input = Vector2.ZERO
