extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@export var music_folder := "res://barkley2/assets/b2_original/_audio/Music/"

var music_bank := {
	}

## Music(get step queue init)

## Called on room load. Specify the music of every room below.
var bgmCheck = 1; ## was 5
#if (argument[0] == "get")

func _ready():
	## Load music banks
	var _music_folder := DirAccess.open( music_folder )
	for file in  _music_folder.get_files():
		if file.ends_with(".import"):
			continue
		if not file.begins_with("mus_"):
			continue
		if file.ends_with(".ogg"):
			music_bank[ file.rstrip(".ogg") ] = load(music_folder + "/" + file)
		else:
			push_error("Unknown file at ", music_folder, file, ".")
	pass
#
#func get( room_name : String):
	## global.bgm_check = bgmCheck; ## WARNING Check what is this.
	#Music("queue", "mus_blankTEMP"); ## Default no music if not specified
#
	### Tir Na Nog
	#if room_name == "tnn"):
	#{
	### Inside Bootybass ##
	#if (room == r_tnn_bootybass02) then 
	#{ 
	#Music("queue", "mus_tnn_bootylectro"); 
	#exit; 
	#}
#
	### Gov Speech ##
	#if (room == r_tnn_maingate02) then
	#{
	#if (Quest("govSpeechInitiate") == 2) then
	#{
	#Music("queue", "mus_blankTEMP");
	#exit;
	#}
	#}
#
	### Wilmer's House ## Wakeup Intro also ##   
	#if (room == r_tnn_wilmer02) then
	#{
	#if (Quest("sceneBrandingStart") <= 3) then Music("queue", "mus_blankTEMP");
	#else Music("queue", "mus_wilmer");
	#exit;
	#}
#
	### Wilmer's house ##
	#if (room == r_tnn_wilmer01) then
	#{ 
	#Music("queue", "mus_wilmer"); 
	#exit; 
	#}
#
	### Mortgage room ## No music during the waiting game ##
	#if (room == r_tnn_mortgage01) then
	#{ 
	#Music("queue", "mus_blankTEMP"); 
	#exit; 
	#}
#
	### TNN L.O.N.G.I.N.U.S. Base ##
	#if (room == r_tnn_rebelbase02) then 
	#{ 
	#Music("queue", "mus_rebelbase"); 
	#exit; 
	#}
#
	### Normal TNN Music ## During curfew and non-curfew ##
	#if (scr_time_db("tnnCurfew") == "during") then Music("queue", "mus_dancePAX");
	#else Music("queue", "mus_tnn_shadowrun2");
	#}
#
	### Eastelands ##
	#if (scr_area_get() == "est") then
	#{         
	### Industrial Zone ##
	#if (room == r_est_industrialZone01) then 
	#{
	#Music("queue", "mus_wst_industrialzone_gumpus");
	#exit;
	#}
#
	### Default Eastelands music ## Post Tutorial Check ##
	#else if (Quest("tutorialProgress") == 0 || Quest("tutorialProgress") >= 12) then Music("queue", "mus_carpfrug");
	#}
#
	### Westeland ##
	#if (scr_area_get() == "wst") then
	#{         
	### Default music ##
	#if (Quest("tutorialProgress") == 0 || Quest("tutorialProgress") >= 12) then Music("queue", "mus_carpfrug");
	#}
#
	### Prison / Hoosegow ##
	#if scr_area_get() = "pri" then
	#{
	### Prison Intro ## Being walked into the Hoosegow, Thrax' speech and processed into the system ##
	#if room = r_pri_prisonGate01 and Quest("prisonArrested") >= 1 and Quest("prisonIntro") < 5 then Music("queue", "mus_blankTEMP");
#
	### Prison itself ##
	#else Music("queue", "mus_blankTEMP");
	#}
#
	### Sewers Floor 1 and Floor 2 ##
	#if (scr_area_get() == "sw1" or scr_area_get() == "sw2") then
	#{        
	### Default music ##
	#Music("queue", "mus_sw1_new2");
	#}
#
	### Factory / Power Plant ##
	#if scr_area_get() = "fct" then 
	#{
	### Tutorial ending, chased by duergar ##
	#if (room == r_fct_factoryOutpost01 && Quest("tutorialProgress") == 10)
	#{
	#Music("queue", "mus_rush");
	#exit;
	#} 
	#else Music("queue", "mus_blankTEMP");
	#}     
#
	### Ys-Kolob ##
	#if scr_area_get() = "pdt" then 
	#{
	#if Quest("draculaBlood") >= 1 then Music("queue", "mus_pdt_heartbeat");
	#else Music("queue", "mus_yskolob");
	#}
#
	### Braincity ##
	#if scr_area_get() = "bct" then Music("queue", "mus_eurotrash_slow");
#
	### Gilbert's Peak, The Mountain Pass ##
	#if scr_area_get() = "pea" then Music("queue", "mus_pea_mountain");
#
	### AI Ruins ##
	#if scr_area_get() = "air" then Music("queue", "mus_AIRuins_powerbadboy");
#
	### Swamps ##
	#if scr_area_get() = "swp" then Music("queue", "mus_carpfrug");
#
	### Dojo ##
	#if room = r_ice_dojoIndoors01 or room = r_ice_dojoOutdoors01 or room = r_ice_dojoPond01 then Music("queue", "mus_dojo");
#
	### Caves, which means shops, moneymaking game, farys etc. just the goofy single room shit ##
	#if room = r_est_caveMoney01 then Music("queue", "mus_blankTEMP");
	#if room = r_est_fortune01 then Music("queue", "mus_blankTEMP");
	#if room = r_wst_caveFary01 then Music("queue", "mus_blankTEMP");
	#if room = r_title then Music("queue", "mus_gbl_aristocrat");
	#}
#else if (argument[0] == "step")
#{
	###show_debug_message("Music('step') = " + string(global.bgm_check));
	#if (global.bgm_check > 0)
	#{
		#global.bgm_check -= dt();
		#if (global.bgm_check <= 0)
		#{
			#if (global.bgm_music == NULL_STRING || global.bgm_disable) audio_set_bgm("mus_blankTEMP");
			#else
			#{
				#if (global.bgm_current_music != global.bgm_music) audio_set_bgm(global.bgm_music);
				###global.bgm_check = bgmCheck; ## Why does this reset?
				###show_debug_message("Music('step') - music check");
			#}
		#}
	#}
	### If inside, apply effect of music dampening
	#var effDes = 1;
	#if (instance_exists(o_room_interior)) effDes = 0.45;
	#if (room == r_tnn_bootybass02) effDes = 1;
	#global.bgm_interior_effect = Goto(global.bgm_interior_effect, effDes, dt_sec());
#}
#else if (argument[0] == "queue")
#{
	#global.bgm_music = argument[1];
	#show_debug_message("Music('queue') - " + global.bgm_music);
#}
#else if (argument[0] == "init")
#{
	#global.bgm_check = bgmCheck;
	#global.bgm_disable = false; ## was global.music_ist_verboten
	#global.bgm_music = ""; ## Value you want to set to
	#global.bgm_interior_effect = 1;
	#global.bgm_fast_fade = false;
#}
#else show_debug_message("Music: Unknown command " + string(argument[0]));
