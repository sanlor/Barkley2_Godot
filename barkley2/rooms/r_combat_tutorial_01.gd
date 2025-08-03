extends B2_ROOMS

## Music mus_vrw
## Zone Virtual Reality
## Flavor It all seems so real...

func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	await get_tree().process_frame
	if not B2_Config.get_current_save_slot() == 69:
		push_error("Loaded VR area without the correct save slot.")
		
	#if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
	if B2_Playerdata.Quest("vr_mission_0" ) == 1:
		B2_Playerdata.Quest("vr_mission_0", 2 )
		B2_CManager.play_cutscene( preload("uid://b4q2wqh34t6kl"), self )
		var mission_0 = preload("res://barkley2/resources/vr_missions/mission_0.tscn").instantiate()
		add_child( mission_0, true )
		mission_0.play("encounter_01")
	elif B2_Playerdata.Quest("vr_mission_1" ) == 1:
		B2_Playerdata.Quest("vr_mission_1", 2 )
		B2_CManager.play_cutscene( preload("uid://b4q2wqh34t6kl"), self )
		#var mission_1 = preload("res://barkley2/resources/vr_missions/mission_1.tscn").instantiate()
		#add_child( mission_1, true )
		#mission_1.play("encounter_01")

	elif B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
