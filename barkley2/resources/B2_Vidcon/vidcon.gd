extends RefCounted
class_name B2_Vidcon


enum VIDCON{NAME,DESCRIPTION}
const VIDCON_DB : Dictionary[int, Array] = {
	00: ["Senor Bappy",                                     "Console: GameShrike 64bit #Developer: P'Tony Dataworks #Genre: Sim-lite ##Praise your Bappy, scorn your Bappy. Be the Bappy."], 				## Treasure Dwarf in r_sw1_treasureDwarf01
	01: ["B:LADe gEAR_x_Havoc",                             "Console: Otakun PRO Ex #Developer: Samwell Bupkis #Genre: Tournament Fighter ##Fight all of the gEARS!"], 										## Treasure Dwarf in r_sw2_treasureDwarf01
	02: ["Bananas Ape-lenty",                               "Console: Brain-Jack II #Developer: Third Reich Games #Genre: BRPG ##Collect all 'nanas! More than the sum of its parts!!"], 					## Secret Vidcon by putting Cyberspear back on the Dais
	03: ["ATP Pro Tour 6K60: Valley of the Volleys",        "Console: Solar Plexus #Developer: Eric Data & Software #Genre: Sportz ##Battle your sportsfoes with incredible netplay!"], 					## Hidden under Aelfleda's Mattress
	04: ["Super Return of Chernobog",                       "Console: Super Hoop Advance #Developer: Yultid Games #Genre: Turn-based Racing ##Chernobog has returned, worse than ever."], 					## Milagros gives you this for the Klatch Invite
	05: ["Creppy Ghoulie IV",                               "Console: Wingman ZX #Developer: Hitoshi Barney #Genre: Horror Encyclopedia ##Gaze at ghastly ghoulies until heart attack."], 					## Kelpster sells you this
	06: ["~F.A.T.E.~ _gain_ reveLation",                    "Console: Hippo System Virtue #Developer: Soros Gamesoft #Genre: JRPG ##Battle with Destiny to defeat ~F.A.T.E.~."], 							## Get after Catfish Queen battle from a T-dwarf
	07: ["Don't Spill the Sauce!",                          "Console: Bitminer 2000 #Developer: Carlos Connect #Genre: Sauce-Sim ##The sauce dances on a knife's edge. Don't spill it!"], 					## Treasure Dwarf in r_sw1_closet01
	08: ["Dervish 2: Whirlstrom",                           "Console: BeyBloat 3 #Developer: Papa Gonzalez Jr. #Genre: LifeSim ##Use powerful Devil Whirls to destroy enemy."], 							## Prison Gate room, chained to a cliff
	09: ["Gorezerker 3: Absolutely!",                       "Console: Linux 64 #Developer: Papmeister Gamez #Genre: Cookie Clicker ##The Gorzerker is on the loose. Click him into submission!"], 			## Prison Gate, secret passage next to the gates
	10: ["Bolly Mixtures",                                  "Console: Game Comrade II #Developer: Troglodyte Gamers #Genre: Cooking ##By Golly! Mix the mixtures, make 'em Bolly!"], 						## Snoozer map in Eastelands
	11: ["BEAST Days <Slayer>: High School Generation",     "Console: Iron Fist 2000 #Developer: Rand Corporation #Genre: Flashlight Simulator ##In the darkest hour... an orange glow brings hope."], 		## Dojo Master gives it to you if you manage to expel Dojo Dad
	12: ["Alchemist Heart Baney -=Divine Comedy=-",         "Console: Caltrax ZX #Developer: Wisp-o-Games #Genre: Visual Novel ##Comedy is but a bubbling tincture. Quaff with abandon."], 					## Prison Cell Treasure Dwarf
	13: ["Thumbelina: F1rst Foli0",                         "Console: ImageWare II #Developer: Yoddler Fish #Genre: Bupkis Clicker ##Thumbelina is back, meaner than ever!"], 								## Get from T-Dwarf chained to the mountain wall, r_pea_ladderMidway01
	14: ["Microwave Tunnel 4: Gun's of the Paupers",        "Console: SludgeMaster O.X. #Developer: KKK Gaming #Genre: Tactical Espionage Goofing ##Old grizzled vet gets hired to do some wetwork."], 		## Get from T-Dwarf chained behind the factory, r_fct_factoryBackyard01
	15: ["Lanzenacht Mitsuru Geschtalten: Chaos Kindern",   "Console: SupaFX #Developer: Dwarfkrutz #Genre: Visual Novel ##Go to High School and date all the people! Marriage!"], 							## Icefields treasure map
	16: ["Christfallen: Ayatollah lost at sea",             "Console: Heinrich VX #Developer: Westboro Games Software #Genre: Edutainment ##Facts and fiction about Clispaeth."], 							## Get from Lord Giuseppe as a handout
	17: ["Hands up and gimme your bloods!",                 "Console: Cyber-Arouser 360 #Developer: Blood Gulp Games #Genre: Roguelike ##Gather weapon's and muscle then battle you're foes!"], 			## Get from Yellow Kid while in Dracula "disguise"
	18: ["Clown School",                                    "Console: F-Earth Turbomax #Developer: Saddam Obummer #Genre: Dating Sim ##The clowns are here, and their juicy nips will be feasted on! "], 	## Pelekryte gives it if you complete the telescope properly
	19: ["Flat Earth 2020: The Otherkin Warz",              "Console: PC #Developer: Gulliver Games #Genre: RTS ##Good vs. Evil... Who will win?"], 														## Ys-Kolob, Z-room after ruining the stakeout
	20: ["Crime Buddies",                                   "Console: SVidCx Home#Developer: Destined Places, LTD#Genre: Act-Adv ##Desperate criminals team up against all odds to pull of the most entertaining heist of the century."], 	##; ## Cuchuelevator Swamps
	21: ["Crime Buddies 2: Caper Buddies",                  "Console: Trekmon 3#Developer: Sensory Acceptable Games#Genre: RPG ##Linda and Gerard reunite to bring honor to the crumbling criminal empire - but at what cost?"],
	22: ["Crime Buddies 3: Cooking with Capers",            "Console: Handyfun Light#Developer: Lotcom Limited#Genre: Match 3/Edutainment ##Crime Buddies teach differential equations and also emotions and also diversity. F2P."],		## Secret Storage in WST
	23: ["Hellbraster Mk. II: Where angels fear",           "Console: Obsidian 64 #Developer: Herbert P. Hunzel #Genre: Action-Novel ##Bring hell back to Brastville, or die trying..."], 					## T-dwarf in Running Mantis' lair
	24: ["Fatal Downshift: The Leagues",                    "Console: Bracula FUN-X #Developer: Chodemasters #Genre: Open World Racing ##Put the pedal to the medal and burn some rubber."], 				## Snoozer Anxo, ransack his corpse
	25: ["Wesley Girl 68",                                  "Console: Trash-ZX #Developer: Zenobia #Genre: Dating Sim ##The Wesley babes are hot, hip and single."], 										## Cgrem village
	26: ["Wesley Girl 70",                                  "empty"], ##
	27: ["B.I.O. Magician Ooze: Escape from Brain City",    "empty"], ##
	28: ["Ninja Hellstrom III: Age of Decadence",           "Console: Turbo Bismarck #Developer: John Beach Games #Genre: Sultan Sim ##Hattori has returned to claim Tokyo by right of conquest."],
	29: ["Billy Bopper II: Muscles of Hell",                "Console: PC #Developer: GZstorm #Genre: Tournament Fighter ##Billy is back, meaner than ever! Grow your muscles and kill them all."], 			## Castle Beach reward
	30: ["Shitler's List",                                  "empty"],
	31: ["Fetcher's Quest",                                 "Console: Retro-Brast #Developer: The Quip Bros #Genre: Fetchventure ##Embark on an epic fetch marathon!"], 									## Zenobia gives it for the Belork Relic Quest
	32: ["mIst-edge III ~over the clouds of wonder~",       "empty"], ##
	33: ["Jigsaw XII",                                      "Console: Limbware Systemz #Developer: American Limb Association #Genre: Jigsaw Puzzle ##Find all the pieces!"], 
	34: ["Macrosoft Pen Buddy",                             "Console: PC #Developer: Macrosoft #Genre: Text Editor ##Create, edit and share text documents with all your friends."], 						## Reward for purchasing 3 readings from Canondorf
	35: ["Vidcon 35",                                       "empty"],
	36: ["S.avan.T Rise D.N.A -innocent crime R0ND0-",      "empty"], ##
	37: ["Cave Stunt",                                      "Console: Old-Fashioned Phone #Developer: Cave #Genre: Traditional Caver ##Have a fun time!"],
	38: ["Vidcon 38",                                       "empty"],
	39: ["Vidcon 39",                                       "empty"],
	40: ["Fart Cat",                                        "empty"], 
	41: ["Shart Cat",                                       "empty"], 
	42: ["<[SolaR]> .rOmAnCiNg. (Grim XraptureX)",          "Console: !station! #Developer: Cl0ud.MAst3r #Genre: Unknown ##Romance? Ya, ya and bring best move to school, allez!"], 						## Governor's Mansion - Confiscation room
	43: ["Pele, Be Quiet and Kick: Side Story",             "Console: PC #Developer: Legend of Game's #Genre: Satirical RPG  ##The indie soccer comedy that spawned many vidcon miems. 4000 years later, fans still await the sequel."],
	44: ["Vidcon 44",                                       "empty"],
	45: ["Vidcon 45",                                       "empty"],
	46: ["Vidcon 46",                                       "empty"],
	47: ["Vidcon 47",                                       "empty"],
	48: ["Vidcon 48",                                       "empty"],
	49: ["Vidcon 49",                                       "empty"],
	50: ["Ziggurat Electron School",                        "empty"], ##
	51: ["Hyberborea no Legends",                           "Console: Hork-Master #Developer: Seymon Anime #Genre: JRPG ##Incredible rollercoaster of emotions awaits in this top-notch JRPG."], 			## Tdwarf in Cuchu's Lair, r_chu_tdwarf01
}
const VIDCON_N 				:= 52
const VIDCONEXPERIENCE 		:= 30

