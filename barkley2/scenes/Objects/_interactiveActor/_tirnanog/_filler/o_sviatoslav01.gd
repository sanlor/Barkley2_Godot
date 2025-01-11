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
	
	## Sviatoslav, resident TnN conspiracy theorist
	# Variables
		# sviatoslavState
			# 0 = never spoken to him
			# 1 = Spoken to Sviatoslav before
		# sviatoslavTip
			# 0 = you haven't asked him for tips
			# 1 = he tells you that there are hidden codes everywhere, you can now bring him a note
			
	## Activation & Deactivation for Curfew
	if B2_Database.time_check("tnnCurfew") == "during" and not is_inside_room():
		queue_free()
		
	if not B2_Database.time_check("tnnCurfew") == "during" and is_inside_room():
		queue_free()
