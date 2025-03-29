extends Resource
class_name B2_EnemyData

@export var enemy_name 				:= ""

@export var hp						:= 12.0 
@export var weight  				:= 12.0

## Godot specific
@export var max_action					:= 100.0
@export var curr_action					:= 0.0
@export var max_health					:= 12.0
@export var curr_health					:= 12.0

## Main Stats
@export var guts					:= 12.0
@export var luck  					:= 12.0 
@export var agile  					:= 12.0 
@export var might  					:= 12.0
@export var piety  					:= 12.0
@export var speed  					:= 12.0

## Resistances
@export var resistance_mental  		:= 50.0 
@export var resistance_normal  		:= 12.0 
@export var resistance_zauber  		:= 50.0 
@export var resistance_cyber  		:= 50.0
@export var resistance_cosmic		:= 50.0 
@export var resistance_bio  		:= 50.0

## NOTE This probably will go unused
@export var resistance_stagger  	:= 12.0
@export var resistance_knockback  	:= 12.0

## Element - How is this used?
@export var zauber  				:= 3.0 
@export var cosmic  				:= 0.0 
@export var bio  					:= 0.0
@export var mental  				:= 0.0 
@export var cyber  					:= 0.0

## Vulnerabilities
@export var vuln_mental  			:= 4.0 
@export var vuln_zauber  			:= 4.0
@export var vuln_cyber  			:= 2.0 
@export var vuln_bio  				:= 5.0 
@export var vuln_cosmic  			:= 3.0

## Gun drop stuff
@export var gunsdrop  				:= 65.0 ## Chance to drop a weapon?

## Possible guns (1 or 0)
@export var generic  				:= 1.0 
@export var shotguns  				:= 0.0 
@export var rifles  				:= 1.0 
@export var mounted  				:= 0.0 
@export var pistols  				:= 0.0 
@export var automatic  				:= 0.0 

## Unknown
@export var projectile  			:= 0.0 
@export var wtc  					:= 12.0

func apply_stats( _enemy_name : String ):
	const ENEMY_DB = preload("res://barkley2/resources/B2_Enemies/enemyDB.json")
	var data = ENEMY_DB.data.get( _enemy_name )
	if data:
		enemy_name = data["name"]
		for stat in data["default"]:
			set( stat, data["default"][stat] )
		
		mutate_stats( luck / 100.0 )
		max_health 		= hp
		curr_health 	= hp
		
		print( "Enemy data for %s loaded!" % enemy_name )
	else:
		print( "failed to load enemy data for enemy %s." % _enemy_name )

func mutate_stats( variation : float ) -> void:
	hp						*= randf_range( - 1 - variation, 1 + variation )
	guts					*= randf_range( - 1 - variation, 1 + variation )
	luck  					*= randf_range( - 1 - variation, 1 + variation )
	agile  					*= randf_range( - 1 - variation, 1 + variation )
	might  					*= randf_range( - 1 - variation, 1 + variation )
	piety  					*= randf_range( - 1 - variation, 1 + variation )
	speed  					*= randf_range( - 1 - variation, 1 + variation )

func increase_action() -> bool:
	var my_spd 		:= speed * 0.25
	curr_action 	= clampf( curr_action + my_spd, 0.0, max_action )
	return curr_action == max_action

func reset_action() -> void:
	curr_action = 0.0
