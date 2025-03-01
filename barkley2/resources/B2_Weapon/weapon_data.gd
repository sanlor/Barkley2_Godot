extends Resource
class_name B2_Weapon
## Parent class for all weapons.
## Holds a list of stats, attack types and skills
# Check Gun(), GunMap(), scr_combat_weapons_generate()

enum EFFECT{ DAMAGE, RECOVERY }

@export var weapon_type 	:= B2_Gun.TYPE.GUN_TYPE_PISTOL
@export var weapon_material	:= B2_Gun.MATERIAL.BROKEN
@export var weapon_group 	:= B2_Gun.GROUP.PISTOLS

var weapon_name	:= ""
var prefix1		: Dictionary ## Set by the wpn generation
var prefix2		: Dictionary ## Set by the wpn generation
var suffix		: Dictionary ## Set by the wpn generation

var type_data 		: Dictionary
var material_data 	: Dictionary

## scr_combat_weapons_applyGraphic
var weapon_color := Color.WHITE
var decal1_color := Color.WHITE
var decal2_color := Color.WHITE
var decal3_color := Color.WHITE


## Use decals or not ##
var displaySpots = false;
var displayParts = false;

## Decal sprites ##
var weapon_first_sprite	 	: AnimatedSprite2D 	## Main sprite, needed.
var weapon_second_sprite	: AnimatedSprite2D
var weapon_third_sprite	 	: AnimatedSprite2D

## Some sort of a bullet alpha multiplier ##
var overlayAlpha = 1.0; # for "weapon_second_sprite" only.

## Hoopz's torso sprite for this particular gun ##
var torsoFrame = "s_HoopzTorsoAim"

var weapon_behaviour		## TODO What this weapon does? check scr_combat_weapons_applyGraphic line 40 to 1800 (Damn)

var weapon_hud_sprite 		: AtlasTexture
var weapon_hud_sprite_mini 	: AtlasTexture

var projectile		: PackedScene 	## Scene of the projectile that the gun makes
var sound_id		:= ""			## Sound ID for the shot sfx
var casing			: PackedScene	## Bullet casing. some weapons dont use this.

@export var att					:= 1.0
@export var spd					:= 1.0
@export var lck					:= 1.0
@export var acc					:= 1.0 ## Lower is better
@export var damage_variation 	:= 0.0 

@export var max_action			:= 100
var curr_action					:= 0

@export var attack_cost			:= 90			## How many action point cost for reloading this weapon

var weapon_xp					:= 0			## Unlocks new skill when you use this weapon for long enough

#@export var normal_attack	: CombatComponent				## Normal attack
#@export var skill_list		: Dictionary[CombatSkill, int] 	## List of attacks, with the EXP necessary to unlock it

func get_full_name() -> String:
	var full_name := ""
	if prefix1:
		full_name += prefix1["name"] + " "
	if prefix2:
		full_name += prefix2["name"] + " "
	full_name += weapon_name
	if suffix:
		full_name += " " + suffix["name"]
	
	return full_name

## check if 
#func has_avaiable_skills() -> bool:
	#for s in skill_list:
		#if s:
			#if s.skill_cost >= curr_action:
				#return true
	#return false
