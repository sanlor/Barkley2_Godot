extends B2_InteractiveActor

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "stand"
	ANIMATION_SOUTH 						= "mantis_DOWN"
	ANIMATION_SOUTHEAST 					= "mantis_DOWN"
	ANIMATION_SOUTHWEST 					= "mantis_DOWN"
	ANIMATION_WEST 							= "mantis_RIGHT"
	ANIMATION_NORTH 						= "mantis_UP"
	ANIMATION_NORTHEAST 					= "mantis_RIGHT"
	ANIMATION_NORTHWEST 					= "mantis_UP"
	ANIMATION_EAST 							= "mantis_RIGHT"
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "stand"
