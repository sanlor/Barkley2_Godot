## This is a VERY BAD resource. Is so messy and I keep forgeting what it even does.
# FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME FIXME

extends Resource
class_name B2_Database

# check scr_money_db()
# check scr_time_db()

# Factorio Space Age is pretty good. its been a few weeks/months since I last worked on this.

## Data related to money. Maybe this should be a Json or other kind of DB? yes, anything can be a DB if you are dumb enough.
## Not money anymore, every "DB" is a dictionary now. Dictionaries can be DBs too.

const money : Dictionary[String, int] = {
	##--------------------------------------------------------------------
	##  TIR NA NOG ~ the HomeTown of the Dwarfs ~
	##--------------------------------------------------------------------
	# Dubre's Map
	"dubreMap01": 10, # the cost of the Tir na nOg map on first offer
	"dubreMap02": 15,# randi_range(0,20) + 1
	# Wilmer Mortgage
	"wilmerMortgage": 100, # base cost of wilmer's mortgage
	"wilmerMortgageBonus": 30, # bonus money included for hoopz
	"wilmerMortgageTotal": 130, # scr_money_db("wilmerMortgage") + scr_money_db("wilmerMortgageBonus"),
	"wilmerSurcharge": 20,
	"vikingstadDemand1": 130, # scr_money_db("wilmerMortgage") + scr_money_db("wilmerSurcharge"),
	"vikingstadTease": 130,
	## TODO: Add the rest of the variables.
	# Data below have terrible formating, but it was the easiest method to copy paste the data.
	
	## Kelpster - TnN Business District House - event_tnn_kelpster01
	"kelpsterArtifact": ##Sells you "Creppy Ghoulie IV diskette" for this amount
	50,
	## Cuthbert - Pet Shop
	"cuthbertFee": ## As the Governor, you have the option to get this fee from Cuthbert
	120,
	## Jacques - TnN (Is he placed?) - event_tnn_jacques01 - 500 was default
	"jacquesRent": ## As the Governor, Jacques asks if you can pay his rent for him as he was late
	100,
	## Slag - TnN - 7 was default per dwarf head
	"slagDwarfPrice": ## The amount you get per dwarf head
	7,
	## Guillaume - TnN Residential - event_tnn_guillaume01 - 5 was default tip
	"guillaumeTip": ##You can tip him. Should be at least 2, as it says "tip x neuro-shekels?" as plural
	5,
	## Ooze Fee for playing bball
	"oozeBallFee":
	20,
	## Benedict sells fishing Pole
	"benedictPole":
	35,
	## Fadima - TnN Housing - event_tnn_fadima01
	## If you plan on editing the value from 25
	## TODO: edit the other values that Fadima notes
	"fadimaCharity": 8,  ## You can buy a "chair"
	"fadimaMatt": 50,  ## Matthias price
	"fadimaGov": 60,  ## Governor price
	"fadimaOrig": 40,  ## First conversation price
	"fadimaOne": 25,  ## Post-Castor offer
	"fadimaTwo": 20,  ## Post-Castor offer 2

	## Gutterhound - TnN
	"gutterhoundTheft":  ## How much you get from Gutterhound (your cut)
	115,
	########## Gelasio Quest ##########
	## Jindrich - TnN Market - event_tnn_jindrich01
	"apricotPrice": ##You can buy Jindrich an apricot, which gives you information about the turncoat Gelasio
	37,
	## Abdul Gafur - TnN Market District - event_tnn_abdulGafur01
	"abdulBigOffer": ## full price of the item
	200, 
	"abdulLilOffer": ## bartered value that goes a little lower (be sure to change Half as well!)
	150, 
	"abdulHalfOffer": ## half now half later price
	75, 

	########## Cornrow / Juicebox - Community Service ##########
	## Cornrow - TnN Market - event_tnn_cornrow01
	"cornrowCornucopia": ## How much you get for giving him the fruit basket
	8, 
	## Mortimer - TnN Market - event_tnn_mortimer01
	"mortimerCandyCorn": ## Can buy this, or get it for free if you rob Mortimer first
	15, 
	"mortimerJawbreaker": ## Can buy this, or get it for free if you rob Mortimer first
	25, 
	"mortimerNonpareil": ## Can buy this, or get it for free if you rob Mortimer first
	40, 
	"mortimerRobbery": ## How much you get for robbing him during Community Service
	63, 
	"mortimerRobberyCut": ## How much you get for talking to Cornrow
	12, 
	## Milagros - TnN Market - event_tnn_milagros01
	## Milagros also gives you vidcons and chips. Edit her stuff to make more sense.
	"milagrosSuicide": ## What she gives you for turning in the suicide note.
	10, 
	"milagrosEric": ## What she gives you for turning in Eric's Manifesto
	10, 
	## Gunsalesman - TnN Market Roof - event_tnn_gunsalesman
	## Refer to scr_gun_db to see which guns he is selling
	"gunsalesmanMap": ##Price of Sewers Floor 1 Map
	10, 
	"gunsalesmanGun1": ##Price of Gun 1 from bad list
	15, 
	"gunsalesmanGun2": ##Price of Gun 2 from bad list
	12, 
	"gunsalesmanGun3": ##Price of Gun 3 from bad list
	10, 
	"gunsalesmanGun4": ##Price of Gun 1 from good list
	150, 
	"gunsalesmanGun5": ##Price of Gun 2 from good list
	75, 
	"gunsalesmanGun6": ##Price of Gun 3 from good list
	70, 
	## Aelfleda - TnN Residential District - event_tnn_aelfleda01
	"aelfledaFull": ## Total cost of Aelfleda's Bill
	87 + 20, #scr_money_db("aelfledaRent") + scr_money_db("vikingstadAelfleda"), 
	"aelfledaRent": ## How much Aelfleda Owes
	87, 
	"vikingstadAelfleda": ##Extortion from Vikingstad
	20, 
	## Egidius - TnN Residential District
	## Prices of jerkins, deposit for "try-before-you-buy"
	"egidiusJerkin1": ## Price of Jerkin 1 - Bottlecap Jerkin
	50, 
	"egidiusJerkin2": ## Price of Jerkin 2 - Eggcrate Jerkin
	50, 
	"egidiusJerkin3": ## Price of Jerkin 3 - Monofilament Jerkin
	50, 
	"egidiusJerkin4": ## Price of Jerkin 4 - Vestal Jerkin
	50, 
	"egidiusDeposit": ## Deposit to try out a jerkin
	25, 
	## Zola - sells the "Pravda Tir na nOg"
	"tnnPravda":
	7, 
	"zolaSpear":
	250, 
	"zolaSpearLoss":
	150, 
	## Clinic ## Cyberization cost ##
	"tatijana20":
	60, 
	##--------------------------------------------------------------------
	##  BRAIN CITY ~ mega City in the Swamps ~
	##--------------------------------------------------------------------
	##Protesters    
	"oozeProtesters": ## Payoff to remove the Protesters from Guilderbergs in bct_ooze01
	50, 
	## Wedding Quest Bandmates
	"garciaChange":
	5, 
	"cccc": 0, 
	"dddd": 0, 
	"eeee": 0, 
	"ffff": 0, 
	"gggg": 0, 
	"hhhh": 0, 
	"iiii": 0, 
	"jjjj": 0, 
	"kkkk": 0, 
	"llll": 0, 
	"mmmm": 0, 
	"nnnn": 0, 
	"oooo": 0, 
	"pppp": 0, 
	"qqqq": 0, 
	"rrrr": 0, 
	"ssss": 0, 
	"tttt": 0, 
	"uuuu": 0, 
	"vvvv": 0, 
	"wwww": 0, 
	"xxxx": 0, 
	"yyyy": 0, 
	"zzzz": 0, 
	##Oligarchy Online
	"ooUnlimited":
	99, 
	"ooHourly":
	39, 
	"ooPayp_Reup":
	9, 
	## VRW Nene's milk and tab
	## You must pay for two different milks, then Nene's tab to get LONGINUS knock
	"neneMilk1": 3, 
	"neneMilk2": 10, 
	"neneTab": 50, 
	## Oliver Twists Organ trade ##
	"organPrice": 8, 
	## Hans Katzenjammers protection money to Dracula ##
	"hansTribute": 124, 
	##--------------------------------------------------------------------
	##  Industrial Park
	##--------------------------------------------------------------------    
	##The Tontine Kunigunde has entered into
	"tontineFull":
	250, 
	##Your cut of the Tontine (half of 
	"tontineCut":
	250 * 1, #scr_money_db("tontineFull") * 0.5, 
	## Chup sales ##
	"brimbleChupNote": 10, 
	"sureshChupShekel": 26, 
	"chupTop": 40, 
	"chupMid": 30, 
	"chupLow": 20,   
	## Filips train ticket ##
	"filipTicket": 75, 
	## Grieg train ticket ##
	"griegTicket": 50, 

	##--------------------------------------------------------------------
	##  MINES ~ a shiuthole ~
	##--------------------------------------------------------------------
	## Biscuits gift ##
	"biscuitGift": 89, 
	## Treasure at Gilbert's Peak ##
	"gilbert": 300, 

	##---------------------
	##  WASTELANDS
	## --------------------

	## Money making game ## Upper limit is the maximum you can ever squeeze out of the guy in total, then there is the cost to play, and the four prices ##
	"moneyMakingGameUpperLimit": 500, 
	"moneyMakingGameCost": 10, 
	"moneyMakingResult01": -40, 
	"moneyMakingResult02": -10, 
	"moneyMakingResult03": +20, 
	"moneyMakingResult04": +50, 

	## Colloidal Silver from old man Jedidiah
	"oldmanColloidal": 75, 

	## Fortune teller prices ##
	"fortuneTeller": 12, 

	##---------------------
	##  DOJO / ICELANDS
	## --------------------

	## Treasure chest in the wilderness ##
	"money_iceland": 350, 

	## Dojo meditation prices ##
	"dojoMeditation_1st": 50,  
	"dojoMeditation_2nd": 100,  
	"dojoMeditation_3rd": 200,   
}

