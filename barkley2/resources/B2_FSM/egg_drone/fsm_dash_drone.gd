extends B2_FSM_Dash
class_name B2_FSM_Dash_Drone

const SONIC_SPINDASH = preload("uid://cp8vy83gypsbb")

var spin_tween : Tween

func enter() -> void:
	super()
	my_actor.is_playingset = true
	if my_actor.curr_input.y > 0.0:		my_actor.ActorAnim.play("CHARGE_UP")
	else:								my_actor.ActorAnim.play("CHARGE_DOWN")
	my_actor.flip_sprite()
	
	my_actor.ActorAudioPlayer.stream = SONIC_SPINDASH
	
	spin_tween = create_tween()
	spin_tween.set_loops( 10 )
	spin_tween.tween_callback( my_actor.ActorAudioPlayer.stop )
	spin_tween.tween_callback( my_actor.ActorAudioPlayer.play )
	#spin_tween.tween_callback( my_actor.ActorAudioPlayer.set_pitch_scale.bind(0.85,1.25) )
	spin_tween.tween_interval( 0.125 )

func exit() -> void:
	if spin_tween: spin_tween.kill()
	super()
	my_actor.is_playingset = false
