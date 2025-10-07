#extends Resource
#class_name B2_CombatManager
@icon("res://barkley2/assets/b2_original/images/merged/s_bct_gunPedestal01.png")
extends Node

## This Resource handles the combat actions, turns, etc.
## When the battle finished, report back to the Combat Cinema Player.
## 10/08/25 Made this an autoload. need some way to store data during combat.

const ENEMY_STATS = preload("res://barkley2/scenes/_Godot_Combat/enemy_stats.tscn")

signal tick_toggled( enabled : bool ) ## stop or starts the combat ticker
signal combat_ended

signal combat_time_stoped		## during certain actions, bullets, casings and such need to be stopped.
signal combat_time_restarted	## during certain actions, bullets, casings and such need to be stopped.

signal enemy_was_defeated( enemy_data : B2_EnemyData )

var combat_cinema : B2_Combat_CinemaPlayer
#var combat_camera
var player_character 	: B2_Player_TurnBased						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies
var defeated_enemy_list : Array[B2_EnemyCombatActor] 	= [] 	## List of all defeated enemies. Used on the end of the battle, to add EXP, item drops and cleanup.

var combat_paused 	:= false :
	set(c):
		combat_paused = c
		#if not c:
		#	print_stack()
var turn_based_combat_running 	:= false
var combat_won					:= false
var escaped_combat				:= false ## enabled if the player escaped combat
var lock_player_action			:= false ## Allow the player to select attacks, skills or items.
var action_queue : Array[queue]

var can_manipulate_camera := true

enum QUEUE_TYPE{NORMAL_ATTACK, OFFENSIVE_SKILL}
class queue: # class used for action queue
	var type			: QUEUE_TYPE
	var action 			: Callable
	var target			: Vector2
	var source_actor 	: B2_CombatActor
	var used_weapon 	: B2_Weapon
	var used_skill		: B2_WeaponSkill
	var finish_action	: Callable

## keep a refere for the player
func register_player( player : B2_Player_TurnBased ) -> void:
	player_character = player
	#player.combat_manager = self
	
## Add enemies to an Array
func register_enemy_list( enemies : Array[B2_EnemyCombatActor] ) -> void:
	enemy_list = enemies
	#enemy.combat_manager = self
	
func start_battle():
	B2_Input.can_fast_forward = false
	
	B2_Input.can_switch_guns = true
	#B2_CManager.combat_manager = self
	assert( B2_CManager.o_hud, "o_hud not loaded. Check the battle script.")
	B2_CManager.o_hud.show_battle_ui()
	
	for e : B2_EnemyCombatActor in enemy_list:
		e.cinema_lookat( player_character )
		if e.show_life_bar:
			e.add_child( ENEMY_STATS.instantiate(), true )
		
	player_character.cinema_lookat( enemy_list.pick_random() )
	
	B2_CManager.o_hud.get_combat_module().register_player( player_character )
	B2_CManager.o_hud.get_combat_module().register_enemies( enemy_list )
	
	turn_based_combat_running = true

## Stop combat tick during target selection, etc.
func pause_combat() -> void: 
	combat_time_stoped.emit()
	B2_Input.can_switch_guns = false
	combat_paused = true

## resume combat tick, allow combat actions again.
func resume_combat() -> void:
	combat_time_restarted.emit()
	B2_Input.can_switch_guns = true
	combat_paused = false

## Player escaped the encounter
func escape_combat() -> void:
	action_queue.clear()
	for i in enemy_list:
		if is_instance_valid(i):
			i.queue_free()
	enemy_list.clear()
	escaped_combat = true

