extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("wilmerItemsTaken") != 0:
		animation = "taken6"
