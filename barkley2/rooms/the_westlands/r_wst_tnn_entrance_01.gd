@tool
extends B2_ROOMS

@onready var o_cinema_0: B2_CinemaSpot = $o_cinema0

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	
	B2_Playerdata.Quest("hoopzGetup", 3)
	
	## Create player node
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
	
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		if B2_Playerdata.Quest("hoopzGetup") > 0:
			if enable_hud: ## Hide hud for the tutorial. might change this later.
				if is_instance_valid(B2_CManager.o_hud):
					B2_CManager.o_hud.hide()
					
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			
			
