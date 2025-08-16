@tool
extends B2_EnvironSolid

func _ready() -> void:
	## Turn these off if you've already picked them up
	if B2_Playerdata.Quest("cutterState") == 2: queue_free()

	if B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after": queue_free()
	if B2_Playerdata.Quest("gutterhoundQuest") >= 7: queue_free()
