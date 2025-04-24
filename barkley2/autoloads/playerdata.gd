extends Node

signal quest_updated
signal stat_updated
signal gun_changed

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

var game_timer : Timer # forgot what this does. is this the quest timer?

## Player data (Wow, what a concept)
var player_stats := B2_HoopzStats.new() ## Fuck the original stat system, its too confusing.
## CRITICAL need to add this to the save game file ( Serialized by var_to_bytes() )

## Guns and goblins (no goblins :(( )
var selected_gun := 0 :
	set(s): selected_gun = wrapi( s, 0, bandolier.size() ); gun_changed.emit()
var bandolier 	: Array[B2_Weapon] ## Main weapons
var gun_bag 	: Array[B2_Weapon] ## Trash weapons

## Jerkin stuff
## NOTE should store dictionaries like this: { "Butterscotch": 5 } -> {"Item": amount}
# Yes, items can stack in this. max of 5 items or something.
var jerkin_pockets : Array[ Dictionary ] = []


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
	#B2_CManager.BodySwap("hoopz");
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
	#preload_skip_tutorial_save_data()
	
## Mostly used for timed quests, curfew and such.
func time_goes_on() -> void:
	if B2_Playerdata.Quest("gameStart") == 2:
		B2_ClockTime.time_step( B2_ClockTime.CLOCK_SPEED )
	else:
		# Time does NOT go on during, the tutorial, title screen and CC.
		pass
	
func record_curr_location() -> bool:
	if B2_Playerdata.Quest("saveDisabled") == 0: ## Save game (if possible) during exit.
		if get_tree().current_scene is B2_ROOMS: ## Only save if the player is inside a valid room.
			if not B2_Input.cutscene_is_playing:
				if is_instance_valid( B2_CManager.o_hoopz ): ## Save current position
					B2_Config.set_user_save_data( "map.room", get_tree().current_scene.name )
					B2_Config.set_user_save_data( "map.x", B2_CManager.o_hoopz.position.x )
					B2_Config.set_user_save_data( "map.y", B2_CManager.o_hoopz.position.y )
		return true
	else:
		return false
	
func SaveGame():
	print_rich("[color=blue]Save game requested.[/color]")
	if B2_Playerdata.Quest("saveDisabled") == 0:
		if not B2_Input.cutscene_is_playing: # Make sure that the game isn't saved during a cutscene.
			B2_Config.create_user_save_data( B2_Config.selected_slot )
	
func Stat( stat_name : String, new_value = null ):
	if new_value:
		player_stats.set( stat_name, new_value )
	else:
		return player_stats.get_effective_stat( stat_name )
	
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
	
	## ClockTime("init"); -> Check B2_ClockTime
	# QuestTracker("init");
	## BodySwap("init"); Check B2_Playerdata.BodySwap()
	## Note("init"); -> check B2_Note
	# Item("reset"); 
	## Map("reset"); -> check B2_Map
	# Cyberspear("reset");
	
	# BodySwap
	B2_Config.set_user_save_data("player.body", "hoopz");
	
	# Item
	B2_Config.set_user_save_data("quest.itemsName", 		Dictionary() ); ## TODO
	B2_Config.set_user_save_data("quest.itemsQuantity", 	Dictionary() ); ## TODO
	
	# Map
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
	
#endregion
	
	# Roll Hoopz base stats ## NOTE No idea how to use these. Ignoring them for now.
	
	# Save maps into Savedata
	B2_Config.set_user_save_data("player.stats.base", 		{}); # was stats_base 		## Check scr_stats_initStats()
	B2_Config.set_user_save_data("player.stats.effective", 	{}); # was stats_effective 	## Check scr_stats_initStats()
	B2_Config.set_user_save_data("player.stats.current", 	0); # was stats_current 	## Check scr_stats_initStats()
	
	#scr_stats_resetStats();
	## NOTE Base stats
	
	## Abilities ## TODO Improve this.
	player_stats = B2_HoopzStats.new()
	
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_LEVEL, 		12 )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_HP, 		47 )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_SPEED,	 	9.5 )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_WEIGHT, 	5.0 )
	#player_stats.set_base_stat( "player.stats.statuseffects", [] ); # was list_status_effect
