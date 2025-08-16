extends B2_Duergar

@export var o_kim01 : B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") == "during": hide()
	
	# if (guplur) exit; ## The fuck is this???
	
	_setup_actor()
	_setup_interactiveactor()
	
	duergar_name 							= "onslow"
	ANIMATION_STAND 						= "s_onslow01"
	ANIMATION_SOUTH 						= "s_onslowSE"
	ANIMATION_SOUTHEAST 					= "s_onslowSE"
	ANIMATION_SOUTHWEST 					= "s_onslowSE"
	ANIMATION_WEST 							= "s_onslowSE"
	ANIMATION_NORTH 						= "s_onslowNE"
	ANIMATION_NORTHEAST 					= "s_onslowNE"
	ANIMATION_NORTHWEST 					= "s_onslowNE"
	ANIMATION_EAST 							= "s_onslowSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_onslow01"
	
	if get_room_area() == "tnn":
		 # Tir na Nog, gutter scene #
		if get_room_name() == "r_tnn_businessDistrict01":
			if B2_Playerdata.Quest("gutterEscape") != 1: queue_free()
			elif B2_Playerdata.Quest("gutterPlan") == 1: queue_free()
			else: cinema_lookat( o_kim01 )
		elif B2_Database.time_check("tnnCurfew") == "during" and get_room_name() == "r_tnn_maingate02": queue_free()
