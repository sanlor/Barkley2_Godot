extends RigidBody2D
class_name B2_CombatActor

@export var health 		:= 100.0

func apply_damage( _damage : float):
	pass

func cinema_lookat( target_node : Node2D ):
	var _direction := position.direction_to( target_node.position ).round()
	var dir_name := vec_2_dir_map.get( _direction, "SOUTH" ) as String
	cinema_look( dir_name )
	
func cinema_look( _direction : String ):
	ActorAnim.stop()
	
	if not ActorAnim.sprite_frames.has_animation(ANIMATION_STAND):
		push_error("Node %s has no animation called %s. You don goofed." % [name, ANIMATION_STAND] )
		return
		
	ActorAnim.animation = ANIMATION_STAND
	match _direction:
		"NORTH": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[0]
		"NORTHEAST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[1]
		"EAST": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[2]
		"SOUTHEAST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[3]
		"SOUTH": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[4]
		"SOUTHWEST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[5]
		"WEST": 		ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[6]
		"NORTHWEST": 	ActorAnim.frame = ANIMATION_STAND_SPRITE_INDEX[7]
			
	real_movement_vector = dir_2_vec_map.get( _direction, Vector2.DOWN) ## Default is South
	movement_vector =  real_movement_vector.round()
	
	ActorAnim.flip_h = false
	if not disable_auto_flip_h: flip_sprite()
	adjust_sprite_offset()
	
func cinema_moveto( _target_spot, _speed : String ):
	assert( is_instance_valid(ActorNav), "ActorNav not valid for node %s." % name )
	
	# Default behaviour
	match _speed:
		"MOVE_FAST": speed = speed_fast
		"MOVE_SLOW": speed = speed_slow
		"MOVE_NORMAL": speed = speed_normal
	
	if _target_spot == null:
		push_error(name, ": node is invalid. ", _target_spot, ".")
	# _target_spot can be eiher a node (Cinema Spot) or a position. What a mess.
	elif _target_spot is Node2D or _target_spot is Vector2:
		
		if _target_spot is Vector2:	destination 		= _target_spot
		else:						destination 		= _target_spot.position
			
		set_movement_target( destination )
		
		is_moving 				= true
		real_movement_vector 	= position.direction_to( destination )
		movement_vector 		= real_movement_vector.round()
		ActorCol.call_deferred("set_disabled", true) # Disable collision while moving
	return
