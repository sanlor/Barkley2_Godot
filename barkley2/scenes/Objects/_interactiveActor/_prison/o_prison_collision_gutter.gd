extends B2_Event_Step_Trigger

func _ready() -> void:
	if B2_Playerdata.Quest("prisonLiberated") == 3:
		queue_free()

func _physics_process(_delta: float) -> void:
	is_active = B2_Playerdata.Quest("gutterhoundPrisonEscape") == 1
