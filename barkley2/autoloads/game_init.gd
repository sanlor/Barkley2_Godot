extends Node

## NOTES
# Godot probably have better ways to do what this script does.

## scr_game_init()
## Call ONCE on game initialization
##live_init(1, "http:##127.0.0.1:5100", ""); ##TODO: remove me

# randomize() ## Godot doesnt need this, I think
# Settings() NOTE Not needed anymore, code init themself.
# Balance() NOTE Not needed anymore, code init themself.
# Sound.init() NOTE Not needed anymore, code init themself.
# paused(0); ## TODO Setup pause function
# scr_deltatime_init();  TBD Godot doesnt need this, I think
# scr_deltatime_update(); TBD Godot doesnt need this, I think
# audio_bgm_init(); ## NOTE Maybe not needed anymore ?

## Debug toggles
var godMode = false;
var pacifyMode = false;

## load config
##scr_load_config();
# Config("init");  ## Godot doesnt need this, I think ## NOTE _ready or _init?

var currentSaveSlot = -1;

# instance_create(0, 0, oBlack); ## NOTE oBlack is just a persistent black screen, used for screen trastitions. Maybe a ColorRect can be used?
# instance_create(0, 0, o_input); ## This seems like a persistent Input controller ## NOTE I dont think I can use any of this code. the whole folder b2input is incompatible with godot.
## TODO Setup Input Manager to replace the above object.
# instance_create(0, 0, oZoneName); # Controls the Zone Text display when changing areas
# instance_create(0, 0, oPrisonVitals); # something related to the Prison ## TODO create and translate the oPrisonVitals object

# scr_input_keymap_init(); ## NOTE Not needed anymore. Godot uses Input for input maping
# Key("init"); ## WARNING This might be useless so it wasnt created. This script handles multiple keypresses.

## load resource list
# scr_savedata_init(); WARNING THis script does only this: global.savedata = ds_map_create();
# scr_soundbanks_init(); WARNING This is a big mess of scripts and registring a lot of sound effects. TODO translate this to Godot
# scr_enemyList(); WARNING This inicializes and populates a bunch of arrays with information about enemies ( global.enemyIndex = ds_map_create(); ). TODO translate this to Godot
# scr_combat_weapons_bfgNames("init"); WARNING Something related to weapon generation? NO idea what BFG is. Not going to mess with this on this stage 23/06/24  TODO translate this to Godot
# Enemy("init"); WARNING This inicializes and populates a bunch of arrays with information about enemies, type of damages and has something to do with s_enemy_editor.  TODO translate this to Godot
# Attack("init"); WARNING This inicializes and populates a bunch of arrays with information about Attack types, knockback and such. Why isnt this a json file?  TODO translate this to Godot
# Duergar("init"); WARNING This inicializes and populates a bunch of arrays with information about Duergars and its used to check the status of said duergars.  Why isnt this a json file?  TODO translate this to Godot
# Map("init"); WARNING This handles the Icons on each map (like the pay rent quest marked with a coin -> Map("add icon", "Tír na nÓg", sMapIconHoopz, 234, 125, "room", "==", "r_tnn_wilmer01"); ).   TODO translate this to Godot
# EffectLightning("init"); WARNING This script handles some kind of lightining effect. Its a bit confusing, but I dont think I need to use code for this. Not sure yet. TODO translate this to Godot ## NOTE Use particles?
# Smoke("init"); WARNING This script handles some kind of smoke effect. Its a bit confusing, but I dont think I need to use code for this. Not sure yet. TODO translate this to Godot ## NOTE Use particles?
# Drop("init"); WARNING This handles the drop chances and generation of random weapons. Its very complex, not goint to touch this at this stage 23/06/24 TODO translate this to Godot
# Jerkin("init"); WARNING This handles Jerkins (clothes) status, db and such. Boy, this really could be a json file. TODO translate this to Godot. NOTE Maybe use a custom resource for this? SQL?
# Gunsmap("init"); WARNING This handles Gun generation. Its complex, cunfusing and weird. Love it, but wont mess with it right now. TODO translate this to Godot.
# Gun("init"); WARNING This handles the guns on Hoopz equip slot VVVVVV TODO translate this to Godot.
# // Gun(add, name, damage, rate, special, weight, ammo, capacity, prefix1, prefix2, material, type, suffix)
# // This is hoopz' gun slots - 6 would be total guns had, so 5 guns + 10 gunbag is 15
# // These do not fully represent the actual guns, these would be linked to a guns ID

