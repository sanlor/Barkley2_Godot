extends B2_Event_Step_Trigger

func event_trigger( _node ):
	
##Disable after you meet Cornrow
#if (Quest("cornrowState") != 0) x = 99999; else x = xstart;
#if (o_juicebox01.visible == 0) x = 99999;
#if (o_cornrow01.visible == 0) x = 99999;
	if B2_Playerdata.Quest("cornrowState") == 0:
		if is_instance_valid(cutscene_script):
			B2_CManager.play_cutscene( cutscene_script, self, [] )

## Unused dialog

#DIALOG | P_NAME = s_port_hoopzSurprise | Who, uh... me?
#DIALOG | Cornrow | I dunno, hey Juicebox, you see any other wet-behind-the-gun's kids walking around?
#DIALOG | Juicebox | Not a one, Cornrow.
#DIALOG | Cornrow | Hah! I'm just playing, come over here, kid. (Check this out, Juicey, I got an idea.)
#DIALOG | P_NAME | Uh... okay...
#MOVETO | o_cts_hoopz | o_cinema2 | MOVE_NORMAL
#WAIT   | 0
#FRAME  | CAMERA_NORMAL | o_cts_hoopz | o_cornrow01
#LOOKAT | o_cts_hoopz | o_cornrow01
#WAIT   | 0
#"
#//Move to Cornrow Main Event
#+ o_cornrow01.script;
