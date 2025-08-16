extends AnimatedSprite2D

func _ready() -> void:
	play()

func _physics_process(_delta: float) -> void:
	if B2_Playerdata.Quest("tnnLoudspeaker") == 1:
		show()
	else:
		hide()
