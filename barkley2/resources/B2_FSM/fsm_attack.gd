@icon("uid://bsyonsnicik4j")
extends B2_FSM
class_name B2_FSM_Attack

@export var state_after_attack		:= B2_AI.STATE.IDLE
@export var max_attack_wait_time 	:= 1000.0
var curr_max_attack_wait_time 		:= 0.0

var has_attacked := false

func _init() -> void:
	my_STATE = B2_AI.STATE.ATTACK

func enter() -> void:
	super()
	my_actor.finished_attack_action.connect(_attack_finished)
	curr_max_attack_wait_time = max_attack_wait_time
	has_attacked = false

func exit() -> void:
	super()
	my_actor.finished_attack_action.disconnect(_attack_finished)

func step() -> void:
	if _has_enemy_actor() and not has_attacked:
		my_actor.curr_input 	= my_actor.global_position.direction_to( enemy_actor.global_position )
		my_actor.curr_aim 		= my_actor.global_position.direction_to( enemy_actor.global_position )
		my_ai.ranged_attack_trigger.emit( true )
		has_attacked = true
	if curr_max_attack_wait_time > 0.0: 
		curr_max_attack_wait_time -= 1.0
	else:
		push_error("%s: Attack animation timeout. this is bad and should not happen." % my_actor.name)
		my_ai.state_transition( my_STATE, state_after_attack )
		

func _attack_finished():
	my_ai.state_transition( my_STATE, state_after_attack )
