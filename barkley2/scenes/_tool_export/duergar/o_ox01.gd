extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "ox"
	ANIMATION_STAND 						= "s_ox01"
	ANIMATION_SOUTH 						= "s_oxSE"
	ANIMATION_SOUTHEAST 					= "s_oxSE"
	ANIMATION_SOUTHWEST 					= "s_oxSE"
	ANIMATION_WEST 							= "s_oxSE"
	ANIMATION_NORTH 						= "s_oxNE"
	ANIMATION_NORTHEAST 					= "s_oxNE"
	ANIMATION_NORTHWEST 					= "s_oxNE"
	ANIMATION_EAST 							= "s_oxSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_ox01"
