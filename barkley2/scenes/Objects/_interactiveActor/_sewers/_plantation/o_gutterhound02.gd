extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Hermit chair
	if get_room_name() == "r_sw2_hermitPass01":
		if B2_Playerdata.Quest("gutterEscape") == 2 && B2_Playerdata.Quest("chanticleerSafety") == 3:
			ActorAnim.animation = "sitting"
		else:
			queue_free()
			
	else:
		## TODO make this actor an pedestrian
		push_warning("This function is not ready yet.")
		
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