#
	## The Magic Five a.k.a. The Power Rangers
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_GUTS, 10 + randi_range(0, 1) )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_LUCK, 10 + randi_range(0, 1) )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_AGILE, 10 + randi_range(0, 1) )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_MIGHT, 10 + randi_range(0, 1) )
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_PIETY, 10 + randi_range(0, 1) )
	
	## Resistances
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_KNOCKBACK, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_STAGGER, 0);

	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_NORMAL, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_BIO, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_CYBER, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_MENTAL, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_ZAUBER, 0);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_RESISTANCE_COSMIC, 0);

	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_NORMAL, 3);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_BIO, 3);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_CYBER, 3);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_MENTAL, 3);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_ZAUBER, 3);
	player_stats.set_base_stat( B2_HoopzStats.STAT_BASE_VULN_COSMIC, 3);
	##scr_stats_rollBaseStats(1, 8, 8, 8, 8, 8);
	
	## NOTE Effective Stats
	# During startup, base stats are the same as the effective one. TODO
	#B2_HoopzStats.set_base_stat("player.stats.effective", B2_Config.get_user_save_data( "player.stats.base", {} ) )
	#scr_stats_genEffectiveStats();
	#scr_stats_resetCurrentStats();
	
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
	
	## Jerkins (Player starts with the Cornhusk Jerkin!) - Bhroom
	B2_Config.set_user_save_data("player.jerkins.has", 			[] ); 	# ds_list of jerkins the player has
	B2_Config.set_user_save_data("player.jerkins.current", 		""); 	# Hoopz current jerkin
	
	B2_Jerkin.reset() 								# TODO
	B2_Jerkin.gain_jerkin("Cornhusk Jerkin") 		# TODO
	B2_Jerkin.equip_jerkin("Cornhusk Jerkin") 		# TODO
	
	# Maps
	B2_Map.gain_map( "Necron 7 - 666th Floor" )
	
	# Chips
	## NOTE WTF are these?
	B2_Config.set_user_save_data("player.chips.has", 			[] );
	B2_Config.set_user_save_data("player.chips.current", 		"");

	# Items
	B2_Config.set_user_save_data("player.items.has", 			[] );
	B2_Config.set_user_save_data("player.schematics.zaubers", 	[] );
	B2_Config.set_user_save_data("player.schematics.relics", 	[] );
	
	# Candy
	B2_Config.set_user_save_data("player.schematics.candy", 	[] );
	# Candy("reset"); TODO
	# Candy("current", NULL); TODO
	
	# Zauber
	B2_Config.set_user_save_data("player.zaubers", 				[] );
	# Zauber("reset"); TODO
	
	# Humanism
	B2_Config.set_user_save_data("player.humanism.bio", 	90.0	);
	B2_Config.set_user_save_data("player.humanism.cyber", 	10.0	);
	B2_Config.set_user_save_data("player.humanism.cosmic", 	0.0		);
	B2_Config.set_user_save_data("player.humanism.zauber", 	0.0		);
	
	# Bonnet ## NOTE ?????? 
	B2_Config.set_user_save_data("player.hasBonnet", true);
	
	# Money
	B2_Playerdata.Quest( "money", 0 )
	
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
	B2_ClockTime.time_init()
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
	print_rich("[color=purple]Loaded tutorial data for Hoopz.[/color]")

func preload_skip_tutorial_save_data(): # user skip the CC and tutorial
	# related script = Game("new from wilmer")
	## Plays as if you did the tutorial, woke up, and grabbed Wilmers stuff
	#scr_savedata_delete();
	#scr_savedata_reset();
	#scr_player_newPlayerIdentity();
	preload_CC_save_data()
	preload_tutorial_save_data()
	
	B2_Playerdata.Quest("gameStart", 2);
	B2_Playerdata.Quest("sceneBrandingStart", 4);
	B2_Playerdata.Quest("wilmerEvict", 1);
	B2_Playerdata.Quest("wilmerHandler", 0);
	B2_Playerdata.Quest("wilmerSleepCount", 0);
	B2_Playerdata.Quest("wilmerSleep", 1);
	B2_Playerdata.Quest("wilmerItemsTaken", 1);
	B2_Playerdata.Quest("wilmerMeeting", 1);
	
	## Timed Quest triggers
	B2_ClockTime.time_event("wilmerSleep", 0, 30)
	B2_ClockTime.time_event("wilmerEvict", 2, 70)
	
	B2_Playerdata.Quest("tutorialProgress", 	100);
	B2_Playerdata.Quest("elevatorFloor", 		665);
	B2_Playerdata.Quest("elevatorFloorGoal", 	665);
	
	#scr_gun_db("wilmerGun"); 													TODO
	#scr_gun_db("estherGun"); 													TODO
	B2_Note.take_note( "Wilmer's Amortization Schedule" )
	B2_Database.money_change( B2_Database.money.get("wilmerMortgageTotal", 69420) )
	#Candy("recipe add", "Butterscotch"); 										TODO
	#repeat (10) scr_items_add(scr_items_db_getCopyOfItem("Butterscotch")); 	TODO
	print_rich("[color=blue]Loaded tutorial skip data.[/color]")
	
	B2_Playerdata.Quest("saveDisabled", 0);
