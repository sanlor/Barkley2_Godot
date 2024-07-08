extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@export var music_folder := "res://barkley2/assets/b2_original/audio/Music/"

var music_bank := {
	}

var tween : Tween

# Old b2 variable. Not sure how its going to be used
var bgm_music : String = ""

## Music(get step queue init)

## Called on room load. Specify the music of every room below.
var bgmCheck = 1; ## was 5
#if (argument[0] == "get")

func _init():
	print("init music banks started: ", Time.get_ticks_msec())
	## Load music tracks
	var _music_folder := DirAccess.open( music_folder )
	print( _music_folder.get_files() )
	for file in  _music_folder.get_files():
		if not file.begins_with("mus_"):
			continue
		if file.ends_with(".ogg.import"):
			music_bank[ file.replace(".ogg.import","") ] = str(music_folder + file.replace(".import",""))

	print("init music banks ended: ", Time.get_ticks_msec(), " - ", music_bank.size(), " music_bank entries")

func _ready():
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )

func set_volume( raw_value : float): # 0 - 100
	B2_Config.bgm_gain_master = raw_value / 100
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )

func get_volume() -> float:
	return B2_Config.bgm_gain_master #db_to_linear(B2_Config.bgm_gain_master)

func room_get( room_name : String):
	# global.bgm_check = bgmCheck; ## WARNING Check what is this.
	#Music("queue", "mus_blankTEMP"); ## Default no music if not specified
	match room_name:
		## Tir Na Nog

		### Inside Bootybass ##
		"r_tnn_bootybass02":
			queue( music_bank.get("mus_tnn_bootylectro", "") )
			
		### Gov Speech ##
		"r_tnn_maingate02":
			#if (Quest("govSpeechInitiate") == 2) then
			queue( music_bank.get("mus_blankTEMP", "") )

		### Wilmer's House ## Wakeup Intro also ##   
		"r_tnn_wilmer02":
			#if (Quest("sceneBrandingStart") <= 3) then Music("queue", "mus_blankTEMP");
			queue( music_bank.get("mus_wilmer", "") )

		### Wilmer's house ##
		"r_tnn_wilmer01":
			queue( music_bank.get("mus_wilmer", "") )

		### Mortgage room ## No music during the waiting game ##
		"r_tnn_mortgage01":
			queue( music_bank.get("mus_blankTEMP", "") )

		### TNN L.O.N.G.I.N.U.S. Base ##
		"r_tnn_rebelbase02":
			queue( music_bank.get("mus_rebelbase", "") )

		### Normal TNN Music ## During curfew and non-curfew ##
		"tnnCurfew":
			## Need to setup the day_night system
			#if (scr_time_db("tnnCurfew") == "during") then Music("queue", "mus_dancePAX");
			#else Music("queue", "mus_tnn_shadowrun2");
			queue( music_bank.get("mus_tnn_shadowrun2", "") )

		### Eastelands ##
		#if (scr_area_get() == "est") then
		### Industrial Zone ##
		"r_est_industrialZone01":
			queue( music_bank.get("mus_wst_industrialzone_gumpus", "") )
	
		### Default Eastelands music ## Post Tutorial Check ##
			#else if (Quest("tutorialProgress") == 0 || Quest("tutorialProgress") >= 12) then Music("queue", "mus_carpfrug");
			#}
		### Westeland ##
			#if (scr_area_get() == "wst") then
			#{         
		### Default music ##
			#if (Quest("tutorialProgress") == 0 || Quest("tutorialProgress") >= 12) then Music("queue", "mus_carpfrug");
			#}
		### Prison / Hoosegow ##
			#if scr_area_get() = "pri" then
			#{
		### Prison Intro ## Being walked into the Hoosegow, Thrax' speech and processed into the system ##
		"r_pri_prisonGate01":
			queue( music_bank.get("mus_blankTEMP", "") )
			#if room = r_pri_prisonGate01 and Quest("prisonArrested") >= 1 and Quest("prisonIntro") < 5 then Music("queue", "mus_blankTEMP");
		### Prison itself ##
			#else Music("queue", "mus_blankTEMP");
			#}
		### Sewers Floor 1 and Floor 2 ##
			#if (scr_area_get() == "sw1" or scr_area_get() == "sw2") then
			#{        
		### Default music ##
			#Music("queue", "mus_sw1_new2");
			#}
		### Factory / Power Plant ##
			#if scr_area_get() = "fct" then 
			#{
		### Tutorial ending, chased by duergar ##
		"r_fct_factoryOutpost01":
			queue( music_bank.get("mus_rush", "") )
			#if (room == r_fct_factoryOutpost01 && Quest("tutorialProgress") == 10)
			#Music("queue", "mus_rush");
			#else Music("queue", "mus_blankTEMP");
		### Ys-Kolob ##
			#if scr_area_get() = "pdt" then 
			#if Quest("draculaBlood") >= 1 then Music("queue", "mus_pdt_heartbeat");
			#else Music("queue", "mus_yskolob");
		### Braincity ##
			#if scr_area_get() = "bct" then Music("queue", "mus_eurotrash_slow");
		### Gilbert's Peak, The Mountain Pass ##
			#if scr_area_get() = "pea" then Music("queue", "mus_pea_mountain");
		### AI Ruins ##
			#if scr_area_get() = "air" then Music("queue", "mus_AIRuins_powerbadboy");
		### Swamps ##
			#if scr_area_get() = "swp" then Music("queue", "mus_carpfrug");
		### Dojo ##
			#if room = r_ice_dojoIndoors01 or room = r_ice_dojoOutdoors01 or room = r_ice_dojoPond01 then Music("queue", "mus_dojo");
		### Caves, which means shops, moneymaking game, farys etc. just the goofy single room shit ##
			#if room = r_est_caveMoney01 then Music("queue", "mus_blankTEMP");
			#if room = r_est_fortune01 then Music("queue", "mus_blankTEMP");
			#if room = r_wst_caveFary01 then Music("queue", "mus_blankTEMP");
		"r_title":
			queue( music_bank.get("mus_gbl_aristocrat", "") )
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
		### If inside, apply effect of music dampening ## NOTE Convert this to Godot.
		#var effDes = 1;
		#if (instance_exists(o_room_interior)) effDes = 0.45;
		#if (room == r_tnn_bootybass02) effDes = 1;
		#global.bgm_interior_effect = Goto(global.bgm_interior_effect, effDes, dt_sec());
		_:
			push_error("Invalid room name: ", room_name)
#}
#else if (argument[0] == "queue")
func queue( track_name : String): ## track name should exist in the Music Bank dict.
	if track_name == "":
		push_warning("Invalid track name: ", track_name)
		track_name = music_folder + "mus_blankTEMP.ogg"

	var next_music : AudioStreamOggVorbis = ResourceLoader.load( track_name, "AudioStreamOggVorbis" )
	next_music.loop = true
	
	if audio_stream_player.playing:
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -80.0, 1.0)
		await tween.finished
		audio_stream_player.stop()
		
	audio_stream_player.stream = next_music
	audio_stream_player.play()
	
	tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", linear_to_db(B2_Config.bgm_gain_master), 1.0)
	await tween.finished
	
	bgm_music = track_name # argument[1];
	
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
