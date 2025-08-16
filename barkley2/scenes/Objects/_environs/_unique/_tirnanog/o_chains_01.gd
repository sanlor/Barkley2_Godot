extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("gutterhoundQuest") >= 7 or B2_Database.time_check("tnnCurfew") == "during" or B2_Database.time_check("tnnCurfew") == "after":
		animation = "cut"
	else:
		animation = "default"
