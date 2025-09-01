extends AnimatedSprite2D

@onready var timer: Timer = $Timer
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	_on_timer_timeout()

func _on_timer_timeout() -> void:
	animation = ["idling", "keyboard", "mouse"].pick_random()
	play()
	
	if animation == "keyboard":		audio_stream_player_2d.play()
	else:							audio_stream_player_2d.stop()
	
	timer.start( randf_range(3.0,7.0) )
