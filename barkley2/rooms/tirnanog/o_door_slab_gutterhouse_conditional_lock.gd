extends Node2D

@onready var o_door_slab_gutterhouse: B2_DoorLocker = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("gutterDoorTNN") == 0:
		#o_door_slab_gutterhouse
		pass
