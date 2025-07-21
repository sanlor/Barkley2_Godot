extends B2_EnvironInteractive

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

# event_swp_growthElemental01
#
#DESCRIPTION:
	#The Growth Elemental is in a box in the Sewers.
	#Talking to it psychically shows you an image (gives you a quest) of the Sludge Machine further into the sewers.
	#Turning off the Sludge Machine (with or without getting the Quest first) gets 
#
	#
#VARIABLES:
	#growthElementalState
		#1 = Autostart cutscene has happened upon room entry.
		#2 = Got Quest for turning off Sludge Machine.
		#3 = Got Quest, turned off Machine (req. sludgeMachineState == 1), talked. Got "W Fruit" item.
		#4 = After 3, talked again and got a hint to plant the fruit.
		#5 = Did not get Quest, turned off Machine (req. sludgeMachineState == 1), talked. Got "W Fruit" item.
#
	#sludgeMachineState
		#1 = Sludge Machine turned off.          

var zauberPrep 		:= ""
var zauberUse 		:= ""
var zauberToggle 	:= ""

var zauber_got : String = \
	"Misc   | music | mus_blankTEMP | 0
	WAIT   | 0.25
	FRAME  | CAMERA_NORMAL | o_growthZauber01
	WAIT   | 0
	WAIT   | 0.25
	LOOKAT | o_cts_hoopz | o_growthZauber01 
	WAIT   | 0.5
	CREATE | o_cts_bioZauber01 | 162 | 185
	SET    | o_growthZauber01 | taken
	SURPRISEAT | o_growthZauber01
	WAIT   | 1
	LOOKAT | o_cts_hoopz | o_growthZauber01
	WAIT   | 1.5
	FOLLOWFRAME | CAMERA_NORMAL | o_cts_bioZauber01
	WAIT   | 2
	LOOK   | o_cts_hoopz | NORTHWEST
	WAIT   | 3.5
	LOOK   | o_cts_hoopz | NORTHWEST
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTHEAST
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTHWEST
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTHEAST
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTHWEST
	WAIT   | 0.25
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 1.0
	PLAYSET | o_cts_hoopz | fishingShowCatch | fishingShowCatchHold
	FRAME  | CAMERA_SLOW | o_cinema2
	WAIT   | 3
	NOTIFY | Got Jello Zauber!
	EVENT  | o_growthElemental01 | 0
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.4
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.4
	Misc   | music | mus_sw1_new2 | 1
	DIALOG | P_NAME    | Wow! Is this what I think it is?
	DIALOG | Gerz-Nutz | Yes! Your very own `sq`Zauber!`rt` Keep it close to you, and it's power and wisdom will soon be yours!
	DIALOG | P_NAME    | Such power... But how do I use this thing?
	DIALOG | Gerz-Nutz | Simply head out to the battlefield and use the `kw`%s`rt` to enter into `kw`Zauber Mode.`rt` 
	DIALOG | Gerz-Nutz | Once in Zauber Mode you can use the `kw`%s`rt` to release the power of the Zauber you are holding. 
	DIALOG | Gerz-Nutz | You can use the `kw`Quickmenu`rt` or the `kw`%s`rt` to switch between different Zaubers!
	DIALOG | P_NAME    | Epic...
	DIALOG | P_NAME    | So what is this one called and what does it do?
	DIALOG | Gerz-Nutz | It is the Jello zauber! It's immense power can summon eldrich goop blobs, also known as `kw`Pozzo's Jello Prisons.`rt` Their immense power ensnare anything that comes in contact with them.
	DIALOG | P_NAME    | Whoa! Awesome!" % [zauberPrep, zauberUse, zauberToggle]


func _ready() -> void:
	if B2_Config.curr_CONTROL == B2_Config.CONTROL.KEYBOARD:
		zauberPrep = "R key"
		zauberUse = "left click"
		zauberToggle = "G key"
	else:
		zauberPrep = "zauber button"
		zauberUse = "action button"
		zauberToggle = "zauber toggle"
	_talk_script()


