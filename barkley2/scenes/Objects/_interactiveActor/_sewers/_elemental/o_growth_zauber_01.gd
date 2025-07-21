extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("growthElementalZauber") == 1:
		animation = "taken"
	else:
		animation = "default"
