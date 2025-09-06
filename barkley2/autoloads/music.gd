extends Node
## Autoload that controls the Music.
# TODO Improve this script. Volume control sucks.

## The static music database
const MUSICBANK 		= preload("res://barkley2/resources/B2_Music/musicbank.json")

## Music that plays during combat.
const BATTLE_MUSIC := [
	"mus_tnn_jockjam",
	#"mus_fishing_battleTEMP",
]
## Music that plays after the battle ended.
const END_BATTLE_MUSIC := [
	"shitworld",
]

## The star of the show. Plays the music.
@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

## emited when a sound had a invalid data
signal music_bank_dirty

## The volatile music database.
var music_bank := {}

## Volume tweener. makes the music fade in/out
var tween : Tween

# Old b2 variable. Not sure how its going to be used
var bgm_music 					:= ""

## What track is being played. useful when changing rooms that use the same music track.
var curr_playing_track 			:= ""
var prev_playing_track 			:= ""
var stored_playing_track		:= ""
var stored_playing_track_time	:= 0.0

## Room audio modifier
# some rooms have the audio volume modified, like interiors
var volume_mod := 1.0

## DEBUG USE ONLY. incase a music cache misses, reindex all music files.
func _load_music_banks( music_folder : String ):
	## Load music tracks
	push_error("Music reindex called.")
	var _music_folder : Array = FileSearch.search_dir( music_folder, "", true )
	for file : String in _music_folder:
		if file.ends_with(".ogg.import"):
			var file_split : Array = file.rsplit("/", false, 1)
			music_bank[ file_split.back().trim_suffix(".ogg.import") ] = str( file.trim_suffix(".import") )
	print_rich("[color=blue_violet]Init music banks ended: ", Time.get_ticks_msec(), " msecs. - ", music_bank.size(), " music_bank entries.[/color]")
	
