extends Sprite2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	audio_stream_player_2d.stream = load( B2_Sound.get_sound("sn_machinelevel") )
	audio_stream_player_2d.stream.loop = true
	audio_stream_player_2d.play()
