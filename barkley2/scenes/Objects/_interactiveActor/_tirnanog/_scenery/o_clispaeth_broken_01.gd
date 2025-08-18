extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Playerdata.Quest("govChurch") == 2:
		play("fancy")
	else:
		play("default")
