extends B2_InteractiveActor

func _ready() -> void:
	## Deactivate after church scene ##
	if B2_Playerdata.Quest("giuseppeScene") >= 1 and get_room_name() == "r_tnn_giuseppesChurch01":
		queue_free()

	## Deactivate if Giuseppe has received the donation ##
	if B2_Playerdata.Quest("govChurch") >= 2 and get_room_name() == "r_tnn_giuseppesChurch01":
		queue_free()
		
	_setup_actor()
	_setup_interactiveactor()
	
	ANIMATION_STAND 						= "s_babalugats01"
	ANIMATION_SOUTH 						= "walk_S"
	ANIMATION_SOUTHEAST 					= "walk_SE"
	ANIMATION_SOUTHWEST 					= "walk_SW"
	ANIMATION_WEST 							= "walk_W"
	ANIMATION_NORTH 						= "walk_N"
	ANIMATION_NORTHEAST 					= "walk_NE"
	ANIMATION_NORTHWEST 					= "walk_NW"
	ANIMATION_EAST 							= "walk_E"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 1, 1]
	ActorAnim.animation 					= "s_babalugats01"

func execute_event_user_4():
	queue_free()
