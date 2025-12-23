extends Resource
class_name B2_Gun_Base
## Resource created to organize some miscelaneous functions.

const BUFFER_SIZE		:= 32000
const COMPRESS_MODE 	:= FileAccess.CompressionMode.COMPRESSION_DEFLATE

#region save and load guns.
static func save_guns() -> void:
	var gun_array := []
	if B2_Playerdata.bandolier:
		for gun in B2_Playerdata.bandolier:
			if gun is B2_Weapon:
				gun_array.append( gun_to_dict( gun ) )
	B2_Config.set_user_save_data( "player.guns.bandolier", gun_array )
	
	var gunbag_array := []
	if B2_Playerdata.gun_bag:
		for gunbag in B2_Playerdata.gun_bag:
			if gunbag is B2_Weapon:
				gunbag_array.append( gun_to_dict( gunbag ) )
	B2_Config.set_user_save_data( "player.guns.bag", gunbag_array )
	
## TODO Fix loading. NOTE Fixed. 
static func load_guns() -> void:
	var gun_array : Array = B2_Config.get_user_save_data( "player.guns.bandolier", [] )
	if gun_array:
		for gun in gun_array:
			if gun is Dictionary:
				var loaded_gun : B2_Weapon = dict_to_gun( gun )
				B2_Playerdata.bandolier.append( loaded_gun )
			else:
				push_error( "Invalid gun loaded: ", gun )
	
	var gunbag_array : Array = B2_Config.get_user_save_data( "player.guns.bag", [] )
	if gunbag_array:
		for gunbag in gun_array:
			if gunbag is Dictionary:
				var loaded_gun : B2_Weapon = dict_to_gun( gunbag )
				B2_Playerdata.gun_bag.append( loaded_gun )
			else:
				push_error( "Invalid gun loaded: ", gunbag )
	
## Gun serialization.
## TODO HANDLE SKILLS
static func gun_to_dict( gun : B2_Weapon ) -> Dictionary:
	var gun_dict := Dictionary()
	gun_dict[ "weapon_type" ] 			= gun.weapon_type
	gun_dict[ "weapon_material" ] 		= gun.weapon_material
	gun_dict[ "weapon_group" ]			= gun.weapon_group
	gun_dict[ "weapon_stats" ]			= gun.weapon_stats.stat_to_dict()

	gun_dict[ "weapon_name" ] 			= gun.weapon_name
	gun_dict[ "weapon_short_name" ] 	= gun.weapon_short_name
	gun_dict[ "weapon_pickup_name" ] 	= gun.weapon_pickup_name
	gun_dict[ "weapon_pickup_color" ] 	= gun.weapon_pickup_color.to_html()
	
	gun_dict[ "prefix1" ] 				= gun.prefix1
	gun_dict[ "prefix2" ] 				= gun.prefix2
	gun_dict[ "suffix" ] 				= gun.suffix
	#gun_dict[ "att" ] 					= var_to_str( gun.att )
	#gun_dict[ "spd" ] 					= var_to_str( gun.spd )
	#gun_dict[ "acc" ] 					= var_to_str( gun.acc )
	#gun_dict[ "afx" ] 					= var_to_str( gun.afx )
	#gun_dict[ "wgt" ] 					= var_to_str( gun.wgt )

	#gun_dict[ "max_action" ] 			= gun.max_action
	#gun_dict[ "curr_action" ] 			= gun.curr_action

	#gun_dict[ "max_ammo" ] 			= var_to_str( gun.max_ammo )
	#gun_dict[ "curr_ammo" ] 			= var_to_str( gun.curr_ammo )

	#gun_dict[ "attack_cost" ] 			= gun.attack_cost
	
	#gun_dict[ "generic_damage" ] 		= gun.generic_damage
	#gun_dict[ "bio_damage" ] 			= gun.bio_damage
	#gun_dict[ "cyber_damage" ] 		= gun.cyber_damage
	#gun_dict[ "mental_damage" ] 		= gun.mental_damage
	#gun_dict[ "cosmic_damage" ] 		= gun.cosmic_damage
	#gun_dict[ "zauber_damage" ] 		= gun.zauber_damage
