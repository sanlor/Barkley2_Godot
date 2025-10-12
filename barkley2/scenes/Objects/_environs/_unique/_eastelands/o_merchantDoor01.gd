extends B2_Environ

@onready var static_body_2d: StaticBody2D = $StaticBody2D
@onready var collision_shape_2d: CollisionShape2D = $StaticBody2D/CollisionShape2D

var t : Tween

func _ready() -> void:
	if get_parent().name == "r_wst_northRespawn01":
		if B2_Playerdata.Quest("wstMerchantDoor") >= 1: 
			open_door()
		else:
			close_door()
	elif get_parent().name == "r_est_snoozer01":
		if B2_Playerdata.Quest("estSnoozerDoor") >= 1:
			open_door()
		else:
			close_door()
	else:
		close_door()
		
func open_door() -> void:
	collision_shape_2d.disabled = true
	if t: t.kill()
	t = create_tween()
	t.tween_property(self, "offset:y", -115.0, 1.0)
	
func close_door() -> void:
	collision_shape_2d.disabled = false
	if t: t.kill()
	t = create_tween()
	t.tween_property(self, "offset:y", -63.0, 1.0)