## Combat ended somehow.
func finish_combat() -> void:
	if combat_won:
		push_warning("Called 'finish_combat()' twice, mistakenly. You need to check why.")
		return
	combat_won = true
	turn_based_combat_running = false
	pause_combat()
	B2_CManager.o_cbt_hoopz.cinema_look( Vector2.DOWN )
	B2_CManager.o_cbt_hoopz.victory_anim()
	
	if B2_CManager.combat_cinema_player:
		if escaped_combat: ## Dont play any music if you escape combat. you dont deserve it.
			B2_Music.play_end_combat( "mus_blankTEMP" )
		else:
			if B2_CManager.combat_cinema_player.end_battle_music:
				B2_Music.play_end_combat( B2_CManager.combat_cinema_player.end_battle_music )
	else:
		push_error("B2_CManager.combat_cinema_player isnt loaded? WTF!")
	
	if B2_CManager.get_BodySwap() == "diaper":
		B2_CManager.o_hud.get_combat_module().add_result_message("Ughhhh...", "sn_mouse_analoghover01")
		B2_CManager.o_hud.get_combat_module().add_result_message("Eughhh...", "sn_mouse_analoghover01")
		
	elif escaped_combat:
		B2_CManager.o_hud.get_combat_module().add_result_message("Escaped combat with your tail behind your legs!", "sn_mouse_analoghover01")
		
	else:
		if B2_CManager.combat_cinema_player.track_exp_gained:
			var _exp := B2_CManager.combat_cinema_player.exp_gained
			B2_CManager.o_hud.get_combat_module().add_result_message("EXP gained: %s!" 				% str(_exp), "sn_mouse_analoghover01")
			B2_Gun.distribute_battle_exp( _exp )
		if B2_CManager.combat_cinema_player.track_money_gained:
			var mon := B2_CManager.combat_cinema_player.money_gained
			B2_CManager.o_hud.get_combat_module().add_result_message("CyberShekels gained: %s!" 	% str(mon), "sn_mouse_analoghover01")
			B2_Database.money_change( +mon )
		if B2_CManager.combat_cinema_player.track_battle_time:
			var tim := B2_CManager.combat_cinema_player.battle_time
			B2_CManager.o_hud.get_combat_module().add_result_message("Battle took %s seconds." 		% str(tim), "sn_mouse_analoghover01")
	
	B2_CManager.o_hud.get_combat_module().show_battle_results()
	await B2_CManager.o_hud.get_combat_module().battle_results_finished
	
	B2_Playerdata.player_stats.reset_action()
	B2_Playerdata.is_holding_gun = false
	
	#combat_cinema.end_combat()
	combat_ended.emit()

func enemy_defeated( enemy_node : B2_EnemyCombatActor ) -> void:
	if turn_based_combat_running:
		if enemy_list.has( enemy_node ):
			enemy_list.erase( enemy_node )
			print( "Enemy %s removed from enemy list." % enemy_node.name )
		else:
			## Trying to remove an enemy that wasnt on the enemy list
			breakpoint
		enemy_was_defeated.emit( enemy_node.enemy_data )
	
	## Cleanup the defeated enemy action ( avoid dead enemies performing actions ).
	var stale_action : queue
	for x : queue in action_queue:
		if x.source_actor == enemy_node:
			stale_action = x
	action_queue.erase(stale_action)

## stop combat, play the defeat animation.
func player_defeated() -> void:
	if turn_based_combat_running:
		turn_based_combat_running = false
		pause_combat()
		B2_CManager.o_hud.combat_module.reset()
		B2_CManager.o_hud.hide_battle_ui()
		
	B2_Input.player_has_control = false
	B2_Music.stop( 1.0 )
	
	if B2_CManager.camera:
		B2_CManager.camera.camera_bound_to_map = false
		var c := B2_CManager.camera
		var p : B2_PlayerCombatActor
		if B2_CManager.o_hoopz:
			p = B2_CManager.o_hoopz
		elif B2_CManager.o_cbt_hoopz:
			p = B2_CManager.o_cbt_hoopz
		else:
			push_error("Both type of actors are unloaded. This is critical."); breakpoint
			
		## Additional check
		if B2_CManager.o_cbt_hoopz and B2_CManager.o_hoopz: push_error("Wow, both combat and regular Hoopz are loaded at the same time. This is not something normal.")
			
		var t := c.create_tween()
		#t.set_parallel( true )
		t.tween_callback( c.set.bind("manual_target", p) )
		t.tween_callback( c.set.bind("manual_control", true) )
		t.tween_interval( 2.25 ) ## weird delay 2: electric boogaloo
		await t.finished
	else:
		### ???? camera not loaded.
		breakpoint
		
	B2_Screen.show_defeat_screen() # <- show the gameover screen
	B2_CManager.o_hud.hide_hud()

