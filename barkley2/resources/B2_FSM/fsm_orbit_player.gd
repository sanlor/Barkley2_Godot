@icon("uid://cu0ttnwa0ykoc")
extends B2_FSM
class_name B2_FSM_Orbit_Player

@export_category("Orbit")
@export var orbit_distance 			:= 64.0
@export var orbit_timer 			:= 4.0 # In seconds
@export var orbit_timer_variation 	:= 2.0 # Add a modifier to the 'orbit_timer' -> orbit_timer + randf_range( 0.0, orbit_timer_variation )
@export var orbit_action_state		: B2_FSM # Action after the timer elapses.

@export_category("De-aggro")
@export var deaggro_distance 		:= 128.0
@export var deaggro_state			: B2_FSM # Action after the deaggro_distance is reached.

func _ready() -> void:
	assert( orbit_action_state, "'orbit_action_state' is not valid." )
	assert( deaggro_state, "'deaggro_state' is not valid." )
