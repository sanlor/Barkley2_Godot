extends B2_Event_Step_Trigger

func _ready() -> void:
	B2_SignalBus.quest_updated.connect( _update_quest )

func _update_quest() -> void:
	is_active = B2_Playerdata.Quest("wiglafState") == 0