#
	#gun_dict[ "weapon_lvl" ] 			= gun.weapon_lvl
	#gun_dict[ "weapon_xp" ] 			= gun.weapon_xp
	#gun_dict[ "skill_list" ] 			= gun.skill_list
	
	gun_dict[ "favorite" ] 				= var_to_str( gun.favorite )
	gun_dict[ "generation" ] 			= gun.generation
	
	gun_dict[ "son" ] 					= gun.son
	gun_dict[ "lineage_top" ] 			= gun.lineage_top
	gun_dict[ "lineage_bot" ] 			= gun.lineage_bot
	#gun_dict[ "dominant_genes" ] 		= gun.dominant_genes
	
	gun_dict[ "gunmap_pos" ] 			= var_to_str( gun.gunmap_pos ) # Vector2

	#gun_dict[ "bullets_per_shot" ] 	= gun.bullets_per_shot
	#gun_dict[ "ammo_per_shot" ] 		= gun.ammo_per_shot
	#gun_dict[ "wait_per_shot" ] 		= gun.wait_per_shot
	#gun_dict[ "bullet_spread" ] 		= gun.bullet_spread
	return gun_dict
	
## TODO HANDLE SKILLS
static func dict_to_gun( gun_dict : Dictionary ) -> B2_Weapon:
	var gun := B2_Weapon.new()
	gun.weapon_type 					= gun_dict.get( "weapon_type", B2_Gun.TYPE.GUN_TYPE_PISTOL)
	gun.weapon_material 				= gun_dict.get( "weapon_material", B2_Gun.MATERIAL.STEEL )
	gun.weapon_group 					= gun_dict.get( "weapon_group", B2_Gun.GROUP.PISTOLS )
	gun.weapon_stats 					= B2_WeaponStats.new()
	gun.weapon_stats.dict_to_stat( gun_dict.get( "weapon_stats", {} ) )

	gun.weapon_name 					= gun_dict.get( "weapon_name", "LOAD_ERROR" )
	gun.weapon_short_name 				= gun_dict.get( "weapon_short_name", "ERRO" )
	gun.weapon_pickup_name 				= gun_dict.get( "weapon_pickup_name", "ERROR" )
	gun.weapon_pickup_color 			= Color( gun_dict.get( "weapon_pickup_color", Color.WHITE.to_html() ) )
	
	gun.prefix1 						= gun_dict.get( "prefix1", "" )
	gun.prefix2 						= gun_dict.get( "prefix2", "" )
	gun.suffix 							= gun_dict.get( "suffix", "" )
	#gun.att 							= str_to_var( gun_dict.get( "att" ) )
	#gun.spd 							= str_to_var( gun_dict.get( "spd" ) )
	#gun.acc 							= str_to_var( gun_dict.get( "acc" ) )
	#gun.afx 							= str_to_var( gun_dict.get( "afx" ) )
	#gun.wgt 							= str_to_var( gun_dict.get( "wgt" ) )

	#gun.max_action 					= gun_dict.get( "max_action" )
	#gun.curr_action 					= gun_dict.get( "curr_action" )
	
	#gun.max_ammo 						= str_to_var( gun_dict.get( "max_ammo" ) )
	#gun.curr_ammo 						= str_to_var( gun_dict.get( "curr_ammo" ) )

	#gun.attack_cost 					= gun_dict.get( "attack_cost" )
	#
	#gun.generic_damage 				= gun_dict.get( "generic_damage", 	1.0 )
	#gun.bio_damage 					= gun_dict.get( "bio_damage", 		1.0 )
	#gun.cyber_damage 					= gun_dict.get( "cyber_damage", 	1.0 )
	#gun.mental_damage 					= gun_dict.get( "mental_damage", 	1.0 )
	#gun.cosmic_damage 					= gun_dict.get( "cosmic_damage", 	1.0 )
	#gun.zauber_damage 					= gun_dict.get( "zauber_damage", 	1.0 )
