extends B2_InteractiveActor

## Katsu, the less than impressive 3rd teammate for BBTTX

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "sKatsu"
	ANIMATION_SOUTH 						= " sKatsuSE"
	ANIMATION_SOUTHEAST 					= " sKatsuSE"
	ANIMATION_SOUTHWEST 					= " sKatsuSE"
	ANIMATION_WEST 							= " sKatsuSE"
	ANIMATION_NORTH 						= " sKatsuNE"
	ANIMATION_NORTHEAST 					= " sKatsuNE"
	ANIMATION_NORTHWEST 					= " sKatsuNE"
	ANIMATION_EAST 							= " sKatsuSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "sKatsu"
	
	#VARIABLES
	#katsuState
		#0 - never talked to him
		#1 - talked to him once
		#2 - talked to him twice (flavor)
		#3 - heard about his skills
#
	#knowKatsuBall
	#0 - don't know he thinks he can ball
	#1 - know he thinks he can ball
	#2 - know that Uschi thinks he sucks
	#3 - seen that he sucks
#
	#katsuBall
		#1 - Katsu agrees to play, need to go tell Uschi about it
		#2 - Uschi tells Hoopz that Katsu can go fuck himself
		#3 - Hoopz tells Katsu he can't play but Katsu asks Hoopz to convince Uschi otherwise
		#4 - Hoopz reports to Uschi, she shuts him down, but then Katsu delivers his Hope Speech
		#5 - Repeating dialog before the game
		#6 - Katsu's default END State if you don't choose him to help with bball (whether he knows about it or not)
		#
	#oozeBall
		#2 - Got Ooze to agree to play
		#4 - Ooze is in the team officially, need to find Duergs now

	#bballMention (this is a band-aid variable for fuckerproofing, difference between telling Katsu you'll recommend him to Uschi or just doing it)
		#0 - haven't mentioned the game to katsuBall
		#1 - HAVE mentioned the game to katsu
	
	if get_room_name() == "r_tnn_bballcourt02" and B2_Playerdata.Quest("katsuBall") <= 3:
		queue_free()
		
	if get_room_name() == "r_tnn_ghettoofsadness01" and B2_Playerdata.Quest("katsuBall") == 4:
		queue_free()
