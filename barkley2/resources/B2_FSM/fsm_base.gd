@abstract
@icon("uid://car41rhwx5kxu")
extends Node
class_name B2_FSM
## Base class for all FSM states, used in B2_AI.
## @tutorial(): https://www.youtube.com/watch?v=ow_Lum-Agbs

@export var my_STATE := B2_AI.STATE.NONE

var my_ai			: B2_AI
var my_actor 		: B2_CombatActor
var enemy_actor 	: B2_CombatActor

func register_my_actor( _my_actor : B2_CombatActor ) -> void:
	my_actor = _my_actor

func register_enemy_actor( _enemy_actor : B2_CombatActor ) -> void:
	enemy_actor = _enemy_actor

## AI Entered a new state
func enter() -> void:
	if not is_instance_valid(my_ai): 		my_ai 			= get_parent()
	if not is_instance_valid(my_actor): 	breakpoint
	if not is_instance_valid(enemy_actor): 	enemy_actor 	= B2_CManager.o_hoopz

## AI exited a state
func exit() -> void:
	pass

## Step function, executed on every process frame
func step() -> void:
	pass
