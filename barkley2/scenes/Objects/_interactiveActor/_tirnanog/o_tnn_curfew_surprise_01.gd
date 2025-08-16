extends B2_Event_Step_Trigger

func _ready() -> void:
	if B2_Playerdata.Quest("curfewSurprise") == 1 && B2_Playerdata.Quest("curfewCollision") == 0:
		pass
	elif B2_Playerdata.Quest("curfewSurprise") == 2 && B2_Playerdata.Quest("curfewCollision2") == 0:
		pass
	else:
		queue_free()
