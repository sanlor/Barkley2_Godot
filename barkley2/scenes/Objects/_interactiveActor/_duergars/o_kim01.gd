extends B2_Duergar

@export var o_onslow01 : B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# //DEACTIVATE
	if B2_Database.time_check("tnnCurfew") == "during" and get_room_name() != "r_tnn_maingate02": queue_free()

	# // Gone after TNN lockdown //
	if B2_Playerdata.Quest("escapedFromTNN") >= 2 and get_room_name() == "r_tnn_maingate02": queue_free()

	_setup_actor()
	_setup_interactiveactor()
	
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
	
	if get_room_name() == "r_tnn_businessDistrict01":
		if B2_Playerdata.Quest("gutterEscape") != 1: 		queue_free()
		elif B2_Playerdata.Quest("gutterPlan") == 1: 		queue_free()
		else: cinema_lookat(o_onslow01);
