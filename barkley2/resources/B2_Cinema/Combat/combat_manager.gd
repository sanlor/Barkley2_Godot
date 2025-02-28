extends Resource
class_name B2_CombatManager
## This Resource handles the combat actions, turns, etc.
## When the battle finished, report back to the Combat Cinema Player.

signal combat_ended

var combat_cinema : B2_Combat_CinemaPlayer
var combat_camer
var player_character 	: B2_CombatActor						## In this game, only one player character exists. 
var enemy_list 			: Array[B2_EnemyCombatActor] 	= [] 	## List of all active enemies
var defeated_enemy_list : Array[B2_EnemyCombatActor] 	= [] 	## List of all defeated enemies. Used on the end of the battle, to add EXP, item drops and cleanup.

## keep a refere for the player
func register_player( player : B2_PlayerCombatActor ) -> void:
	player_character = player
	player.combat_manager = self
	
## Add enemies to an Array
func register_enemy( enemy : B2_EnemyCombatActor ) -> void:
	enemy_list.append( enemy )
	enemy.combat_manager = self
	
func start_battle():
	B2_CManager.combat_manager = self
	B2_CManager.o_hud.show_battle_ui()
	for e : B2_CombatActor in enemy_list:
		e.cinema_lookat( player_character )
	player_character.cinema_lookat( enemy_list.pick_random() )
		
	B2_Music.play_combat( 0.1 )

func tick_combat() -> void:
	pass

func process() -> void:
	var avg_pos 					:= get_avg_pos()
	B2_CManager.camera.combat_focus( avg_pos, get_avg_dist(avg_pos))
	#B2_CManager.camera.focus 		= avg_pos
	#B2_CManager.camera.cam_zoom 	= get_avg_dist(avg_pos)

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
