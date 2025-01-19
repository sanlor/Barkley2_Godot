extends B2_Environ

func _ready() -> void:
	## Closed during/after curfew and while governor
	if B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after" or B2_Playerdata.Quest("govQuest") == 5:
		queue_free()
