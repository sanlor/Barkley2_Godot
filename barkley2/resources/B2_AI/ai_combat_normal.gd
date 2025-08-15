extends B2_AI_Combat
class_name B2_AI_Combat_TurnBased_Normal
## Standard Combat AI

const COMBAT_TARGET = preload("res://barkley2/scenes/_Godot_Combat/combat_target.tscn")

const delay_before_attack 		:= 10.0
var curr_delay_before_attack 	:= 00.0
var has_target 					:= false

var my_bulleye					: AnimatedSprite2D

## AI Action
func combat_action( player_character : B2_CombatActor, _enemy_list : Array[B2_EnemyCombatActor] ) -> bool:
	if is_disabled: ## Disabled AI.
		if my_bulleye:
			my_bulleye.queue_free()
		return false
		
	var enemy_data := get_parent().enemy_data as B2_EnemyData
	
	## Melee test
	if true == false:
		# Projectile
		if has_target:
			curr_delay_before_attack += 0.5
			my_bulleye.dist = curr_delay_before_attack / delay_before_attack
			
			if curr_delay_before_attack >= delay_before_attack:
				has_target = false
				curr_delay_before_attack = 0.0
				my_bulleye.destroy()
				B2_CombatManager.shoot_projectile( get_parent(), my_bulleye.my_target, Callable() )
				enemy_data.reset_action()
				return true
		else:
			has_target = true
			_make_bulleye( player_character )
	else:
		var enemy_melee = get_parent().enemy_melee
		if not enemy_melee:
			push_error("%s: Melee action not set." % get_parent().name )
			return false
		
		if has_target:
			curr_delay_before_attack += 0.5
			my_bulleye.dist = curr_delay_before_attack / delay_before_attack
			
			if curr_delay_before_attack >= delay_before_attack:
				has_target = false
				curr_delay_before_attack = 0.0
				my_bulleye.destroy()
				enemy_melee.action( get_parent(), my_bulleye.my_target )
				enemy_data.reset_action()
				return true
			
		else:
			get_parent().cinema_charge_telegraph( get_parent().global_position.direction_to( player_character.global_position ) )
			has_target = true
			_make_bulleye( player_character )
	
	return false

func _make_bulleye( player_character : B2_CombatActor ) -> void:
	if not my_bulleye:
		my_bulleye = COMBAT_TARGET.instantiate()
	get_parent().add_child( my_bulleye )
	my_bulleye.my_target 	= player_character.global_position
	my_bulleye.my_source = get_parent()
