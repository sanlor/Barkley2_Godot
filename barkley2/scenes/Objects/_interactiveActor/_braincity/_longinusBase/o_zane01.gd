extends B2_InteractiveActor

func _ready() -> void:
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "s_zaneDOWN01"
	ANIMATION_SOUTHEAST 		= "s_zaneDOWN01"
	ANIMATION_SOUTHWEST 		= "s_zaneDOWN01"
	ANIMATION_WEST 				= "s_zaneDOWN01"
	ANIMATION_NORTH 			= "s_zaneUP01"
	ANIMATION_NORTHEAST 		= "s_zaneUP01"
	ANIMATION_NORTHWEST 		= "s_zaneDOWN01"
	ANIMATION_EAST 				= "s_zaneDOWN01"
	ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
	ActorAnim.animation 	= ANIMATION_STAND

func execute_event_user_10():
	## Disable click
	# this function doesnt exist yet.
	pass
