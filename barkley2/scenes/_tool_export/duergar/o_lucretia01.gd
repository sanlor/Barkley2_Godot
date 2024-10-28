extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	duergar_name 							= "lucretia"
	ANIMATION_STAND 						= "s_lucretia01"
	ANIMATION_SOUTH 						= "s_lucretiaSE"
	ANIMATION_SOUTHEAST 					= "s_lucretiaSE"
	ANIMATION_SOUTHWEST 					= "s_lucretiaSE"
	ANIMATION_WEST 							= "s_lucretiaSE"
	ANIMATION_NORTH 						= "s_lucretiaNE"
	ANIMATION_NORTHEAST 					= "s_lucretiaNE"
	ANIMATION_NORTHWEST 					= "s_lucretiaNE"
	ANIMATION_EAST 							= "s_lucretiaSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_lucretia01"
