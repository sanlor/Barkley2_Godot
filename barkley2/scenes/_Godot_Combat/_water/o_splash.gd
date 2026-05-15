extends AnimatedSprite2D
class_name B2_WATER_SPLASH

@onready var gpu_particles: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

const OFFSETS := {
	SPLASH.SMALL 	: -4.0,
	SPLASH.MEDIUM 	: -8.0,
	SPLASH.BIG 		: -13.0,
	SPLASH.TALL 	: -60.0,
}
const ANIMATIONS := {
	SPLASH.SMALL 	: "s_effect_splash_small",
	SPLASH.MEDIUM 	: "s_effect_splash_medium",
	SPLASH.BIG 		: "s_effect_splash_big",
	SPLASH.TALL 	: "s_effect_splash_tall",
}
enum SPLASH{SMALL,MEDIUM,BIG,TALL}
var curr_SPLASH := SPLASH.SMALL

## Splash Type
func set_SPLASH( splash : SPLASH ) -> void:
	curr_SPLASH = splash

func _ready() -> void:
	_splash_now()
	
func _splash_now() -> void:
	audio_stream_player_2d.play()
	gpu_particles.emitting = true
	offset.y = OFFSETS[ curr_SPLASH ]
	play( ANIMATIONS[ curr_SPLASH ] )
	await animation_finished
	self_modulate = Color.TRANSPARENT
	
	if gpu_particles.emitting:
		await gpu_particles.finished
		
	queue_free()
	
