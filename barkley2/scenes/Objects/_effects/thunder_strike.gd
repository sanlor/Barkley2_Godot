@tool
extends Node2D

@onready var s_effect_thunder_strike: AnimatedSprite2D = $s_effect_thunder_strike
@onready var s_effect_thunder_strike_2: AnimatedSprite2D = $s_effect_thunder_strike2
@onready var s_effect_splash_medium: AnimatedSprite2D = $s_effect_splash_medium

@export_tool_button("Test") var _a : Callable = _play_all

func _ready() -> void:
	if randf() > 0.5:
		s_effect_thunder_strike.flip_h = true
		s_effect_thunder_strike_2.flip_h = true
		
	# Change scale
	scale.x 						*= randf_range(0.8,1.0)
	s_effect_splash_medium.scale 	*= randf_range(0.8,1.0)
	
	_play_all()
	await s_effect_thunder_strike.animation_finished
	queue_free()
	
func _play_all() -> void:
	s_effect_splash_medium.play()
	s_effect_thunder_strike.play()
	s_effect_thunder_strike_2.play()
	B2_Sound.play("thunder")
	B2_Sound.play("splash_out")
