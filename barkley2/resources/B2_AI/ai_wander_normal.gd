extends B2_AI_Wander
class_name B2_AI_Wander_Normal

@export var time_to_new_wander_target	:= 5.0
@export var distance_to_wander_target 	:= 10.0
@export var speed_multiplier			:= 50000

func step( actor : B2_EnemyCombatActor ) -> void:
	if actor.is_changing_states:
		return
	
	if actor.is_moving:
		actor.velocity = actor.global_position.direction_to( actor.wander_target_pos ) * speed_multiplier
	else:
		actor.velocity = Vector2.ZERO
		
	actor.apply_central_force( actor.velocity ) ## MOOOOOVE

	## DEBUG
	if actor.global_position.distance_to( actor.wander_target_pos ) < distance_to_wander_target:
		actor.is_moving = false
		actor.wander_target_pos = Vector2.ZERO
		actor.action_timer.start( time_to_new_wander_target * randf_range( 0.5, 1.5 ) )
		
	if _detect_player( actor ):
		actor.is_changing_states = true
		emote.emit( "!" )
		var origin_offset : float = actor.ActorAnim.offset.y
		
		var tween := actor.create_tween()
		tween.tween_property( actor.ActorAnim, "offset:y", origin_offset - 10.0, 0.15 )
		tween.tween_property( actor.ActorAnim, "offset:y", origin_offset, 0.15 )
		tween.tween_interval( 0.5 )
		await tween.finished
		
		actor.curr_MODE = B2_EnemyCombatActor.MODE.CHASE
		actor.is_changing_states = false
	
func _detect_player( actor : B2_EnemyCombatActor ) -> bool:
	if is_instance_valid( B2_CManager.o_hoopz ):
		if actor.position.distance_to( B2_CManager.o_hoopz.position ) < actor.detection_radius:
			actor.velocity = Vector2.ZERO
			return true
	return false
