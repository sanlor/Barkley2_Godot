extends B2_InteractiveActor

const CODE_SNIPPETS 				: B2_Script_Legacy = preload("uid://byxj3hcxagev")
const CUCHU_DOOR_ROOM 				: B2_Script_Legacy = preload("uid://bw4ueynesyoft")
const DWARF_ZION 					: B2_Script_Legacy = preload("uid://eatpvvuyakh")
const GAUNTLET 						: B2_Script_Legacy = preload("uid://20diwpk4wx1v")
const INDIAN_ROPE 					: B2_Script_Legacy = preload("uid://i7qg87dna21d")
const KATSU_SCENE_PRIME 			: B2_Script_Legacy = preload("uid://eluitgc673mu")
const LONGINUS_DEBUG 				: B2_Script_Legacy = preload("uid://84gtul73cxgm")
const PRISON_ALL_QUEST 				: B2_Script_Legacy = preload("uid://p0eoaj1sheif")
const THE_SOCIAL 					: B2_Script_Legacy = preload("uid://c53jsr55kd7gx")
const TRISKELION_SLAUGHTER 			: B2_Script_Legacy = preload("uid://c55mtdxph1sfi")


## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
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
