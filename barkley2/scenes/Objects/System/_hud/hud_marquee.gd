extends ColorRect

## 24-04-25 Wow.... this wont be fun.
# check Marquee

const MARQUEE_COLOR := {
	"Cuchulainn": 		Color8(40, 90, 220),
	"Hoopz Banter": 	Color8(255, 255, 255),
	"Quest": 			Color8(140, 160, 255),
	"Cyberdwarf": 		Color8(255, 185, 80),
	"Random": 			Color8(255, 230, 255),
	"Curses": 			Color8(255, 210, 210),
	"Time": 			Color8(220, 220, 20),
	"Hoopz Hit": 		Color8(255, 50, 100),
	"Quote": 			Color8(230, 255, 240),
	"Hoopz Candy": 		Color8(100, 50, 255),
	"Encounter": 		Color8(255, 255, 150),
	}

const MARQUEE_QUESTS := {
	########################/
##Hoopz Quest Tracker ##
########################/

##NOTE: Only quest variables can be checked here, no time db, or other checks
##All quest checks MUST be true for it to do the quest marquee

##################################################################
##@@@@@@@@          TIR NA NOG MARQUEES
##################################################################

##Wilmer Quest ##
	"I need to pay Mr. Wilmer's rent!": 						[ ["wilmerEvict", "==", "1"], ["mortgageDoorRealize", "==", "0"] ],
	"I forgot to pay the rent! I gotta check on Wilmer.": 		[ ["wilmerEvict", "==", "1"], ["mortgageDoorRealize", "==", "1"] ],

##LONGINUS
	"I wonder where LONGINUS is?": 							[ ["knowLONGINUSTnn", "==", "1"] ],
	"I need to get to the LONGINUS door... The sewers?": 	[ ["knowLONGINUSTnn", "==", "2"] ],
	"Dr. Liu wants some Duergar urine.":					[ ["govQuest", "==", "2"] ],
	"Time to get the golden vial to Dr. Liu.":				[ ["govQuest", "==", "3"] ],
	
##"There's a new governor in town... ME! A speech is in order.":
##   "govQuest", "==", "5",
	"I need the dossier from the Governor's Mansion!":			[ ["govQuest", "==", "5"] ],

##LUGNER
	"I should talk to Guiseppi at the church.": 				[ ["lugnerQuest", "==", "3"] ],
	"I need to meet Slag at the Warehouse.": 					[ ["lugnerQuest", "==", "5"] ],
	"I need to meet Lugner at the Warehouse.": 					[ ["lugnerQuest", "==", "6"] ],

##GUTTERHOUND
	"Gotta find a safehouse for Gutterhound, he's robbing the bank soon.": 	[ ["gutterhoundQuest", "==", "4"] ],
	"OK, got the safe house for Gutter. I need to get back to him soon.": 	[ ["gutterhoundQuest", "==", "5"] ],
	"Flub the safe house. I need to get back to Gutterhound soon.": 		[ ["gutterhoundQuest", "==", "6"] ],

##ADBUL GAFUR
	"I wonder if Abdul-Gafur has that item ready for me...": 	[ ["abdulOffer", "==", "5"] ],
	"I wonder if Abdul-Gafur has that spear ready for me...": 	[ ["abdulOffer", "==", "6"] ],
	"Ugh, now I need to find Zola, what a scam!": 				[ ["abdulOffer", "==", "7"] ],

##BBTX
	"I wonder if I should get back and help Uschi get a bball game together.": 		[["uschiState", "==", "1"]],
	"Gotta find a 3rd baller for the bball game!": 									[["uschiBall", "==", "2"]],
	"Now I gotta challenge a Duergar to a bball game! Mamma Mia!": 					[["uschiBall", "==", "3"]],
	"Gotta let Uschi know the Duergars will play a bball game!": 					[["uschiBall", "==", "4"]],

##Add in hook where you know of rebels

##Gelasio and Jindrich
	"Should I approach Gelasio about his 'shady dealings'?": 		[["gelasioDuergar", "==", "2"], ["gelasioState", "<", "4"]],
	"I wonder if I can find more info for Gelasio...": 				[["gelasioState", "==", "2"]],
	"I agreed to look for Augustine for Gelasio.": 					[["gelasioState", "==", "3"]],
	"I found Augustine! I should tell Gelasio.": 					[["baldoState", "==", "4"]],

##Kelpster ##
	"Hmmm... Fruits for Kelpster...": 				[["kelpsterState", "==", "2"],["fruitbasketTake", "!=", "2"]],

##Community Service - Cornrow and Juicebox ##
	"There's fruits at Granny's house...": 			[["comServ", "==", "2"],["fruitbasketTake", "==", "0"]],
	"These fruits will feed a lot of kids!": 		[["comServ", "==", "2"],["fruitbasketTake", "==", "1"],["kelpsterFruit", "==", "0"]],
	"The Candy Shop has Juicebox's change...": 		[["comServ", "==", "4"]],
	"I should return Juicebox's change...": 		[["comServ", "==", "5"]],
	"The church Granny needs her medicine.": 		[["comServ", "==", "6"],["vivianState", "==", "0"]],
	"Vivian needs her medicine.": 					[["comServ", "==", "6"],["vivianState", ">=", "1"]],

	"I better return to Mr. Cornrow.": 					[["comServ", "==", "7"]],

## Eric Pet Quest ##
## ericQuest = 2 is Eric's quest has been accepted.
	"I wonder if anyone is hiring?": 								[["ericQuest", "==", "2"]],
## ericQuest = 3 is you've found the pet store and talked to the owner.
## ericQuest = 4 is you've told Eric about the resume but still need to do it.
	"I found a place for Eric to work!": 							[["ericQuest", ">=", "3"], ["ericQuest", "<=", "4"]],
##ericQuest = 5 is you've finished the resume.
	"Time to hand in Eric's resume...": 							[["ericQuest", "==", "5"]],
##ericQuest = 6 is cuthbert hated your resume. (not hired)
##ericFailed = 1 when you broke the bad news
	"Yipe! Eric isn't going to be happy...": 						[["ericQuest", "==", "6"],["ericFailed", "==", "0"]],
##ericQuest = 7 is cuthbert liked the resume a little. (hired)
##ericQuest = 8 is cuthbert liked the resume a lot. (hired)
	"I can't wait to share the good news with Eric!": 				[["ericQuest", ">=", "7"], ["ericQuest", "<=", "8"]],

##Cyberspear Quest
	"Gotta find the AI Ruins!": 									[["csQuest", "==", "1"]],
	"Somewhere in the AI Ruins is the Cyberspear!": 				[["csQuest", "==", "2"]],
	"Gotta tell Cyberdwarf the altar is empty!": 					[["csQuest", "==", "4"]],
	"I wonder how deep the Cyberspear Rabbit Hole Goes...": 		[["csQuest", "==", "5"]],
	"Cyberdwarf will be so proud I got part of the Cyberspear.": 	[["csQuest", "==", "7"]],

##Duergars
	"I wonder where I can get those Garlics for Jeltsje.": 			[["jeltsjeGarlics", "==", "1"]],

}

