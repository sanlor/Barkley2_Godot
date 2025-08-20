@tool
extends B2_ROOMS
## Check dsl_gbl_prisonIntro01()

 #prisonArrested
		#0 = Not arrested
		#1 = Arrested after going to rebel HQ and selling out your comrades via Gelasio
		#2 = Arrested for trying to bomb the statue
		#3 = Lost a battle against Duergar for the first time
		#4 = Arrested for robbing the bank with Gutterhound
		#5 = Arrested for chupsale
		#6 = Tried to steal Constantine's piss
		#
	#prisonIntro
		#0 = Intro not begun
		#1 = Walking through the gates
		#2 = Walking in to hear Thrax' speech
		#3 = Walking to Processing
		#4 = Processed
		#5 = Locked up in the cell
		#6 = Intro over

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		
		if B2_Playerdata.Quest("prisonArrested") != 0 and B2_Playerdata.Quest("prisonIntro") != 5:
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
