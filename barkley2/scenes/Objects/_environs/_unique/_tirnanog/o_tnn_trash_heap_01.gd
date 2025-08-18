extends B2_Environ

func _ready() -> void:
	if B2_ClockTime.time_get() >= 6:
		queue_free()
