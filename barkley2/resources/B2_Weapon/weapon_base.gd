extends Resource
class_name B2_Weapon
## Parent class for all weapons.
## Holds a list of stats, attack types and skills
# Check Gun(), GunMap(), scr_combat_weapons_generate()

@export var weapon_type 		:= B2_Gun.TYPE.GUN_TYPE_PISTOL	# "pType"
@export var weapon_material		:= B2_Gun.MATERIAL.STEEL		# "pMaterial"
@export var weapon_group 		:= B2_Gun.GROUP.PISTOLS
@export var weapon_stats		:= B2_WeaponStats.new() # Gun stats, bullet behaviour, casing, effects, etc.

@export_category("Weapon ID")
@export var weapon_name			:= "Undefined"			# "pName"
@export var weapon_short_name	:= "FUCK"
@export var weapon_pickup_name 	:= "Undefined"			# "pickupName"
@export var weapon_pickup_color	:= Color.WHITE			# "pickCol"

var prefix1						:= "" # Dictionary ## Set by the wpn generation	# "pPrefix1"
var prefix2						:= "" # Dictionary ## Set by the wpn generation	# "pPrefix2
var suffix						:= "" # Dictionary ## Set by the wpn generation	# "pSuffix"
var afx_count					:= 0

## SFX stuff
#var max_action_sfx_played 		:= false

@export var max_action						:= 100.0 :
	set(a):
		max_action = a
		curr_action = clamp(curr_action, 0.0, max_action)
var curr_action								:= 100.0
@export var attack_cost						:= 90			## How many action point cost for reloading this weapon

#@export_category("Gun SFX") 
#@export var windupSound 		:= ""		## Wind up SFX (Ex.: Minigun)
#@export var winddownSound 		:= ""		## Wind down SFX (Ex.: Minigun)
#@export var sustainSound 		:= ""		## Wind Sustain SFX (Ex.: Minigun)
#
#@export_category("Attribute Modifiers") ## TODO
#@export var generic_damage					:= 1.0 ## Add Generic damage type to this attack
#@export var bio_damage						:= 1.0 ## Add Bio damage type to this attack
#@export var cyber_damage					:= 1.0 ## Add Cyber damage type to this attack
#@export var mental_damage					:= 1.0 ## Add Mental damage type to this attack
#@export var cosmic_damage					:= 1.0 ## Add Cosmic damage type to this attack
#@export var zauber_damage					:= 1.0 ## Add Zauber damage type to this attack

#@export_category("Gun level")
#@export var weapon_lvl						:= 1			## gun[? "sLevel"] = 1;
#@export var weapon_xp						:= 0			## Unlocks new skill when you use this weapon for long enough

@export_category("Cinema settings") ## TODO
@export var delay_before_action				:= 0.0		## Add a dramatic delay before the shot.
@export var delay_after_action				:= 0.75		## Add a dramatic delay after the shot.

var gunmap_pos								:= Vector2i.ZERO # Used for fusing and drawing the gunmap.

@export_category("Gun Genetics")
@export var favorite						:= false
@export var son								:= {} ## child gun
@export var lineage_top						:= {} ## parent gun (top)
@export var lineage_bot						:= {} ## parent gun (bottom)
@export var generation						:= 1

var dominant_genes							:= [] # List of all dominant genes that this gun has.

#@export var normal_attack	: B2_WeaponAttack						## Normal attack
@export var skill_list		: Dictionary[B2_Gun.SKILL, int] 		## List of attacks, with the EXP necessary to unlock it

## TODO add a custom resource or an external resource for this.
#@export_category("Bullet settings")
#@export var bullets_per_shot 	:= 5 	## how many bullets are spawn
#@export var ammo_per_shot		:= 5 	## how much ammo is used
#@export var wait_per_shot		:= 0.1	## Shotgun spawn all bullets at the same time. Machine gun spawn one at a time
#@export var bullet_spread		:= 0.0	## NOT related to accuracy. Shotgun will spread the bullets on a wide arc. a saw-off shotgun should spread a bit more. 0.0 means no spread and TAU is shooting at random. keep at 0.0 to 0.25.
#@export var turnbased_burst	:= 1	## How many bullets are shot at once, during a turn-based attack.

var is_shooting		:= false
var abort_shooting 	:= false

#region Weapon data
func get_afx_count() -> int:
	return afx_count
	
func get_skill_list() -> Dictionary:
	var s_list : Dictionary[B2_WeaponSkill,int] = {}
	for s : B2_Gun.SKILL in skill_list:
		s_list[ B2_Gun.SKILL_LIST[s] ] = skill_list[s]
	return s_list

func get_weapon_hud_sprite() -> AtlasTexture:
	return B2_Gun.weapon_graphics( self )

func get_full_name() -> String:
	var full_name := ""
	if prefix1:		full_name += prefix1 + " "
	if prefix2:		full_name += prefix2 + " "
	full_name += weapon_name
	if suffix:		full_name += " " + suffix
	return full_name

