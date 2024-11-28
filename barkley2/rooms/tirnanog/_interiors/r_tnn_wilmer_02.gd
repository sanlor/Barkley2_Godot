@tool
extends B2_ROOMS

@onready var o_wilmer_bedsheet_01: AnimatedSprite2D = $o_wilmerBedsheet01

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		# Wake up, sleepyhead!
		# Always execute the below script as it makes the bed solid when necessary
		if B2_Playerdata.Quest("sceneBrandingStart") != 2: 
			#with (o_wilmerBedsheet01) event_user(0);
			## Do nothing, i guess.
			o_wilmer_bedsheet_01.execute_event_user_0() # enable collision
		else:
			B2_Playerdata.Quest("sceneBrandingStart", 3)
			B2_CManager.play_cutscene( cutscene_script, self, [] )
			return
	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
