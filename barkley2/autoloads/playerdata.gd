extends Node

signal quest_updated
signal stat_updated

#region Stats constants
const STAT_ATTACK_DMG_BIO := "dmg_bio"
const STAT_ATTACK_DMG_COSMIC := "dmg_cosmic"
const STAT_ATTACK_DMG_CYBER := "dmg_cyber"
const STAT_ATTACK_DMG_MENTAL := "dmg_mental"
const STAT_ATTACK_DMG_NORMAL := "dmg_normal"
const STAT_ATTACK_DMG_RANDOMPERC := "rand_dmg"
const STAT_ATTACK_DMG_ZAUBER := "dmg_zauber"
const STAT_ATTACK_KNOCKBACK := "knockback"
const STAT_ATTACK_STAGGER_HARDNESS := "stagger_hardness"
const STAT_ATTACK_STAGGER := "stagger"
const STAT_BASE_AGILE := "AGILE"
const STAT_BASE_GUTS := "GUTS"
const STAT_BASE_HP := "hp"
const STAT_BASE_LEVEL := "lvl"
const STAT_BASE_LUCK := "LUCK"
const STAT_BASE_MIGHT := "MIGHT"
const STAT_BASE_PIETY := "PIETY"
const STAT_BASE_RESISTANCE_BIO := "res_bio"
const STAT_BASE_RESISTANCE_COSMIC := "res_cosmic"
const STAT_BASE_RESISTANCE_CYBER := "res_cyber"
const STAT_BASE_RESISTANCE_KNOCKBACK := "res_knockback"
const STAT_BASE_RESISTANCE_MENTAL := "res_mental"
const STAT_BASE_RESISTANCE_NORMAL := "res_normal"
const STAT_BASE_RESISTANCE_STAGGER := "res_stagger"
const STAT_BASE_RESISTANCE_ZAUBER := "res_zauber"
const STAT_BASE_SPEED := "speed"
const STAT_BASE_WEIGHT := "weight"
const STAT_BASE_VULN_BIO := "vul_bio"
const STAT_BASE_VULN_COSMIC := "vul_cosmic"
const STAT_BASE_VULN_CYBER := "vul_cyber"
const STAT_BASE_VULN_MENTAL := "vul_mental"
const STAT_BASE_VULN_NORMAL := "vul_normal"
const STAT_BASE_VULN_ZAUBER := "vul_zauber"
const STAT_CURRENT_HP := "cur_hp"
const STAT_CURRENT_KNOCKBACK := "cur_knockback"
const STAT_CURRENT_STAGGER_HARD := "cur_stagger_hard"
const STAT_CURRENT_STAGGER_HARDNESS := "cur_stagger_hardness"
const STAT_CURRENT_STAGGER_INSTANT := "cur_stagger_inst"
const STAT_CURRENT_STAGGER_SOFT := "cur_stagger_soft"
const STAT_CURRENT_STAGGER_TIME := "cur_stagger_time"
const STAT_EFFECTIVE_ENCUMBERANCE := "encumb"
const STAT_EFFECTIVE_MAX_HP := "max_hp"
#endregion

#region CC Data
var paxEnable = 0;

# Events visited #
var event_finished_alignment = false;
var event_finished_crest = false;
var event_finished_cookie = false;
var event_finished_dropdown = false;
var event_finished_inkblots = false;
var event_finished_gumball = false;
var event_finished_handscanner = false;
var event_finished_palmreading = false;
var event_finished_lottery = false;
var event_finished_multiple = false;
var event_finished_stats = false;
var event_finished_tarot = false;

# Character data, default values # These get updated as you go along the CC process #
var character_name = "Bob";
var character_name_type = 0;
var character_race = "Sludge Elf";
var character_class = "Janitor";
var character_zodiac := 1
var character_zodiac_index = 0;
var character_zodiac_year = str("0000");
var character_zodiac_month = 0;
var character_zodiac_day = 0;
var character_zodiac_era = 0;
var character_blood = 0;
var character_gender := [false,false,false,false,false,false]

