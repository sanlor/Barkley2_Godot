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
var prefix1			: Dictionary ## Set by the wpn generation
var prefix2			: Dictionary ## Set by the wpn generation
var suffix			: Dictionary ## Set by the wpn generation

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

var projectile		: PackedScene 	## Scene of the projectile that the gun makes
var sound_id		:= ""			## Sound ID for the shot sfx
var casing			: PackedScene	## Bullet casing. some weapons dont use this.

## SFX stuff
var max_action_sfx_played 		:= false

@export var att					:= 10.0
@export var spd					:= 10.0
@export var lck					:= 10.0
@export var acc					:= 10.0 ## Lower is better
@export var damage_variation 	:= 0.0 

@export var max_action			:= 100.0
var curr_action					:= 100.0 #0.0

var max_ammo					:= 1000
var curr_ammo					:= 1000

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

func get_held_sprite() -> String:
	return type_data.get( "gunHeldSprite", "" )

func get_gun_color1() -> Color:
	return Color( material_data.get( "color1", "" ) )

func get_gun_color2() -> Color:
	return Color( material_data.get( "color2", "" ) )

func get_gun_color3() -> Color:
	return Color( material_data.get( "color3", "" ) )

func get_gun_alpha() -> float:
	return float( material_data.get( "gunHeldSprite2Alpha", 1.0 ) )

func get_soundID() -> String:
	return type_data.get( "soundId", "" )
	
func get_flash_sprite() -> String:
	return type_data.get( "flashSprite", "" )

func get_casing_sound() -> String:
	return type_data.get( "casingSound", "" )

func get_type_data( data : String ):
	return type_data.get( data )
	
func get_material_data( data : String ):
	return material_data.get( data )

func increase_action() -> void:
	if has_ammo():
		var my_spd 		:= spd * 0.50
		curr_action 	= clampf( curr_action + my_spd, 0.0, max_action )
		
		## Play the "ready" sfx.
		if curr_action == max_action:
			if not max_action_sfx_played:
				print("asdasd")
				if weapon_group == B2_Gun.GROUP.SHOTGUNS:
					B2_Sound.play_pick("hoopz_reload")
				else:
					## NOTE maybe add better sfx?
					B2_Sound.play_pick("hoopz_reload")
					
				max_action_sfx_played = true
		else:
			if curr_action < max_action:
				max_action_sfx_played = false
			
func is_at_max_action() -> bool:
	return curr_action == max_action
	
func reset_action() -> void:
	curr_action = 0.0
	
func recover_ammo( amount : int ) -> void:
	curr_ammo = clampi( curr_ammo + amount, 0, max_ammo )
	
func use_ammo( amount : int ) -> void:
	curr_ammo = clampi( curr_ammo - amount, 0, max_ammo )
	
func has_ammo() -> bool:
	return curr_ammo > 0

func has_sufficient_ammo( amount : int ) -> bool:
	return curr_ammo - amount > 0
	
## check if 
#func has_avaiable_skills() -> bool:
	#for s in skill_list:
		#if s:
			#if s.skill_cost >= curr_action:
				#return true
	#return false
