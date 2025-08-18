extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("govQuest") == 6:
		animation = "empty"
	elif B2_Playerdata.Quest("govTransfer") >= 1:
		animation = "hoopzclamp"
	elif B2_Playerdata.Quest("govQuest") == 5:
		animation = "hoopzclamp"
	else:
		animation = "empty"
