extends B2_EnvironInteractive

func _ready() -> void:
	## Open if quest is good
	if B2_Playerdata.Quest("plantationGate") == 1:
		execute_event_user_0()
	else:
		animation = "default"
		

func execute_event_user_0():
	animation = "flipped"
