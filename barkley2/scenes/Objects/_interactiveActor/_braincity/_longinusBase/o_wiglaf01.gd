extends B2_InteractiveActor

## DSL - Brain City

#wiglafState = 0 - Wiglaf hasn't been spoken to (this triggers on script start)
#wiglafState = 1 - Wiglaf has been spoken to
#wiglafState = 2 - Wiglad has given you a Mission
#
#wiglafMission = 1 - You've been assigned to kill Cuchulainn in order to meet Cyberdwarf.
#wiglafMission = 2 - You've exited the rebel base through the hatch the Jhodfrey shows you.
#wiglafMission = 3 - You've made it passed the Variable Segment and are now entering Cuchu's lair
#wiglafMission = 4 - You've reported back to Wiglaf to complain and get full permission to meet Cyberdwarf.
#wiglafMission = 5 - you've chosen your identity and the "Wiglaf Mission" is over
#
#crustDead      = 1 - Killed first form Cuchu
#crustFightAny  = 1 - You've fought Cuchu Crustacea.
#cuchuLairDeath = 1 - you died in cuchu's lair
#
#tuberPeel = 0 - You do not know about Tuber Peeling duties
#tuberPeel = 1 - Hoopz has been assigned Tuber Peeling duties
#tuberPeel = 2 - Reported to Chandragupta
#tuberPeel = 3 - Tubers peeled, back to BCT
#tuberPeel = 4 - You saw the cinema where Wiglaf chews you out for poor peeling

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
