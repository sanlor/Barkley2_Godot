extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Default DJ Name to current P_NAME
	if str(B2_Playerdata.Quest("djName")) == "0": 			B2_Playerdata.Quest("djName", 			Text.pr("P_NAME") )
	if str(B2_Playerdata.Quest("djNamePrefix")) == "0": 	B2_Playerdata.Quest("djNamePrefix", 	Text.pr("P_NAME") )

	# Object Variables used during Booty Bass Minigame
	B2_Playerdata.Quest("booty_just_named", 	0);
	B2_Playerdata.Quest("booty_just_won", 		0);
	B2_Playerdata.Quest("booty_just_lost", 		0);
	B2_Playerdata.Quest("booty_bootyslayer_go", 0);
	B2_Playerdata.Quest("booty_bulldog_go", 	0);
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

# Camera reset - won't work in DSL
# NOTE Seems to be useless.
func execute_event_user_10():
	breakpoint
