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
var xp							:= 0

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
var dmg_normal				:= 0.0
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

static func reset() -> void:
	B2_Config.set_user_save_data( "player.stat.base", 			{}		)
	B2_Config.set_user_save_data( "player.stat.effective", 		{} 		)
	B2_Config.set_user_save_data( "player.stat.current", 		{}		)
	B2_Playerdata.player_stats = B2_HoopzStats.new()

func save_stats() -> void:
	var my_stats_base 		:= {}
	var my_stats_effective 	:= {}
	var my_stats_current 	:= {}
	
	## Current
	my_stats_current["curr_action"] 	= curr_action
	my_stats_current["curr_health"] 	= curr_health
	
	## Base
	my_stats_base["max_action"] 		= max_action
	my_stats_base["max_health"] 		= max_health
	my_stats_base["vuln_normal"] 		= vuln_normal
	my_stats_base["vuln_mental"] 		= vuln_mental
	my_stats_base["vuln_zauber"] 		= vuln_zauber
	my_stats_base["vuln_cyber"] 		= vuln_cyber
	my_stats_base["vuln_bio"] 			= vuln_bio
	my_stats_base["vuln_cosmic"] 		= vuln_cosmic
	my_stats_base["lvl"] 				= lvl
	my_stats_base["xp"] 				= xp

	my_stats_base["guts"] 				= guts
	my_stats_base["luck"] 				= luck
	my_stats_base["agile"] 				= agile
	my_stats_base["might"] 				= might
	my_stats_base["piety"] 				= piety
	my_stats_base["speed"] 				= speed
	my_stats_base["weight"] 			= weight

	my_stats_base["resistance_mental "] 	= resistance_mental
	my_stats_base["resistance_normal"] 		= resistance_normal
	my_stats_base["resistance_zauber"] 		= resistance_zauber
	my_stats_base["resistance_cyber"] 		= resistance_cyber
	my_stats_base["resistance_cosmic"] 		= resistance_cosmic
	my_stats_base["resistance_bio"] 		= resistance_bio
	
	my_stats_base["resistance_stagger"] 	= resistance_stagger
	my_stats_base["resistance_knockback"] 	= resistance_knockback

	## Element - How is this used?
	#my_stats_base["dmg_zauber"] 		= dmg_zauber
	#my_stats_base["dmg_cosmic"] 		= dmg_cosmic
	#my_stats_base["dmg_bio"] 			= dmg_bio
	#my_stats_base["dmg_mental"] 		= dmg_mental
	#my_stats_base["dmg_cyber"] 		= dmg_cyber
	
	## WARNING Effective stats not implemented.
	my_stats_effective = my_stats_base

	B2_Config.set_user_save_data( "player.stat.base", 			my_stats_base 			)
	B2_Config.set_user_save_data( "player.stat.effective", 		my_stats_effective 		)
	B2_Config.set_user_save_data( "player.stat.current", 		my_stats_current 		)
	
func load_stats() -> void:
	var my_stats_base : Dictionary 			= B2_Config.get_user_save_data( "player.stat.base", {} 		)
	var my_stats_effective : Dictionary 	= B2_Config.get_user_save_data( "player.stat.effective", {} 	)
	var my_stats_current : Dictionary 		= B2_Config.get_user_save_data( "player.stat.current", {} 		)
	
	## TODO Check if this actually works.
	if my_stats_base:
		for stat : String in my_stats_base:
			if stat.to_lower() in self: set(stat, my_stats_base[stat] )
	if my_stats_effective:
		for stat : String in my_stats_effective:
			if stat.to_lower() in self: set(stat, my_stats_effective[stat] )
	if my_stats_current:
		for stat : String in my_stats_current:
			if stat.to_lower() in self: set(stat, my_stats_current[stat] )
	
	B2_SignalBus.stat_updated.emit()

## Increase base stats by a set amount. Used in leveling up.
func increase_base_stat(  stat : String, value : float ) -> void:
	match stat:
		STAT_EFFECTIVE_MAX_HP:	max_health 	+= value
		STAT_BASE_GUTS:			guts 		+= value
		STAT_BASE_LUCK:			luck 		+= value
		STAT_BASE_AGILE:		agile 		+= value
		STAT_BASE_MIGHT:		might 		+= value
		STAT_BASE_PIETY:		piety 		+= value
		STAT_BASE_LEVEL:		lvl			+= value
		_: breakpoint
	B2_SignalBus.stat_updated.emit( stat )

