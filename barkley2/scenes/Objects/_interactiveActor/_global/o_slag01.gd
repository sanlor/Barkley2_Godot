extends B2_InteractiveActor

#//TODO: add in the area controls for Slag here
#//TODO: we should probably move his DSL over to another event so that it's easier to follow
#//else if (scr_area_get() == "est")
#
# Slag Working in TnN, mainly for the Lugner Quest

	#lugnerQuest:
		#1 = you've turned down lugner and he wants nothing to do with you QUEST UNAVAILABLE
		#2 = you've told Lugner you can't help him right away but this leave the quest open for later
		#3 = you've accepted the quest from Lugner, next stop Slag, then Giuseppe
		#4 = Giuseppe refuses to give you any dwarfs. The player can get fuck you dialogue from Slag and Lugner
		#5 = The player has gained some dwarfs and has chosen the Slag path.
		#6 = The player has gained some dwarfs and has chosen the Lugner path.
		#7 = End of Lugner route. You've pressed the button and killed the dwarfs. The player talks to Slag and the quest ends.
		#8 = Spoken to Lugner, the player can press the button or just leave entirely for some reason.
		#9 = End of Slag route. Lugner is dead.
	
	#slagChase - If you exit the market transition left, then go back right away, slag chases you down to give you the quest
		#0 = Default state
		#1 = Slag will chase you down
		#2 = Slag chased you down and you got the quest
		
	#CINEMA MARKERS o_cinema*
		#0 = Hoopz talk to slag first location
		#1 = Where Lugner spawns off screen
		#2 = Where Lugner walks up to confront Hoopz
		#3 = Lugner gets up in Hoopz grill
		#4 = Hoopz backs up
		#5 = Where Slag is hidden behind crates when you send dwarves to Lugner's crate
		#6 = Where Slag goes to surprise shoot Lugner
		#7 = Where Hoopz goes to talk to Lugner, also where he goes to distract Lugner for slag to shoot him

@export var o_cinema5 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "s_cts_slagLOOK"
	ANIMATION_SOUTH 						= "s_cts_slagSE"
	ANIMATION_SOUTHEAST 					= "s_cts_slagSE"
	ANIMATION_SOUTHWEST 					= "s_cts_slagSW"
	ANIMATION_WEST 							= "s_cts_slagSW"
	ANIMATION_NORTH 						= "s_cts_slagNE"
	ANIMATION_NORTHEAST 					= "s_cts_slagNE"
	ANIMATION_NORTHWEST 					= "s_cts_slagNW"
	ANIMATION_EAST 							= "s_cts_slagSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 1, 1, 2, 2, 2, 3]
	ActorAnim.animation 					= "default"

	## Visibility conditions
	if get_room_name() == "r_tnn_warehouse01":
		## You got no dwarfs
		if B2_Playerdata.Quest("lugnerQuest") == 4: pass
		## You chose Slag over Lugner
		elif B2_Playerdata.Quest("lugnerQuest") == 5: pass
		## You chose Lugner, but can still choose Slag - Slag is hiding behind crates
		elif B2_Playerdata.Quest("lugnerQuest") == 6: execute_event_user_5()
		## Slag isn't here
		else: queue_free()
		
	elif get_room_area() == "tnn":
		if B2_Playerdata.Quest("slagChase") != 1:
			if get_room_name() == "r_tnn_marketDistrict01" or get_room_name() == "r_tnn_businessDistrict01": queue_free()
		elif get_room_name() == "r_tnn_marketDistrict01": cinema_look( "SOUTHWEST" )
	elif get_room_area() == "est":
		## Slag is only there for the dossier, no more, no less // Also leaves after time 12 //
		if B2_Playerdata.Quest("operationX") != 3 or B2_ClockTime.time_gate() > 12: queue_free()

# Hoopz walk backwards
func execute_event_user_0():
	push_warning("TODO Backwards")
	
# Reset Hoopz walk backwards
func execute_event_user_1():
	push_warning("TODO Backwards")
	
# Snap to place
func execute_event_user_5():
	if o_cinema5:
		global_position = o_cinema5.global_position
	else: push_error("Cinema 5 not set.")
	
# Deactivate
func execute_event_user_6():
	queue_free() # NOTE is this correct???
	
# Calculate dwarf money
func execute_event_user_15():
	B2_Playerdata.Quest("tempMoney", B2_Playerdata.Quest("dwarfCustody") * B2_Database.money_check_value("slagDwarfPrice") )
