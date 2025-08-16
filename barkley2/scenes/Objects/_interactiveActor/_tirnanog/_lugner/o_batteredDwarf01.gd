extends B2_InteractiveActor

# ======================================================================================================
	#This is the Exterior Tir na nOg Lugner's Script
	#This actually starts with talking to Battered Dwarf, and not Lugner (who is created on Interact)
# ======================================================================================================
			#Quest for Lugner
	#States:
		#0 = not talked
		#1 = talked
	#Quest
		#1 = you've turned down lugner and he wants nothing to do with you QUEST UNAVAILABLE
		#2 = you've told Lugner you can't help him right away but this leave the quest open for later
		#3 = you've accepted the quest from Lugner, next stop Slag, then Giuseppe
		#4 = Giuseppe refuses to give you any dwarfs. The player can get "Fuck you" dialogue from Slag and Lugner(currently broken)
		#5 = The player has gained some dwarfs and has chosen the Slag path.
		#6 = The player has gained some dwarfs and has chosen the Lugner path.
		#7 = End of Lugner route. You've pressed the button and killed the dwarfs. The player talks to Slag and the quest ends.
		#8 = Spoken to Lugner, the player can press the button or just leave entirely for some reason.
		#9 = End of Slag route. Lugner is dead.
		#
	#slagChase - If you exit the market transition left, then go back right away, slag chases you down to give you the quest
		#0 = Default state
		#1 = Slag will chase you down
		#2 = Slag chased you down and you got the quest

@export var o_cinema6 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	if B2_Playerdata.Quest("govMedicine") == 2: queue_free()
	
	if get_room_name() == "r_tnn_businessDistrict01":
		## Lugner should leave the area when the battered dwarf does ##
		if B2_Playerdata.Quest("clockBatteredDwarfHospital") == 1: queue_free()

		## Remove if curfew can be activated, avoids problems with lugner ##
		elif B2_Database.time_check("tnnCurfew") == "during" || B2_Database.time_check("tnnCurfew") == "after": queue_free()

		## Remove after Gov Speech so that you can't meet Slag anymore (after gov speech you are tasked with meeting Slag at the Social) ##
		elif B2_Playerdata.Quest("govQuest") >= 6: queue_free()

		## Create Lugner next to the battered dwarf after lugner interaction ##
		elif B2_Playerdata.Quest("batteredDwarfState") == 1:
			if B2_Playerdata.Quest("lugnerQuest") > 0 && B2_Playerdata.Quest("lugnerQuest") <= 3:
				## What a mess.
				const O_LUGNER_01 = preload("uid://brspu5ogsk81h")
				var lug := O_LUGNER_01.instantiate()
				add_sibling( lug, true )
				lug.global_position = o_cinema6.global_position
				lug.cinema_look("SOUTHWEST")
		
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
