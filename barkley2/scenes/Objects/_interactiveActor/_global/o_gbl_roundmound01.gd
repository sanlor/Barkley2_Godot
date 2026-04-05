extends B2_Event_Step_Trigger

func _ready() -> void:
	B2_SignalBus.quest_updated.connect( check_status )

func event_trigger( _node ):
	if B2_Playerdata.Quest("roundmoundInitiate") == 0:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, [] )

func check_status() -> void:
	is_active = B2_Playerdata.Quest("roundmoundInitiate") == 0

## Unsure what this does.
func execute_event_user_0():
	## TODO
	# with o_sfx_audio_emitter_parent timer_remove = irandom(3) + 1;
	push_error("TODO: set event 0 for %s" % self)
