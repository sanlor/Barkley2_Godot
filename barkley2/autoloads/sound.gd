## The Almighty B2_Sound Node
# Handles all generic SFX from the game. Also helps delivering SFX stream files to be used in AudioPlayer2D
# NOTE All music files are indexed inside the 'SOUNDBANK' json file.
# NOTE 'SOUNDPICK' json file is responsible for all soundpick, which are 'nicknames' for a group of sfx. Ex. "shoot_gun" would pick (at random) gun_shoot01, gun_shoot02 or gun_shoot03.
# This also uses a pool of audio players. This way, multiple SFX can be playied at the same time.
# @tutorial: https://www.youtube.com/watch?v=eRHJWVY2nT8

@icon("uid://bl0xx87ug1w7k")
extends Node

## NOTES
# arguments are now different functions
# scr_music_init() included on this autoload

## emited when a sound had a invalid data
signal sound_bank_dirty

## scr_music_init()
## get duplicate sounds
var debug_messages := false

@onready var audio_loop: AudioStreamPlayer = $AudioLoop

## Godot stuff
@export var audio_folder := "res://barkley2/assets/b2_original/audio/"

const SOUNDBANK 		= preload("res://barkley2/resources/B2_Sound/soundbank.json")
const SOUNDPICK 		= preload("res://barkley2/resources/B2_Sound/soundpick.json")

var sound_bank := {} ## all sounds that the game has.
var sound_pick := {} ## Allow for multipls sounds for the same effect (Like footsteps having random sounds each step)

var sound_pool 				:= [] ## a whole bunch of AudioStreamPlayer
var sound_pool_amount 		:= 50

var sound_loop				:= {} ## Keep track of the loops

var force_sound_bank_reindex := false

## All SFX files are loaded on an array for easy lookup
func _init_sound_banks():
	push_error("Sound reindex called.")
	# https://gist.github.com/hiulit/772b8784436898fd7f942750ad99e33e
	# https://godotengine.org/asset-library/asset/1974
	## Load audio tracks (SFX)
	var audio_files : Array = FileSearch.search_dir(audio_folder, "", true)
	for file : String in audio_files:
		if file.ends_with(".import") and file.contains("sn_"):
			var file_split : Array = file.rsplit("/", false, 1)
			sound_bank[ file_split.back().trim_suffix(".import").replace(".wav","").replace(".ogg","") ] = str( file.trim_suffix(".import") )
			
	print_rich("[color=medium_purple]Init sound banks ended: ", Time.get_ticks_msec(), " msecs. - ", sound_bank.size(), " sound_bank key entries[/color]")
	_save_soundbank_to_disk()
	
func _enter_tree() -> void:
	if force_sound_bank_reindex:
		_init_sound_banks()
	else:
		sound_bank = SOUNDBANK.data
		sound_pick = SOUNDPICK.data
	
func _ready():
	B2_SignalBus.gun_changed.connect( _play_gun_swap_sfx )		## Play gun change sfx
	for i in sound_pool_amount:									## Load audio pool
		sound_pool.append( AudioStreamPlayer.new() )
	sound_bank_dirty.connect( _init_sound_banks )				## Handle cache misses
	if debug_messages: print( "Sound: sound_pool: x", sound_pool.size() ); print( "Sound: sound_bank entries: %s. sound_pick entries: %s." % [ sound_bank.size(), sound_pick.size() ] )

	
