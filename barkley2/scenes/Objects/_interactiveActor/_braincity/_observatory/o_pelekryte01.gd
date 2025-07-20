extends B2_InteractiveActor

## pelekryteState ##
## 0 = Not talked to ##
## 1 = Talked to before ##
## 2 = Agreed to help ##
## 3 = Said you would maybe help ##
## 4 = Reached 2nd floor of sewers ##
## 5 = Mission complete, IRT has been performed ##
## 6 = Mission failed, Pele is dead ##
## 7 = Mission failed, Pele is gone ##

## Use nonwin states as the Pele dies in the sewers state after time 5 ## ???

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	B2_Playerdata.Quest( "gamename", B2_Vidcon.get_vidcon_name(18) )
	
	## Set collision to a circle in the IRT room ##
	#if get_room_name() == "r_sw2_indianRopeTrick01" then scr_entity_setMovementCollisionShape_circle(1);

	## Indian rope trick facing ##
	if get_room_name() == "r_sw2_indianRopeTrick01" or get_room_name() == "r_sw2_utility01":
		ActorAnim.flip_h = true
	
	## If rope trick hasn't occured then check for disabling rules ##
	if B2_Playerdata.Quest("indianRopeTrick") == 0:   
		## Deactivation rules ## TNN ##
		if get_room_area() == "tnn":
			## Deactivate if he is dead OR if mission is complete ##
			if B2_Playerdata.Quest("pelekryteState") >= 5: 
				queue_free()

			## After time 5 he is just gone if you haven't started the quest ##
			# if scr_time_get() >= 5 then scr_event_interactive_deactivate(); TODO

			## Gone from his rooftop if you accepted the quest ##
			if get_room_name() == "r_tnn_businessDistrict01":
				if B2_Playerdata.Quest("pelekryteState") == 2:
					queue_free()
				if B2_Playerdata.Quest("pelekryteState") >= 4:
					queue_free()

			## Don't appear in the backshop room if the quest is not accepted ##
			if get_room_name() == "r_tnn_backshop01":
				if B2_Playerdata.Quest("pelekryteState") < 2 or B2_Playerdata.Quest("pelekryteState") == 3:
					queue_free()
			if get_room_name() == "r_tnn_gutterHouse01":
				if B2_Playerdata.Quest("pelekryteState") < 2 or B2_Playerdata.Quest("pelekryteState") == 3:
					queue_free()

			## Don't appear in the room if you have reached sewers floor 2 ##
			if get_room_name() == "r_tnn_backshop01" and B2_Playerdata.Quest("pelekryteState") >= 4:
				queue_free()
			if get_room_name() == "r_tnn_gutterHouse01" and B2_Playerdata.Quest("pelekryteState") >= 4:
				queue_free()

		## Deactivation rules ## Sewers ##
		elif get_room_area() == "sw1" or get_room_area() == "sw2":
			## Deactivate if he is dead OR if mission is complete ##
			if B2_Playerdata.Quest("pelekryteState") >= 5:
				queue_free()

			## Don't appear in the sewers if the quest is not accepted ##
			if B2_Playerdata.Quest("pelekryteState") < 2 or B2_Playerdata.Quest("pelekryteState") == 3:
				queue_free()

			## Don't show up in Sewer Floor 1 after you have reached Floor 2 ##
			if B2_Playerdata.Quest("pelekryteState") >= 4 and get_room_area() == "sw1":
				queue_free()

		## Reach second floor ##
		if B2_Playerdata.Quest("pelekryteState") == 2:
		## When you reach one of these Floor 2 entrances, Pelekryte is permanently on floor 2 afterwards until the quest is complete in one way or another ##
			if get_room_name() == "r_sw2_eastExit01" or get_room_name() == "r_sw2_end01" or get_room_name() == "r_sw2_start01":
				B2_Playerdata.Quest("pelekryteState", 4);

		## Braincity ##
		if B2_Playerdata.Quest("pelekryteState") != 5 and get_room_area() == "bct":
			queue_free()

	## Rope trick disabling ##
	else:
		## Disable Pelekryte in TNN and Sewers after the Indian Rope Trick has occured ##
		if get_room_area() == "tnn" || get_room_area() == "sw1" || get_room_area() == "sw2":
			queue_free()

	## Get the proper script ##
	if get_room_area() == "tnn": _tnn_script()
	if get_room_area() == "sw1" or get_room_area() == "sw2": _sewer_script()
	if get_room_area() == "bct": _brain_script()
	
	## Regular actor stuff
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

