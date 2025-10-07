extends B2_Event_Step_Trigger

func _physics_process(_delta: float) -> void:
	# Disable if the Shank Event isn't active
	if B2_Playerdata.Quest("prisonLiberated") >= 2:
		is_active = false
	elif B2_Playerdata.Quest("prisonDive") >= 42:
		is_active = false
	elif B2_Playerdata.Quest("switchPrison0") == 1 && B2_Playerdata.Quest("prisonRackguns") == 0 || B2_Playerdata.Quest("prisonRackjerkin") == 0:
		is_active = true
	else:
		is_active = false
