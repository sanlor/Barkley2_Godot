extends B2_Player

func _on_combat_actor_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if curr_STATE == STATE.ROLL:
			# body.apply_damage( 75.0 ) ## Debug setup
			pass

# handle step sounds
func _on_hoopz_upper_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
	if hoopz_normal_body.animation.begins_with("full_roll"):
		if hoopz_normal_body.frame in [3,4,5,6]:
			if not step_smoke.emitting:
				step_smoke.emitting = true
		else:
			step_smoke.emitting = false

func _on_combat_lower_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
