extends B2_AI
class_name B2_AI_Enemy

func _init() -> void:
	ready.connect( func() -> void: _register_states(); _state_setup() )
	#state_changed.connect( state_transition )
	
## DEPRECATED on 07/05/26
## DE-DEPRECATED on 08/05/26
## After the ready function, register all curr states, look for duplicates and shiet.
func _register_states() -> void:
	for child in get_children():
		if child is B2_FSM:
			child.my_actor 		= get_parent()
			child.my_ai 		= self
			child.enemy_actor 	= B2_CManager.o_hoopz
		else:
			push_error("Invalid AI State: %s - %s" % [child.name, get_parent().name]); continue

## Step function, executed on every process frame
func step() -> void:
	if curr_STATE:
		curr_STATE.step()
	
	if debug_visualization: queue_redraw()
