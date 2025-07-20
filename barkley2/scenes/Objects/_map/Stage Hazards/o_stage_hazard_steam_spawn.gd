extends Sprite2D

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

@onready var area_2d: Area2D = $Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self_modulate.a = 0.0

func _on_timer_timeout() -> void:
	gpu_particles_2d.emitting = true
	audio_stream_player_2d.stream = load( B2_Sound.get_sound("sewer_steam") )
	audio_stream_player_2d.play()

func _on_damage_cooldown_timeout() -> void:
	if gpu_particles_2d.emitting:
		if area_2d.has_overlapping_bodies():
			for body : Node2D in area_2d.get_overlapping_bodies():
				if body is B2_CombatActor:
					body.damage_actor( 1, Vector2.DOWN * 20.0 )

func _on_area_2d_body_entered(_body: Node2D) -> void:
	_on_damage_cooldown_timeout()
