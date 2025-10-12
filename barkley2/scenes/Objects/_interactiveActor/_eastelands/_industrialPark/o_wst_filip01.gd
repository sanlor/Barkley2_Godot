extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	# NPC script for Filip, the train ticket seller. He is a con artist and is selling train tickets to a train that doesn't exist. The player can keep buying a new ticket from him during every new time period. The script SHOULD check to see if the player already purchased a train ticket and if a new time has been reached, at which point Filip takes your ticket and gives you the option to buy a new one. Also I decided to give brief flavor dialogue where the player asks Filip questions about the train depending on the time. This makes the script a bit more complicated but the NPC felt really empty without something like that. Considering Filip's ticket check is already on the complicated side, I figured I'd flesh it out more. I also did this because I couldn't figure out a way to make Filip check your ticket only AFTER time has progressed so I tried to get clever with states and shit.
	# NOTE: This script is hinged on the object "Train Ticket" that Filip will sell to you. When a new time has reached Filip will take your train ticket from you automatically and attempt to sell you a new one. The game will probably explode if there is no train ticket item in the game or if we change the name of that item!!!!
	# NOTE: This script is semi-related to the Grieg script in that you can take the ticket and sell it to Grieg for a net loss. I thought about reflecting that in this script somehow, but I already made this script senselessly complicated and didn't find it necessary to make matters worse.
		  
	# Bail out after you give ticket to Grieg //
	if B2_Playerdata.Quest("wstGrieg") == 2:
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
