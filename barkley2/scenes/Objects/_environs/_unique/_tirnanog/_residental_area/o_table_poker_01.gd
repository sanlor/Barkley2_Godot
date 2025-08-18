extends B2_Environ

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_parent() is B2_ROOMS:
		if get_parent().name == "r_pri_prisonInside01":
			if B2_Playerdata.Quest("rebelsArrest") == 0:
				queue_free()
