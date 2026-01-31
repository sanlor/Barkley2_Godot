extends B2_InteractiveActor

#Chaiyaporn is a character with a big brain.
	# It is mutated by proximity to the Brain City Brain.
	# He can answer all sorts of questions, but if you ask him "Who am I?" his head will explode.
	# Brainfan One and Brainfan Two are his constant cohorts.
	
	# TODO: Something that happens when you kill the Brain. His powers subside?
	##----------------------------
	## QUEST VARIABLES
	##----------------------------
	#chaiyapornState
		#0 = have not talked
		#1 = have talked
		#2 = have asked a question, been astounded
	#chaiyapornLoop
		#1 = looping in chaiyaporn's event. only programmatically important, should leave every event as 0 again.
	#chaiyapornCount
		#1 to 4 = counts the number of questions asked
		#5 = turns on chaiyapornTime, resets to 0
	#chaiyapornTime
		#1 = indicates the player must wait for a time unit to pass before getting another round of questions
	#chaiyapornExplode
		#1 = he's exploded!
	#chaiyapornBattle
	#chaiyapornWorld
	#chaiyapornAbout
	#chaiyapornSelf
		#all of the above 4 increase when you ask questions in a given category
		#they have variable max values going up from 0

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
	
	if B2_Playerdata.Quest("chaiyapornExplode") == 1:
		queue_free()
