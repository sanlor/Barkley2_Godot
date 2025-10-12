## Masego in the Industrial Park
extends B2_InteractiveActor

## figbottomQuest
	#0 - Nothing has been done
	#1 - Heard about Figbottom Quest
	#2 - Failed Quest? -
	#3 - Quest accepted -
	#4 - Suresh tells you to talk to Kunigunde
	#5 - Kunigunde tells you to talk to Moriarty
	#6 - Moriarty's clue about Suresh        
	#7 - Sureshs clue about Kunigunde
	#8 - Kunigunde talked to about tontine
	#9 - Someone has been arrested
#figbottomPerp (another way to check who was arrested)
	#0 = no one has been accused/arrested
	#1 = Suresh has been arrested
	#2 = Kunigunde has been arrested
	#3 = Moriarty has been arrested
	#4 = You've been arrested

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
