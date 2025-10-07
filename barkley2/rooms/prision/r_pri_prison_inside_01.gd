@tool
extends B2_ROOMS

# Prison intro part 4: Into the cell
const DSL_GBL_PRISON_INTRO_01 = preload("uid://1tb62g6j6wad")
const DSL_PRI_TOILET_DISTRESSOR = preload("uid://bcqyaeo7o85ly")

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if B2_Playerdata.Quest("prisonArrested") != 0 and B2_Playerdata.Quest("prisonIntro") == 4:
		B2_CManager.play_cutscene( DSL_GBL_PRISON_INTRO_01, self, [] )
	elif B2_Playerdata.Quest("prisonFadeToggle") == 1:
		B2_CManager.play_cutscene( DSL_PRI_TOILET_DISTRESSOR, self, [] )
	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
