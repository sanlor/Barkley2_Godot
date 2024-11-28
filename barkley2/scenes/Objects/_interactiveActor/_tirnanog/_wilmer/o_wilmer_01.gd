extends B2_InteractiveActor

func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()
	
	## Wilmer has some extra "unused" dialog.
	#// Talk to Wilmer again after you've said your goodbyes //
	#if (scr_quest_get_state("wilmerGoodbye") == 1)
	#DIALOG | Wilmer | Hm? What's that? *cough*... *hack*... that you, " + P_NAME + "? You're still here? I thought you were *hack*... *cough*... hitting the road, leaving Ol' Wilmer in the dust! What can I do for you? 
	#
	#//Time = 2
	#DIALOG | Wilmer | *Cough*... *cough*... ah, there you are, youngster. I was beginning to wonder where you'd gone off to. What kind of trouble are you getting yourself into?
	#DIALOG | P_NAME | No trouble...! I hope... but I did want to ask you something if you have the time...
	#
	#DIALOG | Wilmer | *Cough*... *cough*... *hack*... X1, it's... *cough*... it's good to see you again. I was starting to think you'd taken off without saying goodbye to ol' man Wilmer!
	#DIALOG | P_NAME | Mr. Wilmer, that cough sounds pretty serious! Maybe you should visit a doctor about it.
	#DIALOG | Wilmer | Awww, it ain't nothin', kid. Ol' Wilmer's not gettin' any younger and there ain't nothin' a few cough drops could do for me. You get old, kid. We all do.
	#DIALOG | P_NAME | But...
	#DIALOG | Wilmer | But nothin'! 'sides, I ain't goin' up to the clinic just to have Dr. Tatijana tell me I need to watch my diet. They won't NEVER take my butterscotch from me. They'll have to pry 'em from my cold, dead hands. But enough of that. What can I do for you, youngster?
	#/*
	#// CUCHULAINN IS MY DAD!
	#with (scr_event_build_add_choice(cyberdwarf, "Cuchulainn is my dad."))
	#DIALOG | P_NAME | This is just a hunch, but I've got a feeling Cuchulainn's my dad. Call it intuition.
	#DIALOG | Wilmer | ...is that something you really believe?
	#DIALOG | P_NAME | It's not really something you believe. It's something you feel. I just feel like Cuchulainn is my dad.
	#DIALOG | Wilmer | Alright youngster. I think I understand. Or maybe I don't, but if it's that important to you, I'm not gonna stop you.
	#DIALOG | P_NAME | Thank you, Mr. Wilmer...
	#//TODO: go to #1 and activate cuchulainn dad variable
	#
	#// THE CYBERDWARF IS MY DAD!
	#with (scr_event_build_add_choice(cyberdwarf, "The Cyberdwarf is my dad."))
	#DIALOG | P_NAME | This is just a hunch, but I've got a feeling Cyberdwarf's my dad. Call it intuition.
	#DIALOG | Wilmer | Your father? But how do you know?
	#DIALOG | P_NAME | I don't know. It's not really something you know or believe, it's more something you feel. I just FEEL that I have this connection with the Cyberdwarf that goes beyond mere acquaintance. I just FEEL that he's my father.
	#DIALOG | Wilmer | I see. I don't know if I follow you, youngster, but I'm not going to stop you. Do what you feel like you have to do.
	#DIALOG | P_NAME | Thank you, Mr. Wilmer...
	#//TODO: go to #1 and activate cyberdwarf dad variable
	#
	#DIALOG | P_NAME | I think that's it, Mr. Wilmer. Thanks for the help. And in case I don't get the chance to say it before I leave, goodbye.
	#DIALOG | Wilmer | Aw, it was nothin' kid. Don't sweat it. And don't you forget me out there! I'm always here to help!
	#DIALOG | P_NAME | I won't forget you, Mr. Wilmer! Take care!
	#QUEST | wilmerSleepCount -= 1
	#EXIT |
	
func execute_event_user_0():
	## Snooze
	#snoozing = true;
	pass

func execute_event_user_1():
	## Wake up 
	#snoozing = false;
	pass
	
func execute_event_user_2():
	pass
	
func execute_event_user_5():
	pass
