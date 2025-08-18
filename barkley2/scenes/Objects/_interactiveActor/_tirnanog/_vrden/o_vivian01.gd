extends B2_InteractiveActor

## Vivian the "Mallow Runnin'" Granny

#Variables
	#vivianState
		#0 = not talked
		#1 - talked to
	#grannyIncapped
		#0 - you haven't killed Granny
		#1 - you have killed Granny

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("grannyIncapped") == 1:
		ActorAnim.animation = "onground"
	else:
		ActorAnim.animation = "default"
		
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
