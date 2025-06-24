extends Control
## Main DNET Page


func surf_the_web() -> void:
	B2_Screen.set_cursor_type( B2_Screen.TYPE.HAND )
	B2_Playerdata.Quest( "dwarfnet_skin_system", randi_range(0,3) )
