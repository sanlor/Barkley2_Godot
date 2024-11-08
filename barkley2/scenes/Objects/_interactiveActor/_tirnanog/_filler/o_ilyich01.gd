extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= "s_vikingstadSE"
	ANIMATION_SOUTHEAST 					= "s_vikingstadSE"
	ANIMATION_SOUTHWEST 					= "s_vikingstadSE"
	ANIMATION_WEST 							= "s_vikingstadSE"
	ANIMATION_NORTH 						= "s_vikingstadNE"
	ANIMATION_NORTHEAST 					= "s_vikingstadNE"
	ANIMATION_NORTHWEST 					= "s_vikingstadNE"
	ANIMATION_EAST 							= "s_vikingstadSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"
	
	## NOTE Need to revise this actor. animations seems wrong.
