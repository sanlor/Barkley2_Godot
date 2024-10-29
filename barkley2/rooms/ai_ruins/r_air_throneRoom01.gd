extends B2_ROOMS

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	#B2_Music.play( "mus_swp_accousticarea" )
		
	if play_cinema_at_room_start:
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	else:
		if B2_RoomXY.is_room_valid( true ):
			B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
		else:
			_setup_camera( _setup_player_node() )
		
	
