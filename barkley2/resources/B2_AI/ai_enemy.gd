extends B2_AI
class_name B2_AI_Enemy

@export var initial_state : B2_FSM
var my_states : Dictionary[STATE, B2_FSM]
var curr_STATE : STATE

func _init() -> void:
	ready.connect( _register_states )
	state_changed.connect( state_transition )
	
## Apply initial state and warn in case a initial state is not set
func _state_setup() -> void:
	if initial_state:
		curr_STATE = initial_state.my_STATE
	else:
		push_warning("%s: AI not set with 'initial_state'. Setting the first one as the 'initial_state'." % get_parent().name )
		if get_child_count() > 0:
			if get_children().front() is B2_FSM:
				curr_STATE = get_children().front().my_STATE
			else:
				push_error("%s: AI has no valid FSM. you fucked up big time." % get_parent().name )
				breakpoint
		else:
			push_error("%s: AI has no FSM set. you fucked up big time." % get_parent().name )
			breakpoint
	
## After the ready function, register all curr states, look for duplicates and shiet.
func _register_states() -> void:
	for child in get_children():
		if child is B2_FSM:
			if my_states.has( child.my_STATE ): push_error("Duplicated AI State: %s - %s" % [child.name, get_parent().name]); continue
			my_states[ child.my_STATE ] = child
			child.my_actor = get_parent()
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
