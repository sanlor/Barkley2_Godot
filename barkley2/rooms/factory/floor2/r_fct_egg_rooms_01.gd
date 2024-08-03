extends TileMapLayer


func _ready() -> void:
	# If you go back to this room after progressing the tutorial, all the egg shit is already fucked beyond repair and can't be interacted with etc. //
	if B2_Playerdata.Quest( "gameStart", null ) != 1:
		# the cutscene was already played.
		return
	else:
		# play the initial cutscene.
		
		#BodySwap("diaper");
		#scr_event_entity_settings(id, 0, 0, 0);
		#Quest("hudVisible", 0);
		#Quest("zoneVisible", 0);
		#Quest("dropEnabled", 0);
		#Quest("infiniteAmmo", 1);
		pass