static func reset() -> void:
	var vidconHave := []
	vidconHave.resize(VIDCON_N)
	vidconHave.fill(0)
	var vidconBoxed := []
	vidconBoxed.resize(VIDCON_N)
	vidconBoxed.fill(1)
	
	B2_Config.set_user_save_data("player.xp.vidcons", 			vidconHave)
	B2_Config.set_user_save_data("player.xp.vidconsBoxed", 		vidconBoxed)
	
static func change_vidcon( index : int, value : int ) -> void:
	if index in range(VIDCON_N):
		var vidconHave : Array = B2_Config.get_user_save_data("player.xp.vidcons")
		vidconHave[index] = value
		B2_Config.set_user_save_data("player.xp.vidcons", 			vidconHave)
	else:
		push_error("Invalid Vidcon index '%s'." % index)

static func change_vidconboxed( index : int, value : int ) -> void:
	if index in range(VIDCON_N):
		var vidconBoxed : Array = B2_Config.get_user_save_data("player.xp.vidconsBoxed")
		vidconBoxed[index] = value
		B2_Config.set_user_save_data("player.xp.vidconsBoxed", 			vidconBoxed)
	else:
		push_error("Invalid Vidcon index '%s'." % index)
	
static func give_vidcon( index : int ) -> void:
	if index in range(VIDCON_N):
		change_vidcon( index, 1 )
		change_vidconboxed( index, 1 )
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		
static func has_vidcon( index : int ) -> int:
	if index in range(VIDCON_N):
		var vidconHave : Array = B2_Config.get_user_save_data("player.xp.vidcons")
		return vidconHave[index]
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		return 0
		
