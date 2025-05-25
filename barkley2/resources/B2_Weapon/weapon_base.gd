extends Resource
class_name B2_Weapon
## Parent class for all weapons.
## Holds a list of stats, attack types and skills
# Check Gun(), GunMap(), scr_combat_weapons_generate()

signal finished_combat_action

const O_BULLET 		= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_bullet.tscn")
const O_CASINGS 	= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_casings.tscn")
const S_FLASH 		= preload("res://barkley2/scenes/_Godot_Combat/_Guns/muzzle_flash/s_flash.tscn")

enum EFFECT{ DAMAGE, RECOVERY }

@export var weapon_type 	:= B2_Gun.TYPE.GUN_TYPE_PISTOL
@export var weapon_material	:= B2_Gun.MATERIAL.BROKEN
@export var weapon_group 	:= B2_Gun.GROUP.PISTOLS

@export_category("Weapon ID")
@export var weapon_name			:= ""
@export var weapon_short_name	:= ""
@export var weapon_pickup_name 	:= ""
@export var weapon_pickup_color	:= Color.WHITE

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

@export_category("Gun stats") ## TODO
@export var att					:= 30.0
@export var spd					:= 30.0
@export var acc					:= 30.0 ## Lower is better
@export var afx					:= 30.0 ## Affix is not used currently
@export var wgt					:= 10.0

@export var max_action			:= 100.0
var curr_action					:= 100.0 #0.0

@export var max_ammo			:= 30
var curr_ammo					:= 30

@export var attack_cost			:= 90			## How many action point cost for reloading this weapon

@export_category("Attribute Modifiers") ## TODO
@export var generic_damage					:= 1.0 ## Add Generic damage type to this attack
@export var bio_damage						:= 1.0 ## Add Bio damage type to this attack
@export var cyber_damage					:= 1.0 ## Add Cyber damage type to this attack
@export var mental_damage					:= 1.0 ## Add Mental damage type to this attack
@export var cosmic_damage					:= 1.0 ## Add Cosmic damage type to this attack
@export var zauber_damage					:= 1.0 ## Add Zauber damage type to this attack

@export_category("Gun level")
@export var weapon_lvl					:= 1			## gun[? "sLevel"] = 1;
@export var weapon_xp					:= 0			## Unlocks new skill when you use this weapon for long enough

@export_category("Cinema settings") ## TODO
@export var delay_before_action				:= 0.0		## Add a dramatic delay before the shot.
@export var delay_after_action				:= 0.75		## Add a dramatic delay after the shot.

## Genetics
var favorite					:= 1
var son							: B2_Weapon
var lineage_top					:= "" ## ????
var lineage_bot					:= "" ## ????
var generation					:= 1

#@export var normal_attack	: B2_WeaponAttack						## Normal attack
@export var skill_list		: Dictionary[B2_WeaponSkill, int] 		## List of attacks, with the EXP necessary to unlock it

## TODO add a custom resource or an external resource for this.
@export_category("Skill settings")
@export var bullets_per_shot 	:= 5 	## how many bullets are spawn
@export var ammo_per_shot		:= 5 	## how much ammo is used
@export var wait_per_shot		:= 0.1	## Shotgun spawn all bullets at the same time. Machine gun spawn one at a time
@export var bullet_spread		:= 0.0	## NOT related to accuracy. Shotgun will spread the bullets on a wide arc. a saw-off shotgun should spread a bit more. 0.0 means no spread and TAU is shooting at random. keep at 0.0 to 0.25.

var is_shooting		:= false
var abort_shooting 	:= false

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

## Used when you dont know the affixes yet
func get_secret_name() -> String:
	var full_name := ""
	if prefix1:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += prefix1["name"] + " "
		else:
			full_name += "?????" + " "
	if prefix2:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += prefix2["name"] + " "
		else:
			full_name += "?????" + " "
	full_name += weapon_name
	if suffix:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += " " + suffix["name"]
		else:
			full_name += "?????" + " "
	
	return full_name

func get_short_name() -> String:
	return weapon_short_name

func get_power_mod() -> float:
	return (type_data._pow + material_data._pow) / 2.0

func get_speed_mod() -> float:
	return (type_data._spd + material_data._spd) / 2.0

func get_ammo_mod() -> float:
	return (type_data._amm + material_data._amm) / 2.0
	
func get_affix_mod() -> float:
	return (type_data._afx + material_data._afx) / 2.0

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

## Gunshot sound
func get_soundID() -> String:
	var soundId := type_data.soundId
	if material_data.soundId: ## Material sound override
		soundId = material_data.soundId
	if soundId.is_empty():
		soundId = "hoopz_shellcasing_light" ## Default
		## NOTE This is wrong.
	return soundId
	
## Gunshot flash sprite
func get_flash_sprite() -> String:
	return type_data.flashSprite

## Gun Swap sound
func get_swap_sound() -> String:
	if type_data.swapSound.is_empty():
		return "hoopz_swapguns" # Default
	else:
		return type_data.swapSound

func get_reload_sound() -> String:
	if type_data.reloadSound.is_empty():
		return "hoopz_reload" # Default
	else:
		return type_data.reloadSound

## Bullet sprite
func get_bullet_sprite() -> String:
	return material_data.pBulletSprite

## Bullet´s color
func get_bullet_color() -> Color:
	if material_data.pBulletColor.is_empty():
		return Color.WHITE # Default
	else:
		return Color( material_data.pBulletColor )

## Bullet casing sound
func get_casing_sound() -> String:
	return type_data.casingSound
	
## Bullet casing color
func get_casing_color() -> Color:
	return Color.from_string( type_data.bcasingCol, Color.HOT_PINK )
	