## Used when you dont know the affixes yet 
## TODO AFFIXES BITCH!
func get_secret_name() -> String:
	var full_name := ""
	if prefix1:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += prefix1 + " "
		else:
			full_name += "?????" + " "
	if prefix2:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += prefix2 + " "
		else:
			full_name += "?????" + " "
	full_name += weapon_name
	if suffix:
		if randf() > 0.5: ## TEMPORARY!!!!!
			full_name += " " + suffix
		else:
			full_name += "?????" + " "
	
	return full_name

func get_short_name() -> String:
	return weapon_short_name

## 23/11/25 Disabled this temporarelly.
# FIXME
func get_pow() -> float:					return snappedf( weapon_stats.sPower, 0.01) 		# Power 	# FIXME return snappedf( att, 0.01)
func get_spd() -> float:					return snappedf( weapon_stats.sSpeed, 0.01) 		# Speed 	# FIXME return snappedf( spd, 0.01)
func get_amm() -> float:					return snappedf( weapon_stats.sAmmo, 0.01) 			# Ammo 		# FIXME return snappedf( max_ammo, 0.01)
func get_amm_base() -> float:				return snappedf( weapon_stats.pAmmoBase, 0.01) 		# Ammo 		# FIXME return snappedf( max_ammo, 0.01)
func get_afx() -> float:					return snappedf( weapon_stats.sAffix , 0.01)		# Affix 	# FIXME return snappedf( afx, 0.01)
func get_rng() -> float:					return snappedf( weapon_stats.sRange, 0.01) 		# Range 	# FIXME return snappedf( afx, 0.01)
func get_wgt() -> float:					return snappedf( weapon_stats.sWeight, 0.01) 		# Weight 	# FIXME return snappedf( wgt, 0.01)

func get_pow_mod() -> float:				return snappedf( weapon_stats.pPowerMod, 0.01) 		# FIXME return snappedf( ( weapon_stats._pow + weapon_stats._pow ) / 2.0, 0.01)
func get_pow_max_mod() -> float:			return snappedf( weapon_stats.pPowerMaxMod, 0.01) 	# FIXME return snappedf( ( weapon_stats._pmx + weapon_stats._pmx ) / 2.0, 0.01)
func get_spd_mod() -> float:				return snappedf( weapon_stats.pSpeedMod, 0.01) 		# FIXME return snappedf( ( weapon_stats._spd + weapon_stats._spd ) / 2.0, 0.01)
func get_amm_mod() -> float:				return snappedf( weapon_stats.pAmmoMod, 0.01) 		# FIXME return snappedf( ( weapon_stats._amm + weapon_stats._amm ) / 2.0, 0.01)
func get_afx_mod() -> float:				return snappedf( weapon_stats.pAffixMod, 0.01) 		# FIXME return snappedf( ( weapon_stats._afx + weapon_stats._afx ) / 2.0, 0.01)
func get_wgt_mod() -> float:				return snappedf( weapon_stats.pWeightMod, 0.01) 	# FIXME return snappedf( weapon_stats._wgt, 0.01) # ( weapon_stats._wgt + weapon_stats._wgt ) / 2.0

func get_effective_pow() -> float:			return snappedf( get_pow() * get_pow_mod(), 0.01 ) # FIXME return snappedf(att * get_pow_mod(), 0.01)
func get_effective_spd() -> float:			return snappedf( get_spd() * get_spd_mod(), 0.01 ) # FIXME return snappedf(spd * get_spd_mod(), 0.01)
func get_effective_amm() -> float:			return snappedf( get_amm() * get_amm_mod(), 0.01 ) # FIXME return snappedf( float(max_ammo) * get_amm_mod(), 0.01)
func get_effective_afx() -> float:			return snappedf( get_afx() * get_afx_mod(), 0.01 ) # FIXME return snappedf(afx * get_afx_mod(), 0.01)
func get_effective_wgt() -> float:			return snappedf( get_wgt() * get_wgt_mod(), 0.01 ) # FIXME return snappedf(wgt * get_wgt_mod(), 0.01)

# FIXME
## Get gun firerate
func get_rate() -> float:
	var sSpeed 			:= get_spd()
	var sSpeedMod 		:= get_spd_mod()
	var POWER 			:= 1.75;
	var DIVISOR 		:= 4.0;
	var TARGET 			:= 300.0;  # pre-GoG value was 350 - bhroom
	var pFireSpeed 		:= sSpeed * sSpeedMod
	var stepInterval 	:= 15.0 + ( pow(1 + pFireSpeed, POWER) / DIVISOR)
	var timeInterval 	:= (TARGET / stepInterval) / 10
	var perSecond 		:= 1.0 / timeInterval
	return 1.0 / perSecond

func get_damage() -> float:			return weapon_stats.pDamageMin
func get_rate_total() -> String:	return str( get_rate() ) + "/s"
func get_held_sprite() -> String:	return weapon_stats.gunHeldSprite
#
# Return an array of colors for the main color, parts color, spots color and parts alpha.
# Color.HOT_PINK means ERROR
func get_gun_colors() -> Array:
	var colors := [ Color.WHITE, null, null ]
	if weapon_stats.col:				colors[0] = Color.html( weapon_stats.col )
	if weapon_stats.displayParts:		colors[1] = Color.html( weapon_stats.gunheldcol2 )
	if weapon_stats.displaySpots:		colors[2] = Color.html( weapon_stats.gunheldcol3 )
	print(colors)
	return colors

