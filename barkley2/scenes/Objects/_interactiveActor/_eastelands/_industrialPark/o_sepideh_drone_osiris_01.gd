extends B2_EnvironInteractive

func _ready() -> void:
	# Not here if the drone has not crashed #
	if B2_Playerdata.Quest("sepidehDrone") != 4: queue_free()

	# Mangled if drone has crashed and osiris was not killed before the crash by the player #
	if B2_Playerdata.Quest("osirisDroned") != 1: queue_free()
	else: frame = 2
