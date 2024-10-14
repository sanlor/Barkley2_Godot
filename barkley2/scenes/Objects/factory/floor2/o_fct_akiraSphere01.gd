@tool
extends B2_EnvironSolid

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

## Sound ##
var sound = "sn_machinegauges";
var soundVolume = 0.25;

func _ready() -> void:
	play("default")
	
	var audio : AudioStreamWAV = load( B2_Sound.get_sound(sound) )
	audio_stream_player_2d.stream = audio
	audio_stream_player_2d.volume_db = linear_to_db( soundVolume )
	audio_stream_player_2d.play()
	audio_stream_player_2d.finished.connect( audio_stream_player_2d.play )
