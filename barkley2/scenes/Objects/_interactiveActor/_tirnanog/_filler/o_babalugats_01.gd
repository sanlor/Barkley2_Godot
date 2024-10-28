extends B2_InteractiveActor

func _ready() -> void:
	ANIMATION_STAND 						= "s_babalugats01"
	ANIMATION_SOUTH 						= "walk_S"
	ANIMATION_SOUTHEAST 					= "walk_SE"
	ANIMATION_SOUTHWEST 					= "walk_SW"
	ANIMATION_WEST 							= "walk_W"
	ANIMATION_NORTH 						= "walk_N"
	ANIMATION_NORTHEAST 					= "walk_NE"
	ANIMATION_NORTHWEST 					= "walk_NW"
	ANIMATION_EAST 							= "walk_E"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 1, 1]
	ActorAnim.animation 					= "s_babalugats01"
