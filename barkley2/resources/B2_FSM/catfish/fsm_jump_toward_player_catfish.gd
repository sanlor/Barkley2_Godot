extends B2_FSM_Jump_Toward_Player
# Animations related to Catfishes (small)

const O_SPLASH = preload("uid://dgxwfaoi5p3x1")

func _pre_jump() -> void:
	var dir := my_actor.global_position.direction_to( enemy_actor.global_position )
	if dir.y > 0.0:		my_actor.ActorAnim.play("catfish_stagger")
	else:				my_actor.ActorAnim.play("catfish_stagger_up")
		
	## Face the enemy
	my_actor.ActorAnim.flip_h = dir.x > 0.0
	
	var splash : B2_WATER_SPLASH = O_SPLASH.instantiate()
	splash.global_position = my_actor.global_position
	splash.set_SPLASH( B2_WATER_SPLASH.SPLASH.SMALL )
	my_actor.add_sibling.call_deferred( splash, true )
	
func _pos_jump() -> void:
	my_actor.my_shadow.show()
	my_actor.curr_STATE = B2_CombatActor.STATE.NORMAL
