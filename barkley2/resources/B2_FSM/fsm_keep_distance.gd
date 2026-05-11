## Actor get near the target, but not so near
@icon("uid://cu0ttnwa0ykoc")
extends B2_FSM
class_name B2_FSM_Keep_Distance

@export_category("Setup")
@export var enemy_desired_distance	 		:= 64.0
@export var next_action_timer				:= 6.0
@export var next_action_timer_variation 	:= 4.0 # Add a modifier to the 'next_action_timer' -> next_action_timer + randf_range( 0.0, next_action_timer_variation )
@export var next_action_state 				: B2_FSM

var timer : Timer

func _ready() -> void:
	assert(next_action_state)

func enter() -> void:
	super()
	timer = _create_timer( _trigger_timer )
	timer.start( next_action_timer + randf_range( 0.0, next_action_timer_variation ) )

func _trigger_timer() -> void:
	my_ai.state_transition( self, next_action_state )

func step() -> void:
	if _has_enemy_actor():
		var ActorNav := my_actor.ActorNav as NavigationAgent2D
		var target := B2_CManager.o_hoopz
		var distanced_target := target.global_position + target.global_position.direction_to( my_actor.global_position ) * enemy_desired_distance
		
		## Avoid vibrating while trying to reach the target distance
		if distanced_target.distance_squared_to( my_actor.global_position ) > 16.0:
			ActorNav.set_target_position( distanced_target )
			my_actor.curr_input = my_actor.global_position.direction_to( ActorNav.get_next_path_position() )
		else:
			my_actor.curr_input = Vector2.ZERO
		
		if always_face_the_enemy:
			my_actor.curr_aim = my_actor.global_position.direction_to( target.global_position )
