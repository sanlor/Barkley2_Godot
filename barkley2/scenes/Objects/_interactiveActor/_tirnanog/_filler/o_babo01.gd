extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= " sKatsuSE"
	ANIMATION_SOUTHEAST 					= " sKatsuSE"
	ANIMATION_SOUTHWEST 					= " sKatsuSE"
	ANIMATION_WEST 							= " sKatsuSE"
	ANIMATION_NORTH 						= " sKatsuNE"
	ANIMATION_NORTHEAST 					= " sKatsuNE"
	ANIMATION_NORTHWEST 					= " sKatsuNE"
	ANIMATION_EAST 							= " sKatsuSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"
