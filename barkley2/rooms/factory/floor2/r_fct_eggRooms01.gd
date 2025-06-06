@tool
extends B2_ROOMS

@onready var o_room_dream_filter: CanvasLayer = $o_room_dream_filter

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	_set_region()
	
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null, 1) != 1:
		# the cutscene was already played.
		if B2_RoomXY.is_room_valid():
			B2_RoomXY.add_player_to_room( B2_RoomXY.get_room_pos(), true )
		else:
			_setup_camera( _setup_player_node() )
	else:
		# play the initial cutscene.
		
		B2_CManager.BodySwap("diaper");
		B2_Playerdata.Quest("hudVisible", 		0);
		B2_Playerdata.Quest("zoneVisible", 		0);
		B2_Playerdata.Quest("dropEnabled", 		0);
		B2_Playerdata.Quest("infiniteAmmo", 	1);
		
		_setup_camera( null )
		o_room_dream_filter.play_blink()
		B2_CManager.play_cutscene( cutscene_script, self )
