extends B2_Environ

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") != "during":
		queue_free()
