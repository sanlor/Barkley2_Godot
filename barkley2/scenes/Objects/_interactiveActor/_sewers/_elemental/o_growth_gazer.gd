extends B2_EnvironInteractive

@export var seed_number := 1

func _ready() -> void:
	var p = B2_Playerdata.Quest("growthElementalSeedsSown")
	if p >= seed_number:
		animation = "gaze"
		play("gaze")
	else:
		animation = "default"