## Gunshot sound
func get_soundID() -> String:
	var soundId := weapon_stats.soundId
	if weapon_stats.soundId: ## Material sound override
		soundId = weapon_stats.soundId
	if soundId.is_empty():
		soundId = "hoopz_shellcasing_light" ## Default
		## NOTE This is wrong.
	return soundId
	
## Gunshot flash sprite
func get_flash_sprite() -> String:				return weapon_stats.flashSprite

## Gun Swap sound
func get_swap_sound() -> String:
	if weapon_stats.swapSound.is_empty():		return "hoopz_swapguns" # Default
	else:										return weapon_stats.swapSound

func get_reload_sound() -> String:
	if weapon_stats.reloadSound.is_empty():		return "hoopz_reload" # Default
	else:										return weapon_stats.reloadSound

## Bullet sprite
func get_bullet_sprite() -> String:				return weapon_stats.pBulletSprite

## Bullet´s color
func get_bullet_color() -> Color:
	if weapon_stats.pBulletColor.is_empty():	return Color.WHITE # Default
	else:										return Color( weapon_stats.pBulletColor )

## Bullet casing name. Empty names means that the bullet has no casing.
func get_casing_name() -> String:				return weapon_stats.bcasing

## Bullet casing sound
func get_casing_sound() -> String:				return weapon_stats.casingSound
	
## Bullet casing color
func get_casing_color() -> Color:				return Color.from_string( weapon_stats.bcasingCol, Color.HOT_PINK )
	
## Bullet casing size/scale
func get_casing_scale() -> float:				return float( weapon_stats.bcasingScale )
	
## Bullet casing speed/gravity
func get_casing_speed() -> float:				return float( weapon_stats.bcasingSpd )

## TODO add better stats retrieval
func get_gun_stat( stat_name : String ):		return ( weapon_stats.get(stat_name) )
#endregion

#region Weapon Mgmt
#func gain_exp( _exp ) -> void: ## TODO add level up
	#weapon_xp += _exp
	
#func increase_action() -> void:
	#if has_ammo():
		#var my_spd 		:= get_spd() * B2_Config.WEAPON_ACTION_MULTIPLIER
		#
		#if is_overheating(): ## Apply speed penalty to overheated weapons.
			#my_spd *= B2_Config.OVERHEAT_WEAPON_PENALTY
			#
		#curr_action 	= clampf( curr_action + my_spd, -max_action, max_action )
		#
		### Play the "ready" sfx.
		#if curr_action == max_action:
			#if not max_action_sfx_played:
				## print("asdasd")
				#if weapon_group == B2_Gun.GROUP.SHOTGUNS:
					#B2_Sound.play_pick("hoopz_reload")
				#elif weapon_group == B2_Gun.GROUP.PROJECTILE:
					#B2_Sound.play_pick("hoopz_reloadcrossbow")
				#else:
					#B2_Sound.play_pick("hoopz_pistol_reload")
					#
				#max_action_sfx_played = true
		#else:
			#if curr_action < max_action:
				#max_action_sfx_played = false
			#
#func is_at_max_action() -> bool:
	#return curr_action == max_action

# Certain skill should oveheat the weapon.
#func is_overheating() -> bool:
	#return curr_action < 0.0
#
#func reset_action( force_value := 0.0 ) -> void:
	#curr_action = force_value
	
func recover_ammo( amount : int ) -> bool:
	if get_curr_ammo() >= get_max_ammo():													return false
	else: weapon_stats.pCurAmmo = clampi( get_curr_ammo() + amount, 0, get_max_ammo() ); 	return true
	
func use_ammo( amount : int ) -> void:
	if B2_Playerdata.Quest("infiniteAmmo") == 0: ## infinite ammo enabled. Do not decrease ammo.
		weapon_stats.pCurAmmo = clampi( get_curr_ammo() - amount, 0, get_max_ammo() )
	
func has_ammo() -> bool:							return weapon_stats.pCurAmmo - weapon_stats.pAmmoCost > 0
func has_sufficient_ammo( amount : int ) -> bool:	return weapon_stats.pCurAmmo - amount > 0
func get_curr_ammo() -> int:						return weapon_stats.pCurAmmo
func get_max_ammo() -> int:							return weapon_stats.pMaxAmmo
func get_gun_level() -> float:						return weapon_stats.sLevel

func set_curr_ammo( ammo ) -> void:					weapon_stats.pCurAmmo = clampi( ammo, 0, get_max_ammo() )
#endregion

## TODO add a propper value
func get_gun_knockback() -> float:
	var knockback_force = 2000.0
	if B2_Gun.get_current_gun():
		knockback_force *= B2_Gun.get_current_gun().weapon_stats.pRecoil * 10.0
	else:
		push_warning("No gun????")
			
	return knockback_force
