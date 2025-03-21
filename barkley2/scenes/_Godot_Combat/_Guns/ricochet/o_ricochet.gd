extends AnimatedSprite2D

@onready var bullet_sfx: AudioStreamPlayer2D = $bullet_sfx

var ricochetSound = ""

func _ready() -> void:
	play_sound( ricochetSound, false )
	speed_scale = randf_range( 0.55, 1.25 )
	modulate.a = randf_range( 0.5, 0.95 )

func play_sound(soundID : String, loop : bool) -> void:
	var sound_file = load( B2_Sound.get_sound( soundID ) )
	if sound_file:
		sound_file.loop = loop
		bullet_sfx.stream = sound_file
		bullet_sfx.play()
	else:
		push_error("Invalid sound file for sound ID %s." % soundID)

func _on_animation_finished() -> void:
	hide()
	if bullet_sfx.playing:
		await bullet_sfx.finished
	queue_free()