## DEBUG USE ONLY. incase a music cache misses, reindex all music files.
func _save_musicbank_to_disk() -> void:
	print_rich("[color=cyan]WARNING: Saving Musicbank to disk.[/color]")
	var file = FileAccess.open( "res://barkley2/resources/B2_Music/musicbank.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(music_bank, "\t") )

## DEBUG Stuff. reindex json if needed.
func _reindex_musicbank() -> void:
	push_error("Music reindex called.")
	_load_music_banks( "res://barkley2/assets/b2_original/audio/Music/" )
	var file = FileAccess.open( "res://barkley2/resources/B2_Music/musicbank.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(music_bank, "\t") )
	print_rich("[color=cyan]NOTE: Saving musicbank to disk.[/color]")
	music_bank = MUSICBANK.data
	
func _enter_tree() -> void:
	## Load lower quality Music for web export.
	music_bank = MUSICBANK.data

func _ready():
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )
	music_bank_dirty.connect( _reindex_musicbank )

# used to change the volume based on the menu open
func volume_menu( force := false ):
	if B2_Screen.is_any_menu_open() or force:		audio_stream_player.volume_db = linear_to_db( get_volume() * 0.45 )
	elif B2_Screen.is_paused:						audio_stream_player.volume_db = -100.0
	else:											audio_stream_player.volume_db = linear_to_db( get_volume() )
	audio_stream_player.volume_db *= volume_mod
	
func set_volume( raw_value : float): # 0 - 100
	B2_Config.bgm_gain_master = raw_value / 100
	audio_stream_player.volume_db = linear_to_db( B2_Config.bgm_gain_master )
	audio_stream_player.volume_db *= volume_mod
	
func get_volume() -> float:
	return B2_Config.bgm_gain_master #db_to_linear(B2_Config.bgm_gain_master)

## Absolute bonkers function. Plays music based on the area that the player is right now. Someone wen mental on the if/else statements.
func room_get( room_name : String):
	#Music("queue", "mus_blankTEMP"); ## Default no music if not specified
	if room_name == "r_title":
		await get_tree().create_timer(0.5).timeout
		play( "mus_gbl_aristocrat", 0.25 )
		
	elif room_name.contains("tnn"):
		## Tir Na Nog
		### Inside Bootybass ##
		if room_name == "r_tnn_bootybass02":
			play("mus_tnn_bootylectro")
			
		### Gov Speech ##
		if room_name == "r_tnn_maingate02":
			if B2_Playerdata.Quest("govSpeechInitiate") == 2:
				play("mus_blankTEMP")
				
		### Wilmer's House ## Wakeup Intro also ##   
		if room_name == "r_tnn_wilmer02":
			if B2_Playerdata.Quest("sceneBrandingStart") <= 3:
				play("mus_blankTEMP")
			else:
				play("mus_wilmer")
				
		### Wilmer's house ##
		if room_name == "r_tnn_wilmer01":
			play("mus_wilmer")
			
		### Mortgage room ## No music during the waiting game ##
		if room_name == "r_tnn_mortgage01":
			play("mus_blankTEMP")
			
		### TNN L.O.N.G.I.N.U.S. Base ##
		if room_name == "r_tnn_rebelbase02":
			play("mus_rebelbase")
			
		### Normal TNN Music ## During curfew and non-curfew ##
		if room_name == "tnnCurfew": ## WARNING The room name may be incorrect. <---- Verify
			## Need to setup the day_night system ## DONE!
			if B2_Database.time_check("tnnCurfew") == "during":
				play("mus_dancePAX")
		else:
			play("mus_tnn_shadowrun2")
			
	### Eastelands ##
	elif room_name.contains("est"):
		### Industrial Zone ##
		if room_name == "r_est_industrialZone01":
			play("mus_wst_industrialzone_gumpus")
			
		### Default Eastelands music ## Post Tutorial Check ##
		elif B2_Playerdata.Quest("tutorialProgress") == 0 or B2_Playerdata.Quest("tutorialProgress") >= 12:
			play( "mus_carpfrug" )
			
	### Westeland ##
	elif room_name.contains("_wst_"):
		### Default music ##
		if B2_Playerdata.Quest("tutorialProgress") == 0 or B2_Playerdata.Quest("tutorialProgress") >= 12:
			play( "mus_carpfrug" )
		
	### Prison / Hoosegow ##
	elif room_name.contains("_pri_"):
		### Prison / Hoosegow ##

		### Prison Intro ## Being walked into the Hoosegow, Thrax' speech and processed into the system ##
		if room_name == "r_pri_prisonGate01"and B2_Playerdata.Quest("prisonIntro") < 5:
			play("mus_blankTEMP")
		### Prison itself ##
		else :
			play("mus_blankTEMP")
		
		### Sewers Floor 1 and Floor 2 ##
	elif room_name.contains("_sw1_") or room_name.contains("_sw2_"): 
		### Default music ##
		play("mus_sw1_new2")

		### Factory / Power Plant ##
	elif room_name.contains("_fct_"):
		### Tutorial ending, chased by duergar ##
		if room_name == "r_fct_factoryOutpost01" and B2_Playerdata.Quest("tutorialProgress") == 10:
			play("mus_rush")
		else:
			play("mus_blankTEMP")
			
	### Ys-Kolob ##
	elif room_name.contains("_pdt_"):
		if B2_Playerdata.Quest("draculaBlood") >= 1:
			play("mus_pdt_heartbeat")
		else:
			play("mus_yskolob")
			
	### Braincity ##
	elif room_name.contains("_bct_"): ## heh, buceta
		play("mus_eurotrash_slow")
		
	### Gilbert's Peak, The Mountain Pass ##
	elif room_name.contains("_pea_"):
		play("mus_pea_mountain")
		
	### AI Ruins ##
	elif room_name.contains("_air_"):
		play("mus_AIRuins_powerbadboy") 	## Normal music
		#play("mus_swp_accousticarea", "")	## My Debug music
		
	### Swamps ##
	elif room_name.contains("_swp_"):
		play("mus_carpfrug")
		
	### Dojo ##
	elif room_name == "r_ice_dojoIndoors01" or \
		room_name == "r_ice_dojoOutdoors01" or \
		room_name == "r_ice_dojoPond01":
		play("mus_dojo")
		
	### Caves, which means shops, moneymaking game, farys etc. just the goofy single room shit ##
	if room_name == "r_est_caveMoney01": 
		play("mus_blankTEMP")
		
	if room_name == "r_est_fortune01":
		play("mus_blankTEMP")
		
	if room_name == "r_wst_caveFary01": 
		play("mus_blankTEMP")

	### If inside, apply effect of music dampening ## NOTE Convert this to Godot.
	#var effDes = 1;
	#if (instance_exists(o_room_interior)) effDes = 0.45;
	#if (room == r_tnn_bootybass02) effDes = 1;
	#global.bgm_interior_effect = Goto(global.bgm_interior_effect, effDes, dt_sec());
	else:
		#push_warning("Invalid room name: ", room_name)
		pass
		
## "mus_blankTEMP" means mute

func play( track_name : String, speed := 0.25, loop := true ):
	queue( music_bank.get(track_name, ""), speed, loop )

## Play combat music
func play_combat( speed := 0.25, force_track := "" ) -> void:
	store_curr_music()
	if force_track:		queue( music_bank.get( force_track, "" ), speed )
	else:				queue( music_bank.get( BATTLE_MUSIC.pick_random(), "" ), speed )

func play_end_combat( force_track := "" ) -> void:
	if force_track:		B2_Music.play( force_track )
	else:				B2_Music.play( END_BATTLE_MUSIC.pick_random() )

## keep track of the current room music
func store_curr_music() -> void:
	stored_playing_track 			= curr_playing_track
	stored_playing_track_time 		= audio_stream_player.get_playback_position()
	
	## Avoid Cache misses.
	if stored_playing_track.is_empty(): 
		stored_playing_track = music_bank.get( "mus_blankTEMP" )

func resume_stored_music( speed := 0.25 ) -> void:
	queue( stored_playing_track, speed, stored_playing_track_time )

func clear_curr_music() -> void:
	stored_playing_track 			= ""
	stored_playing_track_time 		= 0.0

func stop( speed := 0.25 ):
	if not audio_stream_player:
		return
		
	if audio_stream_player.playing:
		if tween != null:
			tween.kill()
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -80.0, speed)
		await tween.finished
		curr_playing_track = ""
		audio_stream_player.stop()
	else:
		push_warning("Trying to stop playing music when its not playing music.")

