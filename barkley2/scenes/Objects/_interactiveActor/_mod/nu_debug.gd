extends B2_InteractiveActor

func _ready() -> void:
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "walk_s"
	ANIMATION_SOUTHEAST 		= "walk_s"
	ANIMATION_SOUTHWEST 		= "walk_s"
	ANIMATION_WEST 				= "walk_w"
	ANIMATION_NORTH 			= "walk_n"
	ANIMATION_NORTHEAST 		= "walk_n"
	ANIMATION_NORTHWEST 		= "walk_n"
	ANIMATION_EAST 				= "walk_e"
	ANIMATION_STAND_SPRITE_INDEX 	= [ 2, 2, 3, 0, 0, 0, 1, 2 ] # N, NE, E, SE, S, SW, W, NW
	ActorAnim.animation 	= ANIMATION_STAND
