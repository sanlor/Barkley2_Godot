extends B2_Player
## Normal hoopz body behaviour

## handle step sounds for normal state hoopz
func _on_hoopz_normal_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		if hoopz_normal_body.frame in [0,2]: # play audio only on frame 0 or 2
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
	if hoopz_normal_body.animation.begins_with("full_roll"):
		if hoopz_normal_body.frame in [0,1,2]:
			# hoopz_normal_body.look_at( linear_velocity ) ## Test for changing roll sprite direction. need a better fix.
			step_smoke.emitting = false
		elif hoopz_normal_body.frame in [3,4,5,6]:
			hoopz_normal_body.rotation = 0
			if not step_smoke.emitting:
				step_smoke.emitting = true
		else:
			step_smoke.emitting = false
			hoopz_normal_body.rotation = 0
			
## handle step sounds for combat state hoopz
func _on_combat_lower_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		if hoopz_normal_body.frame in [0,2]: # play audio only on frame 0 or 2
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