## Bullet casing size/scale
func get_casing_scale() -> float:
	if type_data.bcasingScale.is_empty():
		return 0.5 # Default
	else:
		return float( type_data.bcasingScale )
	
## Bullet casing speed/gravity
func get_casing_speed() -> float:
	if type_data.bcasingSpd.is_empty():
		return 1.0 # Default
	else:
		return float( type_data.bcasingSpd )
#endregion

#region Weapon Operation
func create_flash(scene_to_place : Node, source_pos : Vector2, dir : Vector2) -> void:
	if get_flash_sprite():
		var flash = S_FLASH.instantiate()
		flash.position = source_pos
		flash.look_at( (source_pos + dir) )
		flash.rotation += randf_range( -PI/32, PI/32 )
		flash.scale = Vector2.ONE * randf_range( 0.8, 1.2 )
		flash.modulate.a *= randf_range( 0.8, 1.2 )
		scene_to_place.add_child( flash, true )
		flash.play( get_flash_sprite() )
		
func create_casing(scene_to_place : Node, casing_pos : Vector2) -> void:
	if get_casing_sound():
		var casing = O_CASINGS.instantiate()
		casing.setup( get_casing_sound(), get_casing_scale(), get_casing_speed(), get_casing_color() )
		casing.position = casing_pos
		scene_to_place.add_child( casing, true )
		
func use_normal_attack( scene_to_place : Node, casing_pos : Vector2,source_pos : Vector2, dir : Vector2, source_actor : B2_CombatActor ) -> void:
	is_shooting = true
	
	if delay_before_action > 0.0:
		await scene_to_place.get_tree().create_timer( delay_before_action ).timeout
	
	## shotgun behaviour.
	if wait_per_shot == 0.0:
		use_ammo( ammo_per_shot )
		B2_Sound.play( get_soundID() )
		create_flash(scene_to_place, source_pos, dir)
		for i in ammo_per_shot:
			create_casing(scene_to_place, casing_pos)
		
	for i in bullets_per_shot:
		if abort_shooting:
			abort_shooting = false
			break
			
		var my_spread_offset := bullet_spread * ( float(i) / float(bullets_per_shot) )
		my_spread_offset -= bullet_spread / bullets_per_shot
		
		var my_acc := get_acc() / 150.0
		var b_dir := dir.rotated( randf_range( -my_acc, my_acc ) + my_spread_offset )
		
		var bullet = O_BULLET.instantiate()
		bullet.my_gun = self
		bullet.set_direction( b_dir )
		bullet.setup_bullet_sprite( get_bullet_sprite(), get_bullet_color() )
		bullet.source_actor = source_actor
		scene_to_place.add_child( bullet, true )
		bullet.position = source_pos
		
		if wait_per_shot > 0.0:
			use_ammo( 1 )
			B2_Sound.play( get_soundID() )
			create_flash(scene_to_place, source_pos, b_dir)
			create_casing(scene_to_place, casing_pos)
			await scene_to_place.get_tree().create_timer( wait_per_shot ).timeout
	
	#use_ammo( ammo_per_shot )
	reset_action( curr_action - attack_cost )
	if not abort_shooting: ## Only delay if it was not aborted
		await scene_to_place.get_tree().create_timer( delay_after_action ).timeout ## Small delay after shooting.
	abort_shooting = false
	is_shooting = false
	
	finished_combat_action.emit()
	
#endregion

#region Weapon Mgmt
func gain_exp( _exp ) -> void: ## TODO add level up
	weapon_xp += _exp
	
func increase_action() -> void:
	if has_ammo():
		var my_spd 		:= get_spd() * 0.05
		
		if is_overheating(): ## Apply speed penalty to overheated weapons.
			my_spd *= 0.25 
			
		curr_action 	= clampf( curr_action + my_spd, -max_action, max_action )
		
		## Play the "ready" sfx.
		if curr_action == max_action:
			if not max_action_sfx_played:
				# print("asdasd")
				if weapon_group == B2_Gun.GROUP.SHOTGUNS:
					B2_Sound.play_pick("hoopz_reload")
				elif weapon_group == B2_Gun.GROUP.PROJECTILE:
					B2_Sound.play_pick("hoopz_reloadcrossbow")
				else:
					B2_Sound.play_pick("hoopz_pistol_reload")
					
				max_action_sfx_played = true
		else:
			if curr_action < max_action:
				max_action_sfx_played = false
			
func is_at_max_action() -> bool:
	return curr_action == max_action

# Certain skill should oveheat the weapon.
func is_overheating() -> bool:
	return curr_action < 0.0

func reset_action( force_value := 0.0 ) -> void:
	curr_action = force_value
	
func recover_ammo( amount : int ) -> void:
	curr_ammo = clampi( curr_ammo + amount, 0, max_ammo )
	
func use_ammo( amount : int ) -> void:
	if B2_Playerdata.Quest("infiniteAmmo") == 0:
		curr_ammo = clampi( curr_ammo - amount, 0, max_ammo )
	else:
		## infinite ammo enabled. Do not decrease ammo.
		pass
	
func has_ammo() -> bool:
	return curr_ammo > 0

func has_sufficient_ammo( amount : int ) -> bool:
	return curr_ammo - amount > 0
	
#endregion

#region Weapon Combat
func get_att() -> float: ## TODO calculate effective stats (type, material and afixes modifiers)
	@warning_ignore("narrowing_conversion")
	return att
	
func get_acc() -> float: ## TODO calculate effective stats (type, material and afixes modifiers)
	@warning_ignore("narrowing_conversion")
	return acc
	
func get_spd() -> float: ## TODO calculate effective stats (type, material and afixes modifiers)
	@warning_ignore("narrowing_conversion")
	return spd
#endregion