func _tnn_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"IF room == r_tnn_backshop01 | IF pelekryteState == 2 | GOTO | SEWAGE
	IF room == r_tnn_gutterHouse01 | IF pelekryteState == 2 | GOTO | SEWAGE
	IF pelekryteState == 0 | GOTO | PELE_TNN0
	IF pelekryteState == 1 | GOTO | PELE_TNN1
	IF pelekryteState == 2 | GOTO | PELE_TNN2
	IF pelekryteState == 3 | GOTO | PELE_TNN3

	SEWAGE
	DIALOG | Dr. Pelekryte | Alright youngshter, I'm ash ready ash I'll ever be...

	PELE_TNN0
	DIALOG | Dr. Pelekryte | Hmph? W-who are you? You're not one of thoshe Duergarsh are you?
	DIALOG | P_NAME | Nah, I'm just your average youngster on the loose.
	DIALOG | Dr. Pelekryte | Phew, thank the shtarsh for that! I can't even imagine what thoshe brutesh would do if they'd find me on their precioush rooftopsh.
	KNOW | knowPelekryte | 2
	GOTO | HEY_MISTER

	PELE_TNN1
	DIALOG | Dr. Pelekryte | Hmm? Ish there shomething you need, youngshter?
	GOTO | HEY_MISTER

	PELE_TNN2
	DIALOG | Dr. Pelekryte | Alright, lad. Are you ready to go? If you are then jusht venture forth and I'll follow you.
	DIALOG | P_NAME | Okay.

	PELE_TNN3
	DIALOG | Dr. Pelekryte | Hmm? Oh, it's you. Did you do everything you needed to here? Do you want to try and escape with me?
	GOTO | SEWERCHOICE

	HEY_MISTER
	CHOICE | Hey mister...
	IF pelekryteState == 0 | REPLY | DRUNK? | ...Are you drunk?
	REPLY | WHYHERE | ... What are you doing up here?
	REPLY | NEEDTOGO | ... I need to go.

	DRUNK?
	DIALOG | P_NAME | Hey mister... are you drunk? Do you need help to get down from here?
	DIALOG | Dr. Pelekryte | What? What ish that shupposhed to mean?
	DIALOG | P_NAME | Don't misunderstand, it's just the way you... What are you doing up here anyway?
	GOTO | TNN_EXPLANATION

	WHYHERE
	DIALOG | P_NAME | Hey mister... What are you doing up here?
	GOTO | TNN_EXPLANATION

	NEEDTOGO
	DIALOG | P_NAME | Hey mister... I need to get going now.
	DIALOG | Dr. Pelekryte | Alright then. Jusht don't tell the Duergarsh that I'm up here...
	QUEST | pelekryteState = 1

	TNN_EXPLANATION
	DIALOG | Dr. Pelekryte | I'm shtudying the shtarsh and conshtellationsh around Necron 7. Or at leasht that'sh what I'm trying to do.
	DIALOG | P_NAME | Oh? What's the problem?
	DIALOG | Dr. Pelekryte | Thish locale for shtartersh. A glorified ghetto with Duergarsh around every corner jusht waiting to karate chop ush dwarfsh. I can never be shure when shome brute ish going to jump me and shend me up the river.
	DIALOG | P_NAME | Can't you just go to some other place? I'm sure there's better places to do all this.
	DIALOG | Dr. Pelekryte | Hmm, you musht be new here, right? Dwarfsh aren't allowed to leave Tir na Nog once they are in here. Thish is the besht I'm going to get until they let ush leave. If they ever let ush leave.
	DIALOG | P_NAME | Oh, uh, right. I forgot about that.
	DIALOG | Dr. Pelekryte | Pershonally I don't think they'll ever let ush out of here. I can't put my finger on it, but shomething'sh wrong here. I don't know what ish going to happen once all the dwarfsh have been brought to Necron 7, and I'm not keen on finding out either. Problem ish, I'm old and decrepit. I can't make it out of here on my own.
	DIALOG | P_NAME | What are you planning exactly? Escaping through the sewers or something?
	DIALOG | Dr. Pelekryte | Oh, I have a plan alright. There'sh an old shervice tunnel down in the shewersh. It'sh been abandoned for quite shome time now but I believe we could ushe it to get out of here.
	DIALOG | P_NAME | We?
	DIALOG | Dr. Pelekryte | Yesh, we. Like I shaid I'm too old to do thish on my own. The shewersh are a dangeroush place. I don't think I need to lecture you about that, right? I can shenshe that you're a shmart kid. You don't believe thish hocush pocush about thish " + '"' + "prize" + '"' + ". No, you know that nothing good ish waiting for ush in here. We need to get out of here ash shoon ash posshible.
	GOTO | SEWERCHOICE

	SEWERCHOICE
	CHOICE | Try to escape Tir na Nog with Pelekryte?
	REPLY | YES | Yeah, let's do it...
	REPLY | NO | I still have things to do here...
	QUEST | pelekryteState = 1

	YES
	DIALOG | P_NAME | Yeah, let's do it. It's about time I got out of here. I have to find the Cyberdwarf, and I'm beginning to think he isn't anywhere near Tir na Nog.
	DIALOG | Dr. Pelekryte | The Cyberdwarf, eh? Never heard about anyone like that, but it'sh none of my bushinessh anyway. Alright, enough lollygaggin'. We need to make hashte. Our opportunity ish here and we have to act while we shtill have it. I'll be waiting for you near the shewer entrance.
	DIALOG | P_NAME | Okay, I'll meet you there.
	FADE | 1 | 1
	WAIT | 1
	EVENT | o_pelekryte01 | 0
	FADE | 0 | 1
	WAIT | 1
	QUEST | pelekryteState = 2

	NO 
	DIALOG | P_NAME | I can't leave yet, I still need things to do here.
	DIALOG | Dr. Pelekryte | Gah, don't be a fool youngshter! You'll be ripe pickingsh for the duergarsh if you shtay here much longer.
	DIALOG | P_NAME | Don't worry about me, old man. I can handle myself.
	DIALOG | Dr. Pelekryte | Very well then. I can't force you to come with me... I'll be waiting here jusht a while longer in cashe you change your mind. But I can't wait forever. If you don't show up then I'll jusht have to brave the shewersh myshelf.
	DIALOG | P_NAME | Okay, I'll see if I can make it in time. Just don't get yourself killed, doc. 
	QUEST | pelekryteState = 3"
	scr.original_script = my_script
	cutscene_script = scr
	
