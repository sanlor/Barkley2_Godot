extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "janos"
	ANIMATION_STAND 						= "s_janos01"
	ANIMATION_SOUTH 						= "s_janosSE"
	ANIMATION_SOUTHEAST 					= "s_janosSE"
	ANIMATION_SOUTHWEST 					= "s_janosSE"
	ANIMATION_WEST 							= "s_janosSE"
	ANIMATION_NORTH 						= "s_janosNE"
	ANIMATION_NORTHEAST 					= "s_janosNE"
	ANIMATION_NORTHWEST 					= "s_janosNE"
	ANIMATION_EAST 							= "s_janosSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_janos01"
