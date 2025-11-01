extends B2_AI
class_name B2_AI_Enemy

func _init() -> void:
	ready.connect( func() -> void: _register_states(); _state_setup() )
	#state_changed.connect( state_transition )
	
## After the ready function, register all curr states, look for duplicates and shiet.
func _register_states() -> void:
	for child in get_children():
		if child is B2_FSM:
			assert(child.my_STATE != STATE.NONE, "Invalid FSM state for %s!" % child.name)
			if my_states.has( child.my_STATE ): push_error("Duplicated AI State: %s - %s - %s" % [child.name, get_parent().name, my_states.keys()]); continue
			my_states[ child.my_STATE ] = child
			child.my_actor = get_parent()
		else:
			push_error("Invalid AI State: %s - %s" % [child.name, get_parent().name]); continue
	#print( my_states )

## Step function, executed on every process frame
func step() -> void:
	if curr_STATE:
		my_states[curr_STATE].step()
	
	if debug_visualization: queue_redraw()

func _draw() -> void:
	#draw_circle( Vector2.ZERO, 128, Color.PINK )
	pass
	
	
