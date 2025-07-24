extends B2_EnvironInteractive

func _ready() -> void:
	pass
	
func execute_event_user_0() -> void:
	B2_Drop.create_drops_from_db("turald free", Vector2.ZERO, Vector2.ZERO)
	push_warning("Gun drop not set yet.")
	
func execute_event_user_1() -> void:
	## Does nothing, basically.
	pass
