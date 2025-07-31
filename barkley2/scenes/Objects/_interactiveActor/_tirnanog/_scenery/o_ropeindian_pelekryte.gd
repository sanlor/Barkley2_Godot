extends B2_EnvironInteractive

## https://youtu.be/SQKRnzWSW0M?t=16422

func _ready() -> void:
	frame = 3
	
	## Something related to the rope path?
	if B2_Playerdata.Quest("indianRopeTrick") == 1:
		pass
		
func execute_event_user_0():
	queue_free()
