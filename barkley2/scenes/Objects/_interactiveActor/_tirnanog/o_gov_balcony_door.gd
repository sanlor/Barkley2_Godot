extends B2_Event_Step_Trigger

func _ready() -> void:
	B2_SignalBus.quest_updated.connect( _state_change )
	
func _state_change() -> void:
	is_active = B2_Playerdata.Quest("govSpeechInitiate") == 1
