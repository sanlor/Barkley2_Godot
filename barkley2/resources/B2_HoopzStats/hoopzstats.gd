extends Resource
class_name B2_HoopzStats
## Class to handle all of hoopz stats.
## Stats can change based on the equipment, jerkins, status effects and stuff like that.

#region Stats constants
const STAT_CURRENT_HP 					:= "curr_health"
const STAT_EFFECTIVE_MAX_HP 			:= "max_health"

const STAT_BASE_HP 						:= "max_health" # "hp"
const STAT_BASE_LEVEL 					:= "lvl"
const STAT_BASE_SPEED 					:= "speed" ## NOTE Will go unused (probably)
const STAT_BASE_WEIGHT 					:= "weight" ## NOTE Will go unused (probably)

## Main Stats
const STAT_BASE_GUTS 					:= "GUTS"
const STAT_BASE_LUCK 					:= "LUCK"
const STAT_BASE_AGILE 					:= "AGILE"
const STAT_BASE_MIGHT 					:= "MIGHT"
const STAT_BASE_PIETY 					:= "PIETY"

## Resistances
const STAT_BASE_RESISTANCE_BIO 			:= "resistance_bio"
const STAT_BASE_RESISTANCE_COSMIC 		:= "resistance_cosmic"
const STAT_BASE_RESISTANCE_CYBER 		:= "resistance_cyber"
const STAT_BASE_RESISTANCE_KNOCKBACK 	:= "resistance_knockback"
const STAT_BASE_RESISTANCE_MENTAL 		:= "resistance_mental"
const STAT_BASE_RESISTANCE_NORMAL 		:= "resistance_normal"
const STAT_BASE_RESISTANCE_STAGGER 		:= "resistance_stagger"
const STAT_BASE_RESISTANCE_ZAUBER 		:= "resistance_zauber"

## Vulnerabilities
const STAT_BASE_VULN_BIO 				:= "vuln_bio"
const STAT_BASE_VULN_COSMIC 			:= "vuln_cosmic"
const STAT_BASE_VULN_CYBER 				:= "vuln_cyber"
const STAT_BASE_VULN_MENTAL 			:= "vuln_mental"
const STAT_BASE_VULN_NORMAL 			:= "vuln_normal"
const STAT_BASE_VULN_ZAUBER 			:= "vuln_zauber"

## Element - How is this used?
const STAT_ATTACK_DMG_BIO 				:= "dmg_bio"
const STAT_ATTACK_DMG_COSMIC 			:= "dmg_cosmic"
const STAT_ATTACK_DMG_CYBER 			:= "dmg_cyber"
const STAT_ATTACK_DMG_MENTAL 			:= "dmg_mental"
const STAT_ATTACK_DMG_NORMAL 			:= "dmg_normal"
const STAT_ATTACK_DMG_ZAUBER 			:= "dmg_zauber"
const STAT_ATTACK_DMG_RANDOMPERC 		:= "rand_dmg"

const STAT_ATTACK_KNOCKBACK 			:= "knockback"
const STAT_ATTACK_STAGGER_HARDNESS 		:= "stagger_hardness"
const STAT_ATTACK_STAGGER 				:= "stagger"

## NOTE Will go unused (probably)
const STAT_CURRENT_KNOCKBACK 			:= "cur_knockback"
const STAT_CURRENT_STAGGER_HARD 		:= "cur_stagger_hard"
const STAT_CURRENT_STAGGER_HARDNESS 	:= "cur_stagger_hardness"
const STAT_CURRENT_STAGGER_INSTANT 		:= "cur_stagger_inst"
const STAT_CURRENT_STAGGER_SOFT 		:= "cur_stagger_soft"
const STAT_CURRENT_STAGGER_TIME 		:= "cur_stagger_time"
const STAT_EFFECTIVE_ENCUMBERANCE 		:= "encumb"
#endregion

## Godot specific
var max_action					:= 100.0
var curr_action					:= 0.0
var max_health					:= 50.0 :
	set(h):
		if h < curr_health: ## Avoid current health being larger than the max health.
			curr_health = h
		max_health = h
var curr_health					:= 50.0

var lvl							:= 12.0

## Main Stats
var guts					:= 12.0
var luck  					:= 12.0 
var agile  					:= 12.0 
var might  					:= 12.0
var piety  					:= 12.0
var speed  					:= 12.0
var weight					:= 69.0 ## Maybe unused?

## Resistances
var resistance_mental  		:= 50.0 
var resistance_normal  		:= 12.0 
var resistance_zauber  		:= 50.0 
var resistance_cyber  		:= 50.0
var resistance_cosmic		:= 50.0 
var resistance_bio  		:= 50.0

## NOTE This probably will go unused
var resistance_stagger  	:= 12.0
var resistance_knockback  	:= 12.0

## Element - How is this used?
var dmg_zauber  			:= 3.0 
var dmg_cosmic  			:= 0.0 
var dmg_bio  				:= 0.0
var dmg_mental  			:= 0.0 
var dmg_cyber  				:= 0.0

## Vulnerabilities
var vuln_normal				:= 0.0
var vuln_mental  			:= 4.0 
var vuln_zauber  			:= 4.0
var vuln_cyber  			:= 2.0 
var vuln_bio  				:= 5.0 
var vuln_cosmic  			:= 3.0

var max_action_sfx_played	:= false
var block_action_increase 	:= false

func set_base_stat( stat : String, value : float ) -> void:
	set(stat.to_lower(), value)
	if get(stat.to_lower()) == value:
		B2_Playerdata.stat_updated.emit()
	else:
		push_error( "%s is not a valid stat." % stat.to_lower() )

func get_base_stat( stat : String ):
	if get( stat.to_lower() ) == null:
		push_warning( "Invalid stat get - ", stat, ": ", get( stat.to_lower() ) )
	return get( stat.to_lower() )

## TODO Setup effective stats
func get_effective_stat( stat : String ):
	if get( stat.to_lower() ) == null:
		push_warning( "Invalid stat get - ", stat, ": ", get( stat.to_lower() ) )
	return get( stat.to_lower() )

func get_curr_action() -> float:
	return curr_action

func is_at_max_action() -> bool:
	return curr_action == max_action

func full_restore() -> void:
	## heal hoopz completely.
	reset_action()
	increase_hp( 9999 )

func increase_hp( hp : int ) -> void:
	curr_health = clampf( curr_health + hp, 0, max_health )

func decrease_hp( hp : int ) -> void:
	curr_health = clampf( curr_health - hp, 0, max_health )

func increase_action() -> bool:
	if block_action_increase:
		return false
		
	var my_spd 		:= speed * 0.25
	curr_action 	= clampf( curr_action + my_spd, 0.15, max_action )
	
	## Play the "ready" sfx.
	if curr_action == max_action:
		if not max_action_sfx_played:
			#B2_Sound.play_pick("hoopz_click")
			B2_Sound.play_pick("hoopz_pickupgun") # <- alternative
			max_action_sfx_played = true
	else:
		if curr_action < max_action:
			max_action_sfx_played = false
	
	return curr_action == max_action

func reset_action() -> void:
	curr_action = 0.0
