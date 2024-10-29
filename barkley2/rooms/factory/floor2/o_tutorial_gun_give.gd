extends B2_Event_Step_Trigger

# Came back afer breaking the light bulbs.

func _ready() -> void:
	# Already triggered.
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 2:
		queue_free()

func event_trigger( _node ):
	if B2_Playerdata.Quest("tutorialCollision", null, 0) >= 1:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, [] )

func execute_event_user_0():
	if get_parent() is B2_ROOMS:
		get_parent().set_pacify( false )
		queue_free()
	else:
		# Where am I?
		breakpoint
