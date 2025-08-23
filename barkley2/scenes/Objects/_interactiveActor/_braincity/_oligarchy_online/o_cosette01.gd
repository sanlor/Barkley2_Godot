extends B2_InteractiveActor

## Cosette the O.O. Account Manager

#Variables
#cosetteState
	#0 = not talked to Cosette
	#1 = talked to Cosette
	#2 = you have backed away from buying an account
#vrwAccount
	#0 = you don't have an account
	#1 = you have an account
#vrwType
	#0 = you do not have an account
	#1 = you have the Pay-As-You-Go account
	#2 = you have the Hourly account
	#3 = you have the Year Subscription account
#
#Related Variables:
#knowOO 
	#0 = never known about 
	#1 = you've heard about OO and so you do not enquire about it.
	#2 = you know that brain city tower 5 has OO in it, Cosette sells it
	#3 = you talk to Cosette and know that you can get OO from her

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
