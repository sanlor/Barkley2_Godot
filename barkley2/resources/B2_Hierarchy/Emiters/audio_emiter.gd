extends AudioStreamPlayer2D
class_name B2_AudioEmitter

## Sound ##
@export var sound 			:= "sn_machinegauges";
@export var soundVolume 	:= 0.15;

func _ready() -> void:
	bus = "Audio"
	var audio : AudioStreamOggVorbis = load( B2_Sound.get_sound(sound) )
	stream = audio
	volume_db = linear_to_db(soundVolume)
	play()
	finished.connect( play )
	_after_ready()

func _after_ready() -> void:
	pass
