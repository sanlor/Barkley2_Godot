@icon("uid://v5cq0dt6obso")
extends B2_Environ
class_name B2_Teleport_Mark

## This node should not exist on a running game.
## Check scr_map_roomstart() line 117

func _ready() -> void:
	queue_free()
