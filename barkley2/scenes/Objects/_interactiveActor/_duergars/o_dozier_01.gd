## Dozier, in the Hoosegow
extends B2_Duergar

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	# Prison intro #
	if B2_Playerdata.Quest("prisonIntro") != 1 and get_room_name() == "r_pri_prisonGate01": 			queue_free()
	if B2_Playerdata.Quest("prisonIntro") != 2 and get_room_name() == "r_pri_prisonCourt01": 			queue_free()
	if B2_Playerdata.Quest("prisonIntro") != 3 and get_room_name() == "r_pri_prisonProcessing01": 		queue_free()
	
	ANIMATION_STAND 						= "s_dozier01"
	ANIMATION_SOUTH 						= "s_dozierSE"
	ANIMATION_SOUTHEAST 					= "s_dozierSE"
	ANIMATION_SOUTHWEST 					= "s_dozierSE"
	ANIMATION_WEST 							= "s_dozierSE"
	ANIMATION_NORTH 						= "s_dozierNE"
	ANIMATION_NORTHEAST 					= "s_dozierNE"
	ANIMATION_NORTHWEST 					= "s_dozierNE"
	ANIMATION_EAST 							= "s_dozierSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_dozier01"
