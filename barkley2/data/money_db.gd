extends Resource
class_name B2_Database

# check scr_money_db()
# Factorio Space Age is pretty good. its been a few weeks/months since I last worked on this.

## Data related to money. Maybe this should be a Json or other kind of DB? yes, anything can be a DB if you are dumb enough.
## Not money anymore, every "DB" is a dictionary now. Dictionaries can be DBs too.

const money := {
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
	250.0 * 0.5, #scr_money_db("tontineFull") * 0.5, 
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

## Add or remove money
static func money_change( amount ) -> void:
	var curr : int = B2_Playerdata.Quest("money")
	var _money : int = max(0, curr + amount)
	B2_Playerdata.Quest("money", _money )
	
