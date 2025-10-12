@tool
extends B2_EnvironSolid

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	play("default")

func execute_event_user_1():
	audio_stream_player_2d.stop()