const MARQUEE_LIST_ACTIVE := {
##LINES MUST BE AT LEAST 7 CHARACTERS AND SHOULD NOT EXCEED 40

############## ACTIVE LISTS - All active lists must be placed here ##############
	## Cuchulainn
	"Cuchulainn": 	
		["Beauhiehiehie!",
		"K'wahuwehuwehuwe!",
		"Gweuheuheuheu!",
		"Have a ROTTEN day!",
		"You'll never stop me!"],

	## Hoopz Banter
	"Hoopz Banter": 	
		["I want candy...",
		"I like vidcons.",
		"I like bikes.",
		"Who... am I?", ##only if not known
		"Gamers MUST unite.",
		"Ugh. This is so hard.",
		"Do I get a prize too?",
		"Heh."],


##Cyberdwarf
	"Cyberdwarf": 	
		["It'sa me, Cyberdwarf.",
		"Cuchulainn can go suck an egg.",
		"Only applebottoms.",
		"Remember to floss."],

##Random / Flavor Text
	"Random": 	
		["A tingle runs down your spine.",
		"The air has a dank smell.",
		"You take a deep breath.",
		"A breeze passes over.",
		"Something feels off.",
		"You redouble your efforts.",
		"You gather your thoughts.",
		"Tick tock.",
		"Who let the dogs in?"],

## Quotes
	"Quote": 	
		["Fortune favors the bold.",
		"The only constant is change.",
		"You don't need a reason to help people.",
		"Where's the beef?",
		"Favorite sport: badminton.",
		"Stay frosty.",
		"Welcome to the Dungle."],

# Curses TODO DEAL WITH THESE.
## "Curses": "You are still cursed by the mummy.": "curseMummy": "!=": "0",
## "Curses": "You can't escape what's inside you... MORGELLONS.": "curseMorgellons": "!=": "0",

## Time - Do not edit or move, the text used for time is found under the "queue" section of this script
	"Time": 		
		["DO TIME"],
}

