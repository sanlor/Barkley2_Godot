extends B2_InteractiveActor

func _ready() -> void:
	## Animation
	ANIMATION_STAND				= "default"
	ANIMATION_SOUTH 			= "s_zaneDOWN01"
	ANIMATION_SOUTHEAST 		= "s_zaneDOWN01"
	ANIMATION_SOUTHWEST 		= "s_zaneDOWN01"
	ANIMATION_WEST 				= "s_zaneDOWN01"
	ANIMATION_NORTH 			= "s_zaneUP01"
	ANIMATION_NORTHEAST 		= "s_zaneUP01"
	ANIMATION_NORTHWEST 		= "s_zaneDOWN01"
	ANIMATION_EAST 				= "s_zaneDOWN01"
	ANIMATION_STAND_SPRITE_INDEX 	= [ 1, 1, 0, 0, 0, 0, 0, 1 ]
	ActorAnim.animation 	= ANIMATION_STAND
	


func execute_event_user_1():
	# used in the r_fct_tutorialZone01 when givving a gun.
	# Looking at the original code, it seems some unused tutorial segment for shooting light bulbs.
	# check o_bustaBulb event 9
	pass
	
func execute_event_user_5():
	## Jalapeno smoke
	# This is so stupid, why is the smoke effect here?
	#Smoke("mass", o_cts_hoopz.x, o_cts_hoopz.y + 2, o_cts_hoopz.z + 24, 2, c_lime, 0.5);
	B2_Screen.add_smoke( "mass", B2_CManager.o_cts_hoopz.position, Color.LIME, 0.5 )

func execute_event_user_15():
	## Lock door at "r_fct_accessHall01"
	# Not sure if needed, since Jodfrey is already blocking the door.
	pass

func execute_event_user_10():
	## Disable click
	# this function doesnt exist yet.
	pass
	
func execute_event_user_11():
	## Spawn blue roses ala Dark Savior
	# Happens during the death scene "zaneJalapeno <= 1". Not sure what it does.
	# repeat (7) instance_create(x, y, o_effect_blue_rose);
	pass
