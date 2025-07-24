extends AnimatedSprite2D

@onready var sludge_audio: AudioStreamPlayer2D = $sludge_audio
@onready var sludge_timer: Timer = $sludge_timer

func _ready() -> void:
	sludge_timer.start()

func _on_sludge_timer_timeout() -> void:
	speed_scale = randf_range(0.75,1.25)
	play()
	sludge_timer.wait_time = 5.0 * randf_range(0.5, 1.2)
	sludge_timer.start()

func _on_frame_changed() -> void:
	if frame == 8:
		sludge_audio.stream = load( B2_Sound.get_sound("sn_splashobject09") )
		sludge_audio.play()
	if frame == 3:
		sludge_audio.stream = load( B2_Sound.get_sound("sn_splashobject07") )
		sludge_audio.play()
