@tool
extends B2_ROOMS

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		if not B2_Playerdata.Quest("wilmerMeeting") == 1 and \
		B2_Playerdata.Quest("duergarInfoWilmer") != 1 :
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			return
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
