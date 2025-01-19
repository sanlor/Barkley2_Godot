extends B2_Door_Tech

## Bootybass club is closed. use a normal door.

func _after_ready() -> void:
	## Closed during/after curfew and while governor
	if B2_Database.time_check("tnnCurfew") == "before" or B2_Playerdata.Quest("govQuest") != 5:
		queue_free()
