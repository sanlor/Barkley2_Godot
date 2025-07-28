extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	##Plantation Script
	if get_room_area() == "sw1":
		if B2_Playerdata.Quest("prisonArrested") >= 1: queue_free()
		elif B2_Playerdata.Quest("stahlState") == 5: queue_free()
		else: _load_sewer_script()
		ActorAnim.animation = "sewer"

	## Hoosegow Scripts
	elif get_room_area() == "pri":
		if B2_Playerdata.Quest("prisonIntro") == 2: queue_free()
		elif B2_Playerdata.Quest("prisonEnding") >= 1: queue_free()
		else: _load_prison_script()
		ActorAnim.animation = "default"
	
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
	#ActorAnim.animation 					= "default"

## Meeting Stahl in the Plantation
func _load_sewer_script() -> void:
	## Variables
	# stahlState
		#0 - not talked
		#1 - you answered both questions wrong, wait 30 to get state 2
		#2 - stahl admires your persistence and lets you ask questions
		#3 - you answered one question right and can ask questions
		#4 - exhausted questions, repeating dialog, will disappear in 30 minutes
		#5 - disappeared
	# stahlGuns
		#0 - nothing
		#1 - the gun's salesman now gives you a better list of gun's
	var script_text := \
	#region long ass text
	"IF stahlName == 0  | QUEST | stahlName = ? ? ?
	IF bossBabby >= 1  | IF gordoState == 2 | GOTO | HUDDLE
	IF stahlState == 5 | GOTO | STAHL05
	IF stahlState == 4 | GOTO | STAHL04
	IF stahlState == 3 | GOTO | STAHL03
	IF stahlState == 2 | GOTO | STAHL02
	IF stahlState == 1 | GOTO | STAHL01
	IF stahlState == 0 | GOTO | STAHL00

	STAHL00
	DIALOG | @stahlName@ = s_port_stahl | It's not polite to stare.
	QUEST  | stahlBotch = 0
	CHOICE | What do you say?
	REPLY  | STARE_NO  | I'm not staring at you.
	REPLY  | STARE_YES | You're the one staring at me!

	STARE_NO
	QUEST  | stahlBotch += 1
	DIALOG | P_NAME | I'm not staring at you.
	WAIT   | 1.0
	DIALOG | @stahlName@ = s_port_stahl | Really? You're the only person here that's looked at me-_actually stopped to find out more. Most dwarfs just pass me by. You must know something they don't.
	GOTO   | STARE_FIRST

	STARE_YES
	DIALOG | P_NAME | You're the one staring at me!
	WAIT   | 1.0
	DIALOG | @stahlName@ = s_port_stahl | Heh. You're the only person here that's looked at me-_actually stopped to find out more. Most dwarfs just pass me by. You must know something they don't.
	GOTO   | STARE_FIRST

	STARE_FIRST
	DIALOG | P_NAME | Uh, not really. I have amnesia...
	DIALOG | @stahlName@ = s_port_stahl | Doubtful. Come clean, who do you work for?
	CHOICE | Who do you work for?
	REPLY  | DONTKNOW | I have no idea what you are talking about.
	REPLY  | WORKFORME | I'm my own boss.

	DONTKNOW
	QUEST  | stahlBotch += 1
	DIALOG | P_NAME | I don't know what you're talking about.
	IF stahlBotch >= 2 | GOTO | CLUELESS
	DIALOG | @stahlName@ = s_port_stahl | You don't know, huh?_ Doesn't matter. You're probably going to turn up dead anyway.
	GOTO   | STARE_SECOND

	WORKFORME
	DIALOG | P_NAME = s_port_hoopzAngry | I work for three people. Me. Myself. And none of your beeswax.
	DIALOG | @stahlName@ = s_port_stahl | Vigilante, huh?_ Me likey._ You're probably going to turn up dead, but it's nice to see someone plotting their own course out here at the red line of the universe.
	GOTO   | STARE_SECOND

	STARE_SECOND
	DIALOG | P_NAME | What about you?
	DIALOG | @stahlName@ = s_port_stahl | What about me?
	QUEST  | stahlState = 3
	GOTO   | STAHLQUESTIONS

	CLUELESS
	DIALOG | @stahlName@ = s_port_stahl | You really are clueless. Now scram.
	QUEST  | stahlState = 1
	ClockTime | event | stahlState | 2 | 30

	STAHL01
	DIALOG | @stahlName@ = s_port_stahl | Give me some space for a moment, will ya?

	STAHL02
	DIALOG | @stahlName@ = s_port_stahl | You're persistent. I give you that. What do you want?
	GOTO   | STAHLQUESTIONS

	STAHL03
	DIALOG | @stahlName@ = s_port_stahl | What is it?
	GOTO   | STAHLQUESTIONS

	STAHL04
	DIALOG | @stahlName@ = s_port_stahl | See you around...

	HUDDLE
	DIALOG | @stahlName@ = s_port_stahl | ...

	STAHLQUESTIONS
	CHOICE | What do you want to know?
	IF butterBarrelState == 0 | REPLY | BARREL00 | What's with the barrel?
	IF butterBarrelState == 1 | REPLY | BARREL01 | Do you work on the Butter Barrel?
	IF stahlWho == 0 | REPLY | WHOISSTAHL | Who are you?
	IF stahlGordo == 0 | IF gordoState >= 1 | REPLY | STAHLWORKGORDO | Do you work for the master of this plantation?
	IF stahlGordo == 1 | IF stahlSlave == 0 | REPLY | NOTASLAVE | So you aren't a slave?
	IF stahlCuchu == 0 | IF stahlGordo == 1 | REPLY | STAHLWORKFORCUCHU | So you work for Cuchulainn?
	IF stahlCuhu == 1 | REPLY | CANIHELP | Can I help you?
	REPLY | NARYYEMIND | Nary ye mind.

	BARRELINFO
	DIALOG | P_NAME | What happens with the butter exactly?
	DIALOG | @stahlName@ = s_port_stahl | Well they just dump in the tubers (minus all `mq`Garlics`rt`) and then wait FIVE minutes. Then it's down to Gordo with the `kw`butter`rt` and Clispaeth alone knows what they do with it.
	QUEST  | butterBarrelState = 2
	QUEST  | knowGarlics += 1
	GOTO   | STAHLQUESTIONS

	BARREL01
	DIALOG | P_NAME | Do you work on the Butter Barrel?
	DIALOG | @stahlName@ = s_port_stahl | Ha, Clispaeth no... I am just here because this gas mask works susrprisingly well and it's obvious your nose doesn't.
	DIALOG | P_NAME | Yeah, I'm tearing up actually.
	GOTO   | STAHLQUESTIONS

	BARREL00
	DIALOG | P_NAME | What is this barrel here?
	DIALOG | @stahlName@ = s_port_stahl | Disgusting huh? They make butter in it... butter from sewer water and tubers. Don't ask me why.
	DIALOG | P_NAME | Ewww, that doesn't even make any sense.
	DIALOG | @stahlName@ = s_port_stahl | You're telling me.
	GOTO   | BARRELINFO

	WHOISSTAHL
	DIALOG | P_NAME | So who are you? You seem different from everybody else I've met.
	DIALOG | @stahlName@ = s_port_stahl | Just an observer, paid to keep an eye on things. Call me._._._ Stahl.
	QUEST  | stahlName = Stahl
	QUEST  | stahlWho = 1
	KNOW   | knowStahl | 1
	GOTO   | STAHLQUESTIONS

	NOTASLAVE
	DIALOG | P_NAME | So you're in disguise? You're not really a slave?
	DIALOG | @stahlName@ = s_port_stahl | The only thing that can truly enslave a dwarf is their own inaction. And to answer your question, no, I'm not really a slave. I'm just laying low here for a while so I can collect information.
	QUEST  | stahlSlave = 1
	GOTO   | STAHLQUESTIONS

	STAHLWORKGORDO
	DIALOG | P_NAME | Do you work under the master of this plantation?
	DIALOG | @stahlName@ = s_port_stahl | Hah! Don't make me laugh. I wouldn't be under Gordo's employ no matter what the shekels. The last thing that found itself under that fat freak was that poor chair.
	QUEST  | stahlGordo = 1
	GOTO   | STAHLQUESTIONS

	STAHLWORKFORCUCHU
	DIALOG | P_NAME | So you work for Cuchulainn?
	DIALOG | @stahlName@ = s_port_stahl | Definitely not. A lot of people around the neighboring galaxies are pretty interested in figuring out what's really going on here. Some say Cuchu's gone off his rocker. Others say it's a ploy and he's up to his old tricks.
	DIALOG | P_NAME | Are others are coming to help? There are a lot of things wrong with this place.
	DIALOG | @stahlName@ = s_port_stahl | Don't count on it. There are no good guys left anymore. It's all about money and risk now and there's not of the former around here. Dwarfs are dwarfs, and I'm not ready to start flooding the home office with reports that we can commoditize them. As for the risk, you're about the brightest person I've spoken to on this floating toilet, so I've had stamp this place as: `w1`/'Not worth our time./'`w0`
	WAIT   | 1.0
	DIALOG | @stahlName@ = s_port_stahl | Of course, I don't know everything there is to know about this place yet. It's probably just a bad assignment.
	QUEST  | stahlCuchu = 1
	GOTO   | STAHLQUESTIONS

	CANIHELP
	IF hoopzGumshoe >= 1 | GOTO | GUMSHOE
	DIALOG | P_NAME | So should I let you know if I see anything serious? Maybe something that could get other galaxies to come and help?
	DIALOG | @stahlName@ = s_port_stahl | You're serious about this, aren't you?_
	GOTO   | HELP_CONT

	GUMSHOE
	DIALOG | P_NAME      | Is there anything I can do to help? I am a `kw`GUMSHOE LEVEL ONE`rt` already!
	DIALOG | @stahlName@ = s_port_stahl | Yeah, yeah, I've heard that song and dance before. Private Investigations. Let me tell you, the only thing that needs to be investigated is a Dwarf with too much money for his own good.
	DIALOG | P_NAME      | What are you saying?
	DIALOG | @stahlName@ = s_port_stahl = s_port_stahl | Not saying anything, just watching...
	GOTO   | HELP_CONT

	HELP_CONT
	DIALOG | @stahlName@ = s_port_stahl | Tell you what, you go out and keep trying to make sense of this place. Try to_ /'prod the Cybergremlin's Nest/' as they say. I'll be watching.
	DIALOG | P_NAME      | Do you mean I should get into trouble?
	DIALOG | @stahlName@ = s_port_stahl | Trouble seems to follow you around already, P_NAME. I don't think you needed me to tell you this. If it helps, tell Redfield the Gun'ssalesman that Stahl said to show him the good stuff... he'll hook you up.
	DIALOG | P_NAME = s_port_hoopzHappy | Wow thanks, Stahl! I could always use an upgrade to my brasting!
	QUEST  | stahlGuns = 1
	DIALOG | @stahlName@ = s_port_stahl | That's enough for now, I'll see you around.
	QUEST  | stahlState = 4
	ClockTime | event | stahlState | 5 | 30

	NARYYEMIND
	DIALOG | P_NAME | Nary ye mind. I'm out of here.
	DIALOG | @stahlName@ = s_port_stahl | Alright."
	#endregion
	var scr := B2_Script_Legacy.new()
	scr.original_script = script_text
	cutscene_script = scr
	
