@abstract
@icon("uid://dd7dfu0ig0hgt")
extends Node
class_name B2_FSM
## Base class for all FSM states, used in B2_AI.

@export var my_STATE := B2_AI.STATE.IDLE

## AI Entered a new state
func enter() -> void:
	pass

## AI exited a state
func exit() -> void:
	pass

## Step function, executed on every process frame
func step() -> void:
	pass