func set_base_stat( stat : String, value : float ) -> void:
	value = clamp(value, 0, 99) ## The OG game clamps this value too.
	set( stat.to_lower(), value ) 
	if get(stat.to_lower()) == value:
		B2_SignalBus.stat_updated.emit( stat )
	else:
		push_error( "%s is not a valid stat. %s - %s." % [stat.to_lower(), get(stat.to_lower()), value] )

func get_base_stat( stat : String ) -> int:
	if get( stat.to_lower() ) == null:
		push_warning( "Invalid stat get - ", stat, ": ", get( stat.to_lower() ) )
	return get( stat.to_lower() )

@warning_ignore_start("narrowing_conversion")
## TODO Setup effective stats
func get_effective_stat( stat : String ) -> int:
	match stat:
		STAT_EFFECTIVE_MAX_HP:		return max_health
		STAT_BASE_GUTS:				return guts
		STAT_BASE_LUCK:				return luck
		STAT_BASE_AGILE:			return agile
		STAT_BASE_MIGHT:			return might
		STAT_BASE_PIETY:			return piety
		STAT_BASE_WEIGHT:
			var gun := 				B2_Gun.get_current_gun()
			if gun:					return snappedf( weight + B2_Jerkin.get_jerkin_stats()["Wgt"] + B2_Gun.get_current_gun().get_wgt(), 0.01 )
			else:					return snappedf( weight + B2_Jerkin.get_jerkin_stats()["Wgt"], 0.01 )
		
		STAT_BASE_RESISTANCE_BIO:			return resistance_bio 		+ int( B2_Jerkin.get_jerkin_stats()["Bio"] )
		STAT_BASE_RESISTANCE_COSMIC:		return resistance_cosmic 	+ int( B2_Jerkin.get_jerkin_stats()["Kosmic"] )
		STAT_BASE_RESISTANCE_CYBER:			return resistance_cyber 	+ int( B2_Jerkin.get_jerkin_stats()["Cyber"] )
		STAT_BASE_RESISTANCE_MENTAL:		return resistance_mental 	+ int( B2_Jerkin.get_jerkin_stats()["Mental"] )
		STAT_BASE_RESISTANCE_NORMAL:		return resistance_normal 	+ int( B2_Jerkin.get_jerkin_stats()["Normal"] )
		STAT_BASE_RESISTANCE_ZAUBER:		return resistance_zauber 	+ int( B2_Jerkin.get_jerkin_stats()["Zauber"] )
		STAT_BASE_RESISTANCE_KNOCKBACK:		return resistance_knockback
		STAT_BASE_RESISTANCE_STAGGER:		return resistance_stagger
		
		STAT_ATTACK_DMG_NORMAL: 			return dmg_normal
		STAT_ATTACK_DMG_BIO: 				return dmg_bio
		STAT_ATTACK_DMG_CYBER: 				return dmg_cyber
		STAT_ATTACK_DMG_MENTAL: 			return dmg_mental
		STAT_ATTACK_DMG_ZAUBER: 			return dmg_zauber
		STAT_ATTACK_DMG_COSMIC: 			return dmg_cosmic
			
		_:	## No "effective" data to calculate.
			if get( stat ) == null: 
				push_warning( "Invalid stat get - ", stat, ": ", get( stat ) )
				return 0
			return get( stat )
@warning_ignore_restore("narrowing_conversion")

func get_curr_action() -> float:	return curr_action
func is_at_max_action() -> bool:	return curr_action == max_action

func full_restore() -> void:
	## heal hoopz completely.
	reset_action()
	increase_hp( 9999 )

func increase_hp( hp : int ) -> void:	curr_health = clampf( curr_health + hp, 0, max_health )
func decrease_hp( hp : int ) -> void:	curr_health = clampf( curr_health - hp, 0, max_health )

func increase_action() -> bool:
	if block_action_increase:
		return false
		
	var my_spd 		:= speed * B2_Config.PLAYER_ACTION_MULTIPLIER
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

func reset_action() -> void:	curr_action = 0.0

## CRITICAL Setup this function correctly
func can_level_up() -> bool: return true
