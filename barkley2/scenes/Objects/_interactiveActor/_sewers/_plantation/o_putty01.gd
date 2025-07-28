extends B2_InteractiveActor

@export var corner : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Go huddle in the corner ##
	if B2_Playerdata.Quest("bossBabby") == 1:
		if corner:
			position = corner.position
			ActorAnim.stop()
		else:
			## Forgot to set Cinema0
			breakpoint
			
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"
