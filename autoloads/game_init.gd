extends Node

## NOTES
# Godot probably have better ways to do what this script does.

## scr_game_init()
## Call ONCE on game initialization
##live_init(1, "http:##127.0.0.1:5100", ""); ##TODO: remove me

# randomize() ## Godot doesnt need this, I think
# Settings() ## Not needed anymore, code init themself.
# Balance() ## Not needed anymore, code init themself.
# Sound.init() ## Not needed anymore, code init themself.
# paused(0); ## TODO Setup pause function
# scr_deltatime_init();  ## Godot doesnt need this, I think
# scr_deltatime_update(); ## Godot doesnt need this, I think
# audio_bgm_init(); ## NOTE Maybe not needed anymore ?

## Debug toggles
var godMode = false;
var pacifyMode = false;

## load config
##scr_load_config();
# Config("init");  ## Godot doesnt need this, I think ## NOTE _ready or _init?

var currentSaveSlot = -1;

# instance_create(0, 0, oBlack); ## INFO oBlack is just a persistent black screen, used for screen trastitions. Maybe a ColorRect can be used?
# instance_create(0, 0, o_input); ## This seems like a persistent Input controller ## NOTE I dont think I can use any of this code. the whole folder b2input is incompatible with godot.
## TODO Setup Input Manager to replace the above object.
# instance_create(0, 0, oZoneName); # Controls the Zone Text display when changing areas
instance_create(0, 0, oPrisonVitals);

scr_input_keymap_init();
Key("init");

## load resource list
scr_savedata_init();
scr_soundbanks_init();
scr_enemyList();
scr_combat_weapons_bfgNames("init");
Enemy("init");
Attack("init");
Duergar("init");
Map("init");
EffectLightning("init");
Smoke("init");
Drop("init");
Jerkin("init");
Gunsmap("init");
Gun("init");
Zauber("init");
Candy("init");
Cyberspear("init");
scr_combat_weapons_fusion_affixhood("init");
scr_combat_weapons_fusion_material("init");
Material("init");
scr_time_db("init");
Vidcon("init");
Draw("init");
Cinema("init");
Border("init");
Item("init");
Shop("init");
CC("init");
spawn_init();

## Audio configurations
audio_falloff_set_model(audio_falloff_linear_distance_clamped);

var sfx_rain_intensity = 0;
Music("init");

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
PEDESTRIAN(true);
var cursorShift = 16;


## prep inventory
ls_inventory = ds_list_create();
money = 5000;
bullets = 999;

idvisible = 1;

## fonts
var fn_1 = font_add_sprite_ext(s_fn1, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]¨_´abcdefghijklmnopqrstuvwxyz{|}~ ÿÓíüú£§", 1, -1); ##was 0 spacing - Note font
var fn_1b = font_add_sprite(s_fn1b, ord(" "), 1, -1);
var fn_1o = font_add_sprite(s_fn1o, ord(" "), 1, 1); ##was 0 spacing
##var fn_2 = font_add_sprite(s_fn2, ord(" "), 1, 0); ##was 0 spacing
var fn_2 = font_add_sprite_ext(s_fn2, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]¨_´abcdefghijklmnopqrstuvwxyz{|}~ ÿÓíüú£§", 1, 0); ##was 0 spacing

var fn_3 = font_add_sprite(s_fn3, ord("!"), 0, 1); ## PROGRESSION IS - '!"' + "    '  *+,-. 0123456789:    ? ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var fn_small = font_add_sprite_ext(s_fn_small, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0, 1); ##was 0,2 spacing, and string was was ord("!") for second argument befoer 1.4.9999
var fn_smallc = font_add_sprite_ext(s_fn_small, ' !"' + "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~", 0, 0); ##used to be 1,1 before version 1.4.9999

var fn_2c = font_add_sprite(s_fn2, ord(" "), 1, -1); ##condensed font
var fn_2o = font_add_sprite(s_fn2o, ord(" "), 0, 0); ##outline only
var fn_2f = font_add_sprite(s_fn2f, ord(" "), 0, 0); ##fill only

