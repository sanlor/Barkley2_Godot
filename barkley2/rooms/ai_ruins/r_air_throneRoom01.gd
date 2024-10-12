extends B2_ROOMS

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	B2_Music.play( "mus_swp_accousticarea" )
		
	if B2_RoomXY.this_room == "":
		if create_player_scene_at_room_start:
			await get_tree().process_frame
			_setup_camera( _setup_player_node() )
		
	if play_cinema_at_room_start:
		B2_CManager.play_cutscene( cutscene_script, self, true )
