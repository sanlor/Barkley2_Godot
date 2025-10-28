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

enum STATE{NONE,IDLE,CHASE}

var actor : B2_CombatActor 		## That me!
var is_active := false			## NOTE Is this used?

## Step function, executed on every process frame
func step() -> void:
	pass

## AI Action
func action() -> void:
	push_warning("Invalid AI action")
