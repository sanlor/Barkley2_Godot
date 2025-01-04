extends B2_Duergar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Curfew not implemented
	
	## Make him patrol if curfew
	#if (scr_time_db("tnnCurfew") == "during") visible = 0;
	#event_inherited();
	#if (guplur) exit;
	
	# Time events not implemented
	
	##DEACTIVATE
	#if (scr_time_db("tnnCurfew") == "during") and room != r_tnn_rebelbase02 then scr_event_interactive_deactivate();
	#if B2_Playerdata.Quest("govQuest") >= 6 and get_parent().name == "r_tnn_residentialDistrict01":
		#queue_free()
	## WARNING ^^^^^ Use B2_QuestCleanup instead.

	## Gone after TNN lockdown ##
	#if B2_Playerdata.Quest("escapedFromTNN") >= 2 and get_parent().name == "r_tnn_maingate02":
	#	queue_free()
	## WARNING ^^^^^ Use B2_QuestCleanup instead.
	
	duergar_name 							= "ox"
	ANIMATION_STAND 						= "s_ox01"
	ANIMATION_SOUTH 						= "s_oxSE"
	ANIMATION_SOUTHEAST 					= "s_oxSE"
	ANIMATION_SOUTHWEST 					= "s_oxSE"
	ANIMATION_WEST 							= "s_oxSE"
	ANIMATION_NORTH 						= "s_oxNE"
	ANIMATION_NORTHEAST 					= "s_oxNE"
	ANIMATION_NORTHWEST 					= "s_oxNE"
	ANIMATION_EAST 							= "s_oxSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_ox01"
