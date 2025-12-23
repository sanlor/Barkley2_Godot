## Audio emiter.
# Will emit 2D audio all the time, used for enviroment's machines and flavor sfx.
extends AudioStreamPlayer2D
class_name B2_AudioEmitter

## Sound ##
@export var sound 			:= "sn_machinegauges";
@export var soundVolume 	:= 0.15;

func _ready() -> void:
	bus = "Audio"
	var audio_res : AudioStreamOggVorbis
	if sound.begins_with("mus"):		audio_res = load( B2_Music.get_music(sound) )
	else:								audio_res = load( B2_Sound.get_sound(sound) )
		
	if audio_res:
		var audio : AudioStreamOggVorbis = audio_res
		stream = audio
		volume_db = linear_to_db(soundVolume)
		play()
		finished.connect( play )
		_after_ready()
	else:
		push_error("Audio file %s for node %s (%s) not found. Check this." % [sound, name, get_parent().name] )
		breakpoint

func _after_ready() -> void:
	pass