func _talk_script() -> void:
	var scr := B2_Script_Legacy.new()
	var my_script := \
	"MOVETO | o_cts_hoopz | o_cinema0 | MOVE_SLOW
	WAIT   | 0
	LOOK   | o_cts_hoopz | NORTH
	IF growthElemental == 1 | IF growthElementalSeedsSown > 0 | GOTO | SEED_CHECK
	IF growthElemental == 0 | GOTO | ELEMENTAL_0
	IF growthElemental == 1 | GOTO | ELEMENTAL_1
	IF growthElemental == 2 | GOTO | ELEMENTAL_2

	SEED_CHECK
	IF growthElementalSeedsSown == 1 | GOTO | SEEDS_SOWN_1  
	IF growthElementalSeedsSown == 2 | GOTO | SEEDS_SOWN_2 
	IF growthElementalSeedsSown == 3 | IF growthElementalZauber == 0 | GOTO | SEEDS_SOWN_3
	IF growthElementalSeedsSown == 4 | IF growthElementalZauber == 0 | GOTO | SEEDS_SOWN_4
	IF growthElementalSeedsSown == 5 | IF growthElementalZauber == 0 | GOTO | SEEDS_SOWN_5
	IF growthElementalSeedsSown == 3 | IF growthElementalZauber == 1 | GOTO | SEEDS_SOWN_3_ZAUB
	IF growthElementalSeedsSown == 4 | IF growthElementalZauber == 1 | GOTO | SEEDS_SOWN_4_ZAUB
	IF growthElementalSeedsSown == 5 | IF growthElementalZauber == 1 | GOTO | SEEDS_SOWN_5_ZAUB

	SEEDS_SOWN_1
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? I've sown one of your seeds. It instantly sprouted into a bush. Pretty cool.
	DIALOG | Gerz-Nutz | Ah... Just one? Come now, my friend. You can do better than that! I believe in you.
	DIALOG | P_NAME    | So uh... No reward for just one seed?
	DIALOG | Gerz-Nutz | Do not be so hasty, my friend. Remember the saying: `w1`You reap what you sow!`w0` Your reward waits at the end. Now go, sow those seeds!
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3

	SEEDS_SOWN_2
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? Two seeds sown. Pretty good, huh?
	DIALOG | Gerz-Nutz | Hmm, that's good progress, but you still have ways to go. I think you aren't taking this as seriously as you should. Hey, here's what we are going to do. You go and plant a third seed and I'll give you your first reward. Then, if you plant the rest of them, you'll get the `kw`ULTIMATE REWARD!`rt`
	DIALOG | P_NAME    | `w1`Oh!`w0` Rewards aplenty... Alright buddy. Hold still, I'll be back later.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3

	SEEDS_SOWN_3
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? Three seeds down, two more to go. What do you have to say to that, huh?
	DIALOG | Gerz-Nutz | Hmm, very good. Soon all the seeds will be sown. Yes... `w1`Mwahahahaha!`w0` 
	DIALOG | Gerz-Nutz | Alright, just to motivate you further, here's a little reward for your troubles thus far. Behold!
	%s
	DIALOG | Gerz-Nutz | Now go! You still have more seeds to sow! When you have sown all of them I will grant you the ultimate reward!
	DIALOG | P_NAME    | Alright, I'm on it!
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3
	QUEST  | growthElementalZauber = 1
	GOTO   | ZAUBER_TEST

	SEEDS_SOWN_3_ZAUB
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? Three seeds in the dirt. Cool, huh?
	DIALOG | Gerz-Nutz | Yes, it is very... cool. But what would be even more cool is if all of the seeds would be sown! Go youngster! Sow the seeds!
	DIALOG | P_NAME    | Okay then...
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3

	SEEDS_SOWN_4
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? Four seeds planted, only one more remains. What do you have to say to that, huh?
	DIALOG | Gerz-Nutz | Yes... Yes! Soon all the seeds will be sown. `w1`Muahahaha!`w0` 
	DIALOG | Gerz-Nutz | Alright, just to motivate you further, here's a suitable reward for your troubles thus far. Here, take it!
	%s
	DIALOG | Gerz-Nutz | Now go! You still have the last seed to sow! Go! Do as I have commanded you and you shall have the ultimate reward!
	DIALOG | P_NAME    | Okay, I'm on it.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3
	QUEST  | growthElementalZauber = 1
	GOTO   | ZAUBER_TEST

	SEEDS_SOWN_4_ZAUB
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | P_NAME    | Hey, what's the haps, paps? Four seeds sown. Are you impressed?
	DIALOG | Gerz-Nutz | Yes, very impressive! But you could be more impressive still. The last seed, youngster! You must get going! The sooner those seeds are sown, the better! Remember, I still have yet another reward in store for you...
	DIALOG | P_NAME    | Alright, I'm on it.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3

	SEEDS_SOWN_5
	DIALOG | P_NAME    | Hey, what's the haps, paps? You see all these seeds I have? I bet you don't because I don't have any. I've sown all of them.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | Gerz-Nutz | Superb! `w1`Muahahahaha!`w0`
	DIALOG | P_NAME    | So uh... You said something about a reward if I recall correctly.
	DIALOG | Gerz-Nutz | Yes! You have served me well! Here, take this!
	%s
	DIALOG | Gerz-Nutz | Wait! There's more! Take this as well!
	USEAT  | o_growthElemental01
	NOTIFY | Found Gorm-Stone!
	ITEM   | Gorm-Stone | 1
	DIALOG | P_NAME    | Oh. Uh... I don't mean to be rude but this looks like a piece of junk.
	DIALOG | Gerz-Nutz | Hah! It may appear like just some plain rock with a bit of paint on it, but nothing could be further from the truth!
	DIALOG | P_NAME    | Okay. If you say so...
	DIALOG | Gerz-Nutz | I see you remain unconvinced. Very well. I urge you to keep it with you, as unremarkable as it may appear to you. There will come a day when you will know it's true value.
	DIALOG | P_NAME    | Can't you just say what it's supposed to be?
	DIALOG | Gerz-Nutz | Words can never explain it's majesty. Now begone! I must resume my meditation now that my sphere of influence has grown, thanks to you. Soon my powers will be restored and I will be free of this wretched dungeon. `w1`Muahahahaha!`w0`
	DIALOG | P_NAME    | Yeah, whatever. Smell ya later.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3
	QUEST  | growthElementalZauber = 1
	QUEST  | growthElemental = 2
	GOTO   | ZAUBER_TEST

	SEEDS_SOWN_5_ZAUB
	DIALOG | P_NAME    | Hey, what's the haps, paps? You see all these seeds I have? I bet you don't because I don't have any. I've sown all of them.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | Gerz-Nutz | Superb! `w1`Muahahahaha!`w0`
	DIALOG | P_NAME    | So uh... You said something about a reward if I recall correctly.
	DIALOG | Gerz-Nutz | Yes! You have served me well! Here! This is now yours!
	USEAT  | o_growthElemental01
	NOTIFY | Found Gorm-Stone!
	ITEM   | Gorm-Stone | 1
	DIALOG | P_NAME    | Oh. Uh... I don't mean to be rude but this looks like a piece of junk.
	DIALOG | Gerz-Nutz | Hah! It may appear like just some plain rock with a bit of paint on it, but nothing could be further from the truth!
	DIALOG | P_NAME    | Okay. If you say so...
	DIALOG | Gerz-Nutz | I see you remain unconvinced. Very well. I urge you to keep it with you, as unremarkable as it may appear to you. There will come a day when you will know it's true value.
	DIALOG | P_NAME    | Can't you just say what it's supposed to be?
	DIALOG | Gerz-Nutz | Words can never explain it's `w1`majesty.`w0` Now begone! I must resume my meditation now that my `kw`sphere of influence`rt` has grown, thanks to you. Soon my powers will be restored and I will be free of this wretched dungeon. `w1`Muahahahaha!`w0`
	DIALOG | P_NAME    | Yeah, whatever. Smell ya later.
	WAIT   | 0.25
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3
	QUEST  | growthElemental = 2

	ELEMENTAL_0
	DIALOG | P_NAME    | (Huh?... What is this thing?)
	WAIT   | 0.5
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	WAIT   | 1.00
	EVENT  | o_growthElemental01 | 2
	DIALOG | Disgusting Plant | Greeting's traveler! Welcome to Gerz-Nutz's lair! 
	WAIT   | 0.2
	Emote  | !
	SURPRISEAT | o_growthElemental01
	WAIT   | 0.2
	DIALOG | P_NAME    | W-what?! It talked!
	WAIT   | 0.25
	DIALOG | Gerz-Nutz | Be not spooked, I am your friend, `kw`Gerz-Nutz the Growth Elemental.`rt`
	LOOKAT | o_cts_hoopz | o_growthElemental01
	DIALOG | P_NAME    | Now I've seen everything...
	WAIT   | 0.25
	DIALOG | Gerz-Nutz | I see you are somewhat surprised and disgusted by my appearance. Would you like to chew on some of my leaves to calm your nerves? They are full of vitamins and fiber.
	DIALOG | P_NAME    | N-no thanks. I think I have to go now.
	DIALOG | Gerz-Nutz | Wait! Hold on for a moment! You need not be afraid of me! I'm just your friendly neighbourhood zaubermancer.
	DIALOG | P_NAME    | Look, I don't mean to be rude but I've got things to do, people to see.
	DIALOG | Gerz-Nutz | Ah, such stressful life you must live. How can you ever hope to harness the power of the zaubers if you don't chill out every now and then?
	DIALOG | P_NAME    | Z-zaubers?
	QUEST  | growthElemental = 1
	GOTO   | ZAUBER_CHOICE

	ZAUBER_CHOICE
	CHOICE | Should I ask something about zaubers?
	REPLY  | ZAUBER_MANCER | You are a zaubermancer?
	REPLY  | ZAUBER_WHAT   | What are zaubers?
	REPLY  | ZAUBER_DOWN   | What are you doing down here?
	IF growthElementalQuest == 0 | REPLY | ZAUBER_GIVE | Can you give me a zauber?
	REPLY  | ZAUBER_DANGER | Are zaubers dangerous?
	REPLY  | ZAUBER_LEAVE  | I gots to go...

	ZAUBER_MANCER
	DIALOG | P_NAME    | You said you are a `kw`zaubermancer.`rt` What does that mean?
	DIALOG | Gerz-Nutz | Ah, a curious mind, I see. A zaubermancer, like me, is someone who has delved deep into the world of zaubers. We have studied the zaubers and lusted after them. We've grasped their power for ourselves and brasted great hexes upon our enemies.
	DIALOG | P_NAME    | Whoa, cool beans, dude.
	DIALOG | Gerz-Nutz | There's much one can learn from the zaubers... and from zaubermancers. `w1`*Wink*`w0`
	DIALOG | P_NAME    | O-oh... `w1`*Blush*`w0`
	GOTO   | ZAUBER_CHOICE

	ZAUBER_WHAT
	DIALOG | P_NAME    | Zaubers, huh? What are zaubers?
	DIALOG | Gerz-Nutz | Zaubers are the manifestation of the knowledge and wisdom of `sq`the Ancients.`rt` They resemble mystical orbs or globes that glow in the dark, and in the dank. 
	DIALOG | P_NAME    | What? Now you are just making stuff up.
	DIALOG | Gerz-Nutz | I kid you not! After `sq`the Ancients`rt` pass on their spirits are seperated from their corporeal forms. In time these spirits and all the knowledge they possess crystallize into zaubers, which are then eventually discovered by us, the zaubermancers. We then draw out their power and wisdom and take it for ourselves. Some use this power for good, others for evil...
	GOTO   | ZAUBER_CHOICE

	ZAUBER_DOWN
	DIALOG | P_NAME    | What the flip are you doing down here?
	DIALOG | Gerz-Nutz | Me? Why, this is my home. This has been my home for centuries. Ever since I overloaded myself with the powers of the `sq`Jello Zauber`rt` and mutated into a plant I have hanged around here, meditating. Pondering the many facets of the universe, and guiding goofy dwarfs to greener pastures.
	GOTO   | ZAUBER_CHOICE

	ZAUBER_GIVE
	DIALOG | P_NAME    | Can you give me a zauber?
	DIALOG | Gerz-Nutz | Ah, I see you too are drawn to their immense power. Yes... perhaps in time you too will be a zaubermancer. But I can't simply give you a zauber. That is not how it works, my young friend. Zaubers must be earned.
	DIALOG | P_NAME    | Aww shucks, another dumb errand, huh?
	DIALOG | Gerz-Nutz | Patience, my child. Patience. I only ask that you take those `sq`seeds in that barrel`rt` and sow them here, in the `sq`first floor of the sewers.`rt`
	DIALOG | P_NAME    | What? Are you out of your flippin' gourd? 
	DIALOG | Gerz-Nutz | No, not at all. There are many `sq`fertile spots down here`rt` that you can use to sow the seeds. All you have to do is find them. 
	DIALOG | P_NAME    | I don't think these things will really flourish in a sewer.
	DIALOG | Gerz-Nutz | You are mistaken! They will flourish, I have foreseen it! Sow as many of those seeds as you can and then return to me for your reward...
	CHOICE | Accept the quest?
	REPLY  | SOW_ACCEPT  | Yay.
	REPLY  | SOW_DECLINE | Nay.

	ZAUBER_DANGER
	DIALOG | P_NAME    | So are zaubers dangerous? It looks to me like they've done a number on you.
	DIALOG | Gerz-Nutz | Yes, indeed they have. `sq`The Elders`rt` warned me of the corrupting power of the zaubers, but I did not listen. My unsatiable lust for power turned me into what you see before you today.
	DIALOG | P_NAME    | Whoa... I'd better steer clear from zaubers.
	DIALOG | Gerz-Nutz | No, that is not true! Too much of a good thing can destroy you but if you tread with care, you will be safe. I did not realize the warning signs until it was too late. With every Magick spell thrown from my magick wand my `kw`GLAMP deteriorated.`rt` I grew weaker and weaker when my goal was to become stronger. Heh, you see the irony, yes?
	DIALOG | P_NAME    | Look, I appreciate the warning but if using zaubers turns you into a shrubbery then I don't want to go anywhere near them.  
	DIALOG | Gerz-Nutz | I can tell you are wise beyond your years, youngster. But you need not be alarmed by the power of the zaubers. `kw`Each time you tap into their power your GLAMP gets demolished,`rt` that is true, but this effect is `kw`only temporary.`rt` Use zaubers sparingly, and no harm will come to you.
	DIALOG | P_NAME    | Hmm... Very interesting...

	ZAUBER_LEAVE
	DIALOG | P_NAME    | I gots to go now.
	DIALOG | Gerz-Nutz | Alright! Be safe, youngster!
	PLAYSET | o_growthElemental01 | retreat | default
	WAIT   | 1
	EVENT  | o_growthElemental01 | 3

	ELEMENTAL_1
	DIALOG | P_NAME    | Hey, what's up?
	WAIT   | 0.5
	PLAYSET | o_growthElemental01 | spook | talk
	WAIT   | 0.25
	SOUND   | sn_plantanspawn01
	EVENT  | o_growthElemental01 | 2
	DIALOG | Gerz-Nutz | Ah, you have returned! No doubt you seek my wisdom, yes?
	GOTO   | ZAUBER_CHOICE

	ELEMENTAL_2
	DIALOG | P_NAME    | Hmm... Looks like this guy is in some sort of a trance... What a weirdo.

	SOW_ACCEPT
	DIALOG | P_NAME    | I guess I could sow your seeds.
	DIALOG | Gerz-Nutz | Good! Very good! Sow as many of them as you can and then return here. You will not regret this...
	QUEST  | growthElementalQuest = 1
	GOTO   | ZAUBER_CHOICE

	SOW_DECLINE
	DIALOG | P_NAME    | Uh, I'll think about it.
	GOTO   | ZAUBER_CHOICE

	ZAUBER_TEST
	WAIT   | 1.5
	MYSTERY | | `mq`Do you wish to participate in Zauber Practice?`rt`
	QUEST  | NoChoicePortrait = 1
	CHOICE | Do some Zauber Practice?
	REPLY  | ZAUBER_PRACTICE_YAY | Yes!
	REPLY  | ZAUBER_PRACTICE_NAY | Nah...

	ZAUBER_PRACTICE_YAY
	QUEST  | NoChoicePortrait = 0
	EVENT  | o_growthElemental01 | 1
	FADE   | 1 | 1
	WAIT   | 1
	Teleport | r_combat_tutorial01 | 400 | 240 | 1

	ZAUBER_PRACTICE_NAY
	QUEST  | NoChoicePortrait = 0
	EXIT   |" % [zauber_got,zauber_got,zauber_got]
	scr.original_script = my_script
	cutscene_script = scr

func execute_event_user_0() -> void:
	B2_Zauber.gain_zauber("bio0")

func execute_event_user_1() -> void:
	#/// Get the zauber room return location 
	#global.zauberRoomName = room;
	#global.zauberRoomX = o_cts_hoopz.x;
	#global.zauberRoomY = o_cts_hoopz.y;
	pass

func execute_event_user_2() -> void:
	audio_stream_player_2d.stop()
	
func execute_event_user_3() -> void:
	await get_tree().create_timer(1).timeout
	audio_stream_player_2d.play()