func _sewer_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"IF room == r_sw1_fishersCreek01 | DIALOG | Dr. Pelekryte | Alright, our goal is to reach the shecond floor of the shewersh and then find the shervice tunnel. Let's get moving.
	IF room == r_sw1_joad01         | DIALOG | Dr. Pelekryte | Yipesh... That poor dwarf there ish exactly what we'll end up like if we don't get out of Tir na N0g. Come on, let'sh go. The tunnel ish on the floor below ush.
	IF room == r_sw1_utility01      | DIALOG | Dr. Pelekryte | Have you gathered your bearingsh yet? If sho then we'd better get moving. We need to find our way to the floor below.
	IF room == r_sw1_tnnShortcut01  | DIALOG | Dr. Pelekryte | It looksh like this ladder leadsh back to Tir na Nog. But that ish not our goal. Our goal ish to get out of Tir na Nog.
	IF room == r_sw1_plantation02   | DIALOG | Dr. Pelekryte | Ah, it ish good to shee all theshe dwarfsh finding employment. Perhapsh the duergarsh aren't all bad...
	IF room == r_sw1_baldomero01    | DIALOG | Dr. Pelekryte | I shpy with my little eye shomething that ish amissh...

	IF room == r_sw2_utility01      | DIALOG | Dr. Pelekryte | Hmm, I'm shure the shervice tunnel ish shomewhere nearby.
	IF room == r_sw2_start01        | DIALOG | Dr. Pelekryte | Thish ish the shecond floor of the shewersh. The shervice tunnel is shomewhere down here. The firsht floor ish done and dushted.
	IF room == r_sw2_eastExit01     | DIALOG | Dr. Pelekryte | Thish ish the shecond floor of the shewersh. The shervice tunnel is shomewhere down here. We no longer need to go back to the firsht floor.
	IF room == r_sw2_end01          | DIALOG | Dr. Pelekryte | Thish ish the shecond floor of the shewersh. The shervice tunnel is shomewhere down here, sho let'sh not go back to the firsht floor.
	IF room == r_sw2_hermitPass01   | GOTO | UNDERSEWER

	UNDERSEWER
	DIALOG | Dr. Pelekryte | Even here, in the darkesht of depthsh, nature findsh a way... 
	DIALOG | P_NAME        | Apparently so.
	DIALOG | Dr. Pelekryte | Youngshter, thish sheemsh like a nice place to resht your feet for a moment. *Shniff* *Shniff* Hmm... That shmell. It shmellsh like gun'sh-fish. I think there might be a fishing shpot in here.
	DIALOG | P_NAME        | Hmm..."
	scr.original_script = my_script
	cutscene_script = scr
	
