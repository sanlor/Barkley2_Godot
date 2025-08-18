extends B2_Environ

func _ready() -> void:
	if B2_Playerdata.Quest("govChurch") == 2:
		queue_free()