## Stahl in the Hoosegow
func _load_prison_script() -> void:
	##VARIABLES
	# stahlPrison
		#0 = haven't talked to Stahl in the Prison
		#1 = have talked, but haven't guessed her identity
		#2 = talked and guessed once incorrectly
		#3 = talked and guessed twice incorrectly
		#4 = talked and guessed thrice (you've failed)
		#5 = you've guess Stahl correctly
	# TODO: there isn't any real TIME ANCHORS in this choice right now... we'll need to modify once we know how time progression in the prison works.
	var script_text := \
	#region Long ass text
	"MOVETO | o_cts_hoopz | o_cinema29 | MOVE_NORMAL
	WAIT   | 0
	LOOK   | o_cts_hoopz | WEST
	IF toggleStahlStall == 1 | GOTO | LOOPINGSTALL
	IF stahlPrison == 5 | GOTO | REPEATINSTRUCTIONS
	IF stahlPrison == 4 | GOTO | FAILURE
	IF stahlPrison == 3 | GOTO | THIRDTRY
	IF stahlPrison == 2 | GOTO | SECONDTRY
	IF stahlPrison == 1 | GOTO | FOLLOWUP
	IF knowStahl >= 1 | GOTO | FIRSTMEET
	IF stahlPrison == 0 | GOTO | FUCK_YOU

	FUCK_YOU
	DIALOG | ? ? ? = s_port_stahlJail | Heh...

	THIRDTRY
	DIALOG | ? ? ? = s_port_stahlJail | Back again?
	DIALOG | P_NAME | Alright, this time I've got you pegged. Get ready to have your mask ripped off!
	DIALOG | ? ? ? = s_port_stahlJail | ... alright then... hazard a guess?
	CHOICE | Hazard a guess?
	REPLY  | LEMMEGUESS | I'm gonna doxxx the roof off this joint!
	REPLY  | AINTGOTTIME02 | This is the last I'll deal with this Goof Troop bullpuck.

	SECONDTRY
	DIALOG | ? ? ? = s_port_stahlJail | How goes it, P_NAME_S?
	DIALOG | P_NAME | Think I could try to `sq`guess your identity again?`rt`
	DIALOG | ? ? ? = s_port_stahlJail | Alright, but you're gonna have to make this one count. Ready?
	CHOICE | Play the game?
	REPLY  | LEMMEGUESS | Time to cut to the chase and tell me who you are.
	REPLY  | AINTGOTTIME02 | Actually, I ain't got time for this Goof Troop bullpuck.

	LOOPINGSTALL
	DIALOG | ? ? ? = s_port_stahlJail | Come back `sq`after you get some rest and come up with a better guess.`rt`
	EXIT |

	FIRSTMEET
	DIALOG | ? ? ? = s_port_stahlJail | Looks like you've gotten yourself into a tight spot, P_NAME_S. Not unlike the last time we spoke.
	DIALOG | P_NAME | Oh hey, um...
	DIALOG | P_NAME = s_port_hoopzSurprise | Wait! How do you know my name?
	DIALOG | ? ? ? = s_port_stahlJail | What do you mean? You don't remember me? We've certainly met.
	DIALOG | P_NAME | Uh, we have? I think I'd remember meeting you.
	DIALOG | ? ? ? = s_port_stahlJail | What's that supposed to mean?_ I'm hurt, P_NAME_S, I really am. Here I was spillin' my guts to you just a few hours earlier, and now you don't have the decency to remember me? Hmmpf_ you think you know someone...
	QUEST  | stahlPrison = 1
	CHOICE | Reply to the mystery madame?
	REPLY  | WHOAREYOU | Play time has transpired, proclaim thine identity!
	REPLY  | AINTGOTTIME01 | I ain't got time for this Goof Troop bullpuck.

	AINTGOTTIME01
	DIALOG | P_NAME | Look, whoever you are, I've got hard time to serve and can't be playin' games. See you in_ `w1`the yard.`w0`
	DIALOG | ? ? ? = s_port_stahlJail | Heh, sure thing kid... I thought you'd want to know how to get out of here early on_ `sq`bad behavior.`rt`_ Doesn't look like it though. See you around.
	WAIT   | 0.4
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.4
	DIALOG | P_NAME = s_port_hoopzSurprise | (I wonder what_ `sq`bad behavior`rt` means...)
	EXIT |

	AINTGOTTIME02
	DIALOG | P_NAME | Nary ye mind. Gotta run, weirdo.
	DIALOG | ? ? ? = s_port_stahlJail | Suit yourself.
	EXIT |

	FOLLOWUP 
	FOLLOWUP 
	DIALOG | ? ? ? = s_port_stahlJail | Well, well the pwnable son returns. What is it?
	DIALOG | P_NAME | Alright, I've been thinking about what you said about `sq`getting out of here early.`rt`
	DIALOG | ? ? ? = s_port_stahlJail | Wanna play my game? See if you can guess who I am.
	CHOICE | Play the game?
	REPLY | WHOAREYOU | Time to cut to the chase and tell me who you are.
	REPLY | AINTGOTTIME02 | I STILL ain't got time for this Goof Troop bullpuck.

	WHOAREYOU
	DIALOG   | P_NAME = s_port_hoopzAngry | Alright, cut the bunk, who are you? And how do you know me?
	DIALOG   | ? ? ? = s_port_stahlJail | Not so fast, P_NAME_S. Information is shekels and shekels are `s1`power`s0`. There is no such thing as a free lunch in this parsec of the galaxy._ If you want me to_ `sq`refresh your memory,`rt` you'll need to pay up. 
	BREAKOUT | add | money
	DIALOG   | P_NAME = s_port_hoopzAngry | Oh yeah? How much?
	DIALOG   | ? ? ? = s_port_stahlJail | No no... shekels may be power, but I'm more interested in the former: `w1`INFORMATION.`w0` Tell you what, `sq`let's play a game. `sq`If you can figure out who I am, I'll tell you how to get out of here T_O_D_A_Y.`rt`
	BREAKOUT | clear
	DIALOG | P_NAME = s_port_hoopzSurprise | Really?
	DIALOG | ? ? ? = s_port_stahlJail | Whattya say, P_NAME_S?
	WAIT   | 0.4
	LOOK   | o_cts_hoopz | SOUTH
	WAIT   | 0.4
	DIALOG | P_NAME | (Hmmm... think, P_NAME_S._ Who have I met that I couldn't see their face? Someone... `w1``sq`with a mask?`rt``w0`)
	WAIT   | 0.4
	LOOK   | o_cts_hoopz | NORTH
	WAIT   | 0.4
	GOTO   | LEMMEGUESS

	LEMMEGUESS
	REPLY | P_NAME | Alright... let me_ hazard a guess.
	GOTO | IDENTITYCHOICE

	IDENTITYCHOICE
	CHOICE | Guess who she is?
	//TODO: add additional 'faceless' characters we find throughout the game
	IF puttyState >= 1       | REPLY | YOUAREPUTTY     | You are Putty from the plantation!
	IF etenLijmState >= 1    | REPLY | YOUAREETEN      | I think you are Eten-Lijm, the plantation guy!
	IF gruftState >= 1       | REPLY | YOUAREGRUFT     | You must be Gruft, the slave!
	IF stahlDuergar == 0     | REPLY | YOUREADUERGAR   | You can't fool me, Duergar!
	IF stahlBolthios == 0    | REPLY | YOUREBOLTHIOS   | You're the bandaged prisoner who gave me these smokes! Bolthios!
	IF knowStahl >= 1         | REPLY | YOURESTAHL      | You're Stahl, from the plantation!
	IF stahlRedfield == 0    | IF knowRedfield >= 2    | REPLY | YOUREREDFIELD | You're Redfield, the gun'ssalesman!
	IF knowBagler >= 2       | REPLY | YOUREBAGLER     | You're Bagler, from the Gamer's Tabernacle!
	IF stahlDarchimedes == 0 | IF knowDarchimedes != 0 | IF knowDarchimedes != 4 | REPLY | YOUREDARCHIMEDES | You're D'archimedes from the Gaming Klatch!

	YOUREDARCHIMEDES
	DIALOG | P_NAME s_port_hoopzSmirk | I don't know how you can jump around so quickly but it's painfully obvious that you are D'archimedes! Now cast of that mask!
	DIALOG | Stahl = s_port_stahlJail | Good Klisp in heaven and all that is holy in the Sombrero Galaxy._ Of course I'm not D'archimedes. `s1`He's inside the prison isn't he?!`s1`
	DIALOG | P_NAME = s_port_hoopzSad | Well,_ I,_ ugh... thought maybe you could move pretty fast and be in two pla-
	DIALOG | Stahl = s_port_stahlJail | Let me stop you right there before you hurt yourself. Go lay down and think this over for a second. I am having reservations about playing this game with you, P_NAME_S, your dimness concerns me.
	DIALOG | P_NAME = s_port_hoopzSad | Aww,_ shucks.
	DIALOG | ? ? ? = s_port_stahlJail | Give me some time to recover from that devastating show of mental aptitude. `sq`Come back in an hour when you have something less insulting.`rt`
	DIALOG | P_NAME = s_port_hoopzSad | Daggit... if you say so.
	QUEST | stahlPrison += 1
	QUEST | stahlDarchimedes = 1
	QUEST | toggleStahlStall = 1
	IF stahlPrison == 4 | GOTO | FAILURE
	EXIT |

	YOUREADUERGAR
	DIALOG | P_NAME = s_port_hoopzAngry | I don't know what your angle is, but I can smell a Duergar from a mile away. You're not trickin' me, blueskin!
	DIALOG | ? ? ? = s_port_stahlJail | What?_ `w2`Ha ha ha!`w0` You think I'm a Duergar?! What is wrong with you?_ `sq`I'm no Duergar.`rt`
	DIALOG | P_NAME = s_port_hoopzSad | Dag-fraggit... I thought I had you dead-to-rights.
	DIALOG | ? ? ? = s_port_stahlJail | More like dead-to-wrong, plus Duergars are blue last time I checked-_ and all the other times I checked before that.
	DIALOG | P_NAME = s_port_hoopzSad | Yeah,_ I guess that's true.
	DIALOG | ? ? ? = s_port_stahlJail | Look, I've got other things to get done here, P_NAME_S. Things like not getting insulted by half-cocked guesses from young brasters. Maybe `sq`come back in an hour and see if you can give it another shot.`rt`
	DIALOG | P_NAME | Oh,_ okay. I guess I'll be back soon.
	DIALOG | ? ? ? = s_port_stahlJail | See you then._._._ a Duergar-_ HA!
	QUEST | stahlPrison += 1
	QUEST | stahlDuergar = 1
	QUEST | toggleStahlStall = 1
	IF stahlPrison == 4 | GOTO | FAILURE
	EXIT |

	YOUREBOLTHIOS
	DIALOG | P_NAME = s_port_hoopzSmirk | I can see through your guise. You are Bolthios! This is some kind of scam. What's your angle?
	DIALOG | ? ? ? = s_port_stahlJail | A clever deduction, however painstakingly ignorant it might be.
	WAIT | 0.5
	DIALOG | P_NAME = s_port_hoopzSurprise | Wait,_ so you aren't Bolthios?
	DIALOG | ? ? ? = s_port_stahlJail | Of course I'm not. You haven't been paying attention at all.
	DIALOG | P_NAME | Uh, well... that wasn't my final answer.
	DIALOG | ? ? ? = s_port_stahlJail | It was for now. `sq`Come back in an hour and maybe we'll see if you can get your head out of your ass and make an educated guess.`rt`
	DIALOG | P_NAME = s_port_hoopzSad| Durn it...
	QUEST | stahlPrison += 1
	QUEST | stahlBolthios = 1
	QUEST | toggleStahlStall = 1
	IF stahlPrison == 4 | GOTO | FAILURE
	EXIT |

	YOUREREDFIELD
	DIALOG | P_NAME = s_port_hoopzSmirk | The jig is up, Redfield. I know that you've been following me for a while to push your hardware, I just didn't know you'd go so far as to get incarcerated to get to your_ `w1`best customer.`w0`
	DIALOG | ? ? ? = s_port_stahlJail | Redfield, eh? Do you honestly think I'm that brast-peddlin' buffoon.
	DIALOG | P_NAME = s_port_hoopzSurprise | Wait so,_ that's not you? You aren't the Gun'ssalesman?
	DIALOG | ? ? ? = s_port_stahlJail | Not only am I not him `sq`but I told you to go talk to him before!_`rt` I tell ya, you've gotta work on your deduction skills. Redfield is only in it for the coin, and do I need to explain again that I'm all about the_ `w1`INFORMATION?`w0`
	DIALOG | P_NAME = s_port_hoopzSad | Aww shoot, totally thought something else...
	WAIT | 0.5
	DIALOG | P_NAME | You gotta gimme another shot! 
	DIALOG | ? ? ? = s_port_stahlJail | Another shot? With how off you were and the last one, I'm not so sure that's wise..._ Tell you what `sq`come back in an hour and I'll give you another shot`rt`
	DIALOG | P_NAME = s_port_hoopzSad | I guess I have no choice...
	DIALOG | ? ? ? = s_port_stahlJail | That's right, you don't. Now go brush up on your facts and maybe you won't embarass yourself come the morning.
	QUEST | stahlPrison += 1
	QUEST | stahlRedfield = 1
	QUEST | toggleStahlStall = 1
	IF stahlPrison == 4 | GOTO | FAILURE
	EXIT |

	YOUREBAGLER
	DIALOG | P_NAME | Come clean, Bagler! I know it's you!
	DIALOG | ? ? ? = s_port_stahlJail | Who the hell is Bagler?
	WAIT | 0.25
	EMOTE | ? | o_cts_hoopz | 0 | 0
	DIALOG | P_NAME | Uh..._ you're not Bagler?
	DIALOG | ? ? ? = s_port_stahlJail | Of course I'm not. Who calls themselves /'Bagler?/'
	DIALOG | P_NAME | Well, there is this dwarf I met in the Gamer's Tab-
	DIALOG | ? ? ? = s_port_stahlJail | That camp of nincompoopery is an insult to the word `w1`INTELLIGENCE.`w0` How in Necron 7 did you think that I could be one of those dummies?
	DIALOG | P_NAME | Well, I just was connecting the dots.
	DIALOG | ? ? ? = s_port_stahlJail | Which dots were those? You should probably get checked for a concussion.
	DIALOG | P_NAME = s_port_hoopzSad | Yeah,_ I'm sorry.
	DIALOG | ? ? ? = s_port_stahlJail | `sq`Come back in an hour and maybe you'll get another shot.`rt`
	DIALOG | P_NAME | An hour? What will I do until then?
	DIALOG | ? ? ? = s_port_stahlJail | I dunno... everydwarf here has gotten pretty good at passing the time. Why don't you give them a chat?
	DIALOG | P_NAME = s_port_hoopzSad | Hhmpf... fine.
	QUEST | stahlPrison += 1
	QUEST | stahlBagler = 1
	QUEST | toggleStahlStall = 1
	IF stahlPrison == 4 | GOTO | FAILURE
	EXIT | 

	YOURESTAHL
	DIALOG | P_NAME | I got it. You're Stahl from the plantation!
	WAIT |
	DIALOG | ? ? ? = s_port_stahlJail | Well, well, well. Looks like you have a brain on you after all, kid.
	DIALOG | P_NAME = s_port_hoopzHappy | Yeah?! I knew you were Stahl! 
	DIALOG | Stahl = s_port_stahlJail | It's not that difficult, I mean the clues were all there. Who else on Necron 7 speaks at my vocabulary level?
	DIALOG | P_NAME | Uh,_ you all kind of sound the same to me to be honest.
	DIALOG | Stahl = s_port_stahlJail | That's because we're all from the same Maker.
	DIALOG | P_NAME = s_port_hoopzSurprise | Uh,_ what? 
	DIALOG | Stahl = s_port_stahlJail | `sq`Our Lord and Savior Clispaeth,`rt` He gave His life so we could have ours.
	DIALOG | P_NAME | I didn't take you to be religious.
	DIALOG | Stahl = s_port_stahlJail | We all have to find our way somehow._ Now take this `s1`Military Grade M80`s0` and drop it down the terlet.
	DIALOG | P_NAME | The terlet?
	DIALOG | Stahl = s_port_stahlJail | Yeah, the terlet. `sq`Drop this thing in there and you'll have you'll have your way out of this place.`rt`
	USEAT | o_stahl01
	NOTIFY | Got the Military Grade M80
	ITEM | Military Grade M-80 | 1
	DIALOG | P_NAME = s_port_hoopzHappy | Gee whiz, a real M80... I've only read about these things in_ /'The Anarchist's Cookbook./'
	DIALOG | Stahl = s_port_stahlJail | Well now you have one in the palm of your hand.
	DIALOG | P_NAME | But I'm still confused about what to do.
	DIALOG | Stahl = s_port_stahlJail | Alright, look. See that room over there?
	FRAME | CAMERA_NORMAL | o_cts_hoopz | o_cinema9
	LOOKAT | o_cts_hoopz | o_cinema9
	WAIT | 0.25
	FRAME | CAMERA_FAST | o_cts_hoopz | o_stahl01
	LOOKAT | o_cts_hoopz | o_stahl01
	DIALOG | P_NAME | Yeah, what about it? Isn't that where the Warden went in before?
	DIALOG | Stahl = s_port_stahlJail | Yep. Inside is `sq`the control room`rt` for the whole prison. If you can get in there, you'll be able to open not only the cell doors, but the gate to the prison as well.
	DIALOG | P_NAME = s_port_hoopzHappy | And then I can get out of here..._ `w1`WE`w0` can get out of here!
	DIALOG | Stahl = s_port_stahlJail | Exactly.
	DIALOG | P_NAME | But how does the toilet factor in?
	DIALOG | Stahl = s_port_stahlJail | You'll see... `sq`just drop that charge into the prison terlet and the path will be obvious to you.`rt`
	DIALOG | P_NAME | Gee, thanks Stahl._ Uh, why are you helping me so much?
	DIALOG | Stahl = s_port_stahlJail | Let's just say `sq`I represent some_ `w1`vested interests.`w0` You've got a lot of fans out there in the galaxy, P_NAME_S._ `w1`GOOD_ LUCK,_ you'll need it.`w0`
	QUEST | stahlPrison = 5
	KNOW | knowStahl | 2
	EXIT |

	REPEATINSTRUCTIONS
	DIALOG | Stahl = s_port_stahlJail | What's the hold up, P_NAME_S? `sq`Get to the prison terlet and drop in the M80.`rt` It's the only way to get out of here.
	DIALOG | P_NAME = s_port_hoopzHappy | You got it, Stahl.
	EXIT |

	FAILURE
	DIALOG | ? ? ? = s_port_stahlJail | Looks like `sq`our time is up.`rt` You're gonna need to find another way out of this prison.
	DIALOG | P_NAME = s_port_hoopzSurprise | Wait, I have a `w1`real emergency!`w0` If I don't get out of here soon, it'll be_ really,_ `s1`really, REALLY BAD!`s0`
	DIALOG | ? ? ? = s_port_stahlJail | Not my problem anymore, so long."
	#endregion
	var scr := B2_Script_Legacy.new()
	scr.original_script = script_text
	cutscene_script = scr