#
	#gun.weapon_lvl 					= gun_dict.get( "weapon_lvl", 		1 )
	#gun.weapon_xp 						= gun_dict.get( "weapon_xp", 		0 )
	
	#gun.skill_list 					= str_to_var( gun_dict.get( "skill_list" ) )
	
	gun.favorite 						= str_to_var( gun_dict.get( "favorite", "false" ) )
	gun.generation 						= gun_dict.get( "generation", 1 )
	gun.gunmap_pos 						= str_to_var( gun_dict.get( "gunmap_pos" ) ) # Vector2i
		
	gun.son								= gun_dict.get( "son", {} )
	gun.lineage_top						= gun_dict.get( "lineage_top", {} )
	gun.lineage_bot						= gun_dict.get( "lineage_bot", {} )
#	gun.dominant_genes					= gun_dict.get( "dominant_genes", [] )

	#gun.bullets_per_shot 				= gun_dict.get( "bullets_per_shot" )
	#gun.ammo_per_shot 					= gun_dict.get( "ammo_per_shot" )
	#gun.wait_per_shot 					= gun_dict.get( "wait_per_shot" )
	#gun.bullet_spread 					= gun_dict.get( "bullet_spread" )
	return gun
#endregion

#region Position the gun on the players hand
## NOTE THis section was on the player script
## Values taken from "scr_player_muzzle_position". unsure how I can use this.
## WARNING 23/12/25 "scr_player_muzzle_position" is NOT used in the final game, we shoundnt use those values. Lets fetch the values from "scr_player_getGunShifts" instead.
static func get_muzzle_dist() -> Vector2:
	var heldBulletDist 		: float = 16.0
	var heldBullet_YShift 	: float = -5.0
	
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldBulletDist = 16.0
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldBulletDist = 20.0
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL,B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,B2_Gun.TYPE.GUN_TYPE_REVOLVER,B2_Gun.TYPE.GUN_TYPE_PISTOL,B2_Gun.TYPE.GUN_TYPE_MAGNUM,B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldBulletDist = 16.0
		_:
			heldBulletDist = 8.0
			
	## 23/12/25 Motherfucher, why does it has a SECOND check???
	match B2_Gun.get_current_gun().weapon_type:
		# heavy weapons are held low and close, to a side
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:  heldBullet_YShift = 0.0; heldBulletDist = 12.0 	#  -4
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:       heldBullet_YShift = -2.0; heldBulletDist = 26.0 	#  -10
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:          heldBullet_YShift = 0.0; heldBulletDist = 28.0 	#  -4
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:     heldBullet_YShift = -2.0; heldBulletDist = 16.0 	#  -10
		B2_Gun.TYPE.GUN_TYPE_BFG:              heldBullet_YShift = -2.0; heldBulletDist = 26.0 	#  -10
			
		# Rifles are held high and close, almost centered
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE:     heldBullet_YShift = 4.0; heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_RIFLE:            heldBullet_YShift = 6.0; heldBulletDist = 13.0
		B2_Gun.TYPE.GUN_TYPE_MUSKET:           heldBullet_YShift = 6.0; heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE:     heldBullet_YShift = 8.0; heldBulletDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE:       heldBullet_YShift = 8.0; heldBulletDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE:      heldBullet_YShift = 8.0; heldBulletDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_CROSSBOW:         heldBullet_YShift = 8.0; heldBulletDist = 8.0
			
		# shotguns are held somewhat low and close, a little to a side.
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN:          heldBullet_YShift = 2.0; heldBulletDist = 12.0
		B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN:    heldBullet_YShift = 0.0; heldBulletDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:  heldBullet_YShift = 2.0; heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN:      heldBullet_YShift = 0.0; heldBulletDist = 14.0
		
		B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:     heldBullet_YShift = 0.0; heldBulletDist = 12.0
			
		# rocket launchers are on the shoulder. - was 12 - 12 but that was too high and borked it
		B2_Gun.TYPE.GUN_TYPE_ROCKET:           heldBullet_YShift = 10.0; heldBulletDist = 4.0
			
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL:    heldBullet_YShift = 4.0; heldBulletDist = 12.0
		B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN:    heldBullet_YShift = 4.0; heldBulletDist = 10.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVER:         heldBullet_YShift = 4.0; heldBulletDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_PISTOL:           heldBullet_YShift = 5.0; heldBulletDist = 12.0
		B2_Gun.TYPE.GUN_TYPE_MAGNUM:           heldBullet_YShift = 4.0; heldBulletDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:        heldBullet_YShift = 4.0; heldBulletDist = 14.0
		
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:         heldBullet_YShift = 8.0; heldBulletDist = 10.0
	return Vector2(heldBulletDist, heldBullet_YShift)
	
