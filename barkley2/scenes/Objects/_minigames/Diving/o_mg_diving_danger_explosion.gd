extends Area2D

@onready var s_effect_explo_48: AnimatedSprite2D = $s_effect_explo_48
@onready var o_mg_diving_spawn_bubbles: GPUParticles2D = $o_mg_diving_spawn_bubbles

func _ready() -> void:
	s_effect_explo_48.play()
	o_mg_diving_spawn_bubbles.emitting = true
	B2_Sound.play( ["sn_mg_diving_explosion1", "sn_mg_diving_explosion2"].pick_random() )

func _on_s_effect_explo_48_animation_finished() -> void:
	self_modulate = Color.TRANSPARENT
	if o_mg_diving_spawn_bubbles.emitting:
		await o_mg_diving_spawn_bubbles.finished
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.name == "o_mg_diving_player":
		body.apply_central_impulse( global_position.direction_to(body.global_position) * 50000.0 )
