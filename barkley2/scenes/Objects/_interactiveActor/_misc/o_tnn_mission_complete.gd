extends CanvasLayer

# check o_tnn_mission_complete
## INCOMPLETE, DOES NOTHING

func _ready() -> void:
	push_error(name + " Not setup yet. fix this!")
	queue_free()
