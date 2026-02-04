extends B2_EnvironInteractive

## DSL - Tuber Peeling

#tuberPeel = 0 - You do not know about Tuber Peeling duties
#tuberPeel = 1 - Hoopz has been assigned Tuber Peeling duties and will find his way to Rootstock
#tuberPeel = 2 - Hoopz has reported to Chandragupta
#tuberPeel = 3 - Potatoes have been peeled, go back to BCT
#tuberPeel = 4 - You saw the cinema where Wiglaf chews you out for poor peeling.
#
#tuberPeel = 1 - Hoopz has been assigned Tuber Peeling duties and will be transported to r_bct_tuberCloset01 to peel
#tuberPeel = 2 - Set at the end of Tuber Peeling Duties
#tuberPeel = 3 - You saw the cinema where Wiglaf chews you out for poor peeling.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## Set light
	#Light("set", 0.33);

	if B2_Playerdata.Quest("tuberPeel") >= 3:
		is_interactive = false

## Peel advance
func execute_event_user_10():
	frame += 1
