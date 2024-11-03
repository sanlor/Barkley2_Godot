extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	duergar_name 							= "onslow"
	ANIMATION_STAND 						= "s_onslow01"
	ANIMATION_SOUTH 						= "s_onslowSE"
	ANIMATION_SOUTHEAST 					= "s_onslowSE"
	ANIMATION_SOUTHWEST 					= "s_onslowSE"
	ANIMATION_WEST 							= "s_onslowSE"
	ANIMATION_NORTH 						= "s_onslowNE"
	ANIMATION_NORTHEAST 					= "s_onslowNE"
	ANIMATION_NORTHWEST 					= "s_onslowNE"
	ANIMATION_EAST 							= "s_onslowSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_onslow01"