## Data related to time. This sistem is very weird, no Idea how its supposed to work.
## Time in this game ssems to make sense. its a 24h period.
# check ClockTime()

const time := {
	## Add all time definitions here
	## Times with 1 argument can only return "before" or "after"
	## try to arrange these by area, and then by chronological order!
	
	##################
	### TIR NA NOG ###
	##################
	"milagrosOpen": 		{"start":2.9, "end":24.0},
	"mortgageClosed": 		{"start":0.9, "end":24.0},
	## scr_time_db("add", "wilmerEviction", 2); - Not needed as mortgageClosed already does the job
	## scr_time_db("add", "bootybassClosed", 3.0); - This is not used anywhere
	## scr_time_db("add", "petClosed", 3.8); - This is not used anywhere
	## scr_time_db("add", "gutterhoundRobbery", 3.8); - This is not used anywhere
	"tnnCurfew": 			{"start":3.8, "end":4.8},
	"fedeDiagnose": 		{"start":3.0, "end":24.0}, ## When fede appears sitting, sad
	"fedeSurgery": 			{"start":4.0, "end":24.0}, ## Fede is in hospital bed, arm in sewers
	
	#################################
	### Operation Reverse Dunkirk ###
	#################################
	"opX_slagSocial": 		{"start":7.0, "end":12.9},
	"opX_Foopba": 			{"start":13.2, "end":16.0},
	"opX_Chandragupta": 	{"start":0.9, "end":24.0},

	"swampDuergars": 		{"start":13.0, "end":24.0},
	"industrialTurrets": 	{"start":12.0, "end":24.0}, ## Point at which industrial parks battery dies and the turrets stop working ## Obsolete now
}

