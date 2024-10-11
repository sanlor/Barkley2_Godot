extends B2_Event_Step_Trigger

# used to check if all the light bulbs were broken.

func _ready() -> void:
	if B2_Playerdata.Quest("tutorialProgress", null, 0) >= 3:
		queue_free()
		
func event_trigger( _node ):
	print("roll check")
	pass
