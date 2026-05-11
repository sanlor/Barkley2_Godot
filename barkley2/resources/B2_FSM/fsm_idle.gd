@icon("uid://cu0ttnwa0ykoc")
extends B2_FSM
class_name B2_FSM_Idle

@export_category("Enemy detection")
@export var enemy_detection_radius 	:= 32.0		# Distance is in Pixels
@export var detected_state 			: B2_FSM

@export_category("Time to Wander")
@export var wander_time 			:= 4.0		# Time is in seconds
@export var wander_state 			: B2_FSM

var wander_timer : Timer

func _ready() -> void:
	assert( detected_state, "'detected_state' not set.")
	assert( wander_state, "'wander_state' not set.")

func enter() -> void:
	super()
	wander_timer = _create_timer( _trigger_timer )
	wander_timer.start( wander_time * randf_range(0.5,1.5) )

func exit() -> void:
	super()
	if wander_timer:
		_timer_cleanup( wander_timer, _trigger_timer )

func _trigger_timer() -> void:
	my_ai.state_transition( self, wander_state )

func step() -> void:
	if _has_enemy_actor():
		if my_actor.global_position.distance_to( enemy_actor.global_position ) < enemy_detection_radius:
			my_ai.state_transition( self, detected_state )
	
	#curr_wander_time -= TIME_DECREASE
	#if curr_wander_time < 0.0:
		#my_ai.state_transition( self, wander_state )
	
	my_actor.curr_input 	= my_actor.curr_input.move_toward(Vector2.ZERO,0.1)
	my_actor.curr_aim 		= my_actor.curr_aim.move_toward(Vector2.ZERO,0.1)
	if my_actor.curr_input.is_zero_approx(): 	my_actor.curr_input = Vector2.ZERO
	if my_actor.curr_aim.is_zero_approx(): 		my_actor.curr_aim = Vector2.ZERO
