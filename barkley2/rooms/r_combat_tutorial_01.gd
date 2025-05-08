extends B2_ROOMS



func _ready() -> void:
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_set_region()
	
	B2_Playerdata.Quest("infiniteAmmo", 		1	)
	
	B2_Candy.gain_candy( "Butterscotch" 			)
	B2_Candy.gain_candy( "Chickenfry Dew" 			)
	B2_Candy.gain_candy( "Butterscotch" 			)
	
	B2_Gun.add_gun( B2_Gun.TYPE.GUN_TYPE_PISTOL, 		B2_Gun.MATERIAL.STEEL, "", false )
	B2_Gun.add_gun( B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN, B2_Gun.MATERIAL.STEEL, "", false )
	B2_Gun.add_gun( B2_Gun.TYPE.GUN_TYPE_SHOTGUN,		B2_Gun.MATERIAL.STEEL, "", false )
	
	await get_tree().process_frame
	if play_cinema_at_room_start and is_instance_valid( cutscene_script ):
		B2_CManager.play_cutscene( cutscene_script, self )
		$mission_01/AnimationPlayer.play("encounter_01")

	if B2_RoomXY.is_room_valid():
		B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
	else:
		_setup_camera( _setup_player_node() )
