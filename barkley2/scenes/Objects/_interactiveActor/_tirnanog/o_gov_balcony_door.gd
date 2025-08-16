extends B2_Event_Step_Trigger

func _ready() -> void:
	if B2_Playerdata.Quest("govSpeechInitiate") != 1:
		queue_free()
