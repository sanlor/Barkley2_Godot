extends B2_InteractiveActor

## Made with B2_TOOL_DWARF_CONVERTER
func _ready() -> void:
	_setup_actor()
	_setup_interactiveactor()

	#// event_bct_chaiyaporn01
	#/*
		#Chaiyaporn is a character with a big brain.
		#It is mutated by proximity to the Brain City Brain.
		#He can answer all sorts of questions, but if you ask him "Who am I?" his head will explode.
		#Brainfan One and Brainfan Two are his constant cohorts.
		#
		#TODO: Something that happens when you kill the Brain. His powers subside?
	#
		#//----------------------------
		#// QUEST VARIABLES
		#//----------------------------
		#chaiyapornState
			#0 = have not talked
			#1 = have talked
			#2 = have asked a question, been astounded
			#
		#chaiyapornLoop
			#1 = looping in chaiyaporn's event. only programmatically important, should leave every event as 0 again.
		#
		#chaiyapornCount
			#1 to 4 = counts the number of questions asked
			#5 = turns on chaiyapornTime, resets to 0
			#
		#chaiyapornTime
			#1 = indicates the player must wait for a time unit to pass before getting another round of questions
			#
		#chaiyapornExplode
			#1 = he's exploded!
			#
		#chaiyapornBattle
		#chaiyapornWorld
		#chaiyapornAbout
		#chaiyapornSelf
			#all of the above 4 increase when you ask questions in a given category
			#they have variable max values going up from 0
		#*/
	#
	#
	#/*if (argument0 == SCRIPT_START) {
	#
	#}
	#else if (argument0 == SCRIPT_STEP) {
		#if (scr_quest_get_state("chaiyapornExplode") == 1) {
			#scr_actor_unsetRigid(id);
			#instance_destroy()
		#}
	#}
	#else if (argument0 == SCRIPT_INTERACT) {
	#
		#var chaiyaporn = id;
		#var event = scr_event_create_main();
		#var question_snippet = scr_event_create_child(event);
		#var whoami_snippet = scr_event_create_child(event);
		#
		#var gehirnport = NULL;
	#
		#/*----------------------------------------------------------------------------------------------------------------
		#// main event ----------------------------------------------------------------------------------------------------
		#//----------------------------------------------------------------------------------------------------------------
			#The main event controls chaiyaporn's looping.
			#The different states:
			#* expired - count has reached 5 - player must return in one time unit later
			#* yr loopin - loop is ongoing. checks if player has asked too many questions, gives responses, and repeats
			#* talked stats - for having guessed and not guessed
			#* first time talking
		#*/
	#/*    with (event) {
			#// expired
			#if (scr_quest_get_state("chaiyapornTime") == 1) {
				#scr_event_build_dialogue("Brainfan One", NULL, "Hey creep, get lost! Leave the man alone!");
				#scr_event_build_dialogue("Brainfan Two", NULL, "Yeah, he said give him a break! Give the man a break for awhile!");
				#scr_event_build_dialogue("Brainfan One", NULL, "... But then come back later and let him blow your mind!");
			#}
			#// yr loopin...
			#else if (scr_quest_get_state("chaiyapornLoop") == 1) {
				#// first time
				#if (scr_quest_get_state("chaiyapornState") == 1) {
					#scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "What! Get out of town! ... and get out of my head!");
					#scr_event_build_dialogue("Brainfan One", NULL, "Thought you could stump him? You thought wrong!");
					#scr_event_build_dialogue("Brainfan Two", NULL, "We told ya! He's unbelievable!");
					#scr_event_build_dialogue("Brainfan One", NULL, "Do you dare try again! Go on, see if there's something he doesn't know!");
					#scr_event_build_quest_state("chaiyapornState", 2);
				#}
				#// multiple times through
				#else {
					#switch(irandom(5)) {
						#case 0: scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "(Wha... what kind of brain power is this!?)"); break;
						#case 1: scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "(He truly knows everything... how terrible!)"); break;
						#case 2: scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "(Holy... this guy's off the deep end...)"); break;
						#case 3: scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "(H-... how did you...?)"); break;
						#case 4: scr_event_build_dialogue(P_NAME, s_port_hoopzShock, "(I don't believe it... I don't believe a lick of it!)"); break;
					#}
					#scr_event_build_dialogue("Brainfan One", NULL, "Ohhhhhh! Ohhhhhh!");
					#scr_event_build_dialogue("Brainfan Two", NULL, "Go again, go again!");
				#}
				#// too many questions
				#if (scr_quest_get_state("chaiyapornCount") == 5) {
					#scr_event_build_dialogue("Chaiyaporn", gehirnport, "All right, all right, I think that's enough. I gotta take care of my 'pan. Can't waste it on such amateur questions!");
					#scr_event_build_dialogue("Brainfan One", NULL, "Yeah, get lost!... for awhile, then come back later so he can trounce you again!");
					#scr_event_build_dialogue("Brainfan Two", NULL, "Yep, we're gonna need your sorry questions at a later date... and only at a later date!");
					#scr_event_build_quest_state("chaiyapornTime", 1);
					#scr_event_build_quest_state("chaiyapornCount", 0);
					#scr_event_build_quest_state("chaiyapornLoop", 0);
					#scr_event_build_end();
				#}
				#else {
					#scr_event_build_event_snippet(question_snippet);
				#}
			#}
			#// talked before, taken a guess
			#else if (scr_quest_get_state("chaiyapornState") == 2) {
				#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Look who's back! Looks like it's time for my to flex my matter once again...");
				#scr_event_build_dialogue("Brainfan One", NULL, "Doubting his uncanny brainpower?");
				#scr_event_build_dialogue("Brainfan Two", NULL, "Go on, just TRY to get one past him!");
				#scr_event_build_event_snippet(question_snippet);
			#}
			#// talked before, haven't guessed
			#else if (scr_quest_get_state("chaiyapornState") == 1) {
				#scr_event_build_dialogue("Chaiyaporn", gehirnport, "So you've returned!");
				#scr_event_build_dialogue("Brainfan One", NULL, "You're back! Gonna chicken out again? Come on, ask him a question!");
				#scr_event_build_dialogue("Brainfan Two", NULL, "Yeah, give it a shot. You'll be blown away!");
				#scr_event_build_event_snippet(question_snippet);
			#}
			#// first time guessing
			#else {
				#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Excuse me...");
				#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Yes? Hey guys... I /'wonder/' what this youngster wants!");
				#scr_event_build_dialogue("Brainfan One", NULL, "Ha ha ha, I get it, /'wonder/'!");
				#scr_event_build_dialogue("Brainfan Two", NULL, "Oh Chaiyaporn, you're so wise, and funny too!");
				#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Thank you, thank you! You're both too kind. So, kid, I know why you're here. You want to ask a question of the great Chaiyaporn!");
				#scr_event_build_dialogue("Brainfan One", NULL, "Go on, ask! There's nothing he can't tell you! Let him trounce you with his knowledge!");
				#scr_event_build_dialogue("Brainfan Two", NULL, "He knows everything! It's incredible! There's nothing outside of his purview!");
				#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Is that true? You know everything?");
				#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Let me think... OF COURSE! Go ahead, just try me! Ask me anything you want to know!");
				#scr_event_build_quest_state("chaiyapornState", 1);
				#scr_event_build_event_snippet(question_snippet);
			#}
		#}
		#
		#
		#
		#
		#
		#/*----------------------------------------------------------------------------------------------------------------
		#// whoami_snippet ------------------------------------------------------------------------------------------------
		#//----------------------------------------------------------------------------------------------------------------
			#This question only appears if you have not met Cyberdwarf yet.
			#It causes Chaiyaporn's head to explode!!!
			#From now on there is a corpse and spot of blood.
			#Or until they get it cleaned up
		#*/
	#/*    with (whoami_snippet) {
			#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Who are you? You're... you're...");
			#scr_event_build_wait(2);
			#scr_event_build_wait_for_actions();
			#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Scanning memory banks... calculating possibilities... widening perception...");
			#scr_event_build_wait(1.5);
			#scr_event_build_wait_for_actions();
			#scr_event_build_dialogue_debug("bort", NULL, "Things go bad here. A cool sfx plays, and his head starts to shake...");
			#scr_event_build_dialogue("Chaiyaporn", gehirnport, "... sorting knowledge banks... synchronizing cortical grid... all lobes are go...");
			#scr_event_build_wait(1.5);
			#scr_event_build_wait_for_actions();
			#scr_event_build_dialogue_debug("bort", NULL, "Things go bad here. A cool sfx plays, and his head starts to shake...");
			#scr_event_build_dialogue("Brainfan Two", NULL, "He's really going for it! He's got the motherlode of knowledge in his sights!");
			#scr_event_build_dialogue("Brainfan One", NULL, "Chaiyaporn? Chaiyaporn? Are you-");
			#scr_event_build_dialogue_debug("bort", NULL, "Chaiyaporn's head fucking explodes!");
			#scr_event_build_wait(3);
			#scr_event_build_wait_for_actions();
			#scr_event_build_dialogue("Brainfan One", NULL, "Chaiyaporn... you...");
			#scr_event_build_dialogue("Brainfan Two", NULL, "Why... why!");
			#scr_event_build_quest_state("chaiyapornExplode", 1);
			#scr_event_build_end();
		#}
		#
		#
	   #
	   #
	   #
		#/*----------------------------------------------------------------------------------------------------------------
		#// question_snippet ----------------------------------------------------------------------------------------------
		#//----------------------------------------------------------------------------------------------------------------
			#The question snippet is looped through multiple times.
			#There are 4 categories of question:
			#* About World - contains L.O.N.G.I.N.U.S. question, and stops when "What time is it?" remains
			#* About Chaiyaporn - loops through the 3 available questions
			#* About Self - goes away when all the questions are asked, leads to "whoami" snippet & chaiyaporn's death
			#* About Battle - loops through, multiple answers for each question
			#* Exit Questioning
		#*/
	#/*    with (question_snippet) {
			#scr_event_build_quest_state("chaiyapornLoop", 1);
			#choice = scr_event_build_choice("Ask...", s_port_hoopz);
			#//--------------------------------------
			#// world questions
			#//--------------------------------------
			#// optional question: longinus
			#if (scr_quest_get_state("longinusDoorKnown") == 0) {
				#var longinus = scr_event_build_add_choice(choice, "Where is L.O.N.G.I.N.U.S.?");
				#with (longinus) {
					#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Where is L.O.N.G.I.N.U.S.? I'm looking for them.");
					#event_bct_chaiyapornThink01();
					#scr_event_build_dialogue("Chaiyaporn", gehirnport, "L.O.N.G.I.N.U.S. is... behind a locked door in Brain City. You'll have to do some knocking. NEXT!");
					#scr_event_build_quest_state("longinusDoorKnown", 1);
				#}
			#}
			#// optional question: cyberdwarf
			#else if (scr_quest_get_state("longinusTalked") == 0) && (scr_quest_get_state("chaiyapornCyberdwarf") == 0) {
				#var cyberdwarf = scr_event_build_add_choice(choice, "Where is the Cyberdwarf?");
				#with (cyberdwarf) {
					#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Do you know where the Cyberdwarf is? I'm on a mission to find him.");
					#event_bct_chaiyapornThink01();
					#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Cyberdwarf, Cyberdwarf, Cyberdwarf... try checking that L.O.N.G.I.N.U.S. place I told you about. Remember? Locked door? Knocking? Ring a bell at all? Do that!");
					#scr_event_build_quest_state("chaiyapornCyberdwarf", 1);
				#}
			#}
			#else {
				#// normal questions
				#switch (scr_quest_get_state("chaiyapornWorld")) {
					#case 0:
						#var where = scr_event_build_add_choice(choice, "What can I do in Brain City?");
						#with (where) {
							#if (scr_time_get() - scr_quest_get_state("brainCityTime") <= 1) {
								#scr_event_build_dialogue(P_NAME, s_port_hoopz, "I'm really new here. What is there to do in Brain City?");
							#}
							#else if (scr_time_get() - scr_quest_get_state("brainCityTime") <= 5) {
								#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Do you have any tips on what is there to do in Brain City?");
							#}
							#else {
								#scr_event_build_dialogue(P_NAME, s_port_hoopz, "I think I know it pretty well, but do you have any favorite Brain City spots?");
							#}
							#event_bct_chaiyapornThink01();
							#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Brain City spots? Check out that humongous flippin' Brain in the center. I feel... drawn to it. I also like logging in to Oligarchy Online. I can plug in and give this big ol' thing a rest!");
							#scr_event_build_quest_state("chaiyapornWorld", 1);
						#}
						#break;
					#case 1:
						#var time = scr_event_build_add_choice(choice, "What time is it?");
						#with (time) {
							#scr_event_build_dialogue(P_NAME, s_port_hoopz, "What time is it? I bet I'm late... for something anyway.");
							#event_bct_chaiyapornThink01();
							#scr_event_build_dialogue("Chaiyaporn", gehirnport, "It's " + string(global.clockHours) + ":" + string(global.clockMinutes) + "... but you had to ask me for that? Come on!");
							#//scr_event_build_quest_state("chaiyapornWorld", 0);
						#}
						#break;
				#}
			#}
			#
			#//--------------------------------------
			#// about questions
			#//--------------------------------------
			#switch (scr_quest_get_state("chaiyapornAbout")) {
				#case 0:
					#var you = scr_event_build_add_choice(choice, "Who are you?");
					#with (you) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Who are you?");
						#event_bct_chaiyapornThink01();
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "I'm the famous Chaiyaporn. I'm blessed with a powerful intellect, and an extremely heavy brain. It's huge. It's so big it's coming out of my skull. Aside from my brain and brain power I'm not really noteworthy, just a dwarf like any other.");
						#scr_event_build_quest_state_add("chaiyapornAbout", 1);
					#}
					#break;
				#case 1:
					#var brain = scr_event_build_add_choice(choice, "How did your brain get so big?");
					#with (brain) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "How did your brain get so big?");
						#event_bct_chaiyapornThink01();
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Proximity to that HUGE WHOPPING BRAIN in the center of the city might have something to do with it, don't you think?");
						#scr_event_build_quest_state_add("chaiyapornAbout", 1);
					#}
					#break;
				#case 2:
					#var know = scr_event_build_add_choice(choice, "Is there anything you don't know?");
					#with (know) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "You're really smart, but, is there anything you don't know?");
						#event_bct_chaiyapornThink01();
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "If I didn't know everything, what would this brain be good for? Most dwarfs find it intimidating... or they laugh. But in fact, I know precisely how much I know. Everything.");
						#scr_event_build_quest_state("chaiyapornAbout", 0);
					#}
					#break;
			#}
			#
			#//--------------------------------------
			#// self questions
			#//--------------------------------------
			#if (scr_quest_get_state("chaiyapornSelf") == 0) {
				#var think = scr_event_build_add_choice(choice, "What am I thinking about?");
				#with (think) {
					#scr_event_build_dialogue(P_NAME, s_port_hoopz, "What am I thinking about right now?");
					#event_bct_chaiyapornThink01();
					#scr_event_build_dialogue("Chaiyaporn", gehirnport, "RM.");
					#// TODO: RoundMound shit goes here.
					#scr_event_build_dialogue_debug("bort", NULL, "Roundmound stuff goes here.");
					#scr_event_build_quest_state("chaiyapornSelf", 1);
				#}
			#}
			#else if (scr_quest_get_state("chaiyapornSelf") == 1) && (scr_quest_get_state("playerX1") == 1) {
				#var whoami = scr_event_build_add_choice(choice, "Who am I?");
				#with (whoami) {
					#scr_event_build_quest_state("chaiyapornSelf", 2);
					#scr_event_build_event_snippet(whoami_snippet);
				#}
			#}
	#
			#//--------------------------------------
			#// battle questions
			#//--------------------------------------
			#switch(scr_quest_get_state("chaiyapornBattle")) {
				#case 0: 
					#var battle = scr_event_build_add_choice(choice, "How's my battling?");
					#with (battle) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "Okay, tell me about my battling!");
						#scr_event_build_dialogue_debug("bort", NULL, "This stuff needs 2 work.");
						#var battle_text = "";
						#switch (irandom(3)) {
							#case 0: battle_text = "destroyed " + string(scr_quest_get_state("statKilledEnemies")) + " enemies so far!"; break;
							#case 1: battle_text = "cast a total of " + string(scr_quest_get_state("statZaubersCast")) + " zaubers so far!"; break;
							#case 2: battle_text = "taken " + string(scr_quest_get_state("statDamageTaken")) + " damage so far!"; break;
							#case 3: battle_text = "dealt " + string(scr_quest_get_state("statDamageDealt")) + " damage so far!"; break;
						#}
						#event_bct_chaiyapornThink01();
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "Battling? Well... you've " + string(battle_text));
						#scr_event_build_quest_state_add("chaiyapornBattle", 1);
					#}
					#break;
				#case 1:
					#var guns = scr_event_build_add_choice(choice, "How are my gun's?");
					#with (guns) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "How are my gun's?");
						#event_bct_chaiyapornThink01();
						#scr_event_build_dialogue_debug("bort", NULL, "need 2 display some info here!");
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "gun's");
						#scr_event_build_quest_state_add("chaiyapornBattle", 1);
					#}
					#break;
				#case 2:
					#var physique = scr_event_build_add_choice(choice, "How's my physique?");
					#with (physique) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "How's my physique?");
						#scr_event_build_dialogue_debug("bort", NULL, "need 2 display some info here!");
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "physique");
						#scr_event_build_quest_state_add("chaiyapornBattle", 1);
					#}
					#break;
				#case 3:
					#var strategy = scr_event_build_add_choice(choice, "What's a good strategy?");
					#with (strategy) {
						#scr_event_build_dialogue(P_NAME, s_port_hoopz, "What's a good strategy?");
						#scr_event_build_dialogue_debug("bort", NULL, "need 2 display some info here!");
						#scr_event_build_dialogue("Chaiyaporn", gehirnport, "strat");
						#scr_event_build_quest_state("chaiyapornBattle", 0);
					#}
					#break;
			#}
			#
			#//--------------------------------------
			#// no more questions
			#//--------------------------------------
			#var nomore = scr_event_build_add_choice(choice, "That's all, no questions.");
			#with (nomore) {
				#scr_event_build_dialogue(P_NAME, s_port_hoopz, "That's all, no questions from me.");
				#// haven't asked a real question!
				#if (scr_quest_get_state("chaiyapornState") == 1) {
					#scr_event_build_dialogue("Brainfan One", NULL, "Boo! Boo! Ask some questions!");
					#scr_event_build_dialogue("Brainfan Two", NULL, "He already knows everything about us!");
					#scr_event_build_dialogue("Brainfan One", NULL, "We. Want. More. Feats!");
				#}
				#scr_event_build_quest_state("chaiyapornLoop", 0);
				#scr_event_build_end();
			#}
			#scr_event_build_quest_state_add("chaiyapornCount", 1);
			#scr_event_build_execute_event_script(event_bct_chaiyaporn01);
		#}
		#
		#scr_event_advance(event);
	#}
	#
	#
	#
	#
	#// chaiyaporn think!
	#
	#/*scr_event_build_dialogue("Chaiyaporn", NULL, "Scanning memory banks... calculating possibilities... widening perception...");
	#//scr_event_build_wait(3);
	#//scr_event_build_animation_play_and_set(o_gehirnkind01, "think", "idle");
	#scr_event_build_wait(0.3);
	#//scr_event_build_play_sound();
	#scr_event_build_wait_for_actions();

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
