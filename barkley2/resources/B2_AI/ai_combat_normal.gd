extends B2_AI_Combat
class_name B2_AI_Combat_Normal
## Standard Combat AI

const COMBAT_TARGET = preload("res://barkley2/scenes/_Godot_Combat/combat_target.tscn")

const delay_before_attack 		:= 10.0
var curr_delay_before_attack 	:= 00.0
var has_target 					:= false

var my_bulleye					: AnimatedSprite2D

## AI Action
func combat_action( player_character : B2_CombatActor, _enemy_list : Array[B2_EnemyCombatActor], combat_manager : B2_CombatManager ) -> bool:
	var enemy_data := get_parent().enemy_data as B2_EnemyData
	
	if has_target:
		curr_delay_before_attack += 0.5
		my_bulleye.dist = curr_delay_before_attack / delay_before_attack
		
		if curr_delay_before_attack >= delay_before_attack:
			has_target = false
			curr_delay_before_attack = 0.0
			my_bulleye.destroy()
			combat_manager.shoot_projectile( get_parent(), my_bulleye.my_target, get_parent().enemy_ranged, Callable() )
			enemy_data.reset_action()
			return true
	else:
		has_target = true
		if not my_bulleye:
			my_bulleye = COMBAT_TARGET.instantiate()
		get_parent().add_child( my_bulleye )
		my_bulleye.my_target 	= player_character.global_position
		my_bulleye.my_source = get_parent()
	
	return false
