extends B2_EnvironInteractive


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if B2_Playerdata.Quest("tuberPeel") >= 3 and get_room_name() == "r_usw_rootstock01":
		is_interactive = false
	if B2_Playerdata.Quest("tuberPeel") >= 3 and get_room_name() == "r_bct_tower06":
		frame = 19

## Peel advance
func execute_event_user_10():
	frame += 1
