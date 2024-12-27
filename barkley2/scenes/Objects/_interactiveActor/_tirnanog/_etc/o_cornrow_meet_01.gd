extends B2_Event_Step_Trigger

func event_trigger( _node ):
	
##Disable after you meet Cornrow
#if (Quest("cornrowState") != 0) x = 99999; else x = xstart;
#if (o_juicebox01.visible == 0) x = 99999;
#if (o_cornrow01.visible == 0) x = 99999;

	if is_instance_valid(cutscene_script):
		B2_CManager.play_cutscene( cutscene_script, self, [] )
