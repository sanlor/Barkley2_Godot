extends B2_InteractiveActor

@export var o_leftChair01 : B2_EnvironInteractive
@export var o_cinema7 : B2_CinemaSpot

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	ANIMATION_STAND 						= "s_drLiu"
	ANIMATION_SOUTH 						= " s_drLiuSE"
	ANIMATION_SOUTHEAST 					= " s_drLiuSE"
	ANIMATION_SOUTHWEST 					= " s_drLiuSE"
	ANIMATION_WEST 							= " s_drLiuSE"
	ANIMATION_NORTH 						= " s_drLiuNE"
	ANIMATION_NORTHEAST 					= " s_drLiuNE"
	ANIMATION_NORTHWEST 					= " s_drLiuNE"
	ANIMATION_EAST 							= " s_drLiuSE"
	ANIMATION_STAND_SPRITE_INDEX 			= [1, 1, 0, 0, 0, 0, 0, 1]
	ActorAnim.animation 					= "s_drLiu"
	
	#region Giant ass script
	
	if get_room_name() == "r_tnn_rebelbase02":
		var script := \
		"IF govQuest == 6          | GOTO | GOVQUEST_6
		IF body == governor       | GOTO | GOVERNOR
		IF govQuest == 3          | GOTO | GOVQUEST_3
		IF govQuest == 2          | GOTO | GOVQUEST_2
		IF govQuest == 1          | GOTO | GOVQUEST_1
		IF liuState == 1          | GOTO | DRLIU_1
		IF liuState == 0          | GOTO | DRLIU_0

		GOVQUEST_6
		IF longinusGov >= 1 | DIALOG | Dr. Liu | Well, P_NAME_S, not only did you pull it off, but you managed to make life in Tir na nOg just a little bit easier for the dwarfs. The policies you enacted are already underway, much to the disappointment of the Duergars, who were hoping for expanded torture routines. This was a victory for L.O.N.G.I.N.U.S. and it's thanks to you, P_NAME!
		IF longinusGov >= 1 | GOTO   | SNIP_QUESTION
		DIALOG | Dr. Liu | Why are you still hanging around? You got your freedom, go ahead and leave already!

		SNIP_QUESTION
		CHOICE | Tell me...
		IF govQuest == 3 | REPLY  | SNIP_URINE          | I've got the Duergar... stuff. // The very last snippet in this script
		// Post Governor
		IF govQuest == 6 | REPLY  | REPLY_WHERE_DWARF   | Any idea where The Cyberdwarf is?
		IF govQuest == 6 | REPLY  | REPLY_LEAVE         | So I guess I can just leave now?
		IF govQuest == 6 | REPLY  | REPLY_HELP_LONGINUS | Can I still help L.O.N.G.I.N.U.S.?
		IF govQuest == 6 | REPLY  | REPLY_GOVERNOR      | What are you going to do with the Governor?
		// Pre governor
		IF govQuest == 2 | REPLY  | REPLY_WHERE_URINE   | Where can I get Duergar urine?
		IF govQuest == 2 | REPLY  | REPLY_THE_PLAN      | What's the whole plan again?
		IF govQuest == 3 | REPLY  | REPLY_THE_PLAN      | What's the whole plan again?
		IF govQuest == 4 | REPLY  | REPLY_THE_PLAN      | What's the whole plan again?
		// Defaults
		REPLY  | REPLY_WHAT_LONGINUS  | Tell me about L.O.N.G.I.N.U.S.
		REPLY  | REPLY_WHO_CYBERDWARF | Tell me about The Cyberdwarf.
		REPLY  | REPLY_SEE_YA         | See ya.

		REPLY_WHERE_DWARF
		DIALOG | P_NAME  | So I guess I'm leaving now, but do you have any idea where I can find `mq`The Cyberdwarf?`rt`
		DIALOG | Dr. Liu | Well, I don't know. Like I told you earlier, we're a small, `kw`local branch of L.O.N.G.I.N.U.S.`rt` and don't really travel outside of the walls of Tir na nog. In fact, we get all our communication from home base through `kw`carrier rats`rt` and normally the paper is just eaten off. We're kinda flying blind here.
		WAIT   | 0.25
		DIALOG | Dr. Liu | All I know is that wherever `mq`The Cyberdwarf`rt` is, he's not here.
		QUEST  | cdwarfSearchGlobal = 2
		QUEST  | cdwarfSearchTNN = 5
		DIALOG | P_NAME  | Aww shucks...
		DIALOG | Dr. Liu | There are lots of L.O.N.G.I.N.U.S. members outside Tir na nOg though, and I'm sure they'll be able to help you better than I can.
		GOTO   | SNIP_QUESTION

		REPLY_LEAVE
		DIALOG | P_NAME  | So I guess I can just leave now?
		DIALOG | Dr. Liu | Right out the front gate. Remember to `sq`take the Secret Dossier to our contact in The Social.`rt` His location is marked on the map I gave you.
		GOTO   | SNIP_QUESTION

		REPLY_HELP_LONGINUS
		DIALOG | P_NAME  | Is there anything else I can do to help out L.O.N.G.I.N.U.S.?
		DIALOG | Dr. Liu | Not this chapter, unless Absalom wants help with something, but if you meet any L.O.N.G.I.N.U.S. in your travels outside of Tir na nOg, let them know you're on their side.
		GOTO   | SNIP_QUESTION

		REPLY_GOVERNOR
		DIALOG | P_NAME  | So uh, what are you going to do with the Governor now?
		DIALOG | Dr. Liu | Heh, I guess we kind of overlooked that part, huh? Well, I guess we'll keep him around and /'use/' him for as long as we think we can keep up the charade.
		DIALOG | Governor Elagabalus | Kiss my ass, `s1`turd fuckers!`s0`
		GOTO   | SNIP_QUESTION

		REPLY_WHERE_URINE
		DIALOG | P_NAME  | Where am I supposed to get that `kw`Duergar urine?`rt`
		DIALOG | Dr. Liu | Hmm, good question. I doubt shops sell it. I guess you'll have to `mq`try a Duergar`rt` or... you did just wade through a `mq`sewer`rt` to get here didn't you?
		DIALOG | P_NAME  | Oh you're right, thanks!
		GOTO   | SNIP_QUESTION

		REPLY_THE_PLAN
		DIALOG | P_NAME  | So what's the whole plan again? How is this supposed to work?
		DIALOG | Dr. Liu | Absalom and I built a body transference device that switches the bodies of the two subjects sitting in it. Our plan, `sq`Operation: Reverse Dunkirk,`rt` is to kidnap the incoming governor by attracting him with `kw`Duergar urine`rt` and then switching bodies with him. You'll then `sq`use the body to infiltrate the Governor's Mansion and steal back a Top Secret Dossier.`rt` With that dossier in hand, we'll be able to start `kw`PHASE TWO`rt` of the mission!
		DIALOG | P_NAME  | What if the Duergars ask me to do something as governor?
		DIALOG | Dr. Liu | To be a convincing governor, you'll have to act like one. `kw`Elagabalus`rt` is known for his ruthless and wanton persecution in the Hoosegow... I imagine the Duergars will be expecting a lot of that from him once he arrives.
		GOTO   | SNIP_QUESTION

		REPLY_WHAT_LONGINUS
		DIALOG | P_NAME  | So what's L.O.N.G.I.N.U.S. all about?
		DIALOG | Dr. Liu | Well, L.O.N.G.I.N.U.S. is about a lot of things. For some dwarfs, it's about fighting Cuchulainn. For others, it's about escaping from the Necron 7. For even more, it's about `kw`Pan-Dwarfism.`rt` But for all of us, it's about autonomy; Cuchulainn doesn't have the right to corral up all the dwarfs in the galaxy into this spaceship, whether or not he's going to give us all a fabulous prize. We just want to go back to the lives we used to have.
		GOTO   | SNIP_QUESTION

		REPLY_WHO_CYBERDWARF
		DIALOG | P_NAME  | Do you know anything about `mq`The Cyberdwarf?`rt` Who is he and where can I find him?
		DIALOG | Dr. Liu | All I know is what they teach you at Dwarf Orphan School. The Cyberdwarf is `kw`very wise`rt` and it's said that he's `kw`very old...`rt` maybe even as old as Cuchulainn. We're a small branch of L.O.N.G.I.N.U.S. and we're cut off from the main group, I don't really know much more and I couldn't tell you where he is. I know of a scout named `kw`Lafayette`rt` who could help... but he's tracking Duergar advancements along Gilbert's Peak.
		KNOW   | knowLafayette | 1
		KNOW   | knowGilbertsPeak | 1
		GOTO   | SNIP_QUESTION

		REPLY_SEE_YA
		IF govQuest == 6 | DIALOG | P_NAME  | It was interesting working with you all, Dr. Liu. I'll keep an eye out for L.O.N.G.I.N.U.S. outside of Tir na nOg. Take care.
		IF govQuest == 6 | DIALOG | Dr. Liu | You too! We'll be sure to put the Governor to good use!
		IF govQuest <= 5 | DIALOG | P_NAME  | Hey, I'll see ya later.
		IF govQuest <= 5 | DIALOG | Dr. Liu | Good luck, P_NAME_S!
		EXIT |

		GOVERNOR
		DIALOG | Dr. Liu | P_NAME_S! Get down to the Governor's mansion at the center of Tir na nOg and find the `kw`confiscated dossier!`rt`

		GOVQUEST_3
		DIALOG | Dr. Liu | Oh hey, P_NAME_S. How's the mission going?
		GOTO   | SNIP_QUESTION

		GOVQUEST_2
		DIALOG | Dr. Liu | Is there something you needed, P_NAME?
		GOTO   | SNIP_QUESTION

		DRLIU_1
		DIALOG | Dr. Liu | I wasn't expecting to see you again, P_NAME. I thought you weren't interested in helping L.O.N.G.I.N.U.S. Have you reconsidered helping us with `sq`Operation: Reverse Dunkirk?`rt`
		IF liuState == 0 | GOTO | SNIP_MEET
		IF liuState == 2 | GOTO | SNIP_BRANCH
		CHOICE | Reconsidered?
		REPLY  | REPLY_HELPME    | You said it could help me?
		REPLY  | REPLY_KISSGRITS | My grits. Kiss 'em.

		REPLY_HELPME
		DIALOG | P_NAME  | You said it could help me? What was that about?
		GOTO   | SNIP_YES

		REPLY_KISSGRITS
		DIALOG | P_NAME  | I'm just gonna stick with you kissing my grits for now, granny.
		DIALOG | Dr. Liu | What a shame...

		DRLIU_0
		DIALOG | Dr. Liu | `w1`Sigh...`w0` it looks like after all my hard work, nobody's going to even try. What's even the point any more?
		DIALOG | P_NAME  | Hey, this is L.O.N.G.I.N.U.S., right? I think I need your help.
		DIALOG | Dr. Liu | You need help. I need help. Lafayette needs help. We all need help.
		DIALOG | P_NAME  | No you see, I was rescued from this weird egg thing by a bunch of dwarfs who said they were with L.O.N.G.I.N.U.S., and they told me I needed to find `mq`The Cyberdwarf.`rt` Do you have any idea where he might be, or what I'm supposed to do?
		DIALOG | Dr. Liu | I hate to tell you but `mq`The Cyberdwarf isn't in Tir na nOg`rt` and we're not the dwarfs who rescued you. We're a small squad just trying to complete `kw`our first sortie`rt` but it's already gone to bunk. If you're looking for The Cyberdwarf, you'll have to look elsewhere. Sorry.
		DIALOG | P_NAME  | Oh... I see... well, thanks anyway...
		LOOK   | o_cts_hoopz | SOUTH
		WAIT   | 0.25
		DIALOG | Dr. Liu | `w1`Wait a second!`rt`
		LOOKAT | o_cts_hoopz | o_dr_liu01 | 
		DIALOG | Dr. Liu | You're a pretty resourceful kid. You made it to our hideout in one piece, maybe you could help us out with a mission and we could, in turn, help you with yours?
		QUEST  | liuState = 1
		GOTO   | SNIP_MEET

		SNIP_MEET
		CHOICE | Hmmm...
		REPLY  | REPLY_BODY       | That body transference thing?
		REPLY  | REPLY_CYBERDWARF | I just want to find The Cyberdwarf.
		REPLY  | REPLY_TIRNANOG   | I just want to get out of Tir na nOg as quickly as I can.
		REPLY  | REPLY_GRITS      | Not today. Kiss my grits, granny.

		REPLY_BODY
		DIALOG | P_NAME  | You mean that body transference thing you were talking about earlier?
		GOTO   | SNIP_YES

		REPLY_CYBERDWARF
		DIALOG | P_NAME  | Well, I really just want to find The Cyberdwarf.
		DIALOG | Dr. Liu | I can't help you with that specifically, but I know `kw`he's not here`rt` and I believe we could come to a mutually beneficial resolution.  I could explain it in more depth if you're interested.
		GOTO   | SNIP_CONFIRM

		REPLY_TIRNANOG
		DIALOG | P_NAME  | Well, I really just want to get out of here as fast as possible.
		DIALOG | Dr. Liu | I was getting to that! I believe that we could come to a mutually beneficial resolution. I could explain it in more depth if you're interested.
		GOTO   | SNIP_CONFIRM

		REPLY_GRITS
		DIALOG | P_NAME  | Not happening. `w1`Kiss my grits,`w0` granny.
		DIALOG | Dr. Liu | Wh-what? But... but I believe we can both benefit from it. And I worked so hard... I shouldn't have even bothered...

		SNIP_CONFIRM
		CHOICE | Am I interested...?
		REPLY  | REPLY_SURE | Sure.
		REPLY  | REPLY_NOPE | Not today.

		REPLY_SURE
		DIALOG | P_NAME  | Okay, sure. If you really think it'll benefit me, I'll hear you out.
		GOTO   | SNIP_YES

		REPLY_NOPE
		DIALOG | P_NAME  | No thanks. Not interested.
		DIALOG | Dr. Liu | Sigh... we could have both benefited from this... I shouldn't have even bothered...
		EXIT |

		SNIP_YES
		DIALOG | Dr. Liu | Yes! For the past few months, Absalom and I have been working on a device that can transfer the consciousness of one being into another, the idea being that we somehow capture a Duergar, switch bodies with it. Pretty clever, huh?
		DIALOG | P_NAME  | Yeah, but_ why?
		DIALOG | Dr. Liu | So we're a fledgling branch of L.O.N.G.I.N.U.S. here in Tir na nog. I just recently started to get our `kw`carrier rats`rt` trained enough to carry on proper comms with Headquarters.
		DIALOG | P_NAME | And?
		DIALOG | Dr. Liu | Well I was set to receive a `sq`Top Secret Dossier`rt containing instructions to initiate a hush-hush, need-to-know operation known as `kw`Operation: Reverse Dunkirk.`rt`
		DIALOG | P_NAME  | Dunkirk?
		DIALOG | Dr. Liu | All I know is the codename. The rest of the mission briefing was `sq`contained in a sealed, Top Secret Document sent directly from LONGINUS Headquarters.`rt` Unfortunately and need I say, `w1`depressingly,`w0` the dosser was confiscated by Duergar Censors on it's way into Tir na Nog circulation.
		DIALOG |  P_NAME | Maybe you shouldn't have mailed it?
		DIALOG | Dr. Liu | Well you see, just recently, a golden opportunity came up: the last governor got transferred. There were `kw`explicit reasons why,`rt` but we don't have to get into them. Whenever a new governor comes in, all heck kind of breaks loose in here and we thought that would allow the mail to at least slip through the Duergar Censors.
		WAIT   | 0.1
		DIALOG | Dr. Liu | We were wrong. Now, `sq`we have to impersonate the incoming Governor and use his status to enter the Governor's Mansion,`rt` where my Dossier is being held. 
		DIALOG | P_NAME  | Okay so it's... `w1`a heist?`rt`
		DIALOG | Dr. Liu | More or less,_ yes.
		WAIT   | 0.33
		DIALOG | Dr. Liu | So, are you in?
		GOTO   | SNIP_BRANCH

		SNIP_BRANCH
		CHOICE | Let me think...
		IF liuBenefit != 1 | REPLY  | REPLY_HELP   | You sure this'll work?
		IF liuPolicy != 1  | REPLY  | REPLY_POLICY | What does the governor do?
		REPLY  | REPLY_IMIN  | Okay, I'm in!
		REPLY  | REPLY_GRITS | Kiss my grits. // Reply exists in above code

		REPLY_HELP
		DIALOG | P_NAME  | Are you honestly sure this harebrained goof-scheme will work?
		DIALOG | Dr. Liu | Oh it's goof-proof! If you switch bodies with the governor you'll be able to walk right out through the main door to the mansion! In fact, while you are governor, you could control all the comings and goings in this slum of slums. Most dwarfs would kill for that privilege!
		QUEST  | liuBenefit = 1
		GOTO   | SNIP_BRANCH

		REPLY_POLICY
		DIALOG | P_NAME  | So what does a Duergar Governor actually do?
		DIALOG | Dr. Liu | We're getting a new governor right now so things are all up in the air. That's why we need to strike. If we wait for the traditional Inaugural Address it could be too late. At every inaugural address, the governor lays out their plans for the future of Tir na nOg. Usually they're about indiscriminate torture roundups or food rationing. But before the Governor gives the address, they normally have free reign of the mansion, and that's exactly where my `kw`Top Secret Dossier`kw` is!
		QUEST  | liuPolicy = 1
		GOTO   | SNIP_BRANCH

		REPLY_IMIN
		DIALOG | P_NAME  | Okay, I'm in. What do I need to do?
		DIALOG | Dr. Liu | `w1`Fantastic!`w0` I knew I could count on you! So here's how it goes down: we somehow kidnap the governor, you switch bodies with him using the body transference device and `sq`sneak into the mansion and get the Dossier.`rt` After that, get back, switch back to your old body and `kw`Operation: Reverse Dunkirk`rt` will have entered `kw`PHASE TWO.`rt`
		DIALOG | P_NAME  | This sounds unbelievably complicated. How are we supposed to kidnap the incoming governor?
		DIALOG | Dr. Liu | Well, that's the tricky part. But I have an idea... see, Duergars are instinctively territorial creatures. They mark their turf with... ahh... well,_ their `kw`urine.`rt` _ When a Duergar urinates on something, it indicates that he owns it. But Duergars are also competitive and domineering creatures as well. A Duergar, attracted by the `kw`pheromones`rt` of another Duergar's urine, will urinate over it in order to prove their dominance.
		DIALOG | P_NAME  | So what are you saying?
		DIALOG | Dr. Liu | Well, I think we could attract the Governor using either Duergar urine or the pheromones extracted from it. The Governor is the highest ranking Duergar in Tir na nOg and he'll want to prove it by stamping out any rivals.
		DIALOG | P_NAME = s_port_hoopzSurprise | So you're saying I need to get some `kw`Duergar urine?`rt` That's pretty disgusting. Where am I even supposed to get it?
		DIALOG | Dr. Liu | Well you could try asking... and you'll need something to hold it in. Here, take this.
		USEAT  | o_dr_liu01
		ITEM   | Sterile Vial | 1
		NOTIFY | Got a Sterile Vial.
		DIALOG | P_NAME  | Ugh... well I'll find it somehow and I'll be back when I get it. Later, Dr. Liu.
		DIALOG | Dr. Liu | Excellent. Good luck to you, P_NAME_S.
		QUEST  | govQuest = 2
		QUEST  | operationX = 1

		SNIP_URINE
		DIALOG | P_NAME  | Well Dr. Liu, I got the Duergar... stuff. What are we supposed to do with it?
		DIALOG | Dr. Liu | Excellent. I'm not even going to ask how you got it. Duergars are territorial animals and urinate to mark their turf. The pheromones in Duergar urine convey power and authority; Duergars will often urinate over another Duergar's urine in order to assert their dominance. It's my hope that we can attract the incoming governor and capture him. Go place it on the left-most chair of the body transference device.
		DIALOG | P_NAME  | Just... dump it on?
		DIALOG | Dr. Liu | Yes, of course.
		DIALOG | P_NAME  | Okay...
		FRAME  | CAMERA_NORMAL | o_rightChair01 | o_leftChair01
		WAIT   | 0
		MOVETO | o_cts_hoopz | o_cinema10 | MOVE_NORMAL
		WAIT   | 0
		LOOK   | o_cts_hoopz | NORTH
		DIALOG | P_NAME  | Well, here goes... *sniff sniff*... ugh, horrendous.
		SOUND  | sn_cupfilling01
		USEAT  | NORTH
		NOTIFY | Emptied the vial onto the chair.
		WAIT   | 1.0
		MOVETO | o_cts_hoopz | o_cinema11 | MOVE_NORMAL
		FRAME  | CAMERA_NORMAL | o_dr_liu01
		WAIT   | 0
		LOOK   | o_cts_hoopz | NORTHEAST
		DIALOG | Dr. Liu | Well, I suppose we just need to wait and see-
		Misc   | music | mus_tnn_shadowrun2 | 0.33
		FRAME  | CAMERA_FAST | o_cinema0
		WAIT   | 0
		Misc   | entity settings | o_governor01 | 0 | 0 | 0
		LOOK   | o_cts_hoopz | SOUTHWEST
		PLAYSET| o_governor01 | window | ANIMATION_IDLE_RIGHT
		SOUND  | sn_crashwindow01
		Misc   | visible | o_governor01 | 1
		PLAYSET| o_cts_hoopz | surpriseSW | surpriseHoldSW
		WAIT   | 0
		Misc   | entity settings | o_governor01 | 0 | 0 | 1
		FOLLOWFRAME | CAMERA_FAST | o_governor01
		PLAYSET| o_absalom01 | turn | speaking
		WAIT   | 0
		WAIT   | 1
		MOVETO | o_governor01 | o_cinema0 | MOVE_NORMAL
		WAIT   | 0
		WAIT   | 1
		DIALOG | Governor Elagabalus | *sniff sniff* Smells like...
		MOVETO | o_governor01 | o_cinema1 | MOVE_NORMAL
		WAIT   | 0
		DIALOG | Dr. Liu| (It's the Governor!)
		MOVETO | o_governor01 | o_cinema2 | MOVE_NORMAL
		WAIT   | 0
		WAIT   | 1
		DIALOG | Governor Elagabalus | ...like...
		MOVETO | o_governor01 | o_cinema3 | MOVE_NORMAL
		WAIT   | 0
		DIALOG | Dr. Liu | (Don't move. Its vision is based on movement!)
		EVENT  | o_dr_liu01 | 15
		Misc   | entity settings | o_leftChair01 | 0 | 0 | 0
		Misc   | entity settings | o_governor01 | 0 | 0 | 0
		DIALOG | Governor Elagabalus | ...smells like competition!
		Misc   | automatic animation | o_governor01 | true
		MOVETO | o_governor01 | o_cinema4 | MOVE_FAST
		WAIT   | 0
		MOVETO | o_governor01 | o_cinema12 | MOVE_FAST
		WAIT   | 0
		Misc   | flip | o_governor01 | 1
		PLAYSET| o_governor01 | enter_chair | chair
		WAIT   | 0
		Misc   | visible | o_governor01 | 0
		SET    | o_leftChair01 | governor
		SOUND  | sn_handlock01
		FRAME  | CAMERA_NORMAL | o_rightChair01 | o_leftChair01
		EVENT  | o_dr_liu01 | 14
		DIALOG | Dr. Liu | We got him!
		DIALOG | P_NAME  | I can't believe it worked!
		MOVETO | o_cts_hoopz | o_cinema6 | MOVE_FAST
		WAIT   | 0
		LOOK   | o_cts_hoopz | NORTH
		DIALOG | Governor Elagabalus | `s1`What the FUCK?!`rt`
		DIALOG | Governor Elagabalus | Lemme outta here! Let me the hell outta here! `s1`I'll dash your gourd upon the rocks!`s0` Do you have any idea who I am? I'm `kw`Governor Elagabalus`rt` and `s1`I own you all!`s0` If you don't let me out of here at once, I'll `s1`burn`s0` you and this whole city to the ground! Where's my `s1`fuckin' fiddle?`s0`
		FRAME  | CAMERA_FAST | o_ritkonen01
		WAIT   | 0
		DIALOG | Soldat Ritkonen | Keep it down! We've got a game going on over here!
		LOOK   | o_cts_hoopz | SOUTHEAST
		FRAME  | CAMERA_FAST | o_cts_hoopz | o_dr_liu01
		WAIT   | 0
		DIALOG | P_NAME  | That shouldn't have been so easy. I guess I underestimated that Duergar competitive spirit.
		DIALOG | Dr. Liu | Well, the Duergar urine worked like a charm. It looks like we've got ourselves a Governor. I guess it's time to see if the body transference device really works!
		DIALOG | P_NAME = s_port_hoopzSurprise | Wait, you don't know if it works yet?
		DIALOG | Dr. Liu | Well, it should `w1`in theory.`w0` If it doesn't, at least we know the urine trick works.
		DIALOG | P_NAME = s_port_hoopzAngry | That's not very reassuring.
		FRAME  | CAMERA_FAST | o_rightChair01 | o_leftChair01
		WAIT   | 0
		DIALOG | Governor Elagabalus | Get me the hell out of here you `s1`gatdam Cyberdwarf sympathizers!`s0` I'll crush you like bugs! `s1`It's about to get Tienanmen up in this biiiitch.`s0`
		DIALOG | Dr. Liu | Quick, P_NAME! He's getting really angry! I'm not sure how long my machine can hold up with him shaking it like that. Let's do it!
		Misc   | entity settings | o_rightChair01 | 0 | 0 | 1
		MOVETO | o_cts_hoopz | o_cinema13 | MOVE_FAST
		FRAME  | CAMERA_NORMAL | o_rightChair01 | o_leftChair01
		WAIT   | 0
		LOOK   | o_cts_hoopz | SOUTH
		WAIT   | 0.2
		SOUND  | sn_handlock02
		SET    | o_rightChair01 | hoopz
		Misc   | set | o_cts_hoopz | 999 | 0
		QUEST  | govTransfer = 1
		WAIT   | 1
		SET    | o_leftChair01 | governorclamp
		SET    | o_rightChair01 | hoopzclamp
		Misc   | music | mus_tnn_shadowrun2 | 0
		WAIT   | 1.0
		QUEST  | govTransfer += 1
		FRAME  | CAMERA_FAST | o_rightChair01 | o_leftChair01 | o_dr_liu01
		SOUND  | sn_headlock01
		SOUND  | sn_headlock02
		DIALOG | Dr. Liu | Ready, P_NAME? When I pull the lever, an electrical pulse will either fry your brains or transfer your consciousness into the Governor's body.
		DIALOG | P_NAME  | So... what's gonna happen to my body when I'm inside the Governor?
		DIALOG | Dr. Liu | The Governor will be inside your body. Don't worry! We'll keep him fed and watered, clean up if he makes a mess of himself.
		DIALOG | P_NAME  | That's reassuring. Well... I guess it's time to see if this thing works...
		DIALOG | Dr. Liu | Ready, P_NAME_S? 3...
		DIALOG | Governor Elagabalus | Get me the hell out of here! Who are you damned dwarfs!? I'll smash your brains in! `s1`I'm the gatdam governor!`s0`
		DIALOG | Dr. Liu | ... 2...
		DIALOG | P_NAME  | Here goes...
		DIALOG | Dr. Liu | ... 1!
		Misc   | music   | mus_tnn_shadowrun2 | 0
		WAIT   | 1.0
		Misc   | visible | o_lever01 | 0
		Misc   | flip | o_dr_liu01 | 1
		PLAYSET | o_dr_liu01 | lever | idle
		SOUND   | sn_doorclosed_plain
		WAIT    | 0
		FRAME   | CAMERA_FAST | o_rightChair01 | o_leftChair01
		WAIT    | 0
		Misc    | visible | o_lever01 | 1
		WAIT    | 1
		Misc    | set | o_governor01 | %s | %s
		Misc    | entity settings | o_governor01 | 0 | 0 | 0
		Misc    | visible | o_governor01 | 1
		Misc    | visible | o_leftChair01 | 0
		Misc    | visible | o_rightChair01 | 0
		SOUND   | sn_chairtransfer01
		PLAYSET | o_governor01 | transfer | transferDone
		WAIT    | 0
		WAIT    | 1
		FADE    | 1 | 2
		WAIT    | 2
		Teleport | r_tnn_rebelbase02 | %s | %s | 2" % [ o_leftChair01.position.x - 14, o_leftChair01.position.y - 9, o_cinema7.position.x, o_cinema7.position.y ]
		set_new_cinemascript( script )
	#endregion

# Move time past curfew to avoid problems
# Go beyond the Curfew to avoid governor problems with it //
# TODO Set the clocktime to max(post-curfew time, current time)
func execute_event_user_10():
	if B2_ClockTime.time_get() < 5.5:
		B2_Playerdata.Quest("curfewAnnouncement", 2);
		B2_Playerdata.Quest("curfewSurprise", 2);
		B2_Playerdata.Quest("tnnCurfew", 2);
		## TODO What are these???
		# scr_savedata_put("clock.time", (24 - 5.5) * 60 * 60);
		# ClockTime("process", 0); 