## scr_player_getGunShifts - set the offsef for the held gun
static func get_gun_held_dist() -> float:
	var heldDist := 0.0
	
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldDist = -6.0
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldDist = -4.0
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldDist = 0.0
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldDist = 22.0
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN, B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN, B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN, B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldDist = 14.0
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldDist = 18.0
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldDist = 16.0
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL, B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN, B2_Gun.TYPE.GUN_TYPE_REVOLVER, B2_Gun.TYPE.GUN_TYPE_PISTOL, B2_Gun.TYPE.GUN_TYPE_MAGNUM, B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldDist = 22.0 # was 17.0
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldDist = 17.0 # was 17.0
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldDist = 0.0
		_:
			push_warning( "Invalid gun type: ", B2_Gun.TYPE.keys()[B2_Gun.get_current_gun().weapon_type] )
	return heldDist

## scr_player_getGunShifts - set the offsef for the held gun
static func get_gun_shifts( gun_held_offset := 0.0 ) -> Vector2:
	var heldHShift := 0.0
	var heldVShift := 0.0
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_MINIGUN:
			heldVShift = -2;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN:
			heldVShift = 3;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			heldVShift = 3;
			heldHShift = -12;
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN:
			heldVShift = 0;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			heldVShift = 1;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			heldVShift = 0;
			heldHShift = -8;
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN:
			heldVShift = 2;
			heldHShift = -8;
		## rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			heldVShift = 12;
			heldHShift = 8;
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL,B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,B2_Gun.TYPE.GUN_TYPE_REVOLVER,B2_Gun.TYPE.GUN_TYPE_PISTOL,B2_Gun.TYPE.GUN_TYPE_MAGNUM,B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:
			heldHShift = 0; # 0
			heldVShift = 5; # 5
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldHShift = 0;
			heldVShift = 6;
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldVShift = 3;
			heldHShift = -12;
		_:
			push_warning( "Invalid gun type: ", B2_Gun.TYPE.keys()[B2_Gun.get_current_gun().weapon_type] )
	
	#heldVShift = 0 ## DEBUG
	#return Vector2( heldHShift, heldVShift )
	return Vector2( heldVShift + gun_held_offset, heldHShift )

