extends B2_InteractiveActor



## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	B2_Playerdata.Quest("gamename", B2_Vidcon.get_vidcon_name(16) )
	if B2_Playerdata.Quest("govChurch") == 2:
		ActorAnim.animation = "fancy"
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

func execute_event_user_0():
	B2_Vidcon.give_vidcon( 16 )
