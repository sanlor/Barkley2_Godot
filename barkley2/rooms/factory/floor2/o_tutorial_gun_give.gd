extends B2_Event_Step_Trigger

# Came back afer breaking the light bulbs.

func _ready() -> void:
	pass

func event_trigger( _node ):
	if is_instance_valid(cutscene_script):
		B2_Cinema.play_cutscene( cutscene_script, self, true )
		
	print("gun_give")

func execute_event_user_0():
	if get_parent() is B2_ROOMS:
		get_parent().set_pacify( false )
	else:
		# Where am I?
		breakpoint
