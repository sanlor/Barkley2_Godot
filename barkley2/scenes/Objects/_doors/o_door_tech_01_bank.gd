extends B2_Door_Tech

func _after_ready() -> void:
	if B2_Playerdata.Quest("gutterhoundQuest") >= 7 or B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after":
		is_open = true
		stick_open = true