# Zauber("init");WARNING Handles the Zauvber DB, equiping, casting and data modification. Zauber. Zauber. Zauber. Zauber. TODO translate this to Godot.
# Candy("init"); WARNING Handles the Candy (recovery items) DB, gererating / smithing new ones and stuff like this. Its amazing how complex and incredible this code is for such a shitty engine. its like scupting a beautiful statue using mud only. TODO translate this to Godot.
# Cyberspear("init"); WARNING Not sure, actually. Looks like it handles the cyberspear locations, remember if they are taken, keep traf of some quest and draws... something related to the Spear. Not going to mess with this right now 23/06/24.  TODO translate this to Godot.
# scr_combat_weapons_fusion_affixhood("init"); WARNING Related to gun gene generation. Not messing with this right now 23/06/24. TODO translate this to Godot.
# scr_combat_weapons_fusion_material("init"); WARNING Related to gun gene generation. Not messing with this right now 23/06/24. TODO translate this to Godot.
# Material("init"); WARNING Related to gun gene generation (mostly DB). Not messing with this right now 23/06/24. TODO translate this to Godot.
# scr_time_db("init"); WARNING Handles time related events, like paying wilmer rent, Curfew, NPCs schedules and things like this. TODO translate this to Godot.
# Vidcon("init"); WARNING Vidcon DB. It also handles saving the status of the vidcon collected to the player save slot. "Shart Cat" is my favorite. TODO translate this to Godot.
# Draw("init"); WARNING Some king of DB to draw sprites. Not sure how this works, its a simples an small script. Probably unfinished. TODO translate this to Godot?
# Cinema("init"); CRITICAL This looks reeeeally important. This handles the dialog, player movement during cutscenes, diag box replies, stuff like this. WARNING This is needed for the title screen.
# ^^^^^ this script is very cool and impressive. no idea how to port it though
# Border("init"); WARNING This handles the random dialog box border. Its a pretty interesting thing. Really have no idea how to port this. TODO translate this to Godot.
# Item("init"); WARNING Item DB. Also handles giving, taking, using and losing items. It also gerenate radom items. TODO translate this to Godot.
# Shop("init"); WARNING Sort of a Shop DB. This handles a Shop inventory and which NPC its tied to. What a weird way to do this. TODO translate this to Godot.
# CC("init"); WARNING I... have no idea what CC means.Custom Character maybe? This script handles the choices made at the begining of the game, like date of birth, zodiac sign, favorite thing, stuff like this. It also gives bonuses to the GLAMP based on these choices. TODO translate this to Godot.
# CRITICAL ^^^^^^^ I need to port this to the game on the first stage.
# spawn_init(); WARNING Not sure, it does only this: global.spawn_maps = ds_map_create(); global.currentSpawnPoint = NULL; 

## Audio configurations
# audio_falloff_set_model(audio_falloff_linear_distance_clamped); WARNING Maybe not needed on godot.

var sfx_rain_intensity = 0;
# Music("init"); NOTE Not needed anymore, code init themself.

## Rain ##
var it_rained_on_previous_map = false;

## Death respawn clock ##
var deathClock = 0;
var deathTimeFirst = 0;
var deathTimeSecond = 0;
var deathTimeThird = 0;

## Affix things ##
var gunsacrifice_affix = false;

## Useless stuff ##
var deathTimerCount = 0;
var pedestrianSprite = 0;
# PEDESTRIAN(true); WARNING This really looks useless. This script does very litle. It changes the variable global.pedestrianCirculation to do... something.
var cursorShift = 16;


## prep inventory
var ls_inventory = Array() # ds_list_create();
var money = 5000;
var bullets = 999;

var idvisible = 1;

