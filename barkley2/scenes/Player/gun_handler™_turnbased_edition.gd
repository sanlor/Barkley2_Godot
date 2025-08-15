extends B2_GunHandler
class_name B2_GunHandler_TurnBased

signal attack_begun
signal attack_finished

# GunHandler version to manage the turnbased gameplay

func use_normal_attack( casing_pos : Vector2,source_pos : Vector2, dir : Vector2, source_actor : B2_CombatActor ) -> void:
	if not curr_gun:
		push_error("Gun resource not loaded correctly.")
		return
		
	## Can't shoot again while the respective timers are still active.
	if not _can_shoot():
		return
		
	## Start timers and necessary variables.
	is_shooting = true
	attack_begun.emit()
	
	## small delay before shooting TODO
	pre_shooting_timer.start()
	await pre_shooting_timer.timeout
	print("%s: pre_shoot" % name)
	
	for shoot in curr_gun.turnbased_burst:
		## Firing rate stuff
		if not firing_rate.is_stopped(): await firing_rate.timeout
		firing_rate.start( curr_gun.wait_per_shot )
		print("%s: during_shoot" % name)
		
		## Only shoot if you have ammo.
		if curr_gun.has_ammo():
			curr_gun.use_ammo( curr_gun.ammo_per_shot )
			B2_Sound.play( curr_gun.get_soundID() )
			_create_flash( source_pos, dir, 1.5)
			for i in curr_gun.ammo_per_shot: ## Double barrel shotgun spawn 2 casings
				_create_casing( casing_pos)
				
			## only apply knockback if you actually fire the weapon.
			source_actor.apply_central_impulse( -dir * curr_gun.get_gun_knockback() ) 
			
			## Spawn bullets. Handguns shoot only one bullet per shot. Shotguns can shoot many per shot.
			for i in curr_gun.bullets_per_shot:
				var my_spread_offset := curr_gun.bullet_spread * ( float(i) / float(curr_gun.bullets_per_shot) )
				my_spread_offset -= curr_gun.bullet_spread / curr_gun.bullets_per_shot
				
				## Aim variations
				var my_acc := curr_gun.get_acc() * B2_Config.BULLET_SPREAD_MULTIPLIER
				var b_dir := dir.rotated( randf_range( -my_acc, my_acc ) + my_spread_offset )
				
				_create_bullet( source_pos, b_dir, source_actor )
		else:
			## Out of ammo.
			B2_Sound.play( "hoopz_click" )
	
	## Used by the turn-based combat
	curr_gun.reset_action( curr_gun.curr_action - curr_gun.attack_cost )
	
	## small delay after shooting TODO
	post_shooting_timer.start()
	await post_shooting_timer.timeout
	print("%s: after_shoot" % name)
	
	## Reset variable. NOTE This may not be needed anymore, since we don't AWAIT stuff no more.
	is_shooting = false
	attack_finished.emit()
