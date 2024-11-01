extends B2_ROOMS

## Railing() script is important. Need to mess with it.
# oRailingDummy sRailing0 sRailing1 oRailing0Placer
# change the gray BG to Black during runtime

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
