extends AnimatedSprite2D

@export var quest_var := ""

func _physics_process(_delta: float) -> void:
	var val : int = B2_Playerdata.Quest(quest_var, null, 11)
	if val:
		frame = val - 1
