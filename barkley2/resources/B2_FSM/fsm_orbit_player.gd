@icon("uid://cu0ttnwa0ykoc")
extends B2_FSM
class_name B2_FSM_Orbit_Player

@export_category("Orbit")
@export var orbit_distance 			:= 64.0
@export var orbit_speed 			:= 32.0
@export var orbit_timer 			:= 4.0 # In seconds
@export var orbit_timer_variation 	:= 2.0 # Add a modifier to the 'orbit_timer' -> orbit_timer + randf_range( 0.0, orbit_timer_variation )
@export var orbit_action_state		: B2_FSM # Action after the timer elapses.

@export_category("De-aggro")
@export var deaggro_distance 		:= 128.0
@export var deaggro_state			: B2_FSM # Action after the deaggro_distance is reached.

var timer 			: Timer
var angled_vector 	:= Vector2.ZERO
var angle_progress 	:= 0.0

func _ready() -> void:
	super()
	assert( orbit_action_state, "'orbit_action_state' is not valid." )
	assert( deaggro_state, "'deaggro_state' is not valid." )

func enter() -> void:
	# Create timer
	timer = Timer.new()
	add_child( timer, true )
	timer.start( orbit_timer + randf_range( 0.0, orbit_timer_variation ) )
	timer.connect( "timeout", _trigger_timer )
	
func exit() -> void:
	# Free timer
	timer.disconnect( "timeout", _trigger_timer )
	timer.stop()
	timer.queue_free()
	
func _trigger_timer() -> void:
	my_ai.state_transition( self, orbit_action_state )

func step() -> void:
	angle_progress = wrapf( angle_progress + orbit_speed * get_process_delta_time(), 0.0, TAU )
	
	if enemy_actor:
		var angle := (Vector2.RIGHT * orbit_distance).rotated( angle_progress )
		angled_vector = enemy_actor.global_position + angle
		#print( angled_vector )
	
	my_actor.curr_input = my_actor.global_position.direction_to( angled_vector )
