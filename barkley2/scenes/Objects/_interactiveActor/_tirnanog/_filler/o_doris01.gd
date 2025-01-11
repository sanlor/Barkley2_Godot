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
	if B2_Database.time_check("tnnCurfew") == "during" and get_room_name() == "r_tnn_residentialDistrict01":
		queue_free()
	elif B2_Database.time_check("tnnCurfew") == "during" and get_room_name() == "r_tnn_warehouseDistrict01":
		queue_free()
	elif B2_Database.time_check("tnnCurfew") == "before" and get_room_name() == "r_tnn_warehouseDistrict01":
		queue_free()
	elif B2_Database.time_check("tnnCurfew") == "after" and not get_room_name() == "r_tnn_warehouseDistrict01":
		queue_free()
#
	## Don't be in two spots at the same time ##
	if B2_ClockTime.time_gate() > 1 and get_room_name() == "r_tnn_residentialDistrict01":
		queue_free()
	if B2_ClockTime.time_gate() <= 1 and get_room_name() == "r_tnn_blockhouse01":
		queue_free()
#
	## Alley flip ##
	#if room = r_tnn_residentialDistrict01 then image_xscale = -1;
