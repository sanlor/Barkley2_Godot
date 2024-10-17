extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("factoryBridge", null, 0) >= 1:
		is_interactive = false
		animation = "flipped"
