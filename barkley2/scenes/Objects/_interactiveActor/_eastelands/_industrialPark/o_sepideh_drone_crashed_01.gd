extends B2_EnvironInteractive

func _ready() -> void:
	# Not here if the drone has not crashed #
	if B2_Playerdata.Quest("sepidehDrone") != 4:
		queue_free()

	# Bloody or clean drone? Depends on if it has killed someone by crashing on the duergs //
	if B2_Playerdata.Quest("osirisDroned") == 1 or B2_Playerdata.Quest("deverauxDroned") == 1:
		frame = 1
	else:
		frame = 0