## scr_player_draw_setGunLayering - Define if the gun is drawn on top or behing the player.
static func get_gun_depth( upper_sprite_frame : int ) -> int:
	var  aArmDepth := [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
	match B2_Gun.get_current_gun().weapon_type:
		B2_Gun.TYPE.GUN_TYPE_PISTOL,B2_Gun.TYPE.GUN_TYPE_FLINTLOCK,\
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL,B2_Gun.TYPE.GUN_TYPE_REVOLVER,\
		B2_Gun.TYPE.GUN_TYPE_MAGNUM,B2_Gun.TYPE.GUN_TYPE_FLAREGUN,\
		B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN:
			aArmDepth[0] = 1;
			aArmDepth[1] = 1;
			aArmDepth[2] = 1;
			aArmDepth[3] = 1;
			aArmDepth[4] = 1;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 1;
			aArmDepth[9] = 0;
			aArmDepth[10] = 0;
			aArmDepth[11] = 0;
			aArmDepth[12] = 0;
			aArmDepth[13] = 0;
			aArmDepth[14] = 0;
			aArmDepth[15] = 0;
			
			if B2_CManager.get_BodySwap() == "diaper":
				aArmDepth[0] = 0;
				aArmDepth[1] = 0;
				aArmDepth[2] = 0;
				aArmDepth[3] = 0;
				aArmDepth[4] = 1;
				aArmDepth[5] = 0;
				aArmDepth[6] = 0;
				aArmDepth[7] = 0;
				aArmDepth[8] = 0;
				aArmDepth[9] = 0;
				aArmDepth[10] = 0;
				aArmDepth[11] = 0;
				aArmDepth[12] = 0;
				aArmDepth[13] = 0;
				aArmDepth[14] = 0;
				aArmDepth[15] = 0;
			
		B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER:
			aArmDepth[0] = 1;
			aArmDepth[1] = 1;
			aArmDepth[2] = 1;
			aArmDepth[3] = 1;
			aArmDepth[4] = 1;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 0;
			aArmDepth[9] = 0;
			aArmDepth[10] = 0;
			aArmDepth[11] = 0;
			aArmDepth[12] = 0;
			aArmDepth[13] = 0;
			aArmDepth[14] = 0;
			aArmDepth[15] = 0;
			
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN,B2_Gun.TYPE.GUN_TYPE_GATLINGGUN,\
		B2_Gun.TYPE.GUN_TYPE_MINIGUN,B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE:
			aArmDepth[0] = 0;
			aArmDepth[1] = 0;
			aArmDepth[2] = 0;
			aArmDepth[3] = 0;
			aArmDepth[4] = 1;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 2; 	# 1
			aArmDepth[9] = 2; 	# 1
			aArmDepth[10] = 2; 	# 1
			aArmDepth[11] = 2; 	# 1
			aArmDepth[12] = 0;
			aArmDepth[13] = 0;
			aArmDepth[14] = 0;
			aArmDepth[15] = 0;

		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,B2_Gun.TYPE.GUN_TYPE_RIFLE,B2_Gun.TYPE.GUN_TYPE_MUSKET,\
		B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,\
		B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE,B2_Gun.TYPE.GUN_TYPE_CROSSBOW:
			aArmDepth[0] = 0;
			aArmDepth[1] = 0;
			aArmDepth[2] = 0;
			aArmDepth[3] = 0;
			aArmDepth[4] = 1;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 2; 	# 1
			aArmDepth[9] = 2; 	# 1
			aArmDepth[10] = 2; 	# 1
			aArmDepth[11] = 2; 	# 1
			aArmDepth[12] = 0;
			aArmDepth[13] = 0;
			aArmDepth[14] = 0;
			aArmDepth[15] = 0;
			
		# shotguns are held somewhat low and close, a little to a side.
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,\
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN,B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN:
			aArmDepth[0] = 0;
			aArmDepth[1] = 0;
			aArmDepth[2] = 0;
			aArmDepth[3] = 0;
			aArmDepth[4] = 0;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 2; 	# 1
			aArmDepth[9] = 2; 	# 1
			aArmDepth[10] = 2; 	# 1
			aArmDepth[11] = 2; 	# 1
			aArmDepth[12] = 0; 	# 0;
			aArmDepth[13] = 0; 	# 0;
			aArmDepth[14] = 0; 	# 0;
			aArmDepth[15] = 0; 	# 0;
			
		# rocket launchers are on the shoulder.
		B2_Gun.TYPE.GUN_TYPE_ROCKET:
			aArmDepth[0] = 1;
			aArmDepth[1] = 1;
			aArmDepth[2] = 1;
			aArmDepth[3] = 1;
			aArmDepth[4] = 0;# was 0
			aArmDepth[5] = 0;
			aArmDepth[6] = 0;
			aArmDepth[7] = 0;
			aArmDepth[8] = 0;
			aArmDepth[9] = 0;
			aArmDepth[10] = 0;
			aArmDepth[11] = 0;
			aArmDepth[12] = 0;
			aArmDepth[13] = 1;
			aArmDepth[14] = 1;
			aArmDepth[15] = 1;
			
		_:
			aArmDepth[0] = 0;
			aArmDepth[1] = 0;
			aArmDepth[2] = 0;
			aArmDepth[3] = 0;
			aArmDepth[4] = 1;
			aArmDepth[5] = 1;
			aArmDepth[6] = 1;
			aArmDepth[7] = 1;
			aArmDepth[8] = 1;
			aArmDepth[9] = 1;
			aArmDepth[10] = 1;
			aArmDepth[11] = 1;
			aArmDepth[12] = 0;
			aArmDepth[13] = 0;
			aArmDepth[14] = 0;
			aArmDepth[15] = 0;
	
	return -aArmDepth[ upper_sprite_frame ]
#endregion
