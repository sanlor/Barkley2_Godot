extends B2_EnvironInteractive

func _ready() -> void:
	frame = 0
	
	# Not here if the drone has not crashed #
	if B2_Playerdata.Quest("sepidehDrone") != 4: queue_free()

	# Mangled if drone has crashed and deveraux was not killed before the crash by the player #
	if B2_Playerdata.Quest("deverauxDroned") != 1: queue_free()
	else: frame = 3
