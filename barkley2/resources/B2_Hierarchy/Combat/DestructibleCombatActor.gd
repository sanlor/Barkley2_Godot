extends B2_CombatActor
class_name B2_DestructibleCombatActor

## WARNING DEPRECATED NODE.

@export var anim		: AnimatedSprite2D
@export var collision 	: CollisionShape2D
@export var has_sound	:= false
@export var sound_name	:= ""
@export var sound_emiter: AudioStreamPlayer2D

@export var emit_smoke		:= false
@export var smoke_emiter 	: GPUParticles2D

var destroyed := false

var health := 1.0

func apply_damage( damage : float):
	if destroyed:
		return
	health -= damage
	
	if health < 0.0:
		if emit_smoke:
			play_sound()
			smoke_up()
		destroy_entity()
	
	if has_sound:
		play_sound()
		
func smoke_up():
	smoke_emiter.emitting = true

func play_sound():
	if sound_emiter.playing:
		sound_emiter.stop()
	var sound_file := load( B2_Sound.get_sound(sound_name) )
	sound_emiter.stream = sound_file
	sound_emiter.play()

func destroy_entity():
	anim.play()
	await anim.animation_finished
	collision.disabled = true
	freeze = true
	destroyed = true
