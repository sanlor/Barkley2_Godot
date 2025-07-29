extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Database.time_check("fedeSurgery") == "before":
		queue_free()
		
	if B2_Playerdata.Quest("fedeArmTouched") || B2_Playerdata.Quest("fedeState") == 4:
		animation = "off"
