extends B2_AI
class_name B2_AI_Player

## Player AI. Receives user inputs and puppeters the parent node (o_hoopz).
func step() -> void:
	if actor:
		actor.curr_input = Input.get_vector("Left","Right","Up","Down")
		actor.curr_aim = actor.get_global_mouse_position()
