extends B2_InteractiveActor

#Variables
	#baldoState
		#0 = never talked to 
		#1 = talked to, repeating choice to rummage through him (this activated the Suicide Note when you walk back in)
		#2 = rummaged through him, taking the paper or not
		#3 = end of states, he just "..."
		#4 = You grabbed the blank note or suicide note, traded it for Aug's note, and he's back to playing dead
		#5 = You got him to stand up, but did not find out he's Augustine
		#
	#baldoEscape
		#1 = ClockTime timer passed, he escaped
	#
	#baldoTimerAllow
		#1 = Allows the "fakeout" timer to occur, resets every time you touch baldo
		#2 = You faked Baldomero out, and the reveal cinema played
		#
	#baldoSeen
		#0 = Never seen Baldomero
		#1 = Seen him once
		#2 = Seen him twice
		#
	#baldoBlank
		#0 = you haven't taken the Blank Paper
		#1 = you have taken the Blank Paper
		#
	#baldoSuicide
		#0 = haven't picked up the suicide note
		#1 = picked up the suicide note

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	##TODO: how do we do time now with DSL? any different?
	if B2_Playerdata.Quest("baldoEscape") == 1 or B2_ClockTime.time_gate() >= 5 or B2_Playerdata.Quest("gelasioState") == 5:
		queue_free()
		
	#TODO: add in animate for Baldomero to "fall flat" as you enter the room"
	#TODO: with @baldomeroState@ >= 1, set a timer of 60 seconds, if you stay in the room for 
	#    that long Baldo gets up and runs event_user(1)
	#TODO: when you walk back into this room from the room above, set baldomero to "fall flat" 
	#    again but drop a NOTE
		
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "default"
	ANIMATION_SOUTH 						= ""
	ANIMATION_SOUTHEAST 					= ""
	ANIMATION_SOUTHWEST 					= ""
	ANIMATION_WEST 							= ""
	ANIMATION_NORTH 						= ""
	ANIMATION_NORTHEAST 					= ""
	ANIMATION_NORTHWEST 					= ""
	ANIMATION_EAST 							= ""
	ANIMATION_STAND_SPRITE_INDEX 			= [0, 0, 0, 0, 0, 0, 0, 0]
	ActorAnim.animation 					= "default"

func _on_fake_dead_timer_timeout() -> void:
	ActorAnim.animation = "standing"
	execute_event_user_1()
	interaction()

