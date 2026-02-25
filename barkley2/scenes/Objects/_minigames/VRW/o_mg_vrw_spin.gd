@tool
extends AnimatedSprite2D
class_name B2_Minigame_VRW_Spin

@onready var timer: Timer = $Timer
@onready var o_mg_vrw_spin: AnimatedSprite2D = $clipper/o_mg_vrw_spin
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var t : Tween
var rng := RandomNumberGenerator.new()
var clones : Array[Node2D]

func _ready() -> void:
	frame = 1
	timer.stop()
	timer.start( rng.randf_range(1.5,3.5) )
	o_mg_vrw_spin.play()

func _on_timer_timeout() -> void:
	o_mg_vrw_spin.speed_scale = rng.randf_range(1.0,15.0)
	o_mg_vrw_spin.modulate = Color.from_hsv( rng.randf(), 1.0, 1.0)
	if not Engine.is_editor_hint():
		audio_stream_player_2d.play()
		audio_stream_player_2d.pitch_scale = rng.randf_range(0.5,1.5)
	
	if t: t.kill()
	t = create_tween()
	
	# Full effect
	t.tween_property( o_mg_vrw_spin, "position:y", rng.randf_range(00.0,30.0), 0.5).set_trans(Tween.TRANS_CUBIC)
	t.tween_property( o_mg_vrw_spin, "position:y", 40.0, 0.5).set_trans(Tween.TRANS_CUBIC)
	
	timer.start( rng.randf_range(1.0,2.5) )