var character_alignment = 0;
var character_alignment_x := 0;
var character_alignment_y := 0;
var character_moral = 0;		# New variables, original are on the script Quest()
var character_ethical = 0;		# New variables, original are on the script Quest()

var character_crest = false;
var character_crest_data := PackedByteArray()

var character_tarot_cards := [] # New variables, original are on the script Quest()


var character_gumball = 0;
var character_stats_race = 0;

var character_lottery := Array()
var character_dropdown_likes := Array()
var character_dropdown_favorites := Array()
var character_multiple := Array()

var character_inkblots := Array()
var character_scanner := Array() ## Hand scanner stats

var character_stat_might = 1;
var character_stat_guts = 1;
var character_stat_acrobatics = 1; 
var character_stat_piety = 1;
var character_stat_luck = 1;

var character_zodiac_year1000 = 0;
var character_zodiac_year100 = 0;
var character_zodiac_year10 = 0;
var character_zodiac_year1 = 0;

## Other shit ##
var placenta_status = -1;
var transition_timer = 25; ## was 14 (bhroom 190529))
#endregion

## Actual important stuff
var player_node : CharacterBody2D
var camera_node : Camera2D

var game_timer : Timer

func _ready():
	character_inkblots.resize( 16 )
	character_scanner.resize( 10 )
	character_dropdown_likes.resize( 9 )
	character_dropdown_favorites.resize( 7 )
	character_multiple.resize(44)
	
	## Game timer
	## Currently used only by the B2_ClockTime class.
	B2_ClockTime.time_init()
	
	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.timeout.connect( time_goes_on )
	
	# make sure that the timer stop when the game is paused or on an open menu.
	game_timer.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	add_child( game_timer, true )
	game_timer.start()
	
	
	## Quest flags overrides
	#preload_CC_save_data()
	B2_CManager.BodySwap("hoopz");
	#preload_CC_save_data()
	#B2_Playerdata.Quest("wilmerMeeting", 0)
	#B2_Playerdata.Quest("tutorialProgress", 	9)
	#B2_Playerdata.Quest("tutorialCspear", 		1)
	#
	#B2_Playerdata.Quest("zaneState", 			6)
	#B2_Playerdata.Quest("tutorialCollision", 	3)
	#B2_Playerdata.Quest("jhodfreyTips", 		2)
	#B2_Playerdata.Quest("gameStart", 			2)
	#B2_Playerdata.Quest("factoryEggs", 		1)
	preload_skip_tutorial_save_data()
	
func time_goes_on() -> void:
	if B2_Playerdata.Quest("gameStart") == 2:
		B2_ClockTime.time_step( B2_ClockTime.CLOCK_SPEED )
	else:
		# Time does NOT go on during, the tutorial, title screen and CC.
		pass
	
func SaveGame():
	print_rich("[color=blue]Save game requested.[/color]")
	B2_Config.create_user_save_data( B2_Config.selected_slot )
	
## This func replaces the Quests script.
func Quest(key : String, value = null, default = 0):
	# if value is not found, return "default"
	var questpath = "quest.vars." + key;
	
	if value == null:
		var _key_value = B2_Config.get_user_save_data(questpath)
		if _key_value == null:
			return default
		else:
			return _key_value
	else:
		B2_Config.set_user_save_data(questpath, value)
		quest_updated.emit()
		return true
		
func get_quest_state(key : String, default = null ):
	return B2_Config.get_user_save_data( "quest.vars." + key, default )

func Effective_Stat(stat_name : String, value = null, default = 0):
	Stat(stat_name, value, default, "effective")

func Stat(stat_name : String, value = null, default = 0, type := "base"):
	# if value is not found, return "default"
	var statpath = "player.stats." + type + "." + stat_name
	
	if value == null:
		var _key_value = B2_Config.get_user_save_data(statpath)
		if _key_value == null:
			return default
		elif _key_value is Dictionary:
			if _key_value.is_empty():
				# when checking the player stats, you should only get int or floats.
				# Dictionaries means that the stat was never set. in this case, dicts should always be empty.
				return default
			else:
				# filled dicts means something went wrong. 
				breakpoint
				return default
		else:
			return _key_value
	else:
		B2_Config.set_user_save_data(statpath, value)
		stat_updated.emit()
		return true
	
