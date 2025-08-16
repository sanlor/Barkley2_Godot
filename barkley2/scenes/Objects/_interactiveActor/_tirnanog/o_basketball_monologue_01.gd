extends B2_Event_Step_Trigger

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") != "before":
		queue_free()
	if B2_CManager.curr_BODY == B2_CManager.BODY.GOVERNOR:
		queue_free()
	
func _physics_process(_delta: float) -> void:
	if B2_Playerdata.Quest("bballMonologue") > 0:
		queue_free()
