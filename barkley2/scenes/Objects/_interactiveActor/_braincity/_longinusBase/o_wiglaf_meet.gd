extends B2_Event_Step_Trigger

func _process(_delta: float) -> void:
	is_active = B2_Playerdata.Quest("wiglafState") != 0