# Similar to the Quest function on B2_PlayerData
func Note(key : String, value = null, default = 0):
	# if value is not found, return "default"
	var questpath = "quest.notes." + key;
	
	if value == null:
		var _key_value = B2_Config.get_user_save_data(questpath)
		if _key_value == null:
			return default
		else:
			return _key_value
	else:
		B2_Config.set_user_save_data(questpath, value)
		return true
	
func preload_CC_save_data():
	# related script = scr_player_newPlayerIdentity();
	
	#scr_player_newPlayerIdentity();
	#CC("new player");
	#room_goto(r_cc);
	
	## WARNING ##
	# ClockTime
	# var EXPERIENCE_MIN = 0.5;
	# var EXPERIENCE_MAX = 1.5;
	# var CLOCK_MAX = 60 * 60 * 24;
	# var CLOCK_SPEED = 4; ## EDITABLE: If you are 1 gate away, it will start at 4 seconds and taper down
	# B2_Config.set_user_save_data("clock.time", CLOCK_MAX);
	# B2_Config.set_user_save_data("clock.gate", 0)
	# B2_Config.set_user_save_data("clock.event.timer", Dictionary() );
	# B2_Config.set_user_save_data("clock.event.quest", Dictionary() );
	# B2_Config.set_user_save_data("clock.event.value", Dictionary() );
	# ClockTime("update") will be IGNORED, fucko.
	## WARNING Shut up!  The above "clock" code was setup in the class B2_ClockTime.
	
	# BodySwap
	B2_Config.set_user_save_data("player.body", "hoopz");
	
	# Note
	# will be ignored for the time being. What a mess.
	
	# Item
	# B2_Config.set_user_save_data("quest.itemsName", 		Dictionary() );
	# B2_Config.set_user_save_data("quest.itemsQuantity", 	Dictionary() );
	
	# Map
	#B2_Config.set_user_save_data("quest.maps", Dictionary() );
	B2_Config.set_user_save_data("quest.maps", Array() ); ## New method 02/01/25
	
	# Note
	B2_Config.set_user_save_data("quest.notes", Array() ); ## New method 02/01/25
	## ATTENTION may break compatibility with the original game´s save game.
	
	# Cyberspear
	B2_Playerdata.Quest("cgremQuest", 0);
	## Tallies how many pieces you have
	B2_Playerdata.Quest("cyberspearGremlinPieces", 0);
	## Total
	B2_Playerdata.Quest("cyberspearGremlinPiecesTotal", 0);
	
	## Create a temporary CombatActor to use for generating Stats ## NOTE I disabled some settings. Looks like data from the CC is being overwrited?
	# Set Hoopz ID Quest Variables
	B2_Playerdata.Quest("playerX1", 1);
	B2_Playerdata.Quest("playerName", "X114JAM9"); # constant P_NAME
	B2_Playerdata.Quest("playerNameFull", "X114JAM9"); # constant P_NAME_F
	B2_Playerdata.Quest("playerNameShort", "X1"); # constant P_NAME_S
	
	#B2_Playerdata.Quest("playerGumballColor", floor(random(255))); # green is 80
	#B2_Playerdata.Quest("playerBlueFace", 0);
	#B2_Playerdata.Quest("playerBlueFaceName", "Becker");
	
