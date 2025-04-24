extends B2_ROOMS

func _init() -> void:
	B2_Playerdata.Quest("hudVisible", 1) ## DEBUG

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	_set_region()
	
	await get_tree().process_frame
	
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
		
	B2_Playerdata.preload_skip_tutorial_save_data()
	B2_Candy.gain_candy( "Butterscotch" )
	B2_Candy.gain_candy( "Chickenfry Dew" )
