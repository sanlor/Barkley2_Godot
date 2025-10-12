@tool
extends B2_ROOMS

## Zenobia Encounter
#variables
#zenobiaState
	#0 = haven't met Zenobia
	#1 = have met zenobia
#zenobiaEncounter
	#0 = this scene hasn't run, you haven't triggered the trap
	#1 = you have triggered the trap, Cauldron scene will now run
	#2 = you didn't have the Clispaeth Quest activated, you were dropped in the cauldron
	#3 = the Cauldron Scene has run and now you talk to zenobia in private, you've already activated the Clispaeth Quest
#hoopzSkelly
	#0 = you have you skeleton
	#1 = you were dropped in the cauldron and the skeleton is used as a relic
	#2 = you got your skeleton back
	#3 = you got dropped in the cauldron without regaining your skelly (went back to the village without irmingards knowledge)
#relicSearch (what Hoopz says he'll look for.)
	#1 = The Iron Crown of Jackson
	#2 = The Veil of Valanciunas
	#3 = The Blood of Klisp
	#4 = The Scala Iactus
	#5 = The Mandyblue
	#6 = The Crown of Jalapenos
	#7 = The Shroud of Ballin'
	#8 = The Grape-topped Grail
	#9 = Boatloads of Trash
#cgremQuest
	#0 = you haven't started the quest
	#1 = the search is activated/started/unpaused
	#2 = the search is "paused" so that it turns off the "QUEST MARKERS" visual gag
	#3 = you've found the particular "relicSearch" item
	#4 = you've been denied the "relicSearch" item, and now have to look for the cyberSpear piece
	#5 = you've found the Cyberspear Piece
	#6 = you've returned with the Cyberspear Piece

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	#if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
	if B2_Playerdata.Quest("zenobiaEncounter") != 0:
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