#region Weird CC overwrites that I disabled - Sanlo 
	# CC Bonus
	#B2_Playerdata.Quest("playerCCBonus", 2); # Keeping for OLD stuff, will remove later

	# CC Name
	#B2_Playerdata.Quest("playerCCName", "");

	# CC Birth Date
	# Compares to ClockTime's 4 digits and gives BONUS equal to quest value
	# if X digit below is even and not 0
	
	#B2_Playerdata.Quest("playerCCPowerBonus", 0);      # X0:00 - Power
	#B2_Playerdata.Quest("playerCCCapacityBonus", 0);   # 0X:00 - Capacity
	#B2_Playerdata.Quest("playerCCAffixBonus", 0);      # 00:X0 - Affix
	#B2_Playerdata.Quest("playerCCSpeedBonus", 0);      # 00:0X - Speed / Rate
	#B2_Playerdata.Quest("playerCCMonth", 0);           # Power Bonus
	#B2_Playerdata.Quest("playerCCDay", 0);             # Capacity Bonus
	#B2_Playerdata.Quest("playerCCYear", 0);            # Affix Bonus
	#B2_Playerdata.Quest("playerCCEra", 0);             # Rate Bonus
	#B2_Playerdata.Quest("playerCCZodiac", "Aries");    # Zodiac
	
	# Zodiac can be used for Character dialogs

	# CC Blood Type
	# Effects FONT and PETAL color of the Haiku
	# 0 = A, 1 = B , 2 = C, 3 = O, 4 = 10w-30, 5 = Corn Syrup
	# o_hoopz_death_grayscale CREATE event has the color values
	#B2_Playerdata.Quest("playerCCBloodType", 0);

	# CC Gender
	# No use currently
	#B2_Playerdata.Quest("playerCCGender", "Dwarf");
	#B2_Playerdata.Quest("playerCCGenderName", "Dwarf");

	# CC Alignment
	#B2_Playerdata.Quest("playerCCAlignmentEthical", ALIGN_ETHICAL_NEUTRAL);
	#B2_Playerdata.Quest("playerCCAlignmentMoral", ALIGN_MORAL_NEUTRAL);

	# CC Tarot
	# 0 - 25 and 26 is BABE
	#B2_Playerdata.Quest("playerCCTarot1", 0);
	#B2_Playerdata.Quest("playerCCTarot2", 1);
	#B2_Playerdata.Quest("playerCCTarot3", 2);
	#B2_Playerdata.Quest("playerCCTarot4", 3);

	# CC Rune
	# This is tracked in a quest var but you also get it as an item at the start
	#B2_Playerdata.Quest("playerCCRune", 0);

	# CC Enemy Boost (hand scanner)
	#B2_Playerdata.Quest("playerCCScanner", 0); # Enemy glamp bonus

	# Roll Hoopz base stats ## NOTE No idea how to use these. Ignoring them for now.
	
	# Save maps into Savedata
	B2_Config.set_user_save_data("player.stats.base", 		{}); # was stats_base 		## Check scr_stats_initStats()
	B2_Config.set_user_save_data("player.stats.effective", 	{}); # was stats_effective 	## Check scr_stats_initStats()
	B2_Config.set_user_save_data("player.stats.current", 	0); # was stats_current 	## Check scr_stats_initStats()
	
	#scr_stats_resetStats();
	## NOTE Base stats
	
	## Abilities
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_LEVEL, 	12 )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_HP, 		47 )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_SPEED, 	9.5 )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_WEIGHT, 	5.0 )
	B2_Config.set_user_save_data( "player.stats.statuseffects", [] ); # was list_status_effect
