extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	if B2_Playerdata.Quest("chanticleerRoommate") == 3:
		queue_free()
	 
	## Remove her if you've ratted her out to Gelasio (she goes to prison, where she is happy and fed)
	elif B2_Playerdata.Quest("duergarInfoAelfleda") == 1:
		queue_free()
		
	## Remove her if you've hesitated on paying her rent
	elif B2_Playerdata.Quest("aelfledaEvict") == 3:
		queue_free()

	## Remove her if curfew gets too far gone
	#elif (scr_time_db("tnnCurfew") == "during") and (ClockTime() > 2.7) then scr_event_interactive_deactivate();
	## TODO Time based events are not working

	##To be safe, also remove after curfew
	#elif (scr_time_db("tnnCurfew") == "after") then scr_event_interactive_deactivate();
	## TODO Time based events are not working

	# Deactivate in Residential when you talked to her after paying rent
	elif B2_Playerdata.Quest("aelfledaEvict") == 4:
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

	#VARIABLES:
	#aelfledaState
		#0 = not talked, starting state
		#1 = chose "neither"... she'll just ignore you now
		#2 = chose "short" or "long"... heard her story
		#3 = final dialogue
		#
	#aelfledaEvict
		#0 = haven't heard about her eviction, OR declined to help her, can't be saved at curfew
		#1 = have heard about her eviction and can pay money to keep her from being evicted
		#2 = payed her rent and allowed her to get back to her house
		#3 = Refuse to pay her mortgage in front of Vikingstad, Aelfleda is instantly taken to the Hoosegow
		#4 = Aelfleda waits on the steps a little longer after you tell her she's paid up
		#5 = ClockTime state that removed Aelfleda after a time, she'll end up in block house after you talk to her mattress
#
	#gelasioDuergar
		#0 = haven't learned anything about Gelasio's dealings with the Duergars
		#1 = you've gained a little suspicion about Gelasio
		#2 = you've gained enough suspicion to confront Gelasio (you get the other +=1 from Jindritch)  
		#
	#aelfledaAugustine
		#0 = you haven't heard about Augustine
		#1 = she mentions Augustine, but not by name
		#2 = she mentions Augustine by name
		#3 = Gelasio lies and shoots down you questioning about Aelfleda through character assassination
		#4 = state that removes you questioning Augustine in his confrontation
		#5 = the truth is out and you know that Gelasio was the guy who ratted out Augustine 
#
	#Needs:
	#1 Move to sewers, possibly.
	#2 Return with money, possibly.
	#3 different amounts
