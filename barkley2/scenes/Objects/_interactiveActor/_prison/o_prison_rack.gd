extends B2_EnvironInteractive

@export var type := "guns"

func _ready() -> void:
	if B2_Playerdata.Quest("prisonLiberated") >= 2 || B2_Playerdata.Quest("prisonDive") >= 30:
		pass
	elif B2_Playerdata.Quest("prisonRack" + type) == 0:
		animation = type
