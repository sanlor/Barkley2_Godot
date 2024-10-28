extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "kim"
	ANIMATION_STAND 						= "s_kim01"
	ANIMATION_SOUTH 						= "s_kimSE"
	ANIMATION_SOUTHEAST 					= "s_kimSE"
	ANIMATION_SOUTHWEST 					= "s_kimSE"
	ANIMATION_WEST 							= "s_kimSE"
	ANIMATION_NORTH 						= "s_kimNE"
	ANIMATION_NORTHEAST 					= "s_kimNE"
	ANIMATION_NORTHWEST 					= "s_kimNE"
	ANIMATION_EAST 							= "s_kimSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_kim01"
