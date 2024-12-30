extends B2_InteractiveActor

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
	
	## In during curfew, out before and after curfew ##
	#if (scr_time_db("tnnCurfew") == "during") and room = r_tnn_residentialDistrict01 then scr_event_interactive_deactivate();
	#else if (scr_time_db("tnnCurfew") == "during") and room = r_tnn_warehouseDistrict01 then scr_event_interactive_deactivate();
	#else if (scr_time_db("tnnCurfew") == "before") and room = r_tnn_warehouseDistrict01 then scr_event_interactive_deactivate();
	#else if (scr_time_db("tnnCurfew") == "after") and room != r_tnn_warehouseDistrict01 then scr_event_interactive_deactivate();
#
	## Don't be in two spots at the same time ##
	#if ClockTime() > 1 and room = r_tnn_residentialDistrict01 then scr_event_interactive_deactivate();
	#if ClockTime() <= 1 and room = r_tnn_blockhouse01 then scr_event_interactive_deactivate();
#
	## Alley flip ##
	#if room = r_tnn_residentialDistrict01 then image_xscale = -1;
