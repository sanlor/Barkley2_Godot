@abstract
@icon("uid://car41rhwx5kxu")
extends Node
class_name B2_FSM
## Base class for all FSM states, used in B2_AI.
## @tutorial(): https://www.youtube.com/watch?v=ow_Lum-Agbs

const TIME_DECREASE := 1.0

## DEPRECATED on 08/05/26
#var my_STATE 		:= B2_AI.STATE.NONE

var my_ai			: B2_AI				# The AI that is using this FSM
var my_actor 		: B2_CombatActor	# The Actor that has the AI that uses this FSM
var enemy_actor 	: B2_CombatActor	# The enemy to target.

func _ready() -> void:
	B2_CManager.o_hoopz_changed.connect( func(): enemy_actor = B2_CManager.o_hoopz ) # Update target IF hoopz changes costumes during combat.

## Check if you have an enemy registered.
func _has_enemy_actor() -> bool:
	if B2_CManager.o_hoopz and not enemy_actor:
		## Issue with enemy_actor definition. this should never occur.
		enemy_actor = B2_CManager.o_hoopz
		#breakpoint
		
	if enemy_actor:									return not enemy_actor.is_actor_dead
	#elif B2_CManager.o_hoopz:						return not B2_CManager.o_hoopz.is_actor_dead
	else:											return false

## Register myself (The actor that has this AI).
func register_my_actor( _my_actor : B2_CombatActor ) -> void:
	my_actor = _my_actor

## Register your enemy (Usually Hoopz).
func register_enemy_actor( _enemy_actor : B2_CombatActor ) -> void:
	enemy_actor = _enemy_actor

## AI Entered a new state.
func enter() -> void:
	if not my_ai: 			my_ai 			= get_parent()
	if not my_actor: 		breakpoint
	if not enemy_actor:		enemy_actor		= B2_CManager.o_hoopz 

## AI exited a state.
func exit() -> void:
	pass

## Step function, executed on every process frame.
func step() -> void:
	pass
