extends B2_EnvironInteractive

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") == "during":
		is_interactive = false
