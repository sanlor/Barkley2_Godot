extends B2_ROOMS

@onready var b_2_cinema: B2_Cinema = $B2_Cinema

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
	# change the gray BG to Black during runtime
	RenderingServer.set_default_clear_color( Color.BLACK ) ## TEMP
	
	_init_pathfind()
	_update_pathfind()
	# print( get_astar_path( Vector2(208,274) / 16, Vector2(270,464) / 16 ) ) ## debug testing
	
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null ) != 1:
		# the cutscene was already played.
		# return
		pass
	else:
		# play the initial cutscene.
		
		#BodySwap("diaper");
		#scr_event_entity_settings(id, 0, 0, 0);
		B2_Playerdata.Quest("hudVisible", 		0);
		B2_Playerdata.Quest("zoneVisible", 		0);
		B2_Playerdata.Quest("dropEnabled", 		0);
		B2_Playerdata.Quest("infiniteAmmo", 	1);
		b_2_cinema.play_cutscene()