func tick_combat() -> void:
	#print( "Curr gun is ", B2_Gun.get_current_gun().get_full_name() ) ## DEBUG
	
	if not combat_paused:
		## Check if the combat is finished ( no enemies are on the battlefield )
		if enemy_list.is_empty() and not combat_won:
			finish_combat()
			return
			
		if enemy_list.is_empty():
			return
			
		## Pretty important. Won't tell you why.
		B2_CManager.o_hud.get_combat_module().tick_combat()
		
		## Increase weapon action
		if B2_Playerdata.gunbag_open:
			B2_Gun.get_current_gun().increase_action()
		else:
			for wpn : B2_Weapon in B2_Playerdata.bandolier:
				wpn.increase_action()
		
		## increase player action
		if B2_Playerdata.player_stats.increase_action():
			## TODO player action (move, defend)
			if randf() > 0.9: ## TEMP
				#B2_Playerdata.player_stats.reset_action()
				pass
		
		## Increase enemy action and perform action when ready.
		for enemy : B2_EnemyCombatActor in enemy_list:
			if enemy.enemy_data:
				if enemy.enemy_data.increase_action():
					if enemy.get_ai_turnbased().combat_action( player_character, enemy_list ):
						return
				else:
					pass
			else:
				## Forgot to add enemy data.
				push_warning("%s: Forgot to add enemy data." % self)
				breakpoint
		
		## Check action queue
		if action_queue.size() > 0:
			# Exec action queue
			var action : queue = action_queue.pop_front(); print("Executing action.")
			
			if is_instance_valid( action.source_actor ):
				match action.type:
					QUEUE_TYPE.NORMAL_ATTACK:
						action.action.call( action.source_actor, action.target, action.finish_action )
					QUEUE_TYPE.OFFENSIVE_SKILL:
						action.action.call( action.source_actor, action.target, action.used_skill, action.finish_action )
					_:
						breakpoint
			else:
				## source action was "killed" before executing the action".
				push_warning("The actor was killed before execution its action queue.")

func _physics_process(_delta: float) -> void:
	if turn_based_combat_running:
		if can_manipulate_camera:
			var avg_pos 					:= get_avg_pos()
			B2_CManager.camera.combat_focus( avg_pos, get_avg_dist(avg_pos) )
			B2_CManager.camera.focus 		= avg_pos
			B2_CManager.camera.cam_zoom 	= get_avg_dist(avg_pos)

## Combat actions
# Public func. Queue action for turn based combat
func shoot_projectile( source_actor : B2_CombatActor, target : Vector2, finish_action : Callable ) -> void:
	var q := queue.new()
	q.type = QUEUE_TYPE.NORMAL_ATTACK
	q.action = _shoot_projectile
	q.source_actor = source_actor
	q.target = target
	#q.used_weapon = used_weapon
	q.finish_action = finish_action
	action_queue.append( q )
	print( "action queued: ", action_queue.size() )
	
