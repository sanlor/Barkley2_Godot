extends B2_EnvironInteractive

@export var seed_number := 1

func _ready() -> void:
	if B2_Playerdata.Quest("growthElementalSeedsSown") >= seed_number:
		animation = "gaze"
	else:
		animation = "default"