## List of item names, sprite ID and descriptions.
## Lots of item names and descripties where disabled / commented
const items := { 
	## Misc items
	"Lock Pick": { "id": 0, "description": "Pick your locks with this handy device." }, 
	"Firaga": { "id": 0, "description": "Junction to a GF for extra stats." }, 
	"Golden Key": { "id": 0, "description": "A key fit for a king." }, 
	
	## Sewer Items
	"Fiscian Gut's": { "id": 1, "description": "Gut's from an aquatic creature." }, 
	"Garlics": { "id": 2, "description": "Exquisite veggies (to some...)" }, 
	"Sewer Butter": { "id": 3, "description": "Butter from a barrel. *OFFENSIVE*" }, 
	"Fishing Pole": { "id": 13, "description": "Catch gun'sfish. Pro-am Certified." }, 
	"Gorm-Stone": { "id": 0, "description": "Mystical stone oozing with holy power." }, 
	"Sewer Seed": { "id": 0, "description": "Slimy seeds you can plant in dirt." }, 
	
	## Lures
	"F-Lure Bayou Goopster": { "id": 17, "description": "Disgustingly goopy lure that sucks." }, 
	"F-Lure Devil's Drifter": { "id": 18, "description": "This lure was forged by Old Scratch himself." }, 
	"F-Lure Tiger Tom": { "id": 19, "description": "Fierce lure imbued with the soul of a tiger." }, 
	"F-Lure Ladybug": { "id": 20, "description": "Majestic lure for a majestic fisherman." }, 
	"F-Lure Daverdale": { "id": 21, "description": "Fossilized remains of the eidolon Daverdale." }, 
	"F-Lure Dread Wonthy": { "id": 22, "description": "A lure completely without mercy." }, 
	
	## TNN
	"Dragon Lord Gemstone": { "id": 4, "description": "The eye of the Fire Drake shines naught as bright." }, 
	"WristCONP2000": { "id": 5, "description": "Has all the latest gadgets and gizmos." }, 
	"Wilmer's Bones": { "id": 6, "description": "Soul cannot rest lest these bones are buried." }, 
	"Sterile Vial": { "id": 7, "description": "Once used by Vampyre Prince Drago." }, 
	"Duergar Urine": { "id": 8, "description": "Drago wants you to keep it." }, 
	"Fruit Basket": { "id": 9, "description": "Mangos, Mangosteens, Rambutans, et. al." }, 
	"Granny's Medicine": { "id": 10, "description": "A granny needs this." }, 
	"Bomb": { "id": 11, "description": "Military Grade Explosives: C- (passing)" }, 
	"Bolt Cutters": { "id": 12, "description": "Good at cutting bolts and nards." }, 
	
	## The Hooosegow
	"Pack of Smokes": { "id": 0, "description": "Smoking tobacco and feeding midlane causes caner." }, 
	"Military Grade M-80": { "id": 0, "description": "Let'er rip and pull back a stump." }, 
	"Pelekryte's Shiv": { "id": 0, "description": "Sharp and shiny, just like a star..." }, 
	"Suresh's Shiv": { "id": 0, "description": "Dirty and rusty, just like garbage..." }, 
	"Kunigunde's Shiv": { "id": 0, "description": "Hip and cool, just like a trend..." }, 
	
	## SWAMP
	"Card 3": { "id": 0, "description": "A mysterious card covered in feces. The text 'Card 3' is printed on it." }, 
	
	## Brian City <- NOTE Lol
	"Cuchukeycard": { "id": 0, "description": "Property of Cuchulainn. Wants it back." }, 
	
	## CC Items
	"Special Coin": { "id": 0, "description": "Lands on it's side when flipped..." }, 
	"Tuh, Ghost of Grandpa": { "id": 0, "description": "A mystical rune." }, 
	"Nip'pon, Apparition of Anime": { "id": 0, "description": "A mystical rune." }, 
	"M'kah, Spirit of Fire": { "id": 0, "description": "A mystical rune." }, 
	"Olop, Wraith of Riceballs": { "id": 0, "description": "A mystical rune." }, 
	"Dilly Dong Dong, Kelpie of Corn Cobs": { "id": 0, "description": "A mystical rune." }, 
	"Xatar, Phantom of Vidcons": { "id": 0, "description": "A mystical rune." }, 
	"As'hak, Haunt of Dwarfs": { "id": 0, "description": "A mystical rune." }, 
	"Esh'tek, Specter of Winter": { "id": 0, "description": "A mystical rune." }, 
	
	## Factory / Power Plant
	"Empty Influence Ovum": { "id": 15, "description": "A mystical chicken egg, waiting to be recharged." }, 
	"Influence Ovum": { "id": 16, "description": "A mystical chicken egg, surging with energy." }, 
	
	## Other
	"Senator's Letter": { "id": 0, "description": "Letter addressed to Michael Johnson." }, 
	"Cyberspear Piece": { "id": 0, "description": "Piece of a legendary instrument." }, 
	"Busted Ass Tuba": { "id": 0, "description": "Legendary Ass Tuba. Too bad it's busted." }, 
	
	## Humanators 
	"KOSMIChumanator": { "id": 0, "description": "Kosmically good humanator." }, 
	"BIOhumanator": { "id": 0, "description": "Bio-organic humanator." }, 
	"CYBERhumanator": { "id": 0, "description": "Cyberized humanator." }, 
	"MENTALhumanator": { "id": 0, "description": "Mindfreaking humanator." }, 
	"ZAUBERhumanator": { "id": 0, "description": "Zauberical humanator." }, 
	
	## Cgremlin Village
	"Youngster Skelly": { "id": 0, "description": "Biodegradeable Exoskeleton." }, 
	"Iron Crown of Jackson": { "id": 0, "description": "Jackson wore this one." }, 
	"Veil of Valanciunas": { "id": 0, "description": "The veil is yet to be lifted." }, 
	"Blood of Klisp": { "id": 0, "description": "100% authentic." }, 
	"Scala Iactus": { "id": 0, "description": "We have no idea what this is." }, 
	"Mandyblue": { "id": 0, "description": "Ah, yes, the legendary Mandyblue." }, 
	"Crown of Jalapenos": { "id": 0, "description": "A crown fit for a king!" }, 
	"Shroud of Ballin'": { "id": 0, "description": "Named after a medical condition." }, 
	"Grape-topped Grail": { "id": 0, "description": "Beaning utility." }, 
	
	## Undefined mess
	"Zauber Pistol": { "id": 0, "description": "Zauber Pistol" }, 
	
	"Guppy": { "id": 0, "description": "Guppy" }, 
	"Pike": { "id": 0, "description": "Pike" }, 
	"Carp": { "id": 0, "description": "Carp" }, 
	"Gun": { "id": 0, "description": "Gun" }, 
	"Item": { "id": 0, "description": "Item" }, 
	"Item2": { "id": 0, "description": "Item2" }, 
	"Useless Item": { "id": 0, "description": "description" }, 
	
	"Camera": { "id": 0, "description": "description" }, 
	"Turkey Feather": { "id": 0, "description": "Sacred memento from Zalatar." }, 
	
	"Tribune-Wrapped Item": { "id": 0, "description": "description" }, 
	"Mystery Item": { "id": 0, "description": "description" }, 
	"Derided Item": { "id": 0, "description": "description" }, 
	"Esteemed Item": { "id": 0, "description": "description" }, 
	
	"d:GLAZEr": { "id": 0, "description": "description" }, 
	
	"B1 Visitor Badge": { "id": 0, "description": "description" }, 
	"2F Visitor Badge": { "id": 0, "description": "description" }, 
	"3F Visitor Badge": { "id": 0, "description": "description" }, 
	"Tower Keycard": { "id": 0, "description": "description" }, 
	"Guilderberg Keycard": { "id": 0, "description": "description" }, 
	"Bronze Coin": { "id": 0, "description": "description" }, 
	"Silver Coin": { "id": 0, "description": "description" }, 
	"Gold Coin": { "id": 0, "description": "description" }, 
	"Durian Gaz": { "id": 0, "description": "description" }, 
	"LONGINUSFAKEITEM": { "id": 0, "description": "description" }, 
	"Guilderberg Deed": { "id": 0, "description": "description" }, 
	"W Seed": { "id": 0, "description": "description" }, 
	"Dreadfruit": { "id": 0, "description": "description" }, 
	"W Fruit": { "id": 0, "description": "description" }, 
	"Kirin Horn": { "id": 0, "description": "description" }, 
	"Snake Corpse": { "id": 0, "description": "description" }, 
	"Dwarf Skull": { "id": 0, "description": "description" }, 
	"Mandorla": { "id": 0, "description": "description" }, 
	"Alms Bowl": { "id": 0, "description": "description" }, 
	"Purified Alms Bowl": { "id": 0, "description": "description" }, 
	"Harmonious Alms Bowl": { "id": 0, "description": "description" }, 
	"Mystic Alms Bowl": { "id": 0, "description": "description" }, 
	"Ablution Bowl": { "id": 0, "description": "description" }, 
	"Humble Ablution Bowl": { "id": 0, "description": "description" }, 
	"Harmonious Ablution Bowl": { "id": 0, "description": "description" }, 
	"Mystic Ablution Bowl": { "id": 0, "description": "description" }, 
	"Singing Bowl": { "id": 0, "description": "description" }, 
	"Purified Singing Bowl": { "id": 0, "description": "description" }, 
	"Humble Singing Bowl": { "id": 0, "description": "description" }, 
	"Mystic Singing Bowl": { "id": 0, "description": "description" }, 
	"Royal Gem Box": { "id": 0, "description": "description" }, 
	"Magnetic Tape": { "id": 0, "description": "description" }, 
	"Hardtack Small Plates": { "id": 0, "description": "description" }, 
	"Hardtack Entree": { "id": 0, "description": "description" }, 
	"Hardtack Special": { "id": 0, "description": "description" }, 
	"Hardtack 1st Course": { "id": 0, "description": "description" }, 
	"Hardtack 2nd Course": { "id": 0, "description": "description" }, 
	"Hardtack 3rd Course": { "id": 0, "description": "description" }, 
	"Hardtack": { "id": 0, "description": "description" }, 
	"Hemalatha's Bill": { "id": 0, "description": "description" }, 
	"Hemalatha's Receipt": { "id": 0, "description": "description" }, 
	"advent_calendar": { "id": 0, "description": "description" }, 
	"rigged_advent_calendar": { "id": 0, "description": "description" }, 
	"monster_bait": { "id": 0, "description": "description" }, 
	
	## Castle Beach
	"Bubkis Family Heirloom": { "id": 0, "description": "Butter knife made from Jalapenoglass."},
	
	## Cyberspear
	"Cyber Tip": { "id": 0, "description": "The sharp tip of a mysterious weapon." }, 
	"Cyber Wing": { "id": 0, "description": "The majestic wing decoration of a mysterious weapon." }, 
	"Cyber Handle": { "id": 0, "description": "The sturdy handle of a mysterious weapon." }, 
	"Cyber Counterweight": { "id": 0, "description": "The precise counterweight of a mysterious weapon." }, 
	"Cyber Trigger": { "id": 0, "description": "The fierce trigger of a mysterious weapon." }, 
	
	"Lucky Frog Amulet": { "id": 0, "description": "Cheap bargain bin trash." }, 
	"Adoption Papers": { "id": 0, "description": "Proceedings to procure a progeny" }, 
	
	## The Social / Industrial Park
	"Chup": { "id": 0, "description": "Industrial strength chup. Decimates the glaucomas." }, 
	"Train Ticket": { "id": 0, "description": "Ticket for a Train." }, 
	
	## Ys-Kolob 
	"Letter to Don Diego": { "id": 0, "description": "Letter addressed to Don Diego de la Vega." },
	"Z-Codec": { "id": 0, "description": "Mysterious device. Shaped like an eel." }, 
	"Duck Organs": { "id": 0, "description": "A dullard mallard's innards" },
	
	## Debug
	"Placeholder Item": { "id": 0, "description": "A silly debug item. does nothing" }
	}

static func money_check_value( money_key : String ) -> int:
	return money.get( money_key, 0 )

## Add or remove money
static func money_change( amount ) -> void:
	var curr : int = B2_Playerdata.Quest("money")
	var _money : int = max(0, curr + amount)
	B2_Playerdata.Quest("money", _money )
	
## Check if the current time is before, during or after certain events.
## ALERT Actual time tracking is not setup yet.
static func time_check( period : String ) -> String:
	if time.has( period ):
		var start 	: float = time[period]["start"]
		var end 	: float = time[period]["end"]
		
		var curr_time := 12.0 ## ALERT Time management not created yet. 12.0 is WIP!
		
		if period == "tnnCurfew":
			if B2_Playerdata.Quest("tnnCurfew") == 2:
				return "after"
			elif B2_Playerdata.Quest("tnnCurfew") == 1:
				return "during"
			else:
				return "before";
				
		if curr_time < start:
			return "before"
		elif curr_time >= end:
			return "after"
		else:
			return "during"
			
	else:
		push_error("B2_Database - Event %s not found. Returned invalid." % period)
		return "invalid"
