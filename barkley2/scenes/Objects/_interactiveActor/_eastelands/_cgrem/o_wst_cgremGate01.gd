extends B2_EnvironInteractive

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D
		
func _process(_delta: float) -> void:
	# Gate open #
	if B2_Playerdata.Quest("cgremGate") == 1:
		animation = "open"
		is_interactive = false
		collision_shape_2d.disabled = true
	else:
		animation = "default"
		is_interactive = true
		collision_shape_2d.disabled = false
