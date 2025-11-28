@tool
extends B2_ROOMS

## Cool area
# 27/10/25 using it as a debug combat area. Developing AI right now.

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
	
	B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_MINIGUN )
	B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_SHOTGUN )
	B2_Gun.add_gun_to_bandolier( B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN )
