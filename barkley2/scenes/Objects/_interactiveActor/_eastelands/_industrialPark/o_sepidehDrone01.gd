extends B2_InteractiveActor

#sepidehDrone
	#0 = Nothing
	#1 = Found drone, not talked to Sepideh
	#2 = Found drone, have talked to Sepideh
	#3 = Decline battery use
	#4 = Accepted battery use

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Deactiavte once flown #
	if B2_Playerdata.Quest("sepidehDrone") == 4:
		queue_free()
		
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

func execute_event_user_0():
	## gravity_z = 5;
	# instance_create(x, y, o_sepidehDrone_dummy);
	# o_sepidehDrone_dummy.depth = depth;
	# visible = 0;
	breakpoint
	
# Check if duergs are already dead
func execute_event_user_1():
	if B2_Playerdata.Quest("duergar_dead_osiris") == 0: 
		B2_Playerdata.Quest("osirisDroned", 1);
	if B2_Playerdata.Quest("duergar_dead_deveraux") == 0: 
		B2_Playerdata.Quest("deverauxDroned", 1);
		
func execute_event_user_2():
	queue_free()
