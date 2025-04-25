extends ColorRect

## 24-04-25 Wow.... this wont be fun.
# check Marquee

const MARQUEE_COLOR := {
	"Cuchulainn": global.textcolorCuchulainn,
	"Hoopz Banter": global.textcolorHoopzBanter,
	"Quest": global.textcolorSidequest,
	"Cyberdwarf": global.textcolorCyberdwarf,
	"Random": global.textcolorFlavor,
	"Curses": global.textcolorCurses,
	"Time": global.textcolorTime,
	"Hoopz Hit": global.textcolorHoopzDamage,
	"Quote": global.textcolorQuote,
	"Hoopz Candy": global.textcolorHoopzCandy,
	"Encounter": global.textcolorEncounter,
}

const MARQUEE_LIST := {
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

########################/
##Hoopz Quest Tracker ##
########################/

##NOTE: Only quest variables can be checked here, no time db, or other checks
##All quest checks MUST be true for it to do the quest marquee

##################################################################
##@@@@@@@@          TIR NA NOG MARQUEES
##################################################################

##Wilmer Quest ##
	"Quest": 
		{ "I need to pay Mr. Wilmer's rent!": 						[ ["wilmerEvict", "==", "1"], ["mortgageDoorRealize", "==", "0"] ] },
		{ "I forgot to pay the rent! I gotta check on Wilmer.": 	[ ["wilmerEvict", "==", "1"], ["mortgageDoorRealize", "==", "1"] ] },

##LONGINUS
		{ "I wonder where LONGINUS is?": 							[ ["knowLONGINUSTnn", "==", "1"] ] },
		{ "I need to get to the LONGINUS door... The sewers?": 
			[ ["knowLONGINUSTnn", "==", "2"] ]
			},
	"Quest": "Dr. Liu wants some Duergar urine.":
	["govQuest": "==": "2"],
	"Quest": "Time to get the golden vial to Dr. Liu.":
	["govQuest": "==": "3"],
##"Quest": "There's a new governor in town... ME! A speech is in order.":
##   "govQuest": "==": "5",
"Quest": "I need the dossier from the Governor's Mansion!":
["govQuest": "==": "5"],

##LUGNER
"Quest": "I should talk to Guiseppi at the church.":
["lugnerQuest": "==": "3"],
"Quest": "I need to meet Slag at the Warehouse.":
["lugnerQuest": "==": "5"],
"Quest": "I need to meet Lugner at the Warehouse.":
["lugnerQuest": "==": "6"],

##GUTTERHOUND
"Quest": "Gotta find a safehouse for Gutterhound, he's robbing the bank soon.":
["gutterhoundQuest": "==": "4"],
"Quest": "OK, got the safe house for Gutter. I need to get back to him soon.":
["gutterhoundQuest": "==": "5"],
"Quest": "Flub the safe house. I need to get back to Gutterhound soon.":
["gutterhoundQuest": "==": "6"],

##ADBUL GAFUR
"Quest": "I wonder if Abdul-Gafur has that item ready for me...":
["abdulOffer": "==": "5"],
"Quest": "I wonder if Abdul-Gafur has that spear ready for me...":
["abdulOffer": "==": "6"],
"Quest": "Ugh, now I need to find Zola, what a scam!":
["abdulOffer": "==": "7"],

##BBTX
"Quest": "I wonder if I should get back and help Uschi get a bball game together.":
["uschiState": "==": "1"],
"Quest": "Gotta find a 3rd baller for the bball game!":
["uschiBall": "==": "2"],
"Quest": "Now I gotta challenge a Duergar to a bball game! Mamma Mia!":
["uschiBall": "==": "3"],
"Quest": "Gotta let Uschi know the Duergars will play a bball game!":
["uschiBall": "==": "4"],

##Add in hook where you know of rebels

##Gelasio and Jindrich
"Quest": "Should I approach Gelasio about his 'shady dealings'?": 
["gelasioDuergar": "==": "2"],
["gelasioState": "<": "4"],
"Quest": "I wonder if I can find more info for Gelasio...": 
["gelasioState": "==": "2"],
"Quest": "I agreed to look for Augustine for Gelasio.": 
["gelasioState": "==": "3"],
"Quest": "I found Augustine! I should tell Gelasio.": 
["baldoState": "==": "4"],

##Kelpster ##
"Quest": "Hmmm... Fruits for Kelpster...": 
["kelpsterState": "==": "2"],
["fruitbasketTake": "!=": "2"],

##Community Service - Cornrow and Juicebox ##
"Quest": "There's fruits at Granny's house...": 
["comServ": "==": "2"],
["fruitbasketTake": "==": "0"],

"Quest": "These fruits will feed a lot of kids!": 
["comServ": "==": "2"],
["fruitbasketTake": "==": "1"],
["kelpsterFruit": "==": "0"],

"Quest": "The Candy Shop has Juicebox's change...": 
["comServ": "==": "4"],

"Quest": "I should return Juicebox's change...": 
["comServ": "==": "5"],

"Quest": "The church Granny needs her medicine.": 
["comServ": "==": "6"],
["vivianState": "==": "0"],
"Quest": "Vivian needs her medicine.": 
["comServ": "==": "6"],
["vivianState": ">=": "1"],

"Quest": "I better return to Mr. Cornrow.": 
["comServ": "==": "7"],

## Eric Pet Quest ##
## ericQuest = 2 is Eric's quest has been accepted.
"Quest": "I wonder if anyone is hiring?": 
"ericQuest": "==": "2",
## ericQuest = 3 is you've found the pet store and talked to the owner.
## ericQuest = 4 is you've told Eric about the resume but still need to do it.
"Quest": "I found a place for Eric to work!": 
"ericQuest": ">=": "3":
"ericQuest": "<=": "4",
##ericQuest = 5 is you've finished the resume.
"Quest": "Time to hand in Eric's resume...": 
"ericQuest": "==": "5",
##ericQuest = 6 is cuthbert hated your resume. (not hired)
##ericFailed = 1 when you broke the bad news
"Quest": "Yipe! Eric isn't going to be happy...": 
"ericQuest": "==": "6":
"ericFailed": "==": "0",
##ericQuest = 7 is cuthbert liked the resume a little. (hired)
##ericQuest = 8 is cuthbert liked the resume a lot. (hired)
"Quest": "I can't wait to share the good news with Eric!": 
"ericQuest": ">=": "7":
"ericQuest": "<=": "8",

##Cyberspear Quest
"Quest": "Gotta find the AI Ruins!": "csQuest": "==": "1",
"Quest": "Somewhere in the AI Ruins is the Cyberspear!": "csQuest": "==": "2",
"Quest": "Gotta tell Cyberdwarf the altar is empty!": "csQuest": "==": "4",
"Quest": "I wonder how deep the Cyberspear Rabbit Hole Goes...": "csQuest": "==": "5",
"Quest": "Cyberdwarf will be so proud I got part of the Cyberspear.": "csQuest": "==": "7",

##Duergars
"Quest": "I wonder where I can get those Garlics for Jeltsje.": "jeltsjeGarlics": "==": "1",

##Cyberdwarf
"Cyberdwarf": "It'sa me, Cyberdwarf.",
"Cyberdwarf": "Cuchulainn can go suck an egg.",
"Cyberdwarf": "Only applebottoms.",
"Cyberdwarf": "Remember to floss.",

##Random / Flavor Text
"Random": "A tingle runs down your spine.",
"Random": "The air has a dank smell.",
"Random": "You take a deep breath.",
"Random": "A breeze passes over.",
"Random": "Something feels off.",
"Random": "You redouble your efforts.",
"Random": "You gather your thoughts.",
"Random": "Tick tock.",
"Random": "Who let the dogs in?",

## Quotes
Marquee("add list":  1,
"Quote": "Fortune favors the bold.",
"Quote": "The only constant is change.",
"Quote": "You don't need a reason to help people.",
"Quote": "Where's the beef?",
"Quote": "Favorite sport: badminton.",
"Quote": "Stay frosty.",
"Quote": "Welcome to the Dungle.",

## Curses
"Curses": "You are still cursed by the mummy.": "curseMummy": "!=": "0",
"Curses": "You can't escape what's inside you... MORGELLONS.": "curseMorgellons": "!=": "0",

## Time - Do not edit or move, the text used for time is found under the "queue" section of this script
"Time": "DO TIME",

############/##INACTIVE LISTS - All inactive lists must be placed after all active lists have been declared ##############/
## Hoopz Hit
"Hoopz Hit": "I'm hit!",
"Hoopz Hit": "Ughhhh!",
"Hoopz Hit": "Ouchie!",

## Hoopz Candy
"Hoopz Candy": "Gulp!!!",
"Hoopz Candy": "Munch!!!",
"Hoopz Candy": "Chomp!!!",

## Encounter
"Encounter": "A <0> approaches.",
"Encounter": "A <0> appears.",
"Encounter": "You see a <0>.",
}

@onready var hud_marquee_text: Label = $hud_marquee_text

const MARQUEE_SIZE := 154.0
const MARQUEE_SPEED := 16.0

func _physics_process(delta: float) -> void:
	hud_marquee_text.position.x = wrapf(hud_marquee_text.position.x - MARQUEE_SPEED * delta, -MARQUEE_SIZE + 222, 222 * 1.75 )
