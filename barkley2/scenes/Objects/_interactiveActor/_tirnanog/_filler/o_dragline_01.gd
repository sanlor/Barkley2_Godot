extends B2_InteractiveActor

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "s_dragline01"
	ANIMATION_SOUTH 						= "walk_S"
	ANIMATION_SOUTHEAST 					= "walk_SE"
	ANIMATION_SOUTHWEST 					= "walk_SW"
	ANIMATION_WEST 							= "walk_W"
	ANIMATION_NORTH 						= "walk_N"
	ANIMATION_NORTHEAST 					= "walk_NE"
	ANIMATION_NORTHWEST 					= "walk_NW"
	ANIMATION_EAST 							= "walk_E"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_dragline01"
