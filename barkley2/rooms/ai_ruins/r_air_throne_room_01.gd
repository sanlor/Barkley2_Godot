extends B2_ROOMS

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
		
	if B2_RoomXY.this_room.is_empty():
		if create_player_scene_at_room_start:
			await get_tree().process_frame
			_setup_camera( _setup_player_node() )
		
	if play_cinema_at_room_start:
		#b2_cinema.setup_camera( b2_camera )
		B2_Cinema.play_cutscene( cutscene_script, self, true )