#
	## The Magic Five a.k.a. The Power Rangers
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_GUTS, 10 + randi_range(0, 1) )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_LUCK, 10 + randi_range(0, 1) )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_AGILE, 10 + randi_range(0, 1) )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_MIGHT, 10 + randi_range(0, 1) )
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_PIETY, 10 + randi_range(0, 1) )
	
	## Resistances
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_KNOCKBACK, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_STAGGER, 0);

	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_NORMAL, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_BIO, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_CYBER, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_MENTAL, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_ZAUBER, 0);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_RESISTANCE_COSMIC, 0);

	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_NORMAL, 3);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_BIO, 3);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_CYBER, 3);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_MENTAL, 3);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_ZAUBER, 3);
	B2_Config.set_user_save_data( "player.stats.base." + STAT_BASE_VULN_COSMIC, 3);
	##scr_stats_rollBaseStats(1, 8, 8, 8, 8, 8);
	
	## NOTE Effective Stats
	# During startup, base stats are the same as the effective one.
	B2_Config.set_user_save_data("player.stats.effective", B2_Config.get_user_save_data( "player.stats.base", {} ) )
	
	#scr_stats_genEffectiveStats();
	#scr_stats_resetCurrentStats();
	#endregion

	# Save status effects into Savedata
	
	
	# Respawn info
	B2_Config.set_user_save_data("player.respawn.do", false);
	B2_Config.set_user_save_data("player.respawn.room", "");
	B2_Config.set_user_save_data("player.respawn.x", 0);
	B2_Config.set_user_save_data("player.respawn.y", 0);
	B2_Config.set_user_save_data("player.respawn.loc", "");
	B2_Config.set_user_save_data("player.respawn.junk", false);
	B2_Config.set_user_save_data("player.deaths.total", 0);
	B2_Config.set_user_save_data("player.deaths.current", 0);
	
	# Jerkin
	B2_Config.set_user_save_data("player.jerkins.has", 			Dictionary() ); # ds_list of jerkins the player has
	B2_Config.set_user_save_data("player.jerkins.current", 		""); # Hoopz current jerkin
	
	B2_Config.set_user_save_data("player.chips.has", 			Dictionary() );
	B2_Config.set_user_save_data("player.chips.current", 		"");

	# Items
	B2_Config.set_user_save_data("player.items.has", 			Dictionary() );
	B2_Config.set_user_save_data("player.schematics.zaubers", 	Dictionary() );
	B2_Config.set_user_save_data("player.schematics.relics", 	Dictionary() );
	
	# Candy
	B2_Config.set_user_save_data("player.schematics.candy", 	Dictionary() );
	
	# Zauber
	B2_Config.set_user_save_data("player.zaubers", 				Dictionary() );
	
	# Humanism
	B2_Config.set_user_save_data("player.humanism.bio", 90.0);
	B2_Config.set_user_save_data("player.humanism.cyber", 10.0);
	B2_Config.set_user_save_data("player.humanism.cosmic", 0.0);
	B2_Config.set_user_save_data("player.humanism.zauber", 0.0);
	
	# Bonnet ## NOTE ?????? 
	B2_Config.set_user_save_data("player.hasBonnet", true);
	
	# XP
	B2_Config.set_user_save_data("player.xp.questxp", 0);

	B2_Config.set_user_save_data("player.xp.level", 12);
	B2_Config.set_user_save_data("ustation.smelt", 500);
	
	# Vidcon # Vidcon("reset"); # Reset vidcons you have and vidcon XP
	B2_Config.set_user_save_data("player.xp.vidcons", 		0);
	B2_Config.set_user_save_data("player.xp.vidconsBoxed", 	0);
	
	# Spawn points
	B2_Config.set_user_save_data("spawn", Dictionary() );
	
	# Gunmap - Generate hoopz's gun map for this game
	#Gunsmap("generate");
	B2_Config.set_user_save_data("gunsmap.seed", 0); # was global.gunsmapSeed
	
	# Generate guns
	B2_Config.set_user_save_data("player.guns.bandolier", 		Dictionary() );
	B2_Config.set_user_save_data("player.guns.bag", 			Dictionary() );
	B2_Config.set_user_save_data("player.guns.schematics", 		Dictionary() );
	
	B2_Config.set_user_save_data("player.guns.lineage", 		Dictionary() );
	B2_Config.set_user_save_data("player.guns.lineageID", 		Dictionary() );
	B2_Config.set_user_save_data("player.guns.lineageCount", 	0);
	
	# Cuchu elevator starts at floor 666 # I put this here as guided by bort, blame him. 
	# The idea is to set the initial floor to 666 just once so this seems like a good spot #
	B2_Playerdata.Quest("elevatorFloorGoal", 	665);
	B2_Playerdata.Quest("elevatorFloor", 		665);
	B2_Playerdata.Quest("hudVisible", 			1);
	B2_Playerdata.Quest("zoneVisible", 			1);
	B2_Playerdata.Quest("dropEnabled", 			1);
	B2_Playerdata.Quest("dropTable", 			0); # 0 = regular, 1 = boss
	B2_Playerdata.Quest("infiniteAmmo", 		0);
	B2_Playerdata.Quest("yapWords", 			0);
	
	B2_Playerdata.Quest("saveDisabled", 		1 );
	B2_Playerdata.Quest("sceneBrandingStart", 	1 );
	B2_Playerdata.Quest("gameStart", 			1 );
	B2_Playerdata.Quest("elevatorFloor", 		665 );
	B2_Playerdata.Quest("elevatorFloorGoal", 	665 );
	B2_Playerdata.Quest("ccCompleted", 			1 );
	
	B2_Config.set_user_save_data("map.room", "r_fct_eggRooms01") # scr_savedata_put("map.room", "r_fct_eggRooms01");
	B2_Config.set_user_save_data("map.x", 0); # scr_savedata_put("map.x", 0);
	B2_Config.set_user_save_data("map.y", 0); # scr_savedata_put("map.y", 0);
	
	B2_Config.create_user_save_data( B2_Config.selected_slot ) ## scr_savedata_save();
	print_rich("[color=red]Loaded default CC data for Hoopz.[/color]")
	
