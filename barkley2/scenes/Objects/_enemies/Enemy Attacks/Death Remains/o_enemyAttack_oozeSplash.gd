extends Area2D

@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var t : Tween

func _ready() -> void:
	audio_stream_player_2d.stream = B2_Sound.get_sound_stream("hoopz_puddlestep")
	audio_stream_player_2d.pitch_scale = randf_range(0.75,1.25)
	audio_stream_player_2d.play()
	
	animated_sprite_2d.scale = Vector2.ONE * 0.1
	
	t = create_tween()
	t.tween_property( animated_sprite_2d, "scale", Vector2.ONE, randf_range(0.25,0.5) )
	t.tween_callback( collision_shape_2d.set_disabled.bind(false) )
	t.tween_interval( randf_range(3.0,5.0) )
	t.tween_callback( collision_shape_2d.set_disabled.bind(true) )
	t.tween_property( animated_sprite_2d, "scale", Vector2.ONE * 0.1, randf_range(0.25,0.5) )
	t.tween_callback( queue_free )

func _on_hit_timer_timeout() -> void:
	for body in get_overlapping_bodies():
		if body is B2_Player_FreeRoam:
			body.damage_actor( randf() * 2.0, Vector2.ZERO )
			print("DEBUG: Ooze (%s) damage with TEMP values." % self)
			break
