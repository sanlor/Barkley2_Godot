extends "res://barkley2/scenes/Objects/_doors/o_doorlight_up.gd"

func _ready() -> void:
	super()
	if B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after" or B2_Playerdata.Quest("govQuest") == 5:
		queue_free()
