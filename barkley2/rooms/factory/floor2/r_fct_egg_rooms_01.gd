extends B2_ROOMS

@onready var o_room_dream_filter: CanvasLayer = $o_room_dream_filter

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	
	if not play_cinema_at_room_start:
		return
	
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null ) != 1:
		# the cutscene was already played.
		# return
		pass
	else:
		# play the initial cutscene.
		
		#BodySwap("diaper");
		B2_Playerdata.Quest("hudVisible", 		0);
		B2_Playerdata.Quest("zoneVisible", 		0);
		B2_Playerdata.Quest("dropEnabled", 		0);
		B2_Playerdata.Quest("infiniteAmmo", 	1);
		
		_setup_cinema()
		_setup_camera()
		
		b2_cinema.setup_camera( b2_camera )
		b2_cinema.play_cutscene( cutscene_script )
