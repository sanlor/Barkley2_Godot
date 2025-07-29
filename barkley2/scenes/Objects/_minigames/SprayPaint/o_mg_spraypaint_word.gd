extends AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	var val : int = B2_Playerdata.Quest("puzzleSpraypaintWho")
	if val:
		frame = val