func preload_tutorial_save_data(): # user skip the CC
	# related script = CC("hoopz player");
	
	# related script = Game( "new" )
	# This is the game start from Character Creation, the "canon start"
	B2_Playerdata.Quest("saveDisabled", 1);
	B2_Playerdata.Quest("sceneBrandingStart", 1);
	B2_Playerdata.Quest("gameStart", 1);
	B2_Playerdata.Quest("elevatorFloor", 665);
	B2_Playerdata.Quest("elevatorFloorGoal", 665);
	B2_Playerdata.Quest("ccCompleted", 1);
	
	B2_Config.set_user_save_data("map.room", "r_fct_eggRooms01");
	B2_Config.set_user_save_data("map.x", 0);
	B2_Config.set_user_save_data("map.y", 0);
	B2_Config.create_user_save_data( B2_Config.selected_slot ) # set_user_save_data();
	# Teleport(r_fct_eggRooms01, 0, 0, 1);

func preload_skip_tutorial_save_data(): # user skip the CC and tutorial
	# related script = Game()
	## Plays as if you did the tutorial, woke up, and grabbed Wilmers stuff
	#scr_savedata_delete();
	#scr_savedata_reset();
	#scr_player_newPlayerIdentity();
	preload_CC_save_data()
	preload_tutorial_save_data()
	
	B2_Playerdata.Quest("gameStart", 2);
	B2_Playerdata.Quest("sceneBrandingStart", 2);
	#B2_Playerdata.Quest("wilmerEvict", 1);
	#B2_Playerdata.Quest("wilmerHandler", 0);
	#B2_Playerdata.Quest("wilmerSleepCount", 0);
	#B2_Playerdata.Quest("wilmerSleep", 1);
	#B2_Playerdata.Quest("wilmerItemsTaken", 1);
	#B2_Playerdata.Quest("wilmerMeeting", 0);
	B2_Playerdata.Quest("tutorialProgress", 100);
	B2_Playerdata.Quest("elevatorFloor", 665);
	B2_Playerdata.Quest("elevatorFloorGoal", 665);
	
	#scr_gun_db("wilmerGun");
	#scr_gun_db("estherGun");
	#Candy("recipe add", "Butterscotch");
	#repeat (10) scr_items_add(scr_items_db_getCopyOfItem("Butterscotch"));
	#Note("take", "Wilmer's Amortization Schedule");
	#scr_money_set(scr_money_db("wilmerMortgageTotal"));
	#paused(0);
	#global.DELTA_TIME_MOD = 1;
	#Teleport(r_tnn_wilmer01, 240, 350, 1);
