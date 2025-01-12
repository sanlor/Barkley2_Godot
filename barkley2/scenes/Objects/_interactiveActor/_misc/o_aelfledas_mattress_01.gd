extends B2_EnvironInteractive

@export var reference_spot : B2_CinemaSpot

#// aelfledaMattress states
#// 0 = default, can't click
#// 1 = was told to search it, can click
#// 2 = moved matress, can click
#// 3 = set in shortcut room when this state is less than 2, mattress moved, cannot click

func _ready() -> void:
	## Unless the mattress state is over 0, you can't click on it
	if B2_Playerdata.Quest("aelfledaMattress") == 3:
		is_interactive = false
		
	## Move to cinema marker if you already have
	if B2_Playerdata.Quest("aelfledaMattress") >= 2:
		if is_instance_valid(reference_spot):
			position = reference_spot.position
		else:
			breakpoint

func execute_event_user_10():
	pass
func execute_event_user_11():
	pass
