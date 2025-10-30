## Temporary audio emiter.
# Will emit 2D audio, then remove myself from existance
extends AudioStreamPlayer2D
class_name B2_Temp_AudioEmitter

## Sound ##
@export var sound 			:= "";
@export var soundVolume 	:= 0.15;

func _init( _sound : String ) -> void:
	sound = _sound

func _ready() -> void:
	name = "temp_audioemitter"
	bus = "Audio"
	var audio_res
	if sound.begins_with("mus"):
		audio_res = load( B2_Music.music_bank.get(sound) )
	else:
		audio_res = load( B2_Sound.get_sound(sound) )
		
	if audio_res:
		finished.connect( queue_free )
		var audio : AudioStreamOggVorbis = audio_res
		stream = audio
		volume_db = linear_to_db(soundVolume)
		play()
	else:
		push_warning("%s: No SFX to play... ('%s')" % [name, sound])
		queue_free()
