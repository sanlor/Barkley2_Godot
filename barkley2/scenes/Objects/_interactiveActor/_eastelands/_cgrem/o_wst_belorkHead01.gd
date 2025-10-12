extends B2_EnvironInteractive

func _ready() -> void:
	# Hoopz' bones #
	if B2_Playerdata.Quest("hoopzSkelly") == 1 or B2_Playerdata.Quest("hoopzSkelly") == 3:
		animation = "skeleton"

	# Other relics #
	if B2_Playerdata.Quest("zenobiaNewRelic") == 1: animation = "iron"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 2: animation = "veil"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 3: animation = "blood"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 4: animation = "block"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 5: animation = "mandyblue"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 6: animation = "jalapenos"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 7: animation = "shroud"
	if B2_Playerdata.Quest("zenobiaNewRelic") == 8: animation = "mug"
