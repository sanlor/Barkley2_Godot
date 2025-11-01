## Base class for all AIs.
# Contains some interfaces for a AI or the player to communicate to the Actor.
@abstract
@icon("uid://doli655kh53ie")
extends Node2D
class_name B2_AI
# https://shaggydev.com/2023/10/08/godot-4-state-machines/
# https://www.sandromaglione.com/articles/how-to-implement-state-machine-pattern-in-godot
# https://gdscript.com/solutions/godot-state-machine/

## Actor control signal
# These signals are used to activate specific functions of the actor.
# Enemies and Hoopz share these functions, so that we are able to control enemies or add an AI to Hoopz
signal ranged_attack_trigger( 	active : bool ) ## Actor is  firing ranged weapon
signal melee_attack_trigger( 	active : bool ) ## Actor is attacking at melee range
signal aim_trigger( 			active : bool ) ## Actor is aiming its weapon / getting ready to fire
signal roll_trigger( 			active : bool ) ## Actor is rolling torward a direction
signal charge_trigger( 			active : bool ) ## Actor is Charging at a direction
signal jump_trigger(			active : bool ) ## Actor is Jumping

## FSM Signals
# Signals used to control the behaviour for the FSM.
signal state_changed( state : B2_FSM )

## All states an AI can have
enum STATE{
	NONE,			## Invalid state.
	IDLE,			## AI is not doing anything
	CHASE,			## Chasing the enemy
	STOP,
	WANDER,			## Was idle, move to a different location
	READY_ATTACK,	## Is begining to attack or charging an attack
	ATTACK,			## Is attacking. NOTE should last 1 frame most of the time.
	DYING,			## Its dying, emitting particles, gibs and such. cant be removed yet.
	DEAD			## Its dead. NOTE should last 1 frame most of the time.
	}

@export_category("Debug Stuff")
@export var debug_visualization := true

@export_category("Setup Stuff")
var my_states : Dictionary[STATE, B2_FSM]
var curr_STATE : STATE

var actor : B2_CombatActor 		## That me!
var is_active := false			## NOTE Is this used?

## Apply initial state and warn in case a initial state is not set
func _state_setup() -> void:
	if get_child_count() > 0: # Check if there are any FSM setup.
		if get_children().front() is B2_FSM:
			state_transition( curr_STATE , get_children().front().my_STATE ) # The initial state is always the first one.
		else: push_error("%s: AI has no valid FSM. you fucked up big time." % get_parent().name ); breakpoint
	else: push_error("%s: AI has no FSM set. you fucked up big time." % get_parent().name ); breakpoint

## Cleanly change states, by running its enter and exit functions.
func state_transition( _curr_state : STATE, _new_state : STATE ) -> void:
	if _curr_state == _new_state:	return ## Do nothing for the same state
	if curr_STATE == _new_state:	return ## Do nothing for the same state
	if _new_state == STATE.NONE:	return ## Do nothing the initial state as NONE
		
	if my_states.has( _curr_state ):		## Run Exit function.
		my_states[_curr_state].exit()
	#else: push_error( "Invalid AI State: %s - %s - %s" % [STATE.keys()[_curr_state], get_parent().name, my_states] )
	
	if my_states.has( _new_state ):			## Register stuff and run Enter function.
		curr_STATE = _new_state
		my_states[_new_state].enter()
		state_changed.emit( curr_STATE, _new_state )
	else: push_error( "Invalid AI State: %s - %s - %s" % [STATE.keys()[_new_state], get_parent().name, my_states] ); breakpoint
	print_rich("[color=red][b]%s: DEBUG changed state from %s to %s.[/b][/color]" % [get_parent().name, STATE.keys()[_curr_state], STATE.keys()[_new_state]])

## Step function, executed on every process frame
func step() -> void:
	pass

## AI Action
func action() -> void:
	push_warning("Invalid AI action")