func queue( track_name : String, speed := 0.25, track_position := 0.0, loop := true ): ## track name should exist in the Music Bank dict.
	if track_name == "":
		push_warning("Invalid track name: '%s'. Playing a classic instead: mus_blankTEMP." % track_name)
		print_rich("[color=cyan] Music cache miss. Get ready to reindex the music stuff. [/color][color=blue]Queue the error messages![/color]")
		music_bank_dirty.emit()
		track_name = music_bank.get( "mus_blankTEMP" ) # music_folder + "mus_blankTEMP.ogg"
		
	elif curr_playing_track == track_name and audio_stream_player.playing:
		# already playing that track, do nothing.
		return
		
	else:
		# update track name, queue the change
		curr_playing_track = track_name
	
	var next_music : AudioStreamOggVorbis = ResourceLoader.load( track_name, "AudioStreamOggVorbis" )
	next_music.loop = loop
	
	# handle sudden change is music tracks.
	if is_instance_valid(tween):
		if tween.is_running():
			push_warning("You are changing music tracks ( %s ) too fast. Volume tweener is still running. Waiting for it to finish." % track_name)
			await tween.finished
	
	if audio_stream_player.playing:
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", -80.0, speed)
		await tween.finished
		audio_stream_player.stop()
		
	audio_stream_player.stream = next_music
	audio_stream_player.play( track_position )
	audio_stream_player.volume_db = -80.0
	
	if speed != 0.0: # fade in music
		tween = create_tween()
		tween.tween_property(audio_stream_player, "volume_db", linear_to_db(B2_Config.bgm_gain_master * volume_mod), speed)
		await tween.finished
	else: # instant music
		audio_stream_player.volume_db = linear_to_db(B2_Config.bgm_gain_master)
		audio_stream_player.volume_db *= volume_mod
	
	bgm_music = track_name # argument[1];