func _brain_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"IF peleStarState == 0 | GOTO | GREETINGS
	IF peleStarState == 1 | GOTO | ITEM_CHECKER
	IF peleStarState == 2 | GOTO | RETURN_FOR_QUEST
	IF peleStarState == 3 | GOTO | TELESCOPE_WIP
	IF peleStarState == 4 | GOTO | TELESCOPE_READY
	IF peleStarState == 5 | GOTO | TELESCOPE_READY_REPEAT

	GREETINGS
	DIALOG | Dr. Pelekryte | Ah, it'sh you! The youngshter who `sq`helped me eshcape Tir na nog!`rt`_ Thank you sho much for helping me out back there!
	DIALOG | P_NAME = s_port_hoopzHappy | Mr. Pelekryte!_ Wowzers!_ So you made it after all. I thought you were a goner for sure.
	DIALOG | Dr. Pelekryte | Hah, I'm made of shterner shtuff.
	DIALOG | P_NAME        | So what happened to you? One moment you are there, doing the `sq`ol' Indian Rope Trick,`rt` and then all of a sudden you are sliding into a hole in the wall.
	DIALOG | Dr. Pelekryte | Ah, it'sh a long shtory. Shorry about leaving you behind, youngshter. I knew that wash my only chance, sho I took it. Nothing pershonal. 
	DIALOG | P_NAME        | Oh, it's fine. I made it out of Tir na nog on my own anyway.
	DIALOG | Dr. Pelekryte | Hah, indeed you did. Anyway, ash I wash shaying, the rope carried me all the way through the shervice tunnel and then I found myshelf in the `kw`Weshtelandsh.`rt` What followed wash one tribulation after another, but with shome persheverance and a lot of good luck I made it to Braincity. 
	DIALOG | P_NAME        | Whoa! That's so dope, dude.
	DIALOG | Dr. Pelekryte | Yesh, it's dope ash shit! 
	DIALOG | P_NAME        | So I see you finally got back to astronomy. Is this your `sq`observatory?`rt`
	DIALOG | Dr. Pelekryte | Thish ish the one and only `sq`Braincity Obshervatory.`rt`_ Uh, actually to be totally honesht with you, it'sh not much of anything yet. Jusht look at all thish shtuff I shtill need to short out. But I'm hopeful that with shome time and effort I'll make thish into a bashtion of knowledge.
	DIALOG | P_NAME        | Yeah, it's a real pigsty in here. No offense.
	DIALOG | Dr. Pelekryte | None taken, youngshter.
	DIALOG | P_NAME        | Hey, mind if I take a peek at the stars?
	DIALOG | Dr. Pelekryte | You can't. Well, not quite yet anyway. You shee that thing needsh a bit of maintenance to put it lightly. Uh, you wouldn't mind helping me out with the `sq`teleshcope?`rt` I know you've already done sho much for me, but I'm a shitty, decrepit old man. I can't do thish on my own.
	CHOICE | Agree to fix the telescope?
	REPLY  | FIX_YAY | Yeah, sure!
	REPLY  | FIX_NAY | No!

	FIX_YAY
	DIALOG | P_NAME        | Okay, I guess I can help a bit. What exactly do you need me to do?
	DIALOG | Dr. Pelekryte | Oh that'sh great newsh! Yeah, sho ash you can shee all the neceshshary partsh are shtrewn about the would-be obshervatory. If you could, pleashe help me shet them in their proper placesh.
	DIALOG | P_NAME        | Alright. How do I know which thing goes where?
	DIALOG | Dr. Pelekryte | Let'sh do it like thish: you pick up an inshtrument you want to know about, and I'll tell you where it'sh shupposhed to go. Then you shimply put it in it'sh place.
	DIALOG | P_NAME        | Okay, sounds easy enough. Here we go...
	QUEST  | peleStarState = 1

	FIX_NAY
	DIALOG | P_NAME        | Sorry but I've got other things to do.
	DIALOG | Dr. Pelekryte | Oh that'sh quite alright. Maybe shome other time then?
	DIALOG | P_NAME        | Yeah, I might come back here later. Good luck, and stay frosty.
	DIALOG | Dr. Pelekryte | Thanksh!
	QUEST  | peleStarState = 2

	RETURN_FOR_QUEST
	DIALOG | Dr. Pelekryte | Ah, youngshter! Did you change your mind about helping me fix up thish meshsh?
	CHOICE | Agree to fix the telescope?
	REPLY  | FIX_YAY | Yeah, sure!
	REPLY  | FIX_NAY | No!

	ITEM_CHECKER
	IF peleStarItem == 0 | DIALOG | Dr. Pelekryte | Hey what'sh thish? Your handsh are empty! Did you get everything shorted out already?
	IF peleStarItem == 0 | GOTO   | END_MINIGAME
	IF peleStarItem == 1 | DIALOG | Dr. Pelekryte | That beauty ish the `sq`BFXT Mainframe Chip.`rt` Shet that next to the `kw`Quantum Teshla Shcanner.`rt`
	IF peleStarItem == 2 | DIALOG | Dr. Pelekryte | Oh, careful! That'sh the `sq`Quantum Teshla Shcanner.`rt` Put that next to the `kw`Quadcore Heimlich Battery`rt` and the `kw`BFXT Mainframe.`rt`
	IF peleStarItem == 3 | DIALOG | Dr. Pelekryte | Heavy ishn't it? That'sh the `sq`Quadcore Heimlich Battery.`rt` Shet that below the monitor.
	IF peleStarItem == 4 | DIALOG | Dr. Pelekryte | Hmm, oh that's the `sq`Hyperborean Modulator.`rt` Put that between the `kw`Mark II Globulator`rt` and the `kw`Quadcore Heimlich Battery.`rt`
	IF peleStarItem == 5 | DIALOG | Dr. Pelekryte | That's the `sq`Mark II Globulator.`rt` Put that below the `kw`Crystal Pistons.`rt`
	IF peleStarItem == 6 | DIALOG | Dr. Pelekryte | Thoshe are the `sq`Cryshtal Pishtonsh.`rt` Put thoshe near the `kw`Mark II Globulator`rt` and the `kw`Exhaust Pipe.`rt`
	IF peleStarItem == 7 | DIALOG | Dr. Pelekryte | Ah, look at that beauty. That'sh the `sq`Exhausht Pipe.`rt` Put that next to the`kw`Crystal Pishtonsh`rt` and leave an empty shlot on the left shide of it.

	END_MINIGAME
	CHOICE | Is this arduous task over?
	REPLY  | MINIGAME_YAY | Yeah...
	REPLY  | MINIGAME_NAY | Nah... 

	MINIGAME_YAY
	DIALOG | P_NAME        | Yeah, doc. I think I'm all done here.
	EVENT  | o_pelekryte01 | 4
	IF peleMachine == 0    | GOTO | MINIGAME_NONE
	IF peleMachine == 1    | GOTO | MINIGAME_LITTLE
	IF peleMachine == 2    | GOTO | MINIGAME_LOT
	IF peleMachine == 3    | GOTO | MINIGAME_ALL
	IF peleMachine == 4    | GOTO | MINIGAME_PERFECT

	MINIGAME_NONE
	DIALOG | Dr. Pelekryte | Thanksh! Umm... Wait a minute. Did you even do anything? What a shcam! I've been schammed! Schammed, flimmed and flammed!
	DIALOG | P_NAME        | Sorry doc, that's all I could manage with this aching back of mine.
	DIALOG | Dr. Pelekryte | Hmph. Guessh I have to short thish shtuff on my own after all.
	ClockTime | event | peleStarState | 4 | 120
	GOTO   | MINIGAME_POST 

	MINIGAME_LITTLE
	DIALOG | Dr. Pelekryte | Thanksh! Uh, I wash hoping you'd do a bit more but that's fine. The resht I can manage on my own. Well, I better get to it then. Thanksh for your help.
	DIALOG | P_NAME        | No problem, doc.
	ClockTime | event | peleStarState | 4 | 90
	GOTO   | MINIGAME_POST 

	MINIGAME_LOT
	DIALOG | Dr. Pelekryte | Thanksh! I really appreciate thish you know. I'm shorry that I don't really have anything to give you in return.
	ClockTime | event | peleStarState | 4 | 60
	GOTO   | MINIGAME_POST 

	MINIGAME_ALL
	DIALOG | Dr. Pelekryte | Thanksh! You've done a real whopper of a doozy of a job.
	DIALOG | P_NAME        | I'm just glad to help doc.
	DIALOG | Dr. Pelekryte | Oh, I just remembered that I had shomething for you!_ Here, take thish ash a token of my gratitude.
	USEAT  | o_pelekryte01
	NOTIFY | Found the vidcon @gamename@!
	EVENT  | o_pelekryte01 | 5
	DIALOG | P_NAME        | Oh, hey. I didn't know you were into vidcons Mr. Pelekryte.
	DIALOG | Dr. Pelekryte | I'm a born gamer. I'm more entangled in this ashtronomy bushineshsh right now but I like to beat up on shome kidsh online every now and then. Have you sheen my noshcope360 compilation video on dwarftube?
	DIALOG | P_NAME        | Uh, no, I haven't. Well, thanks for this Mr. Pelekryte. I hope I'll get to use that telescope soon enough.
	DIALOG | Dr. Pelekryte | Heh, jusht come back a bit later, I'll have her all juiced up.
	ClockTime | event | peleStarState | 4 | 30
	GOTO   | MINIGAME_POST 

	MINIGAME_PERFECT
	DIALOG | Dr. Pelekryte | W-wow! You have shinglehandedly fixed up the teleshcope to near perfection! Thish ish amazing! 
	DIALOG | P_NAME        | Heh, they used to call me the brainiac. I guess they were right...
	DIALOG | Dr. Pelekryte | Amen to that, brother!_ Thanksh to you I'll have thish teleshcope fixed up in no time.
	DIALOG | P_NAME        | Hmm... Keep me posted, old timer.
	DIALOG | Dr. Pelekryte | Oh I will._ Here, take this as a token of my gratitude.
	USEAT  | o_pelekryte01
	NOTIFY | Found the vidcon @gamename@!
	EVENT  | o_pelekryte01 | 5
	DIALOG | P_NAME        | Oh, hey. I didn't know you were into vidcons Mr. Pelekryte.
	DIALOG | Dr. Pelekryte | I'm a born gamer. I'm more entangled in this ashtronomy bushineshsh right now but I like to beat up on shome kidsh online every now and then. Have you sheen my noshcope360 compilation video on dwarftube?
	DIALOG | P_NAME        | Uh, no, I haven't. Well, thanks for this Mr. Pelekryte. I hope I'll get to use that telescope soon enough.
	DIALOG | Dr. Pelekryte | Heh, jusht come back a bit later, I'll have her all juiced up.
	ClockTime | event | peleStarState | 4 | 10
	GOTO   | MINIGAME_POST 

	MINIGAME_POST 
	DIALOG | Dr. Pelekryte | Anyway, I shtill have to double-check the calibrationsh and run shome errandsh, but come back here later and I'll have thish teleshcope ready for ushe. 
	DIALOG | P_NAME        | Awesome! Okay, I'll see you later then.
	QUEST  | peleStarState = 3

	MINIGAME_NAY
	DIALOG | P_NAME        | There's still work to be done.
	DIALOG | Dr. Pelekryte | Carry on then!

	TELESCOPE_WIP
	DIALOG | Dr. Pelekryte | Come back a little later, youngshter. I shtill need to make shome adjushtmentsh and arrangementsh before the `kw`Teleshcope`rt` ish ushable.

	TELESCOPE_READY
	DIALOG | Dr. Pelekryte | Ah, welcome youngshter! Welcome to the Saint Pelekryte Obshervatory!
	DIALOG | P_NAME        | Hey doc. What's up? Did you get that telescope all under control?
	DIALOG | Dr. Pelekryte | You bet I did. You want to take a peek, youngshter?
	DIALOG | P_NAME        | Wow, can I?
	DIALOG | Dr. Pelekryte | Of courshe! Without you I'd shtill be shtuck in Tir na nog. We've got shome other activitiesh here ash well. I could tell you shome very intereshting shatishticsh and tidbitsh of hishtory about the outer shpace around Necron 7. Or if you'd like, you could participate in the Conshtellation Competition hoshted by the Necron 7 Ashtrological Shociety. 
	SET    | o_telescope_screen01 | stars
	QUEST  | peleStarState = 5
	GOTO   | OBSERVE_CHOICE

	TELESCOPE_READY_REPEAT
	DIALOG | Dr. Pelekryte | Back for more, eh?
	DIALOG | P_NAME        | Hey doc. There's just something I wanted to know...
	GOTO   | OBSERVE_CHOICE

	OBSERVE_CHOICE
	CHOICE | What do you want to do?
	IF peleTelescope == 0     | REPLY | OBSERVE_SCOPE | Lemme use the telescope!
	IF peleBoredom == 0       | REPLY | OBSERVE_STATS | Lay down the stats and history, doc!
	IF peleConstellation == 0 | REPLY | OBSERVE_COMPO | Competition? Sign me up!
	REPLY  | OBSERVE_NADA  | Uh, I gotta go.

	OBSERVE_SCOPE
	DIALOG | P_NAME        | I wanna use the telescope!
	DIALOG | Dr. Pelekryte | Heh, I guesshed as much. The teleshcope ish out mosht popular attraction here at the Obshervatory. Sho much sho that unfortunately I've had to shart ashking for a shmall fee for ushing the teleschope. I hate to do it, but there are shome maintenance coshtsh involved here, and I gotta eat too. Pleashe undershtand.
	DIALOG | P_NAME        | O-oh... I guess that makes sense. How much is the fee?
	BREAKOUT | add | money
	DIALOG | Dr. Pelekryte | ... Uh... it'sh @money_pelekryteFee@ Neuro-Shekels.
	DIALOG | P_NAME        | What?! That's outrageous!
	DIALOG | Dr. Pelekryte | Y-yeah, I know! But I've got no choice. I need to cover my expenshesh shomehow.
	CHOICE | Pay up? (@money_pelekryteFee@ Neuro-Shekels)
	IF money >= @money_pelekryteFree@ | REPLY | SCOPE_PAY | Here's the dough.
	IF money < @money_pelekryteFree@  | REPLY | SCOPE_XYZ | I don't have enough...
	REPLY  | SCOPE_NAY     | No dice.

	SCOPE_PAY
	QUEST  | money -= @pelekryteFee@
	DIALOG | P_NAME        | This better be worth it.
	DIALOG | Dr. Pelekryte | Oh, you bet it ish. Here, take a look for yourshelf.
	BREAKOUT | clear
	QUEST  | peleTelescope = 1
	// Telescope view

	SCOPE_NAY
	DIALOG | P_NAME        | No way, doc! That's way too much.
	DIALOG | Dr. Pelekryte | No pay, no play. Shorry.
	BREAKOUT | clear
	DIALOG | P_NAME        | `w1`*Sigh*`w0`
	GOTO   | OBSERVE_CHOICE

	SCOPE_XYZ
	DIALOG | P_NAME        | I don't have that sort of money on me...
	DIALOG | Dr. Pelekryte | No pay, no play. Shorry.
	DIALOG | P_NAME        | But I helped you out in Tir na Nog. Doesn't that count to anything?
	DIALOG | Dr. Pelekryte | Hey, I appreciate what you've done for me, I really do. But I shtill need to eat.
	DIALOG | P_NAME        | `w1`*Sigh*`w0`
	DIALOG | Dr. Pelekryte | Ish there anything elshe that might interesht you?
	GOTO   | OBSERVE_CHOICE

	OBSERVE_STATS
	DIALOG | P_NAME        | Give me some stats and history, pronto!
	DIALOG | Dr. Pelekryte | You want shtatsh? I'll show you shtatsh...
	DIALOG | Dr. Pelekryte | `w1`*Ahem*`w0` In the coshmosh shurrounding Necron 7 there are approximately 32 million different shtarsh. Now, it'sh important to note that the `kw`Garfunkel Method`rt` ish ushed to confirm theshe numbersh and ash shuch there ish definetly a margin of error. But that ish nor here or there. Out of theshe shtarsh only approximately 12% have any shignificant celeshtial objectsh orbiting them which ish conshidered to be an anomaly among the ashtronomical community. Three of the biggesht shtarsh near Necron 7 are YLDDD-523, QW23-BETA and LOPNER6. Ash far ash planetsh go, there are only a handful of planetsh that are inhabited. The inhabitantsh conshisht moshtly of indigenoush wildlife, moshty due to all the dwarf coloniesh on thoshe planetsh being abducted and transhported to Necron 7. In the year 5443 of the Herbert Age, there wash a shignificant shupernova which devashtated the Goiter Centauri and Jalapeno Goblin shyshtemsh. 
	DIALOG | Dr. Pelekryte | Another `w1`VERY`w0` intereshting event happened in the year 6022 of the Herbert Age when there wash a big breakout in the Iron Hooshgow which ish conshtantly drifting along the edge of the known univershe. The Grand Duke of Lopshtopore deshcribed the breakout ash the greatesht hoot in a hooshgow he hash ever sheen. Oh, excushe me, I wash going off topic for a bit there. Anywaysh, ash I wash shaying, there has been 530572 confirmed ashteroid shightingsh ever shince shuch thingsh have been recorded. On top of that, there hash been 9372 shightings of U.F.O.'s from which only 62 have been officially confirmed. Shtrange, huh?
	DIALOG | P_NAME        | Thank you doc, this has been... very interesting, but could we do something else?
	DIALOG | Dr. Pelekryte | B-but I washn't finished yet!
	QUEST  | peleBoredom = 1
	GOTO   | OBSERVE_CHOICE

	OBSERVE_COMPO
	DIALOG | P_NAME        | What's this about a competition of some sort?
	DIALOG | Dr. Pelekryte | Ah, so you want your name in the hishtory booksh eh? Well, thish ish your chance!
	DIALOG | P_NAME        | What do I need to do? I don't have to fill in some boring forms do I?
	DIALOG | Dr. Pelekryte | No no, I'll take care of shuch formalitiesh. All you have to do ish create the conshtellation. You shee that computer machine attached to the telescope? It'sh running a shimulation of the coshmosh around Necron 7. It'sh bashed on all the findingsh I have inputted into the shyshtem.
	DIALOG | P_NAME        | How do I use that to make constellations?
	DIALOG | Dr. Pelekryte | Conshtellation. Shingular. Everyone getsh to shubmit only one conshtellation. Thoshe are the rulesh. Anywaysh, I've shetup the shyshtem sho that all you have to do ish draw the conshtellation on it. That'sh it! Shimple, huh?
	DIALOG | P_NAME        | What about the submitting part? This is going to be made official right?
	DIALOG | Dr. Pelekryte | Oh yesh, quite right. Once you've drawn the conshtellation, I'll fill in the appropriate formsh and then I'll d-mail all the material to the conshtellation committee. If your shubmishshion winsh then they'll shend out a certificate for you and then it'll all be official.
	DIALOG | P_NAME        | Wow, sounds great! Let's get to it then.
	WAIT   | 0.25
	FRAME  | CAMERA_NORMAL | o_cinema0
	MOVETO | o_cts_hoopz   | o_cinema0 | MOVE_NORMAL
	WAIT   | 0
	LOOK   | o_cts_hoopz   | NORTH
	WAIT   | 0.5
	USEAT  | NORTH
	WAIT   | 0.5
	CREATE_WAIT | o_mg_star_control
	WAIT   | 0
	WAIT   | 1
	DIALOG | P_NAME        | A work of art, if I do say so myself.
	LOOKAT | o_cts_hoopz   | o_pelekryte01
	WAIT   | 0.15
	FRAME  | CAMERA_NORMAL | o_cts_hoopz | o_pelekryte01
	WAIT   | 0.25
	MOVETO | o_cts_hoopz   | o_cinema0 | MOVE_NORMAL
	WAIT   | 0
	DIALOG | P_NAME        | Alright doc. I've got the constellation all done and dusted.
	DIALOG | Dr. Pelekryte | Great work! Okay I'll `kw`d-mail`rt` your shubmishshion to the committee and after a while they should shend out a reply._ `w1`Exciting huh?`w0`
	DIALOG | P_NAME        | Awesome... I can't wait! Okay doc I think I'll go and do something to pass the time. You'll tell me as soon as you hear something, right?
	DIALOG | Dr. Pelekryte | Oh, absholutely. It'll probably take a day or two before it'sh all shaid and done though.
	DIALOG | P_NAME        | Okay. See you around doc.
	QUEST  | peleConstellation = 1

	OBSERVE_NADA
	DIALOG | P_NAME        | Uh, actually I've got other stuff to do right now. See you around."

	scr.original_script = my_script
	cutscene_script = scr

func execute_event_user_0() -> void:
	queue_free()

func execute_event_user_4() -> void:
	## TODO Add telescope stuff
	# check o_pelekryte01 event 4
	push_warning("Event 4 not set.")

func execute_event_user_5() -> void:
	B2_Vidcon.give_vidcon( 18 )
