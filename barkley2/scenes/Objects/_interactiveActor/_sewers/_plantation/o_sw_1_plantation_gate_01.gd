extends AnimatedSprite2D

@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	# If closed, add in the solid, otherwise change to open image #
	if B2_Playerdata.Quest("plantationGate") == 0:
		_close()
	else:
		_open()

func _open() -> void:
	collision_shape_2d.disabled = true
	frame = 1
	
func _close() -> void:
	collision_shape_2d.disabled = false
	frame = 0