## This writes the Sound list to disk to avoid unecessary lookups during boot.
func _save_soundbank_to_disk() -> void:
	print_rich("[color=cyan]WARNING: Saving Soundbank to disk.[/color]")
	var file = FileAccess.open( "res://barkley2/resources/B2_Sound/soundbank.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(sound_bank, "\t") )
	
func _save_soundpick_to_disk() -> void:
	print_rich("[color=cyan]WARNING: Saving SoundPick to disk.[/color]")
	var file = FileAccess.open( "res://barkley2/resources/B2_Sound/soundpick.json", FileAccess.WRITE )
	file.store_string( JSON.stringify(sound_pick, "\t") )
	
func set_volume( raw_value : float ): # 0 - 100
	raw_value = clampf(raw_value, 0, 100)
	B2_Config.sfx_gain_master = raw_value / 100
	for sound in sound_pool:
		sound.volume_db = linear_to_db( B2_Config.sfx_gain_master )

func get_volume() -> float:
	return B2_Config.sfx_gain_master

## Plays SFX when the player changes Weapons.
func _play_gun_swap_sfx() -> void:
	var wpn : B2_Weapon = B2_Gun.get_current_gun()
	## Tries to pick a specific swapsound. if it cant, play the default one.
	if wpn:		play_pick( wpn.get_swap_sound() )
	else:		play_pick( "hoopz_swapguns" ) ## "hoopz_swapguns" is the default is no sound exists

## used for Positional sounds. # Return the file name for a sound effect
func get_sound(soundID : String) -> String:
	if sound_bank.has(soundID):
		return sound_bank[soundID]
	elif sound_pick.has(soundID): ## Fallback to soundpick
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return get_sound(soundVal) ## NOTE We looping, bitch
	else:
		return ""
	
# Return the file name for a soundpick
func get_sound_pick(soundpickID : String) -> String:
	if sound_pick.has(soundpickID): ## Fallback to soundpick
		assert( not sound_pick[soundpickID].is_empty(), "It should not be empty, i think." )
		return sound_pick[soundpickID].pick_random() as String # <- Important
	else:
		return soundpickID # Sound not found
		
## stop the player from playing, emit a signal to force a graceful stop
## You can also do some fancy stuff, like fading aout the audio before stopping it.
func stop(sfx : AudioStreamPlayer, fade := false, fade_time := 0.0): 
	if sound_loop.has(sfx):
		sound_loop[sfx] = 0
	if fade:
		var fade_tween := create_tween()
		fade_tween.tween_property(sfx, "volume_db", linear_to_db(0.01), fade_time )
		await fade_tween.finished
	if sfx != null:
		sfx.finished.emit()

func play_pick(soundID : String, start_at := 0.0, priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	if sound_pick.has(soundID):
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return play(soundVal, start_at, priority, loops, pitch)
	else:
		push_warning("Invalid SoundID: ", soundID); sound_bank_dirty.emit()
		return AudioStreamPlayer.new() # -1;
		
func play(soundID : String, start_at := 0.0, priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	if soundID.begins_with("sn_debug"): print("Debug sound used (%s). Change this for final release." % soundID)
	
	if sound_bank.has(soundID):
		return queue(soundID, start_at, priority, loops, pitch)
		
	elif sound_pick.has(soundID): ## Fallback to soundpick
		assert( not sound_pick[soundID].is_empty(), "It should not be empty, i think." )
		var soundVal : String = sound_pick[soundID].pick_random() # <- Important
		return play(soundVal, start_at, priority, loops, pitch) ## NOTE We looping, bitch
		
	else: ## Invalid sound
		if soundID.is_empty():			push_warning("B2_Sound: Empty SoundID called.")
		else:							push_warning("Invalid SoundID: ", soundID); sound_bank_dirty.emit()
		return AudioStreamPlayer.new()

func queue( soundID : String, start_at := 0.0, _priority := false, loops := 1, pitch := 1.0 ) -> AudioStreamPlayer:
	if sound_pool.is_empty():
		push_error("No audiostreeeeeeeam on the pool. This is CRITICAL!")
		return AudioStreamPlayer.new()
	var sfx : AudioStreamPlayer = sound_pool.pop_back()
	var sound := load( sound_bank[soundID] )
	sfx.stream = sound
	sfx.name = soundID + "_" + str(randi())
	sfx.finished.connect( finished_playing.bind(sfx) )
	sfx.volume_db = linear_to_db( B2_Config.sfx_gain_master )
	sfx.pitch_scale = pitch
	sfx.bus = "Audio"
	
	## Loop Setup
	sound_loop[sfx] = loops
	
	## Play the damn thing.
	add_child(sfx)
	sfx.play( start_at )
	return sfx			## Some nodes ant to monitor the state of its AudioPlayer

## Loop - Allow infinite looping SFX while changing rooms. for limited looping, use play()
func play_loop( soundID : String ):
	var audio_stream : AudioStreamOggVorbis = load( get_sound( soundID ) )
	audio_stream.loop = true
	audio_loop.volume_db = linear_to_db( B2_Config.sfx_gain_master * 0.75 )
	audio_loop.stream = audio_stream
	audio_loop.play()
	
func stop_loop():
	if audio_loop.playing:
		audio_loop.stop()
	else:
		push_warning("Nothing is playing. something may be wrong.")

func set_loop_volume( volume : float ):
	if volume > 1.0:
		push_warning("Volume out of range - %s - careful." % volume)
	audio_loop.volume_db = linear_to_db( volume )

func finished_playing( sfx : AudioStreamPlayer ):
	if sound_loop.has(sfx):		## Check if its looping
		sound_loop[sfx] -= 1	## Decrease loops
		if sound_loop[sfx] > 0:	## There are still loops to be looped. play anbother one.
			sfx.play()
			return
			
	## Finished playing. cleanup and return to the pool.
	sfx.finished.disconnect( finished_playing.bind(sfx) )
	remove_child( sfx )
	sound_pool.push_back( sfx )
