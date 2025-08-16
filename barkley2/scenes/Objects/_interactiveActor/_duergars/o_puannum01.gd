extends B2_Duergar

@export var o_onslow01 : B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
		
	duergar_name 							= "puannum"
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "s_puannum01"
	ANIMATION_SOUTH 						= "s_puannumSE"
	ANIMATION_SOUTHEAST 					= "s_puannumSE"
	ANIMATION_SOUTHWEST 					= "s_puannumSE"
	ANIMATION_WEST 							= "s_puannumSE"
	ANIMATION_NORTH 						= "s_puannumNE"
	ANIMATION_NORTHEAST 					= "s_puannumNE"
	ANIMATION_NORTHWEST 					= "s_puannumNE"
	ANIMATION_EAST 							= "s_puannumSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_puannum01"
	
	if get_room_name() == "r_tnn_businessDistrict01":
		if B2_Playerdata.Quest("gutterEscape") != 1: queue_free()
		elif  B2_Playerdata.Quest("gutterPlan") == 1: queue_free()
		else: cinema_lookat( o_onslow01 )
