extends B2_InteractiveActor

## Frampton is the steward of the VRW Station Area.
# He looks after the people that are stuck in VRW but still have the mortal needs in Brain City.
# It would be great if he was applying Hydrating Gel into a VRW users mouth.
# He feels like he's stuck in Diner Dash.  This could only really be pulled off if he has a cool dashing animation so the alternative is:
# He jusy hates his job.
#
## Frampton's Variables:
# framptonState = 0 - you've never met Frampton
# framptonState = 1 - you've met Frampton and he's told you to talk to Cosette to buy your account
# framptonState = 2 - not used currently
# framptonState = 3 - you've been asked about OO and possibly been chided for good
#
# framptonRestart = 1 - used only to restart the event to count your chidings
#
# framptonChides = 0 - never been Chided
# framptonChides >= garners more intense chidings
#
## Related Variables:
# vrwAccount == 0 - no account for VRW
# vrwAccount == 1 - created an account for VRW
# vrwLoggedIn == 0 - you've never logged in
# vrwLoggedIn == 1 - you've experienced Oligarchy Online, even for a moment
# knowDwarfNET == 1 - you've heard about DwarfNET

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
