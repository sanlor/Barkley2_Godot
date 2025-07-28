extends B2_InteractiveActor
## Meeting the Babby System

## bossBabby
	#0 = Has not been activated
	#1 = Is active and a boss
	#2 = Has been killed in a fight
	#3 = Remains dormant in the cellar

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Deactivations ##
	if get_room_name() == "r_sw1_plantation02":
		## While Gordo is alive he won't be up at the plantation ##
		if B2_Playerdata.Quest("gordoState") != 2:
			queue_free()
		##If he has been destroyed or left dormant in the cellar, he won't be up at the plantation ##
		if B2_Playerdata.Quest("bossBabby") >= 2:
			queue_free()
			
	elif get_room_name() == "r_sw2_gordo01":
		## If Gordo has been killed he should no longer appear in the cellar //
		if B2_Playerdata.Quest("gordoState") == 2:
			queue_free()
		## If he has been destroyed, he should no longer appear in the cellar //
		if B2_Playerdata.Quest("bossBabby") == 2:
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
