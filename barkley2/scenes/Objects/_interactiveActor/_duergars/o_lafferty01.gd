extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	duergar_name 							= "lafferty"
	ANIMATION_STAND 						= "s_lafferty01"
	ANIMATION_SOUTH 						= "s_laffertySE"
	ANIMATION_SOUTHEAST 					= "s_laffertySE"
	ANIMATION_SOUTHWEST 					= "s_laffertySE"
	ANIMATION_WEST 							= "s_laffertySE"
	ANIMATION_NORTH 						= "s_laffertyNE"
	ANIMATION_NORTHEAST 					= "s_laffertyNE"
	ANIMATION_NORTHWEST 					= "s_laffertyNE"
	ANIMATION_EAST 							= "s_laffertySE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_lafferty01"
