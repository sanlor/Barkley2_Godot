extends B2_Duergar

@onready var audio_emitter: B2_AudioEmitter = $B2_AudioEmitter

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	duergar_name 							= "constantine"
	ANIMATION_STAND 						= "s_constantine01"
	ANIMATION_SOUTH 						= "s_constantineSE"
	ANIMATION_SOUTHEAST 					= "s_constantineSE"
	ANIMATION_SOUTHWEST 					= "s_constantineSE"
	ANIMATION_WEST 							= "s_constantineSE"
	ANIMATION_NORTH 						= "s_constantineNE"
	ANIMATION_NORTHEAST 					= "s_constantineNE"
	ANIMATION_NORTHWEST 					= "s_constantineNE"
	ANIMATION_EAST 							= "s_constantineSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "default"
