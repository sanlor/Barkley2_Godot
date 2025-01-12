extends B2_InteractiveActor
## "Zola" the newspaper seller, bounces around TNN

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	#Variables
		#zolaState
			#0 = never talked
			#1 = talked
		#zolaNews
			#1-10 = this decays and just has various weird headlines, all flavor
		#pravdaPurchased
			#0 = never purchased
			#1 = purchased
			#2 = purchased but given away or lost
		#zolaSpearBuy
			#0 - haven't heard about her desire to buy the spear
			#1 - have heard about her desire to buy the spear
		#zolaBuyOff
			#0 = Check if Zola still has the spear on him
			#1 = Return to negotiate the spear purchase
			#2 = Spear has been reaquired
			#3 = Hint about Ooze
	
	if get_room_name() == "r_tnn_warehouseDistrict01":
		## In the Warehouse District for 22:30 to 21:00
		if B2_ClockTime.time_gate() <= 1.5 or B2_ClockTime.time_gate() >= 3.0:
			queue_free()
	if get_room_name() == "r_tnn_businessDistrict01":
		## In the Business District for 24:00 to 22:30
		if B2_ClockTime.time_gate() >= 1.5:
			queue_free()
	if get_room_name() == "r_tnn_marketDistrict01":
		## In the Market District from After Curfew to 18:00
		if B2_Database.time_check("tnnCurfew") != "after" or B2_ClockTime.time_gate() >= 6.0:
			queue_free()
	if get_room_name() == "r_tnn_boardinghouse01":
		## If curfew is active, she's inside
		if B2_Database.time_check("tnnCurfew") != "during":
			queue_free()
		else:
			## Animation "inside"
			ActorAnim.frame = 1
		
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
