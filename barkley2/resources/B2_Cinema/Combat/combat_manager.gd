extends Resource
class_name B2_CombatManager
## This Resource handles the combat actions, turns, etc.
## When the battle finished, report back to the Combat Cinema Player.

const ENEMY_STATS = preload("res://barkley2/scenes/_Godot_Combat/enemy_stats.tscn")

signal tick_toggled( enabled : bool ) ## stop or starts the combat ticker
signal combat_ended

var combat_cinema : B2_Combat_CinemaPlayer
var combat_camera
var player_character 	: B2_HoopzCombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies
var defeated_enemy_list : Array[B2_EnemyCombatActor] 	= [] 	## List of all defeated enemies. Used on the end of the battle, to add EXP, item drops and cleanup.

var combat_paused := false

var action_queue : Array[queue]

class queue: # class used for action queue
	var action 			: Callable
	var source_actor 	: B2_CombatActor
	var used_weapon 	: B2_Weapon
	var finish_action	: Callable

## keep a refere for the player
func register_player( player : B2_HoopzCombatActor ) -> void:
	player_character = player
	#player.combat_manager = self
	
## Add enemies to an Array
func register_enemy_list( enemies : Array[B2_EnemyCombatActor] ) -> void:
	enemy_list = enemies
	#enemy.combat_manager = self
	
func start_battle():
	B2_Input.can_fast_forward = false
	
	B2_Input.can_switch_guns = true
	B2_CManager.combat_manager = self
	B2_CManager.o_hud.show_battle_ui()
	
	for e : B2_CombatActor in enemy_list:
		e.cinema_lookat( player_character )
		e.add_child( ENEMY_STATS.instantiate(), true )
		
	player_character.cinema_lookat( enemy_list.pick_random() )
	
	B2_CManager.o_hud.get_combat_module().register_player( player_character )
	B2_CManager.o_hud.get_combat_module().register_enemies( enemy_list )
	
	B2_Music.play_combat( 0.1 )

func pause_combat() -> void: ## Stop combat tick during target selection, etc.
	B2_Input.can_switch_guns = false
	combat_paused = true

func resume_combat() -> void: 
	B2_Input.can_switch_guns = true
	combat_paused = false

func finish_combat() -> void:
	pause_combat()
	B2_Music.play("shitworld") ## Test music
	B2_CManager.o_cbt_hoopz.cinema_look( Vector2.DOWN )
	
	B2_CManager.o_hud.get_combat_module().add_result_message("Test message 1!", "sn_cursor_pausemenu01")
	B2_CManager.o_hud.get_combat_module().add_result_message("Test message 2!", "sn_cursor_error01")
	B2_CManager.o_hud.get_combat_module().add_result_message("Test message 3!", "sn_cursor_select01")
	B2_CManager.o_hud.get_combat_module().add_result_message("Test message 4!", "sn_utilitycursor_buttonclick01")
	
	B2_CManager.o_hud.get_combat_module().show_battle_results()
	await B2_CManager.o_hud.get_combat_module().battle_results_finished
	
	B2_Music.resume_stored_music()
	combat_cinema.end_combat()

func enemy_defeated( enemy_node : B2_CombatActor ) -> void:
	if enemy_list.has( enemy_node ):
		enemy_list.erase( enemy_node )
		print( "Enemy %s removed from enemy list." % enemy_node.name )
	else:
		## Trying to remove an enemy that wasnt on the enemy list
		breakpoint

func tick_combat() -> void:
	if not combat_paused:
		B2_CManager.o_hud.get_combat_module().tick_combat()
		
		## Check if the combat is finished ( no enemies are on the battlefield )
		if enemy_list.is_empty():
			combat_paused = true
			finish_combat()
			return
		
		for wpn : B2_Weapon in B2_Playerdata.bandolier:
			wpn.increase_action()
		
		if B2_Playerdata.player_stats.increase_action():
			## TODO player action (move, defend)
			if randf() > 0.9: ## TEMP
				B2_Playerdata.player_stats.reset_action()
		
		for enemy : B2_EnemyCombatActor in enemy_list:
			if enemy.enemy_data:
				if enemy.enemy_data.increase_action():
					enemy.enemy_data.reset_action() ## TEMP
					print( "DEBUG: enemy action ", enemy )
				else:
					pass
			else:
				## Forgot to add enemy data.
				breakpoint
		
		# Check action queue
		if action_queue.size() > 0:
			# Exec action queue
			var action : queue = action_queue.pop_front(); print("Executing action.")
			
			if is_instance_valid( action.source_actor ):
				action.action.call( action.source_actor, action.used_weapon, action.finish_action )
			else:
				## source action was "killed" before executing the action".
				pass

func process() -> void:
	var avg_pos 					:= get_avg_pos()
	B2_CManager.camera.combat_focus( avg_pos, get_avg_dist(avg_pos))
	B2_CManager.camera.focus 		= avg_pos
	B2_CManager.camera.cam_zoom 	= get_avg_dist(avg_pos)

## Combat actions
# Public func. Queue action
func shoot_projectile( source_actor : B2_CombatActor, used_weapon : B2_Weapon, finish_action : Callable ) -> void:
	var q := queue.new()
	q.action = _shoot_projectile
	q.source_actor = source_actor
	q.used_weapon = used_weapon
	q.finish_action = finish_action
	action_queue.append( q )
	print( "action queued: ", action_queue.size() )
	
# Execute queued action
func _shoot_projectile( source_actor : B2_CombatActor, used_weapon : B2_Weapon, finish_action : Callable ) -> void:
	pause_combat()
	var casing_pos := Vector2.ZERO
	var muzzle_pos := Vector2.ZERO
	var aim_direction := Vector2.ZERO
	if source_actor is B2_HoopzCombatActor:
		casing_pos = source_actor.combat_weapon	.global_position	## where should a casing spawn
		muzzle_pos = source_actor.gun_muzzle.global_position		## where the bullet should spawn
		aim_direction = source_actor.aim_target						## Bullets direction
		B2_Sound.play_pick( B2_Gun.get_current_gun().get_reload_sound() )
		await source_actor.get_tree().create_timer(1.0).timeout
	else:
		# An enemy is shooting.
		pass ## TODO
		
	used_weapon.use_normal_attack( source_actor.get_parent(), casing_pos, muzzle_pos, aim_direction )
	await used_weapon.finished_combat_action ## Wait for the gun to fire or whatever.
	finish_action.call()
	resume_combat()
	
## Helper function, used to control the camera position.
func get_avg_pos() -> Vector2:
	var n_combatants := 1
	var avg_pos	:= player_character.position
	for e : B2_CombatActor in enemy_list:
		avg_pos += e.position
		n_combatants += 1
	return avg_pos / n_combatants
	
func get_avg_dist(avg_pos : Vector2) -> float:
	var n_combatants := 1
	var avg_dist := player_character.position.distance_to( avg_pos )
	for e : B2_CombatActor in enemy_list:
		avg_dist += e.position.distance_to( avg_pos )
		n_combatants += 1
	return roundf( avg_dist / n_combatants )
