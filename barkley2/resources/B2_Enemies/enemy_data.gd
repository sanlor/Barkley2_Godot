extends Resource
class_name B2_EnemyData

const ENEMY_DB = preload("res://barkley2/resources/B2_Enemies/enemyDB.json")

var enemy_name 				:= ""

var hp						:= 12.0 
var weight  				:= 12.0

## Godot specific
var max_action					:= 100.0
var curr_action					:= 0.0
var max_health					:= 12.0
var curr_health					:= 12.0

## Main Stats
var guts					:= 12.0
var luck  					:= 12.0 
var agile  					:= 12.0 
var might  					:= 12.0
var piety  					:= 12.0
var speed  					:= 12.0

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
var zauber  				:= 3.0 
var cosmic  				:= 0.0 
var bio  					:= 0.0
var mental  				:= 0.0 
var cyber  					:= 0.0

## Vulnerabilities
var vuln_mental  			:= 4.0 
var vuln_zauber  			:= 4.0
var vuln_cyber  			:= 2.0 
var vuln_bio  				:= 5.0 
var vuln_cosmic  			:= 3.0

## Gun drop stuff
var gunsdrop  				:= 65.0 ## Chance to drop a weapon?

## Possible guns (1 or 0)
var generic  				:= 1.0 
var shotguns  				:= 0.0 
var rifles  				:= 1.0 
var mounted  				:= 0.0 
var pistols  				:= 0.0 
var automatic  				:= 0.0 

## Unknown
var projectile  			:= 0.0 
var wtc  					:= 12.0

func apply_stats( _enemy_name : String ):
	var data = get_enemy_stats( _enemy_name )
	if data:
		enemy_name = data["name"]
		for stat in data["default"]:
			set( stat, data["default"][stat] )
		
		mutate_stats( luck / 100.0 )
		max_health 		= hp
		curr_health 	= hp
		
		print( "Enemy data for %s loaded!" % enemy_name )

func mutate_stats( variation : float ) -> void:
	hp						*= randf_range( - 1 - variation, 1 + variation )
	guts					*= randf_range( - 1 - variation, 1 + variation )
	luck  					*= randf_range( - 1 - variation, 1 + variation )
	agile  					*= randf_range( - 1 - variation, 1 + variation )
	might  					*= randf_range( - 1 - variation, 1 + variation )
	piety  					*= randf_range( - 1 - variation, 1 + variation )
	speed  					*= randf_range( - 1 - variation, 1 + variation )

## WARNING Use only the default build.
func get_enemy_stats( _enemy_name : String ) -> Dictionary:
	if ENEMY_DB.data.has( _enemy_name ):
		return ENEMY_DB.data.get( _enemy_name )
	else:
		push_error( "%s enemy data not found." % _enemy_name )
		return {}

func increase_action() -> bool:
	var my_spd 		:= speed * 0.25
	curr_action 	= clampf( curr_action + my_spd, 0.0, max_action )
	return curr_action == max_action

func reset_action() -> void:
	curr_action = 0.0
