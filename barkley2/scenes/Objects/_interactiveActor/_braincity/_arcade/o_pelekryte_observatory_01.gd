extends B2_Event_Step_Trigger

func _process(_delta: float) -> void:
	## Check if Pele made it out of TNN with your help ##
	if B2_Playerdata.Quest("pelekryteState") != 5: 
		is_active = false
	else:
		## Collision trigger ##
		if B2_Playerdata.Quest("peleScope") == 1: 
			is_active = false
		else:
			is_active = true
		
		## Check if you have already done all your collision events ##
		if B2_Playerdata.Quest("peleStarState") >= 2:
			is_active = false
		else:
			is_active = true
