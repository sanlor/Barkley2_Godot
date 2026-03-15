extends B2_Duergar

var o_kim01 : 			B2_Duergar
var o_door_tech_01: 	B2_Door_Tech

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
	
	if not o_kim01:
		o_kim01 = get_sibling("o_kim01")
	if not o_door_tech_01:
		o_door_tech_01 = get_sibling("o_door_tech01")
		
	if get_room_area() == "tnn":
		 # Tir na Nog, gutter scene #
		if get_room_name() == "r_tnn_businessDistrict01":
			if B2_Playerdata.Quest("gutterEscape") != 1: queue_free()
			elif B2_Playerdata.Quest("gutterPlan") == 1: queue_free()
			else: 
				if o_kim01: cinema_lookat( o_kim01 )
				else: push_error("%s: Actor o_kim01 not found.")
		elif B2_Database.time_check("tnnCurfew") == "during" and get_room_name() == "r_tnn_maingate02": queue_free()
		
func execute_event_user_0():
	if o_door_tech_01:	o_door_tech_01.locked = false
	else:				push_error("%s: Door o_door_tech01 not found." % name)
	
# /// Create patrol
func execute_event_user_10():
	## Not implemented yet
	breakpoint
	
# // AFTER GOV SPEECH CHECKS FOR SOME STUFF //
func execute_event_user_15():
	if B2_Playerdata.Quest("govCow") == 2:
		B2_ClockTime.time_event("govCow", 4, 60);
	if B2_Playerdata.Quest("govKalevi") == 2:
		B2_ClockTime.time_event("govKalevi", 4, 60);