static func unbox_vidcon( index : int ) -> void:
	if index in range(VIDCON_N):
		change_vidconboxed( index, 0 )
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		
static func is_vidcon_unboxed( index : int ) -> int:
	if index in range(VIDCON_N):
		var vidconBoxed : Array = B2_Config.get_user_save_data("player.xp.vidconsBoxed")
		return vidconBoxed[index]
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		return 0

static func get_vidcon_name( index : int ) -> String:
	if index in range(VIDCON_N):
		return VIDCON_DB[index][VIDCON.NAME]
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		return "INVALID INDEX"
		
static func get_vidcon_description( index : int ) -> String:
	if index in range(VIDCON_N):
		return VIDCON_DB[index][VIDCON.DESCRIPTION]
	else:
		push_error("Invalid Vidcon index '%s'." % index)
		return "INVALID INDEX"
		
static func total_boxed_vidcons() -> int:
	var vidconBoxed : Array = B2_Config.get_user_save_data("player.xp.vidconsBoxed")
	return vidconBoxed.count( 1 )
	
static func total_unboxed_vidcons() -> int:
	var vidconBoxed : Array = B2_Config.get_user_save_data("player.xp.vidconsBoxed")
	return vidconBoxed.count( 1 )
	
static func get_experience() -> int:
	return total_unboxed_vidcons() * VIDCONEXPERIENCE
