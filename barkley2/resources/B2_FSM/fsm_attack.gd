@icon("uid://bsyonsnicik4j")
extends B2_FSM
class_name B2_FSM_Attack

@export var attack_again_state		: B2_FSM
@export var after_attack_state		: B2_FSM
@export var max_attack_wait_time 	:= 1000.0
@export var randomly_attack_again	:= false
var curr_max_attack_wait_time 		:= 0.0

var has_attacked := false

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
		
func _attack_finished():
	if randomly_attack_again and randf() > 0.5:
		my_ai.state_transition( self, attack_again_state )
	else:
		my_ai.state_transition( self, after_attack_state )
