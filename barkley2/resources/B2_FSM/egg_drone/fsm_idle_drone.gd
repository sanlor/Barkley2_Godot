extends B2_FSM_Idle
class_name B2_FSM_Idle_Drone

@export var overheat_emitter : GPUParticles2D

func enter() -> void:
	super()
	overheat_emitter.emitting = true

func exit() -> void:
	super()
	overheat_emitter.emitting = false
	
	if my_actor.ActorAudioPlayer:
		my_actor.ActorAudioPlayer.stream = B2_Sound.get_sound_stream("junkbot_alert")
		my_actor.ActorAudioPlayer.play()
