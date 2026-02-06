extends B2_EnvironInteractive


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func execute_event_user_0():
	if B2_CManager.o_cts_hoopz:
		B2_CManager.o_cts_hoopz.hide()

## Not used in the Godot port
func execute_event_user_1():
	pass
