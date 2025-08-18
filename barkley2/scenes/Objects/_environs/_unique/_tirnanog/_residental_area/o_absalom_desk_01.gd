extends B2_Environ


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("duergarInfoLonginus") == 1:
		play("bad")
	else:
		play("default")
