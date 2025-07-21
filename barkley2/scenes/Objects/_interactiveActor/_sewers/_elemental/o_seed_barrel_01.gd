extends B2_EnvironInteractive


func _ready() -> void:
	if B2_Playerdata.Quest("growthElementalSeeds") == 1:
		frame = 1
	else:
		frame = 0
