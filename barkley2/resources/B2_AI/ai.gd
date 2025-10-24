## Base class for all AIs.
# Contains some interfaces for a AI or the player to communicate to the Actor.
@abstract
extends Node
class_name B2_AI

# https://shaggydev.com/2023/10/08/godot-4-state-machines/

signal ranged_attack_trigger( 	active : bool ) ## Actor is  firing ranged weapon
signal melee_attack_trigger( 	active : bool ) ## Actor is attacking at melee range
signal aim_trigger( 			active : bool ) ## Actor is aiming its weapon / getting ready to fire
signal roll_trigger( 			active : bool ) ## Actor is rolling torward a direction
signal charge_trigger( 			active : bool ) ## Actor is Charging at a direction
signal jump_trigger(			active : bool ) ## Actor is Jumping

var actor : B2_CombatActor
var is_active := false

## AI Entered a new state
func enter() -> void:
	pass

## AI exited a state
func exit() -> void:
	pass

## Step function, executed on every process frame
func step() -> void:
	pass

## AI Action
func action() -> void:
	push_warning("Invalid AI action")
