# Moriarty the psycho, shanks you right away
extends B2_InteractiveActor

## NOTE This seems incomplete. Cant find the dialog script for this one.

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	## Deactivate if prison is liberated
	if B2_Playerdata.Quest("prisonLiberated") == 3: queue_free()

	## Deactivate if she isn't arrested
	if B2_Playerdata.Quest("moriartyArrest") != 1: queue_free()
	
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
