extends B2_AI
class_name B2_AI_Enemy
## AI for enemies. Duh.

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
			if B2_CManager.o_hoopz:
				child.enemy_actor 	= B2_CManager.o_hoopz
		else:
			push_error("Invalid AI State: %s - %s" % [child.name, get_parent().name]); continue

## Step function, executed on every process frame
func step() -> void:
	if curr_STATE:
		curr_STATE.step()
	else:
		if get_children().is_empty():
			push_error("%s: No FSM detected. Bitch, you fucked up! Removing the actor %s from this dimension, fix this mess!!!" % [self.name, get_parent().name])
			breakpoint
			get_parent().queue_free()
		else:
			push_error("%s: curr_STATE not set for actor %s! Picking the first one I see... Which iiiiiiis... %s." % [self.name, get_parent().name, get_children().front().name])
			curr_STATE = get_children().front()
	
	if debug_visualization: queue_redraw()