## fonts
## CRITICAL This is weird. s_fn1 is a sprite set ("..\Barkley2.gmx\mvc\sprites\s_fn1\"), each letter is a sprite? I dont have a single font file for the text to import on godot... Fuck.
var fn_1 : FontFile = preload("res://barkley2/assets/fonts/f_fn1.png") #font_add_sprite_ext(s_fn1, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]¨_´abcdefghijklmnopqrstuvwxyz{|}~ ÿÓíüú£§", 1, -1); ##was 0 spacing - Note font
var fn_1b : FontFile = preload("res://barkley2/assets/fonts/f_fn1b.png") # = font_add_sprite(s_fn1b, ord(" "), 1, -1);
var fn_1o : FontFile = preload("res://barkley2/assets/fonts/f_fn1o.png") # font_add_sprite(s_fn1o, ord(" "), 1, 1); ##was 0 spacing
###var fn_2 = font_add_sprite(s_fn2, ord(" "), 1, 0); ##was 0 spacing
var fn_2 : FontFile = preload("res://barkley2/assets/fonts/f_fn2.png") # font_add_sprite_ext(s_fn2, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]¨_´abcdefghijklmnopqrstuvwxyz{|}~ ÿÓíüú£§", 1, 0); ##was 0 spacing
#
#var fn_3 = font_add_sprite(s_fn3, ord("!"), 0, 1); ## PROGRESSION IS - '!"' + "    '  *+,-. 0123456789:    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var fn_small : FontFile = preload("res://barkley2/assets/fonts/f_fn_small.png") # font_add_sprite_ext(s_fn_small, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0, 1); ##was 0,2 spacing, and string was was ord("!") for second argument befoer 1.4.9999
var fn_smallc : FontFile = preload("res://barkley2/assets/fonts/f_fn_small.png") # font_add_sprite_ext(s_fn_small, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0, 0); ##used to be 1,1 before version 1.4.9999
#
var fn_2c : FontFile = fn_2 # font_add_sprite(s_fn2, ord(" "), 1, -1); ##condensed font
#var fn_2o = font_add_sprite(s_fn2o, ord(" "), 0, 0); ##outline only
#var fn_2f = font_add_sprite(s_fn2f, ord(" "), 0, 0); ##fill only
## NOTE uncomment above when the font stuff is sorted.

## Elevator numbers ##
var fn_elevator = null ## WARNING // font_add_sprite(s_mg_elevator_numbers, ord('0'), true, 0);

##dwarfnet fonts
var fn_dnet = null ## WARNING // font_add_sprite(s_dnet_font, ord('!'), true, 1);

##b-ball tactics fonts
var fn_tactics = null ## WARNING // font_add_sprite(s_fn_tactics, ord(" "), 1, -1);
var fn_tactics_bold = null ## WARNING // font_add_sprite(s_fn_tacticsb, ord(" "), 1, -1);

##Gun display font
var fn_5 = null ## WARNING // font_add_sprite(s_fn5, ord("!"), 1, 0);
var fn_5o = null ## WARNING // font_add_sprite(s_fn5o, ord("!"), 1, 0);
var fn_5os = null ## WARNING // font_add_sprite(s_fn5os, ord(" "), 1, -1);
var fn_5c = null ## WARNING // font_add_sprite(s_fn5c, ord("!"), 1, 1);
var fn_7oc = null ## WARNING // font_add_sprite(s_fn7oc, ord(" "), 1, -1);
var fn_12oc = null ## WARNING // font_add_sprite(s_fn12oc, ord(" "), 1, -1);
var fn_hud = null ## WARNING // font_add_sprite(s_hud_num, ord("0"), 0, 3);

## GZ condensed version
var fn_debug = null ## WARNING // font_add_sprite(s_fn_debug, ord("!"), 1, 1);
var fn_7ocs = null ## WARNING // font_add_sprite(s_fn7ocs, ord(" "), 1, -1);
var fn_12ocs = null ## WARNING // font_add_sprite(s_fn12ocs, ord(" "), 1, -1);
var fn_12ocsd = null ## WARNING // font_add_sprite(s_fn12ocsd, ord(" "), 1, -1);
var utilityFontSmelt = null ## WARNING // font_add_sprite(sMenuUtilitySmeltNumbers, ord(" "), 1, 0);
var fn_chat = null ## WARNING // font_add_sprite(s_fn_chat, ord(" "), 1, 1);

# quickmenu2("init"); ##creates persistent qmenu object and sets some global vars
## NOTE Handles the quickMenu (pressing Q). Not going to mess with it now.
# scr_gun("init"); ##initializes some gun's stuff. gun's gun's gun'ii gun's
## WARNING //This is hoopz' gun slots - 6 would be total guns had, so 5 guns + 10 gunbag is 15 NOTE Not messing with guns RN.

# draw_set_font(var fn_2) TODO Figure out the font situation

## Collision object was here

## At the very end, create the screen scaling system object
# instance_create(0, 0, o_screen) WARNING "o_screen" looks like something specific to GM. It also does some post process FX to the screen (CRT filter, i think). Not messing with this RN.

## Combatactor surfaces # NOTE Not sure what this is.
var combatactor_surf_256 = null # WARNING // surface_create(256, 256);
var combatactor_surf_128 = null # WARNING // surface_create(128, 128);
var combatactor_surf_64  = null # WARNING // surface_create(64, 64);
var combatactor_surf_32  = null # WARNING // surface_create(32, 32);

