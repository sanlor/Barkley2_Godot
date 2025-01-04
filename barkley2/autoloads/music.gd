extends Node

@onready var audio_stream_player = $AudioStreamPlayer

@export var music_folder := "res://barkley2/assets/b2_original/audio/Music/"

var music_bank := {
	}

var tween : Tween

# Old b2 variable. Not sure how its going to be used
var bgm_music : String = ""

## What track is being played. useful when changing rooms that use the same music track.
var curr_playing_track := ""

## Room audio modifier
# some rooms have the audio volume modified, like interiors
var volume_mod := 1.0

func _load_music_banks():
	## Load music tracks
	var _music_folder : Array = FileSearch.search_dir( music_folder, "", true )
	for file : String in _music_folder:
		if file.ends_with(".import"):
			var file_split : Array = file.rsplit("/", false, 1)
			music_bank[ file_split.back().trim_suffix(".ogg.import") ] = str( file.trim_suffix(".import") )
	print("init music banks ended: ", Time.get_ticks_msec(), " msecs. - ", music_bank.size(), " music_bank entries")

func _enter_tree() -> void:
	_load_music_banks()

func _ready():
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )

# used to change the volume based on the menu open
func volume_menu():
	if B2_Screen.is_map_open:
		audio_stream_player.volume_db = linear_to_db( get_volume() * 0.45 )
	elif B2_Screen.is_paused:
		audio_stream_player.volume_db = -100.0
	else:
		audio_stream_player.volume_db = linear_to_db( get_volume() )
		
	audio_stream_player.volume_db *= volume_mod
	
func set_volume( raw_value : float): # 0 - 100
	B2_Config.bgm_gain_master = raw_value / 100
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )
	audio_stream_player.volume_db *= volume_mod
	
func get_volume() -> float:
	return B2_Config.bgm_gain_master #db_to_linear(B2_Config.bgm_gain_master)

func room_get( room_name : String):
	
	#Music("queue", "mus_blankTEMP"); ## Default no music if not specified
	if room_name == "r_title":
		queue( music_bank.get("mus_gbl_aristocrat", ""), 0.0 )
	elif room_name.contains("tnn"):
		## Tir Na Nog
		### Inside Bootybass ##
		if room_name == "r_tnn_bootybass02":
			queue( music_bank.get("mus_tnn_bootylectro", "") )
			return
			
		### Gov Speech ##
		if room_name == "r_tnn_maingate02":
			if B2_Playerdata.Quest("govSpeechInitiate") == 2:
				queue( music_bank.get("mus_blankTEMP", "") )
				return

		### Wilmer's House ## Wakeup Intro also ##   
		if room_name == "r_tnn_wilmer02":
			if B2_Playerdata.Quest("sceneBrandingStart") <= 3:
				queue( music_bank.get("mus_blankTEMP", "") )
			else:
				queue( music_bank.get("mus_wilmer", "") )
				return

		### Wilmer's house ##
		if room_name == "r_tnn_wilmer01":
			queue( music_bank.get("mus_wilmer", "") )
			return

		### Mortgage room ## No music during the waiting game ##
		if room_name == "r_tnn_mortgage01":
			queue( music_bank.get("mus_blankTEMP", "") )
			return

		### TNN L.O.N.G.I.N.U.S. Base ##
		if room_name == "r_tnn_rebelbase02":
			queue( music_bank.get("mus_rebelbase", "") )
			return

		### Normal TNN Music ## During curfew and non-curfew ##
		if room_name == "tnnCurfew":
			## Need to setup the day_night system
			#if (scr_time_db("tnnCurfew") == "during") then Music("queue", "mus_dancePAX");
			pass
		else:
			queue( music_bank.get("mus_tnn_shadowrun2", "") )

	### Eastelands ##
	elif room_name.contains("est"):
		### Industrial Zone ##
		if room_name == "r_est_industrialZone01":
			queue( music_bank.get("mus_wst_industrialzone_gumpus", "") )
			return
	
		### Default Eastelands music ## Post Tutorial Check ##
		elif B2_Playerdata.Quest("tutorialProgress") == 0 or B2_Playerdata.Quest("tutorialProgress") >= 12:
			queue( music_bank.get( "mus_carpfrug" ) )
			
	### Westeland ##
	elif room_name.contains("wst"):
		### Default music ##
		if B2_Playerdata.Quest("tutorialProgress") == 0 or B2_Playerdata.Quest("tutorialProgress") >= 12:
			queue( music_bank.get( "mus_carpfrug" ) )
		
	### Prison / Hoosegow ##
	elif room_name.contains("pri"):
		### Prison / Hoosegow ##

		### Prison Intro ## Being walked into the Hoosegow, Thrax' speech and processed into the system ##
		if room_name == "r_pri_prisonGate01":
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
	if room_name == "r_fct_factoryOutpost01":
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
	else:
		#push_warning("Invalid room name: ", room_name)
		pass
# "mus_blankTEMP" means mute
func play( track_name : String, speed := 0.25 ):
	queue( music_bank.get(track_name, ""), speed )

func stop( speed := 0.25 ):
	#queue( music_bank.get("mus_blankTEMP.ogg", ""), speed )
	if tween != null:
		tween.kill()
	tween = create_tween()
	tween.tween_property(audio_stream_player, "volume_db", -80.0, speed)
	await tween.finished
	audio_stream_player.stop()

#else if (argument[0] == "queue")
func queue( track_name : String, speed := 1.0 ): ## track name should exist in the Music Bank dict.
	if track_name == "":
		push_warning("Invalid track name: ", track_name)
		track_name = music_folder + "mus_blankTEMP.ogg"
	
	if curr_playing_track == track_name:
		# already playing that track, do nothing.
		return
	else:
		# update track name, queue the change
		curr_playing_track = track_name
	
	var next_music : AudioStreamOggVorbis = ResourceLoader.load( track_name, "AudioStreamOggVorbis" )
	next_music.loop = true
	
	# handle sudden change is music tracks.
	if is_instance_valid(tween):
		if tween.is_running():
			push_warning("You are changing music tracks too fast. Tween is still running. Waiting for it to finish.")
			await tween.finished
	
	if audio_stream_player.playing:
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -80.0, speed)
		await tween.finished
		audio_stream_player.stop()
		
	audio_stream_player.stream = next_music
	audio_stream_player.play()
	audio_stream_player.volume_db = -80.0
	
	if speed != 0.0: # fade in music
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", linear_to_db(B2_Config.bgm_gain_master * volume_mod), speed)
		await tween.finished
	else: # instant music
		audio_stream_player.volume_db = linear_to_db(B2_Config.bgm_gain_master)
		audio_stream_player.volume_db *= volume_mod
	
	bgm_music = track_name # argument[1];
