extends B2_Event_Step_Trigger



func _process(_delta: float) -> void:
	if B2_Playerdata.Quest("cdwarfStart") != 0 && B2_Playerdata.Quest("cdwarfCinema") != 8:
		is_active = false
	else:
		is_active = true
