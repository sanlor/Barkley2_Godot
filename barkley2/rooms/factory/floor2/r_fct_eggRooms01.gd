extends B2_ROOMS

@onready var o_room_dream_filter: CanvasLayer = $o_room_dream_filter

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
		
	await get_tree().process_frame
	if B2_RoomXY.this_room.is_empty():
		if create_player_scene_at_room_start:
			_setup_camera( _setup_player_node() )
			return ## DEBUG
	
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null, 1) != 1:
		# the cutscene was already played.
		return
	else:
		# play the initial cutscene.
		
		#BodySwap("diaper");
		B2_Playerdata.Quest("hudVisible", 		0);
		B2_Playerdata.Quest("zoneVisible", 		0);
		B2_Playerdata.Quest("dropEnabled", 		0);
		B2_Playerdata.Quest("infiniteAmmo", 	1);
		
		_setup_camera( null )
		o_room_dream_filter.play_blink()
		B2_CManager.play_cutscene( cutscene_script, self )
