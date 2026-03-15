extends AnimatedSprite2D

func _ready() -> void:
	if B2_Database.time_check("tnnCurfew") != "during":
	#if B2_Database.time_check("tnnCurfew") != "before":
		print(B2_Database.time_check("tnnCurfew"))
		queue_free()
