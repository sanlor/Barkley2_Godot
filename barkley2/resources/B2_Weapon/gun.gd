extends Resource
class_name B2_Weapon
## Parent class for all weapons.
## Holds a list of stats, attack types and skills
# Check Gun(), GunMap(), scr_combat_weapons_generate()

const O_BULLET 		= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_bullet.tscn")
const O_CASINGS 	= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_casings.tscn")
const S_FLASH 		= preload("res://barkley2/scenes/_Godot_Combat/_Guns/muzzle flash/s_flash.tscn")

enum EFFECT{ DAMAGE, RECOVERY }

@export var weapon_type 	:= B2_Gun.TYPE.GUN_TYPE_PISTOL
@export var weapon_material	:= B2_Gun.MATERIAL.BROKEN
@export var weapon_group 	:= B2_Gun.GROUP.PISTOLS

var weapon_name			:= ""
var weapon_pickup_name 	:= ""
var weapon_pickup_color	:= Color.WHITE

## gun[? "gunmap_pos"] = -1; 	## TODO
## gun[? "numberval"] = 0; 		## TODO
## gun[? "rarity"] = 0; 		## TODO
## gun[? "pointsUsed"] = 0; 	## TODO

var prefix1			: Dictionary ## Set by the wpn generation
var prefix2			: Dictionary ## Set by the wpn generation
var suffix			: Dictionary ## Set by the wpn generation

var type_data 		: B2_WeaponType
var material_data 	: B2_WeaponMaterial

var weapon_hud_sprite 		: AtlasTexture

## SFX stuff
var max_action_sfx_played 		:= false

@export var att					:= 30.0
@export var spd					:= 30.0
@export var acc					:= 30.0 ## Lower is better

@export var max_action			:= 100.0
var curr_action					:= 100.0 #0.0

var max_ammo					:= 300
var curr_ammo					:= 300

@export var attack_cost			:= 90			## How many action point cost for reloading this weapon

var weapon_lvl					:= 1			## gun[? "sLevel"] = 1;
var weapon_xp					:= 0			## Unlocks new skill when you use this weapon for long enough

## Genetics
var favorite					:= 1
var son							: B2_Weapon
var lineage_top					:= "" ## ????
var lineage_bot					:= "" ## ????
var generation					:= 1

#@export var normal_attack	: CombatComponent				## Normal attack
#@export var skill_list		: Dictionary[CombatSkill, int] 	## List of attacks, with the EXP necessary to unlock it

#region Weapon data
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
	return type_data.gunHeldSprite
#
# Return an array of colors for the main color, parts color, spots color and parts alpha.
# Color.HOT_PINK means ERROR
func get_gun_colors() -> Array:
	var colors := [ Color.WHITE, null, null ]
	if material_data.col:
		colors[0] = Color.from_string( material_data.col, 			Color.HOT_PINK )
	if material_data.displayParts:
		colors[1] = Color.from_string( material_data.gunheldcol2, 	Color.HOT_PINK )
	if material_data.displaySpots:
		colors[2] = Color.from_string( material_data.gunheldcol3, 	Color.HOT_PINK )
	return colors

func get_soundID() -> String:
	var soundId := type_data.soundId
	if material_data.soundId: ## Material sound override
		soundId = material_data.soundId
	if soundId.is_empty():
		soundId = "hoopz_shellcasing_light" ## Default
	return soundId
	
func get_flash_sprite() -> String:
	return type_data.flashSprite

func get_swap_sound() -> String:
	if type_data.swapSound.is_empty():
		return "hoopz_swapguns"
	else:
		return type_data.swapSound

func get_bullet_sprite() -> String:
	return material_data.pBulletSprite

func get_bullet_color() -> Color:
	if material_data.pBulletColor.is_empty():
		return Color.WHITE
	else:
		return Color( material_data.pBulletColor )

func get_casing_sound() -> String:
	return type_data.casingSound
	
func get_casing_color() -> Color:
	return Color.from_string( type_data.bcasingCol, Color.HOT_PINK )
	
func get_casing_scale() -> float:
	if type_data.bcasingScale.is_empty():
		return 0.5
	else:
		return float( type_data.bcasingScale )
	
func get_casing_speed() -> float:
	if type_data.bcasingSpd.is_empty():
		return 1.0
	else:
		return float( type_data.bcasingSpd )
	
#endregion

#region Weapon Operation
func shoot_gun( scene_to_place : Node2D, casing_pos : Vector2,source_pos : Vector2, dir : Vector2 ) -> void:
	B2_Sound.play( get_soundID() )
	var bullet = O_BULLET.instantiate()
	bullet.set_direction( dir )
	bullet.position = source_pos
	scene_to_place.add_sibling( bullet, true )
	bullet.setup_bullet_sprite( get_bullet_sprite(), get_bullet_color() )
	
	if get_flash_sprite():
		var flash = S_FLASH.instantiate()
		flash.position = source_pos
		flash.look_at( source_pos + dir )
		scene_to_place.add_sibling( flash, true )
		flash.play( get_flash_sprite() )
	
	if get_casing_sound():
		var casing = O_CASINGS.instantiate()
		casing.setup( get_casing_sound(), get_casing_scale(), get_casing_speed(), get_casing_color() )
		casing.position = casing_pos
		scene_to_place.add_sibling( casing, true )
	
#endregion

#region Weapon Mgmt
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
	
#endregion
