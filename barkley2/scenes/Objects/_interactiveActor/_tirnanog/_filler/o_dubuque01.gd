extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Animation ##
	if is_inside_room():
		ActorAnim.animation = "inside"
	else:
		ActorAnim.animation = "default"
	
	## Activation & Deactivation for Curfew
	if B2_Database.time_check("tnnCurfew") == "during" and not is_inside_room():
		queue_free()
	if not B2_Database.time_check("tnnCurfew") == "during" and is_inside_room():
		queue_free()
	
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
