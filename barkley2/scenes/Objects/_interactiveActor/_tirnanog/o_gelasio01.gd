extends B2_InteractiveActor

## Meeting Gelasio for the first time

# REVISED GELASIO, he's a turncoat informant for the Duergars murdered Augustine in the Swamps
# He gives you FREE GUTS points because you drink GRAPE JUICE with him for each note you give him.

#Variables
	#gelasioState
		#0 - not talked
		#1 - talked, he offers the grape, you declined
		#2 - you've drank the grape! but have not agreed to help look for augie yet. 
		#3 - you have agreed to look for augie. (USED TO BE: you assume the Baldomero is Augustine, this increases the Marquee for this Quest)
		#4 - Gelasio has been found out as a turncoat, but you lose (time advances)
		#5 - Gelasio gets freaked out by the letter from Augustino and disappears looking for him (he shows up later Dead in the Wasteland)
		#
	#gelasioDuergar (this is increased initially by Aelfleda and Jindrich)
		#0 - no suspicion of Duergar Involvment
		#1 - more suspicion
		#2 - even more suspicion
		#
	#Note Variables
		#duergarInfoRuins
			#0 - none
			#1 - the Duergars will be told that there is an Ancient Ruins in the Undersewers!
		#duergarInfoLonginus
			#0 - none
			#1 - you are arrested once you enter the LONGINUS base
		#duergarInfoGamingKlatch
			#0 - none
			#1 - the Duergars will be told about the Gaming Klatch Existence, one more add and it will be raided!
			#2 - the Gaming Klatch will be raided!
		#duergarInfoBBall
			#0 - none
			#1 - When you get to the Bball Hideaway, the Commish is gone,
				#he's arrested in 1 time unit and sent to prison.
		#duergarInfoCornrow
			#0 - none
			#1 - Cornrow and Juicebox are executed and crucified in the Prison
		#duergarInfoWilmer
			#0 - none
			#1 - Wilmer is immediately taken to the Prison (He'll get jacked in prison)
		#duergarInfoAelfleda
			#0 - none
			#1 - Aelfleda is immediately taken to the prison (She'll be super happy in prison, as she'll be fed and have shelter)
			#2 - if Chanticleer has taken in Aelfelda, then you still get rewarded, lose her eviction, but she doesn't show up in prison
			#3 - sold her and Chanti out to Gelasio, both are arrested.

#// Not sitting there during the curfew //
#//TODO: he is somewhere else during the curfew? As a clue that he is buddy buddy with the duergs
#//TODO: he vanishes at gelasioState == 5, and after curfew if gelasioState == 4 

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	# Runs off after you spook him with the Augustino Letter
	# Doesn't show up till ClockTime 2
	if B2_Playerdata.Quest("gelasioState") == 6 or B2_ClockTime.time_gate() < 1: 
		#print(B2_ClockTime.time_gate())
		queue_free()
	print(B2_ClockTime.time_gate())
	## Runs off (like a bitch) ##
	if B2_Playerdata.Quest("gelasioState") == 5:
		B2_Playerdata.Quest("gelasioState", 6);
		queue_free()
		
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

## Grape bonuses
func execute_event_user_4():
	var stat := B2_Playerdata.player_stats
	stat.increase_base_stat( stat.STAT_BASE_GUTS, 1)
