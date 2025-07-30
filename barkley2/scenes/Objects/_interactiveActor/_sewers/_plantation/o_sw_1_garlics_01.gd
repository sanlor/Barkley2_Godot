extends B2_EnvironInteractive

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("garlicsPicked") == 1:
		queue_free()

func execute_event_user_4():
	queue_free()
