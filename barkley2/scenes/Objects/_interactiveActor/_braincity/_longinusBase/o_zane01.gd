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
	ActorAnim.animation 	= ANIMATION_STAND