func execute_event_user_1() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"QUEST  | baldoState = 5
	QUEST  | baldoTimerAllow = 2
	DIALOG | ??? = s_port_baldomero | Alright, alright, I'm getting up!
	FRAME  | CAMERA_FAST | o_cts_hoopz | o_baldomero01
	WAIT   | 0
	SURPRISEAT | o_baldomero01
	DIALOG | P_NAME = s_port_hoopzSurprise | Egad!_ You're alive!
	WAIT   | 0.5
	SET    | o_baldomero01 | standing
	WAIT   | 0.5
	DIALOG | ??? = s_port_baldomero | Yeah yeah, you smoked me out... Happy now?
	FOLLOWFRAME  | CAMERA_FAST | o_cts_hoopz
	MOVETO | o_cts_hoopz | o_cinema0 | MOVE_FAST
	WAIT   | 0
	LOOKAT | o_cts_hoopz | o_baldomero01
	FRAME  | CAMERA_FAST | o_cts_hoopz | o_baldomero01
	DIALOG | P_NAME = s_port_hoopzSurprise | No I'm not happy, just more confused!
	DIALOG | ??? = s_port_baldomero | Look man, I was just hangin' out and you had to come in here and poke your nose around like some kind of shadester.
	DIALOG | P_NAME = s_port_hoopzSurprise | Me the shadester? You are the guy playing dead in the middle of the sewers. That is shady as hudge!
	IF baldoState == 2 | GOTO | RUMMAGEACCUSE
	GOTO   | YOUDONE

	RUMMAGEACCUSE
	DIALOG | ??? = s_port_baldomero | You molested me while I was prone!
	DIALOG | P_NAME = s_port_hoopzSurprise | I didn't molest you! I thought you were dead!
	DIALOG | ??? = s_port_baldomero | Oh gross, why would you try to molest a corpse?!
	DIALOG | P_NAME = s_port_hoopzShock | I wasn't! No! I was just-
	DIALOG | ??? = s_port_baldomero | Blah blah, you were just what?
	CHOICE | What's your cover?
	IF gelasioState == 3 | REPLY | AUGUSTINE | Looking for clues about Augustine.
	REPLY | REBEL | I thought you were a rebel!
	REPLY | BOUNDARIES | I may need to reconsider what personal boundaries are.

	REBEL
	DIALOG | P_NAME | I was looking for Rebels.
	DIALOG | ??? = s_port_baldomero | Looking for Rebels?! Are you some type of Duergar stooge?
	DIALOG | P_NAME = s_port_hoopzSurprise | No! The opposite! I'm looking for help finding The Cyberdwarf!
	DIALOG | ??? = s_port_baldomero | Look, you can look for whom or whatever you want, just don't be so /'handsy/' about it.
	DIALOG | P_NAME | You're right, I'm sorry...
	DIALOG | ??? = s_port_baldomero | Alright, are we done here? Can I go back to my work?
	GOTO   | YOUDONE

	BOUNDARIES
	DIALOG | P_NAME | I think I've drastically overstepped.
	DIALOG | ??? = s_port_baldomero | I'll say.
	DIALOG | P_NAME | I'm sorry...
	DIALOG | ??? = s_port_baldomero | Sorries are for stuffs and sacks, can I get back to my work now?
	GOTO   | YOUDONE

	YOUDONE
	CHOICE | (What the heck...)
	IF gelasioState == 2 | REPLY | AUGIEREVEAL | Wait, are you Augustine?
	//TODO: just a flavor addition below, set this to IF (longinus has been found) you can ask about sewers
	REPLY  | ONEMORETHING | Wait, about the sewers...
	REPLY  | GOAWAY | I will take mine... good day.

	ONEMORETHING
	DIALOG | P_NAME | Wait one more thing... I am looking for L.O.N.G.I.N.U.S. do you know where they are down here?
	DIALOG | ??? = s_port_baldomero | Look man, ugh alright... you want to know about the Rebels?
	DIALOG | P_NAME = s_port_hoopzHappy | Yes!
	DIALOG | ??? = s_port_baldomero | Alright they got this secret code to get in.
	DIALOG | P_NAME | Secret?
	DIALOG | ??? = s_port_baldomero | Yeah so I don't really know how it works, but essentially-
	//TODO: add directions to where Baldomero sends you to the rebel secret
	DIALOG | ??? = s_port_baldomero | You'll see a wall. I've seen them put in some kind of SECRET CODE, but I've never been close enough to really see it.
	DIALOG | P_NAME | A code huh? Hmmm, I'll have to check this out for myself. Thanks for the tip!
	DIALOG | ??? = s_port_baldomero | Yeah, great...
	DIALOG | P_NAME | What's your name anyways?
	DIALOG | ??? = s_port_baldomero | Oh it's hard to pronounce but here I'll spell it for you... N_O_N_E_ O_F_ Y_O_U_R_ B_U_S_I_N_E_S_S.
	DIALOG | P_NAME = s_port_hoopzSad | Oh...
	DIALOG | ??? = s_port_baldomero | We done here?
	GOTO   | YOUDONE

	AUGUSTINE
	DIALOG | P_NAME | I was looking for clues.
	DIALOG | ??? = s_port_baldomero | Clues?_ For what?
	GOTO   | AUGIEREVEAL

	AUGIEREVEAL
	QUEST  | baldoState = 4
	DIALOG | P_NAME | I'm looking for a dwarf named Augusti-_ Wait-
	DIALOG | P_NAME = s_port_hoopzHappy | You aren't Augustine are you?
	DIALOG | ??? = s_port_baldomero | Me? Well,_ who's asking?
	DIALOG | P_NAME | I'm, P_NAME. I'm a GUMSHOE LEVEL ONE. I'm on assignment from Gelasio.
	DIALOG | ??? = s_port_baldomero | Gelasio, eh?
	DIALOG | P_NAME | Yeah you know him, right?
	WAIT   | 0.3
	DIALOG | ??? = s_port_baldomero | Yeah, I know him. I'm_ I'm Augustino...
	DIALOG | P_NAME = s_port_hoopzHappy | Wow! Augustine?! Really?
	DIALOG | Augustine = s_port_baldomero | Yeah. When someone says they are someone, you should believe them. No doy. So what do you want with me, now that you've found me?
	DIALOG | P_NAME | Oh uh, well. Mr. Gelasio is looking for you pretty desperately. I think you should go back up to Tir na nOg. He's really lonely drinking The Grape by himself.
	DIALOG | Augustine = s_port_baldomero | The Grape, eh? Hmmm... Tempting but I have some things I am taking care of down here.
	DIALOG | P_NAME = s_port_hoopzSad | Oh... I think Gelasio really wants you back... Maybe you can write him a note or something?
	DIALOG | Augustine = s_port_baldomero | Yeah I was just about to suggest that but you kept talking.
	IF baldoSuicideNote == 1 | GOTO | NOTETAKEBACK
	IF baldoBlank == 1 | GOTO | NOTETAKEBACK
	GOTO   | NOTEGIVE

	NOTETAKEBACK
	DIALOG | Augustine = s_port_baldomero | Here give me back my note that you stole.
	DIALOG | P_NAME | Oh, uh sure.
	WAIT   | 0.25
	USEAT  | o_baldomero01
	IF baldoSuicideNote == 1 | NOTE | give | Suicide Note
	IF baldoBlank == 1       | NOTE | give | Blank Paper
	IF baldoSuicideNote == 1 | NOTIFY | Gave Augustine back the Suicide Note
	IF baldoBlank == 1       | NOTIFY | Gave Augustine back the Blank Paper
	GOTO   | NOTEGIVE

	NOTEGIVE
	DIALOG | Augustine = s_port_baldomero | Hmmm let's see.
	WAIT   | 2
	DIALOG | Augustine = s_port_baldomero | Here you go.
	NOTE   | take | Augustino's Letter
	NOTIFY | Got Augustine's Letter
	WAIT   | 0.2
	DIALOG | P_NAME | Hmmm, thanks. I hope this will help Gelasio. (And maybe get me to L_E_V_E_L_ T_W_O_... hehe.)
	DIALOG | Augustine = s_port_baldomero | Yeah yeah, so we done here?
	GOTO   | GOAWAY

	GOAWAY
	DIALOG | P_NAME | Uh, I guess so.
	IF baldoState == 4 | DIALOG | Augustine = s_port_baldomero | Good. Bye.
	IF baldoState != 4 | DIALOG | ??? = s_port_baldomero | Good. Bye.
	WAIT   | 0.5
	SET    | o_baldomero01 | playDead
	WAIT   | 0.5
	IF baldoState == 4 | DIALOG | P_NAME | ... uh thanks Mr. Augustine.
	IF baldoState == 4 | DIALOG | Augustine = s_port_baldomero | ...
	IF baldoState != 4 | DIALOG | ??? = s_port_baldomero | ...
	GOTO   | END

	END
	EVENT | o_baldomero01 | 0
	EXIT |"
	scr.original_script = my_script
	cutscene_script = scr
