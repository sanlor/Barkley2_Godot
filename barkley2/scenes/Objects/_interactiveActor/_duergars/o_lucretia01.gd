extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
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
	
	# Gone from market after gov quest #
	if B2_Playerdata.Quest("govQuest") >= 6 and get_room_name() == "r_tnn_marketDistrict01": queue_free()

	# Not there during curfew #
	if B2_Database.time_check("tnnCurfew") == "during": queue_free()

	# Gone after TNN lockdown #
	if B2_Playerdata.Quest("escapedFromTNN") >= 2 and get_room_name() == "r_tnn_maingate02": queue_free()

func execute_event_user_10():
	## Create patrol
	# TODO
	# with (id) scr_event_interactive_deactivate();
	# obj = instance_create(x, y, o_lucretia_patrol);
	# Destroy(id);
	# with (obj) target_number = 0;
	breakpoint
