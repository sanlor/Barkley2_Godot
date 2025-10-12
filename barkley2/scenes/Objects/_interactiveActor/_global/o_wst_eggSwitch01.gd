extends B2_EnvironInteractive

@export var o_merchantDoor01 : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Animation #
	if get_room_name() == "r_wst_northRespawn01":
		if B2_Playerdata.Quest("wstMerchantDoor") == 1: animation = "filled"
		if B2_Playerdata.Quest("wstMerchantDoor") == 2: animation = "default"

func execute_event_user_0():
	assert( o_merchantDoor01 )
	o_merchantDoor01.open_door()
