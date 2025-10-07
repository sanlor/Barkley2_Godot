extends Area2D

@onready var point_light_2d: PointLight2D = $PointLight2D
@onready var s_effect_explo_48: AnimatedSprite2D = $s_effect_explo_48
@onready var o_mg_diving_spawn_bubbles: GPUParticles2D = $o_mg_diving_spawn_bubbles
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

var damaged_already := false

func _ready() -> void:
	s_effect_explo_48.play()
	o_mg_diving_spawn_bubbles.emitting = true
	
	## Play directional SFX
	var file := B2_Sound.get_sound( ["sn_mg_diving_explosion1", "sn_mg_diving_explosion2"].pick_random() )
	audio_stream_player_2d.stream = load( file )
	audio_stream_player_2d.play()
	
	# Make light and dim over time
	var t := create_tween()
	t.tween_property(point_light_2d, "energy", 0, 0.75)

func _on_s_effect_explo_48_animation_finished() -> void:
	self_modulate = Color.TRANSPARENT
	if o_mg_diving_spawn_bubbles.emitting:
		await o_mg_diving_spawn_bubbles.finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player" and not damaged_already:
		body.hurt()
		body.apply_central_impulse( global_position.direction_to(body.global_position) * 30000.0 )
		damaged_already = true
