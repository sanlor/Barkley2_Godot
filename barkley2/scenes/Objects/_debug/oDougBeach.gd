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
const CUCHU_LOBBY 					: B2_Script_Legacy = preload("uid://pps4h3mr3g56")
const GILBERT_S_PEAK 				: B2_Script_Legacy = preload("uid://cuuy4direimui")


## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if get_room_name() == "r_bct_tower06":				cutscene_script = LONGINUS_DEBUG
	if get_room_name() == "r_sw2_indianRopeTrick01":	cutscene_script = INDIAN_ROPE
	if get_room_name() == "r_tnn_bballcourt02":			cutscene_script = KATSU_SCENE_PRIME
	if get_room_name() == "r_chu_elevatorLobby01":		cutscene_script = CUCHU_LOBBY
	if get_room_name() == "r_chu_crustDoor01":			cutscene_script = CUCHU_DOOR_ROOM
	if get_room_area() == "min":						cutscene_script = GAUNTLET
	if get_room_name() == "r_tri_colosseum01":			cutscene_script = TRISKELION_SLAUGHTER
	if get_room_name() == "r_pri_prisonInside01" || get_room_name() == "r_pri_prisonGate01": cutscene_script = PRISON_ALL_QUEST
	if get_room_name() == "r_est_industrialZone01":		cutscene_script = THE_SOCIAL
	if get_room_area() == "pea":						cutscene_script = GILBERT_S_PEAK
	if get_room_name() == "r_bct_towerZion":			cutscene_script = DWARF_ZION
	
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
