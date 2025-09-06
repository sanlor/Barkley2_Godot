extends B2_Player_FreeRoam
## Diaper exceptions

func _ai_roll_at( enabled : bool ) -> void:
	if enabled:
		if get_parent() is B2_ROOMS:
			if get_parent().room_player_can_roll:
				start_rolling( curr_input )

func stop_rolling() -> void:
	if linear_velocity.length() < 4.0:
		## DEBUG - TODO Improve this.
		if hoopz_normal_body.animation == ROLL or hoopz_normal_body.animation == ROLL_BACK:
			if hoopz_normal_body.frame < 7: ## Wait for the animation to finish - TODO Signals?
				return
				
		# Roooolliiing eeeeennd.
		curr_STATE = STATE.NORMAL
		hoopz_normal_body.animation = "stand"
		linear_damp = walk_damp
		step_smoke.emitting = false
		hoopz_normal_body.flip_h = false

## handle step sounds for normal state hoopz
func _on_hoopz_normal_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		if hoopz_normal_body.frame in [0,2]: # play audio only on frame 0 or 2
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
			
## handle step sounds for combat state hoopz
func _on_combat_lower_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		if hoopz_normal_body.frame in [0,2]: # play audio only on frame 0 or 2
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
