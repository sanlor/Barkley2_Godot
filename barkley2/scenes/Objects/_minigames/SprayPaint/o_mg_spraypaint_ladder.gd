extends Sprite2D

@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

func _ready() -> void:
	if B2_Playerdata.Quest("sprayPaintSolved") == 1:	# If puzzle is solved # Show ladder #
		open_ladder()
	else:												# Puzzle is not solved
		close_ladder()
	
func open_ladder() -> void:
	show()
	collision_shape_2d.disabled = true
	
func close_ladder() -> void:
	hide()
	collision_shape_2d.disabled = false
	
func execute_event_user_0() -> void:
	open_ladder()
