extends Node

## NOTES
# arguments are now different functions
# scr_music_init() included on this autoload

## scr_music_init()
## get duplicate sounds

@warning_ignore("unused_variable")
@onready var tim = Time.get_ticks_msec()

var dsmSound = Dictionary() ## ds_map_create();
var dslSoundRecent = Array() ##ds_list_create(); # original # debug
var dsmSoundLength = Dictionary() ## ds_map_create();
var dsmSoundOrphan = Dictionary() ## ds_map_create();
var dsmSoundStream = Dictionary() ## ds_map_create();
var dsmSoundVolume = Dictionary() ## ds_map_create();
var dsmSoundMemory = Dictionary() ## ds_map_create();

## WARNING Modified this code
var souCou = 0
var musCou = 0
var filNam
var dirNam
var pthNam
var sndNam
var sizTot = 0

var soundPlayed := Array()
var soundHealth := Array()

## Godot stuff
@export var audio_folder := "res://barkley2/assets/b2_original/audio/"

var sound_bank := {} ## all sounds that the game has.

var sound_pool 				:= [] ## a whole bunch of AudioStreamPlayer
var sound_pool_directional 	:= [] ## a whole bunch of AudioStreamPlayer2D, to enable far away sounds and such.
var sound_pool_amount 		:= 25

var sound_loop				:= {} ## Keep track of the loops

func _init_sound_banks():
	print("init sound banks started: ", Time.get_ticks_msec())
	await get_tree().process_frame
	
	## Load audio tracks (SFX)
	var _audio_folder := DirAccess.open( audio_folder )
	for folder in _audio_folder.get_directories():
		var _folder := DirAccess.open( audio_folder + "/" + folder ) # Recursive search
		for file in  _folder.get_files():
			if not file.begins_with("sn_"): # only allow sn_ prefix music
				continue
			if file.ends_with(".import"): # ignore godot files
				sound_bank[ file.trim_suffix(".import").replace(".wav","").replace(".ogg","") ] = str(audio_folder + folder + "/" + file.replace(".import",""))

	print("init sound banks ended: ", Time.get_ticks_msec(), " - ", sound_bank.size(), " sound_bank entries")
	
func set_volume( raw_value : float ): # 0 - 100
	B2_Config.sfx_gain_master = raw_value / 100
	for sound in sound_pool:
		sound.volume_db = linear_to_db( B2_Config.sfx_gain_master )

func get_volume() -> float:
	return B2_Config.sfx_gain_master

func _ready():
	_init_sound_banks()
	
	for i in sound_pool_amount:
		sound_pool.append( 					AudioStreamPlayer.new() 	)
		sound_pool_directional.append( 		AudioStreamPlayer2D.new() 	)
	print("Sound: sound_pool: x", sound_pool.size(), " - sound_pool_directional: x", sound_pool_directional.size())

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