# Execute queued action
func _shoot_projectile( source_actor : B2_CombatActor, target : Vector2, finish_action : Callable ) -> void:
	print( "%s: Started shooting." % name )
	pause_combat()
	#B2_CManager.o_hud.get_combat_module().hide_player_controls()
	var casing_pos := Vector2.ZERO
	var aim_direction := Vector2.ZERO
	var gun_handler	: B2_GunHandler_TurnBased
	if source_actor is B2_Player_TurnBased:
		casing_pos = source_actor.combat_weapon	.global_position				## where should a casing spawn
		aim_direction = source_actor.global_position.direction_to( target )		## Bullets direction
		gun_handler = source_actor.gun_handler
		B2_Sound.play_pick( B2_Gun.get_current_gun().get_reload_sound() )
		
	elif source_actor is B2_EnemyCombatActor:
		# An enemy is shooting.
		aim_direction = source_actor.global_position.direction_to( target )
		B2_Sound.play( source_actor.sound_alert )
	else: breakpoint ## Unknown actor.
		
	## avoid cases where the source_actor dies while geting ready to attack.
	if is_instance_valid( source_actor ):
		lock_player_action = true
		# gun_handler.select_gun( used_weapon ) ## NOTE This was breaking the gun selection stuff.
		gun_handler.use_normal_attack( casing_pos, aim_direction, source_actor )
		await gun_handler.attack_finished
		if finish_action: finish_action.call() ## Avoid calling invalid functions.
		lock_player_action = false
	else: breakpoint
		
	if B2_CManager.o_hud.get_combat_module().can_resume_combat():
		#B2_CManager.o_hud.get_combat_module().show_player_controls()
		resume_combat()
	else:
		print("Could not unpause the battle.")
		print_stack()
	
	
func use_skill( source_actor : B2_CombatActor, target : Vector2, used_skill : B2_WeaponSkill, finish_action : Callable ) -> void:
	var q := queue.new()
	q.type = QUEUE_TYPE.OFFENSIVE_SKILL
	q.action = _use_skill
	q.source_actor = source_actor
	q.target = target
	#q.used_weapon = used_weapon
	q.used_skill = used_skill
	q.finish_action = finish_action
	action_queue.append( q )
	
func _use_skill( source_actor : B2_CombatActor, target : Vector2, used_skill : B2_WeaponSkill, finish_action : Callable ) -> void:
	pause_combat()
	var casing_pos := Vector2.ZERO
	var aim_direction := Vector2.ZERO
	var gun_handler	: B2_GunHandler_TurnBased
	if source_actor is B2_Player_TurnBased:
		casing_pos = source_actor.combat_weapon	.global_position				## where should a casing spawn
		aim_direction = source_actor.global_position.direction_to( target )		## Skill direction
		gun_handler = source_actor.gun_handler
	else: breakpoint ## Unknown actor.
		
	## avoid cases where the source_actor dies while geting ready to perform.
	if is_instance_valid( source_actor ):
		lock_player_action = true
		# used_skill.action( source_actor.get_parent(), casing_pos, muzzle_pos, aim_direction, source_actor )
		# await used_skill.action_finished ## Wait for the skill to finish and shiet.
		gun_handler.use_gun_skill( casing_pos, aim_direction, used_skill, source_actor )
		await gun_handler.attack_finished ## Wait for the skill to finish and shiet.
		if finish_action: finish_action.call() ## Avoid calling invalid functions.
		lock_player_action = false
	else: breakpoint
	
	if B2_CManager.o_hud.get_combat_module().can_resume_combat():
		resume_combat()
	else:
		print("Could not unpause the battle.")
		print_stack()
	
	
## Helper functions, used to control the camera position.
# Get the average position of all combat actors
func get_avg_pos() -> Vector2:
	assert( is_instance_valid(player_character), "Turn-Based player not loaded." )
	var n_combatants := 1
	var avg_pos	:= player_character.position
	for e : B2_CombatActor in enemy_list:
		avg_pos += e.position
		n_combatants += 1
	return avg_pos / n_combatants
	
# Get the average distance from the average position of all combat actors
func get_avg_dist(avg_pos : Vector2) -> float:
	var n_combatants := 1
	var avg_dist := player_character.position.distance_to( avg_pos )
	for e : B2_CombatActor in enemy_list:
		avg_dist += e.position.distance_to( avg_pos )
		n_combatants += 1
	return roundf( avg_dist / n_combatants )