## Elevator numbers ##
var fn_elevator = font_add_sprite(s_mg_elevator_numbers, ord('0'), true, 0);

##dwarfnet fonts
var fn_dnet = font_add_sprite(s_dnet_font, ord('!'), true, 1);

##b-ball tactics fonts
var fn_tactics = font_add_sprite(s_fn_tactics, ord(" "), 1, -1);
var fn_tactics_bold = font_add_sprite(s_fn_tacticsb, ord(" "), 1, -1);

##Gun display font
var fn_5 = font_add_sprite(s_fn5, ord("!"), 1, 0);
var fn_5o = font_add_sprite(s_fn5o, ord("!"), 1, 0);
var fn_5os = font_add_sprite(s_fn5os, ord(" "), 1, -1);
var fn_5c = font_add_sprite(s_fn5c, ord("!"), 1, 1);
var fn_7oc = font_add_sprite(s_fn7oc, ord(" "), 1, -1);
var fn_12oc = font_add_sprite(s_fn12oc, ord(" "), 1, -1);
var fn_hud = font_add_sprite(s_hud_num, ord("0"), 0, 3);

## GZ condensed version
var fn_debug = font_add_sprite(s_fn_debug, ord("!"), 1, 1);
var fn_7ocs = font_add_sprite(s_fn7ocs, ord(" "), 1, -1);
var fn_12ocs = font_add_sprite(s_fn12ocs, ord(" "), 1, -1);
var fn_12ocsd = font_add_sprite(s_fn12ocsd, ord(" "), 1, -1);
var utilityFontSmelt = font_add_sprite(sMenuUtilitySmeltNumbers, ord(" "), 1, 0);
var fn_chat = font_add_sprite(s_fn_chat, ord(" "), 1, 1);
quickmenu2("init"); ##creates persistent qmenu object and sets some global vars
scr_gun("init"); ##initializes some gun's stuff. gun's gun's gun'ii gun's

draw_set_font(var fn_2)

## Collision object was here

## At the very end, create the screen scaling system object
instance_create(0, 0, o_screen)

## Combatactor surfaces
var combatactor_surf_256 = surface_create(256, 256);
var combatactor_surf_128 = surface_create(128, 128);
var combatactor_surf_64  = surface_create(64, 64);
var combatactor_surf_32  = surface_create(32, 32);

##Externally loaded resources
Portrait("init"); 
HUD("init"); 

##GZ Stuff
scr_enemyDB_init(); ##Only call once per game, loads enemy stat DB
Marquee("init"); ##ONLY CALL ONCE PER GAME, and at the very end as it checks quest vars and clock time
Breakout("init"); ##For breakout boxes
Shake("init");
Minigame("init");
Flourish("init");
Note("game init");

## Create world collision - MUST be after settings for rtreeSize
instance_create(0, 0, sys_collision);

##The below two are for hoopz facing during cinemas
var eventObject = NULL;
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
for (var i = 0; i < 6; i++) {
	var spawn_palette[i] = spawn_point_create(0, 0, o_enemy_cGremlin_small);
}

## Spawn editor palette
ds_map_replace(var spawn_palette[0], "hue", c_orange);
ds_map_replace(var spawn_palette[1], "hue", c_red);
ds_map_replace(var spawn_palette[2], "hue", c_yellow);
ds_map_replace(var spawn_palette[3], "hue", c_green);
ds_map_replace(var spawn_palette[4], "hue", c_purple);
ds_map_replace(var spawn_palette[5], "hue", c_blue);

## List for light objects in o_room_darkarea
Light("init");

## Globals for zauber stance
var stanceBeforeZauber = -1;
var stanceBeforeRoll = -1;
var stanceZauberHolster = 0;
var asdas
## For spawning arrest
var duergarPatrol = 1;

## Create the first room
scr_map_initialise_init();

## Reset game (code re-use)
scr_game_reset();
