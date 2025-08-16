extends B2_Event_Step_Trigger

func _ready() -> void:
	if B2_CManager.curr_BODY != B2_CManager.BODY.GOVERNOR:
		queue_free()
