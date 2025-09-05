@tool
extends B2_EnvironProp

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var timer: Timer = $Timer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	timer.start( 20.0 + randf_range(0.0, 10.0) )

func _on_timer_timeout() -> void:
	play("default")
	audio_stream_player_2d.play()
	timer.start( 23.0 + randf_range(-5.0, 50.0) )
