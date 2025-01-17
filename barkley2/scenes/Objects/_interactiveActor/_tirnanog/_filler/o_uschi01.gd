extends B2_InteractiveActor
	## Uschi the Baller Queen of TnN
	## Uschi, the b-ball girl.

	#VARIABLES
		#uschiGov
			#0 - Not talked to Uschi as governor
			#1 - Have talked to Uschi as governor
		#uschiLookingFlavor 
			#0 - Slight response change
			#1 - Slight response change
		#uschiState
			#0 - never talked to Uschi
			#1 - talked to her
		#uschiBall
			#0 - haven't talked about balling
			#1 - turned her down to ball, you can come back and challenge later
			#2 - Quest for the third baller has begun
			#3 - You now have a baller and need to challenge the Duergars
			#4 - You have a duergar challenge accepted - you can play the game now
			#5 - You lost the game against the Duergars and can try again if you leverage something
			#6 - You won the game and got the Clandestine Courts Baller Zine
			#7 - Commish repeat
			#8 - You forgot to get back to Uschi in time and the quest is locked out
			#9 - You told Uschi to frub off, failing the quest
		#bballComplete
			#1 - a switch to send you right to the snippet where Uschi reacts to the results of the game
		#knowDwarfLeague
			#0 - Never heard of the Dwarf Leagues
			#1 - Heard of the Dwarf Leagues
			#2 - Heard of "The Commish"
		#oozeBall
			#1 - Ooze offers to ball for a price
			#2 - Ooze agrees to ball for a price
			#3 - The game is over and Ooze no longer wants to ball
			#4 - Ooze has played and is opened up for more games
			#5 - Ooze needs more money to play again  

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Deactivate if outdoors during curfew ##
	if B2_Database.time_check("tnnCurfew") == "during" and not is_inside_room():
		queue_free()
	
	## Deactivate if Uschi has gone back inside after getting angry with you ##
	if B2_Playerdata.Quest("uschiBall") == 9 and get_room_name() == "r_tnn_bballcourt02":
		queue_free()
		
	if B2_Playerdata.Quest("uschiBall") != 9:
		## Indoors during curfew ##
		if not B2_Database.time_check("tnnCurfew") == "during" and is_inside_room():
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
