extends B2_InteractiveActor
class_name B2_InteractiveActor_Player
# Cutscene version of hoopz.
# check scr_event_hoopz_switch_cutscene()

func _enter_tree() -> void:
	assert(name == "o_cts_hoopz", "Hoopz actor name %s is different than expected." % name)
	is_interactive 			= false
	disable_auto_flip_h 	= true
