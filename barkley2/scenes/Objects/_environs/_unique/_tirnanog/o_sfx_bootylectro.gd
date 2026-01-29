@tool
extends B2_AudioEmitter

func _ready() -> void:
	super()
	if B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after":
		queue_free()
	
	if B2_Playerdata.Quest("govQuest") == 5:
		volume_db = linear_to_db(soundVolume * 0.4)
