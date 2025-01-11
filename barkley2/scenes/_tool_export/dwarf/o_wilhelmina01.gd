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
	
	if is_inside_room(): ## Only exist inside a room during Curfew.
		if B2_Database.time_check("tnnCurfew") == "before":
				queue_free()
				
		if B2_Database.time_check("tnnCurfew") == "after":
				queue_free()
	else:
		# Outside.
		if B2_Database.time_check("tnnCurfew") == "during":
				queue_free()
				
		if B2_Database.time_check("tnnCurfew") == "after":
				queue_free()
