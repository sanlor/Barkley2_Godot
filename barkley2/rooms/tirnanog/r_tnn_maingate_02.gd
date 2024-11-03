@tool
extends B2_ROOMS

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		## This plays when the GovSpeech is properly achieved
		if B2_Playerdata.Quest("govSpeechInitiate") == 2:
			B2_CManager.play_cutscene( cutscene_script2, self, [] )
			
		## The Branding Scene at the beginning of the game/after the into/tutorial sequence
		elif B2_Playerdata.Quest("sceneBrandingStart") == 1:
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
		
	else:
		_setup_camera( _setup_player_node() )

## CRITICAL
#A lot of stuff is missing, like pedestrians and such. Im ignoring them to be able to finish the tutorial quickly.