const MARQUEE_LIST_INACTIVE := {
############/##INACTIVE LISTS - All inactive lists must be placed after all active lists have been declared ##############/
## Hoopz Hit
	"Hoopz Hit": 	
		["I'm hit!",
		"Ughhhh!",
		"Ouchie!"],

## Hoopz Candy
	"Hoopz Candy": 	
		["Gulp!!!",
		"Munch!!!",
		"Chomp!!!"],

## Encounter
	"Encounter": 	
		["A <0> approaches.",
		"A <0> appears.",
		"You see a <0>."],
}

@onready var hud_marquee_text: RichTextLabel = $hud_marquee_text

const MARQUEE_SIZE := 154.0
const MARQUEE_SPEED := 16.0

var msg_buffer : Array[ Array ] = []

var t := 0.0

func check_duplicated_msg( msg : String ) -> bool:
	## check if the message already exists on the buffer.
	for m : Array in msg_buffer:
		if m.front() == msg + "     ":
			return true
	return false

func get_cool_marquee_message() -> Array:
	#var msg := {"PLACEHOLDER": Color.HOT_PINK}
	var msg := []
	
	## check Marquee line 359
	if randi_range(0,99) < 25:
		## get quest msg.
		for try in 10:
			var my_msg : String = MARQUEE_QUESTS.keys().pick_random()
			var is_valid		:= false
			
			for conditions : Array in MARQUEE_QUESTS[my_msg]:
				# look at me, getting fancy names for vars and shit. they are probably wrong anyway.
				var operand 		= conditions[0]
				var comparator 		= conditions[1]
				var operator 		= conditions[2]
				
				match comparator:
					"==":
						is_valid = int( B2_Playerdata.Quest(operand) ) == int(operator)
					">=":
						is_valid = int( B2_Playerdata.Quest(operand) ) >= int(operator)
					"<=":
						is_valid = int( B2_Playerdata.Quest(operand) ) <= int(operator)
					"!=":
						is_valid = int( B2_Playerdata.Quest(operand) ) != int(operator)
					
				## AND operation
				if not is_valid:
					break
						
			if is_valid:
				if not check_duplicated_msg( my_msg ):
					print( "Marquee: Added quest msg - ", my_msg )
					msg = [ my_msg, MARQUEE_COLOR["Quest"] ]
		
	# check Marquee line 598
	#if "fighting a boss":
		# TODO
		
	if msg.is_empty():
		# get random msg
		var my_msg : String = MARQUEE_LIST_ACTIVE.keys().pick_random()
		
		## check if the message already exists on the buffer.
		for try in 10:
			if check_duplicated_msg(my_msg):
				my_msg = MARQUEE_LIST_ACTIVE.keys().pick_random()
			else:
				break
		
		if my_msg == "Time":
			msg = [ Text.pr("THE TIME IS " + str( B2_ClockTime.time_display() ) ), MARQUEE_COLOR["Time"] ]
		else:
			msg = [ MARQUEE_LIST_ACTIVE[my_msg].pick_random(), MARQUEE_COLOR[my_msg] ]
	
	msg[0] += "     " ## Add padding to the msg. Check Marquee line 530
	
	return msg

func _physics_process(_delta: float) -> void:
	#hud_marquee_text.position.x = wrapf(hud_marquee_text.position.x - MARQUEE_SPEED * delta, -MARQUEE_SIZE + 222, 222 * 1.75 )
	
	t += 0.1 # MARQUEE_SIZE * delta
	
	if t >= 1.0:
		t = 0.0
			
		hud_marquee_text.clear()
		## Draw all buffered messages to the marquee
		for msg : Array in msg_buffer:
			hud_marquee_text.push_color( msg.back() )
			hud_marquee_text.append_text( msg.front().to_lower() )
			hud_marquee_text.pop()
			
		## remove the first letter from the fist message to simulate a scroll
		if not msg_buffer.is_empty():
			var first_msg : String = msg_buffer[0][0]
			if first_msg == "" or first_msg.length() == 1:
				## No message left, remove the message data.
				msg_buffer.remove_at(0)
			else:
				msg_buffer[0][0] = first_msg.erase(0) # lol
		
		## add new message to the buffer.
		if msg_buffer.size() < 10:
			msg_buffer.append( get_cool_marquee_message() )
			#print( "Marquee: Poping new messge to the pile!")
			
	## Smooth scrolling
	var weird_char_offset := 6.0
	hud_marquee_text.position.x = 226.0 - weird_char_offset * t
	
