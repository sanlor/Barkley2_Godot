## Suresh, trash lover of the Industrial Park
extends B2_InteractiveActor

#VARIABLES
	#figbottomQuest
		#0 - Nothing has been done
		#1 - Heard about Figbottom Quest
		#2 - Failed Quest?
		#3 - Quest accepted
		#4 - Suresh tells you to talk to Kunigunde
		#5 - Kunigunde tells you to talk to Moriarty
		#6 - Moriartys clue about Suresh        
		#7 - Sureshs clue about Kunigunde
		#8 - Kunigunde talked to about tontine
		#9 - Someone has been arrested    
	#sureshArrest
		#0 = suresh hasn't been arrested
		#1 = suresh has been arrested for Figbottoms murder     

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	if B2_Playerdata.Quest("sureshJerkinless") == 1:
		ActorAnim.animation = "default"
	else:
		ActorAnim.animation = "jerkin"
	
	# Arrested #
	if B2_Playerdata.Quest("sureshArrest") == 1:
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
