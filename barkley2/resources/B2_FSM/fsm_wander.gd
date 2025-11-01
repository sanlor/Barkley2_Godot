@icon("uid://ve2133l2re3k")
extends B2_FSM
class_name B2_FSM_Wander

@export var wander_distance 		:= 64.0
var my_target						:= Vector2.INF ## Global coordinates

@export_category("Enemy detection")
@export var enemy_detection_radius 	:= 64.0

@export var wander_timeout 			:= 500.0 ## Make sure that the actor doesnt get stuck in this statevar 
var curr_wander_timeout				:= 0.0

func _init() -> void:
	my_STATE = B2_AI.STATE.WANDER

func enter() -> void:
	super()
	get_target()
	curr_wander_timeout = wander_timeout

func get_target() -> bool:
	for try : int in 10:
		## https://docs.godotengine.org/en/stable/tutorials/physics/ray-casting.html
		var space_state 	:= my_actor.get_world_2d().direct_space_state
		var possible_target := my_actor.to_global( Vector2( randf_range(-wander_distance,wander_distance) , randf_range(-wander_distance,wander_distance) ) )
		var query 			:= PhysicsRayQueryParameters2D.create( my_actor.global_position, possible_target, 0xFFFFFFFF, [my_actor.get_rid()])
		var result 			:= space_state.intersect_ray(query)
		if result.is_empty():
			my_target = possible_target
			return true
	
	my_target = Vector2.INF
	return false

func step() -> void:
	## Enemiy detection
	if _has_enemy_actor():
		if my_actor.global_position.distance_to( enemy_actor.global_position ) < enemy_detection_radius:
			my_ai.state_transition( my_STATE, B2_AI.STATE.CHASE )
			
	if my_target != Vector2.INF:
		## Wander movement
		var ActorNav := my_actor.ActorNav as NavigationAgent2D
		
		ActorNav.set_target_position( my_target )
		my_actor.curr_input = my_actor.global_position.direction_to( ActorNav.get_next_path_position() )
		#print(my_target)
		if my_actor.global_position.distance_to( my_target ) < 12.0:
			my_ai.state_transition( my_STATE, B2_AI.STATE.IDLE )
	
	curr_wander_timeout -= TIME_DECREASE
	if curr_wander_timeout < 0:
		push_error("Wander timeout reached for %s. fix this." % my_actor.name)
		my_ai.state_transition( my_STATE, B2_AI.STATE.IDLE )
