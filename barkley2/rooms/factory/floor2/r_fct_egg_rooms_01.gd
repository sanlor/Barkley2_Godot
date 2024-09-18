extends Node2D

@onready var b_2_cinema: B2_Cinema = $B2_Cinema

# on the original game, the object o_world runs a piece of code at every room start.
# check scr_map_roomstart()

func _ready() -> void:
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
