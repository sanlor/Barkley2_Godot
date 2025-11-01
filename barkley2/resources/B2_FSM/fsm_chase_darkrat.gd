## Special DarkRat behaviour.
# After chasing for some time, randomly stop.
extends B2_FSM_Chase
class_name  B2_FSM_Chase_DarkRat

@export var chance_to_stop := 0.0025 ## If randf() is smaller than this value, stop chasing. Check on every step.

## Disable the "Far" action
func _target_far() -> void:
	pass

func step() -> void:
	if randf() < chance_to_stop:
		my_ai.state_transition( my_STATE, B2_AI.STATE.STOP )
	super()
