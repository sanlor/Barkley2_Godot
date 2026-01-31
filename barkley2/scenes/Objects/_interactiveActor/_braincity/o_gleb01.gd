extends B2_InteractiveActor

var gleb_early 		:= 5.0
var gleb_collapse 	:= 13.0
var gleb_middle 	:= gleb_collapse - 1.0

var gleb_late 		:= 18.0

# gleb's required value to move in
var gleb_req 		:= 50.0
# gleb's rent
var gleb_rent 		:= 15.0

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
	
	# if gleb is in the dilapidated zone
	if B2_Playerdata.Quest("glebOffer") == 3:
		queue_free()
		
	# if already collapsed
	if get_room_name() == "r_bct_dwarfZion01" and B2_ClockTime.time_gate() > gleb_collapse:
		queue_free()
		
	# if not yet collapsed
	if get_room_name() == "r_bct_dwarfZionAlley01" and B2_ClockTime.time_get() <= gleb_collapse:
		queue_free()
		
	# reset glebState 2 to 1, if the situation has changed
	if B2_Playerdata.Quest("glebState") == 2:
		if B2_Playerdata.Quest("glebTime") <= gleb_early and B2_ClockTime.time_gate() > gleb_early:
			B2_Playerdata.Quest("glebState", 1);
			
		elif B2_Playerdata.Quest("glebTime") <= gleb_middle && B2_ClockTime.time_gate() > gleb_middle:
			B2_Playerdata.Quest("glebState", 1)
			
		elif B2_Playerdata.Quest("glebTime") == gleb_collapse and B2_ClockTime.time_gate() > gleb_collapse:
			B2_Playerdata.Quest("glebState", 1);
			
		elif B2_Playerdata.Quest("glebCollapse") == 0:
			if B2_ClockTime.time_gate() >= 2 + B2_Playerdata.Quest("glebTime") and B2_Playerdata.Quest("glebTime") > gleb_early:
				B2_Playerdata.Quest("glebState", 1);

	elif B2_Playerdata.Quest("glebCollapse") == 0:
		if B2_ClockTime.time_gate() >= 2 + B2_Playerdata.Quest("glebTime") and B2_Playerdata.Quest("glebTime") > gleb_early:
			B2_Playerdata.Quest("glebState", 1);
	
	# Spin speed
	if B2_Playerdata.Quest("glebState") == 0:
		ActorAnim.stop()
		ActorAnim.frame = 0
	elif B2_Playerdata.Quest("glebState") == 2:
		ActorAnim.play()
		ActorAnim.speed_scale = 1.00
	elif B2_Playerdata.Quest("glebState") == 4:
		ActorAnim.play()
		ActorAnim.speed_scale = 2.00