##Externally loaded resources
# Portrait("init"); WARNING Dialog Portraits DB. Its used during dialog and choses the portrait based on the speaker's name. amazing, but could be a json file.
# HUD("init"); WARNING handles drawing the guns on the HUD, and some data about guns. mostly guns. Hate the gunplay on the game.

##GZ Stuff
# scr_enemyDB_init(); ##Only call once per game, loads enemy stat DB
# ^^^^^ WARNING Dang, you can feel the change in developers. This loads some enemy data from a json file -> "..\Barkley2.gmx\datafiles\enemyDB.json"! TODO Make Godot read this file... somehow.
# Marquee("init"); ##ONLY CALL ONCE PER GAME, and at the very end as it checks quest vars and clock time
# ^^^^^^ WARNING This handles the flavor text that scrolls on the botton of the GUI: "I need to pay Mr. Wilmer's rent!" TODO Translate this to Godot.
# Breakout("init"); ##For breakout boxes # WARNING Looks like this handles the little dialog box during certain scenes (like you money amount, political power, stuff like that). TODO Translate this to Godot.
# Shake("init"); WARNING Shakes the screen with some fancy controls. TODO Translate this to Godot.
# Minigame("init"); WARNING Handles stuff related to minigames. Not going to mess with this RN - NOTE Oligarchy Online was called "swordbane online" at some point. TODO Translate this to Godot.
# Flourish("init"); ## /// Flourish("build", string_portrait, 0_to_1_time) WARNING No idea what this does. TODO find out what this does.
# Note("game init"); WARNING Handles the notes that Hoops receives, like the "Sealed Secret Dossier", "Augustino's Letter". NOTE the sprite s_tnn_papers seems important. TODO Translate this to Godot.

## Create world collision - MUST be after settings for rtreeSize
# instance_create(0, 0, sys_collision); CRITICAL Seems important. This persistent object calls the script "scr_collisionSystem_init". NOTE Not sure how this works... Maybe is something specific to GMS?

##The below two are for hoopz facing during cinemas
var eventObject = null # NULL;
var eventInteract = false;
var eventFacing = 6; ##Contains last facing of Hoopz
var eventFrame = 0;
var eventTeleport = 0;

## Phosphor CRT Shader editable vars
var shaderNoise = 0.1; ##shader_crt_pass1_tolinear
var shaderHardScan = -12; ##shader_crt_pass2_toscreen
var shaderHardPix = -6; ##shader_crt_pass2_toscreen
var shaderHardBloomScan = -2; ##shader_crt_pass2_toscreen
var shaderHardBloomPix = -1.5; ##shader_crt_pass2_toscreen
var shaderBloomAmount = 0.09; ##shader_crt_pass2_toscreen
var shaderHardVScan = -1.50; ##shader_crt_pass2_toscreen

## Cyber Shader editable vars
var shaderCyberHBloomHard = -1.0;
var shaderCyberVBloomHard = -1.0;
var shaderCyberBloomAmount = 0.14;
var shaderCyberHardScan = -12.0;
var shaderCyberNoise = 0.1;

## Spawn editor vars
# WARNING Temp disabled.
#for (var i = 0; i < 6; i++) {
	#var spawn_palette[i] = spawn_point_create(0, 0, o_enemy_cGremlin_small); ## spawn_point_create(x, y, objectIndex)
#}

## Spawn editor palette
# WARNING Temp disabled.
#ds_map_replace(var spawn_palette[0], "hue", c_orange);
#ds_map_replace(var spawn_palette[1], "hue", c_red);
#ds_map_replace(var spawn_palette[2], "hue", c_yellow);
#ds_map_replace(var spawn_palette[3], "hue", c_green);
#ds_map_replace(var spawn_palette[4], "hue", c_purple);
#ds_map_replace(var spawn_palette[5], "hue", c_blue);

## List for light objects in o_room_darkarea
# Light("init"); WARNING Handles the special effect related to light and darkness. TODO Translate this to Godot.

## Globals for zauber stance
var stanceBeforeZauber = -1;
var stanceBeforeRoll = -1;
var stanceZauberHolster = 0;
var asdas
## For spawning arrest
var duergarPatrol = 1;

## Create the first room
# scr_map_initialise_init(); WARNING does only this: global.rooms_loaded = ds_list_create(); TODO Translate this to Godot.

## Reset game (code re-use)
# scr_game_reset(); CRITICAL Now this is where is all begins
# Resets o_control and o_input objects.
# doest this: global.first_room = scr_map_initialise_load_room(r_debugGreets01, 128, 96); ## NOTE not sure what is this.
# Loads the room r_title.
