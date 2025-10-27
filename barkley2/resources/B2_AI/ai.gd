## Base class for all AIs.
# Contains some interfaces for a AI or the player to communicate to the Actor.
@abstract
@icon("uid://doli655kh53ie")
extends Node
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

enum STATE{IDLE}

@export var initial_state : B2_FSM
var my_states : Dictionary[STATE, B2_FSM]
var curr_STATE : STATE

var actor : B2_CombatActor 		## That me!
var is_active := false			## NOTE Is this used?

func _init() -> void:
	ready.connect( _populate_states )
	
## After the ready function, register all curr states, look for duplicates and shiet.
func _populate_states() -> void:
	for child in get_children():
		if child is B2_FSM:
			if my_states.has( child.my_STATE ): push_error("Duplicated AI State: %s - %s" % [child.name, get_parent().name]); continue
			my_states[ child.my_STATE ] = child
		else:
			push_error("Invalid AI State: %s - %s" % [child.name, get_parent().name]); continue

func state_transition( _curr_state : STATE, _new_state : STATE ) -> void:
	if _curr_state == _new_state:	return
	if curr_STATE == _new_state:	return
		
	if my_states.has( _curr_state ):		## Run Exit function.
		my_states[_curr_state].exit()
	else: push_error( "Invalid AI State: %s - %s" % [STATE.keys()[_curr_state], get_parent().name] )
	
	if my_states.has( _new_state ):			## Register stuff and run Enter function.
		curr_STATE = _new_state
		my_states[_new_state].enter()
		state_changed.emit( curr_STATE )
	else: push_error( "Invalid AI State: %s - %s" % [STATE.keys()[_new_state], get_parent().name] )
	
## Step function, executed on every process frame
func step() -> void:
	if curr_STATE:
		my_states[curr_STATE].step()

## AI Action
func action() -> void:
	push_warning("Invalid AI action")