func play(soundID : String, start_at := 0.0, priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	## Sound("play" / "at" / "on", etc...)
	## Sound("play", 1 = soundID, 2 = priority, 3 = loops)
	if sound_bank.has(soundID):
		
	#if check(soundID, -999, -999) == 0:
		## audio_sound_gain_ext(soundID, 1, 0); ## TODO Port this script / function
		return queue(soundID, start_at, priority, loops, pitch) # 0 # audio_play_sound(soundID, priority, loops); ## TODO Port this script / function
	else:
		push_warning("Invalid SoundID: ", soundID)
		return AudioStreamPlayer.new() # -1;

func queue(soundID : String, start_at := 0.0, _priority := false, loops := 1, pitch := 1.0) -> AudioStreamPlayer:
	if sound_pool.is_empty():
		push_error("No audiostreen on the pool. This is CRITICAL!")
		return AudioStreamPlayer.new()
	var sfx : AudioStreamPlayer = sound_pool.pop_back()
	var sound := load( sound_bank[soundID] )
	sfx.stream = sound
	sfx.name = soundID + "_" + str(randi())
	sfx.finished.connect( finished_playing.bind(sfx) )
	sfx.volume_db = linear_to_db( B2_Config.sfx_gain_master )
	sfx.pitch_scale = pitch
	## Loop Setup
	sound_loop[sfx] = loops
	
	add_child(sfx)
	sfx.play( start_at )
	return sfx
	#print("player ",sfx," added.")

func finished_playing( sfx : AudioStreamPlayer ):
	if sound_loop.has(sfx):
		sound_loop[sfx] -= 1
		if sound_loop[sfx] > 0:
			sfx.play()
			return
	sfx.finished.disconnect( finished_playing.bind(sfx) )
	remove_child( sfx )
	sound_pool.push_back( sfx )
	#print("player ",sfx," removed.")

func at( soundID, x, y, _z, _fallDist, _fallMax, _fallFactor, _loops, _priority ):
	## Sound("at", 1 = soundID, 2 = x, 3 = y, 4 = z, 5 = fallDist, 6 = fallMax, 7 = fallFactor, 8 = loops, 9 = priority)
	if check( soundID, floor( x / 32) * 32, floor( y / 32) * 32) == 0:
		# audio_sound_gain_ext(argument[1],1,0);  ## TODO Port this script / function
		return 0 # audio_play_sound_at(argument[1], argument[2], argument[3], argument[4], argument[5], argument[6], argument[7], argument[8], argument[9]);  ## TODO Port this script / function
	else:
		return -1;

func on(_emitterID, soundID, _loops, _priority):
	## Sound("on", 1 = emitterID, 2 = soundID, 3 = loops, 4 = priority)
	# if check( soundID, audio_emitter_get_x( emitterID ), audio_emitter_get_y( emitterID ) == 0): ## TODO Port this script / function
	if check( soundID, 0, 0 == 0):
		# audio_sound_gain_ext(emitterID, 1, 0); ## TODO Port this script / function
		return 0 #audio_play_sound_on( emitterID, soundID, loops, priority ); ## TODO Port this script / function
	else:
		return -1;


func step():
	## Clear sound history
	## TODO Figure out what this does. Until them, is disabled.
	# Looks like some kind of timer for sfx. 
	#for (var _s = 0; _s < ds_list_size(var soundPlayed); _s += 1):
	for _s in soundPlayed.size() - 1:
		#var _v = soundHealth.find(_s);
		#_v -= get_process_delta_time();
		#if (_v <= 0):
			#ds_list_delete(var soundPlayed, _s);
			#ds_list_delete(var soundHealth, _s);
			#_s -= 1;
		#else:
			#ds_list_replace(var soundHealth, _s, _v);
		pass

func check(soundID, x, y):
	# original # Check if this sound has been played too recently
	# original # Sound("check", 1 = soundID, 2 = x, 3 = y)
	var _st = str( soundID ) + "=" + str( floor( x )) + "x" + str( floor( y ) );
	if soundPlayed.find( _st ) != -1 :
		# original #show_debug_message("Sound('check') - Stopped " + string(_st) + " from playing to prevent sound overlap.");
		return 1;
	else:
		# original #show_debug_message("Sound('check') - Played " + string(_st) + " and added to list.");
		soundPlayed.append(_st);
		soundHealth.append(0.05);
		return 0;

func scr_sound_init():
	print("scr_sound_init(): Begin...") # show_debug_message("scr_sound_init(): Begin...");
	
	## WARNING Disabled this code. No idea what it does.
	## I think it load some files from a json file and store it on dictionaries.

	#var dirQue = ds_queue_create();
	#ds_queue_enqueue(dirQue, "_audio");
	#while (!ds_queue_empty(dirQue)) 
	#{  
		#dirNam = ds_queue_dequeue(dirQue);    # original # Search all files and subdirectories under the directory.    
		#filNam = file_find_first(dirNam + '\*', fa_directory);    
		#while (filNam != "") 
		#{        
			#pthNam = dirNam + "\" + filNam;
			## original #show_debug_message("scr_sound_init(): Searching " + pthNam);
			## original #show_debug_message("scr_sound_init(): isDirectory = " + string(file_attributes(pthNam, fa_directory)));
			## original #filename_ext(filNam) == "")
			#if (directory_exists(pthNam)) # original #file_attributes(pthNam, fa_directory))
			#{
				#if (filNam != "." && filNam != "..")
				#{
					#ds_queue_enqueue(dirQue, pthNam);
					## original #show_debug_message("scr_sound_init(): Added " + pthNam + " to search queue..."); 
				#}
			#}        
			#else if (filename_ext(filNam) == ".ogg") # original # Streamed sound
			#{       
				#sndNam = string_replace(filename_name(filNam), ".ogg", "");
				#ds_map_add(var dsmSound, sndNam, audio_create_stream(pthNam));
				#ds_map_add(var dsmSoundLength, sndNam, 0); # original # Cannot calulate length for music files
				#ds_map_add(var dsmSoundOrphan, sndNam, 1);
				#ds_map_add(var dsmSoundStream, sndNam, 1);
				#ds_map_add(var dsmSoundVolume, sndNam, 1);
				#ds_map_add(var dsmSoundMemory, sndNam, 0);
				#musCou += 1;
				## original #show_debug_message("scr_sound_init(): Music from " + pthNam + " as " + filNam);       
			#}
			#else if (filename_ext(filNam) == ".wav") # original # Streamed sound
			#{
				#off = 44;
				#buf = buffer_load(pthNam);
				#siz = buffer_get_size(buf) - off;
				#sizTot += siz;
				#sndBuf = audio_create_buffer_sound(buf, buffer_s16, 44100, off, siz, audio_mono);
				#sndNam = string_replace(filename_name(filNam), ".wav", "");
				#ds_map_add(var dsmSound, sndNam, sndBuf);
				#ds_map_add(var dsmSoundLength, sndNam, siz / (44100 * 2));
				#ds_map_add(var dsmSoundOrphan, sndNam, 1);
				#ds_map_add(var dsmSoundStream, sndNam, 0);
				#ds_map_add(var dsmSoundVolume, sndNam, 1);
				#ds_map_add(var dsmSoundMemory, sndNam, siz / 1024);
				#souCou += 1;
				## original #show_debug_message("scr_sound_init(): Sound from " + pthNam + " as " + filNam); 
			#}
			#else # original # Unrecognized
			#{
				## original #show_debug_message("scr_sound_init(): Unrecognized file " + pthNam + " in Audio folder."); 
			#}
			#filNam = file_find_next();    
		#}    
		#file_find_close();
	#}
	#ds_queue_destroy(dirQue);
	## show_debug_message("scr_sound_init(): End. " + string(musCou) + " streamed files, " + string(souCou) + " loaded files, " + string(musCou + souCou) + " total files. Took " + string((get_timer() - _tim) / 1000) + "ms. Occupying " + string(sizTot / 1024 / 1024) + "Mb of memory.");

	# original #/ Load volume from sound.json
	# scr_sound_load();
	
func scr_sound_load():
	pass
