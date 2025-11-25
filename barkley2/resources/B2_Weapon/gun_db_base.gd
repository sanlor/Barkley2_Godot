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

	gun_dict[ "max_action" ] 			= gun.max_action
	gun_dict[ "curr_action" ] 			= gun.curr_action

	#gun_dict[ "max_ammo" ] 				= var_to_str( gun.max_ammo )
	#gun_dict[ "curr_ammo" ] 			= var_to_str( gun.curr_ammo )

	gun_dict[ "attack_cost" ] 			= gun.attack_cost
	
	gun_dict[ "generic_damage" ] 		= gun.generic_damage
	gun_dict[ "bio_damage" ] 			= gun.bio_damage
	gun_dict[ "cyber_damage" ] 			= gun.cyber_damage
	gun_dict[ "mental_damage" ] 		= gun.mental_damage
	gun_dict[ "cosmic_damage" ] 		= gun.cosmic_damage
	gun_dict[ "zauber_damage" ] 		= gun.zauber_damage

	gun_dict[ "weapon_lvl" ] 			= gun.weapon_lvl
	gun_dict[ "weapon_xp" ] 			= gun.weapon_xp
	gun_dict[ "skill_list" ] 			= gun.skill_list
	
	gun_dict[ "favorite" ] 				= var_to_str( gun.favorite )
	gun_dict[ "generation" ] 			= gun.generation
	
	gun_dict[ "son" ] 					= gun.son
	gun_dict[ "lineage_top" ] 			= gun.lineage_top
	gun_dict[ "lineage_bot" ] 			= gun.lineage_bot
	gun_dict[ "dominant_genes" ] 		= gun.dominant_genes
	
	#gun_dict[ "gunmap_pos" ] 			= var_to_str( gun.gunmap_pos )

	gun_dict[ "bullets_per_shot" ] 		= gun.bullets_per_shot
	gun_dict[ "ammo_per_shot" ] 		= gun.ammo_per_shot
	gun_dict[ "wait_per_shot" ] 		= gun.wait_per_shot
	gun_dict[ "bullet_spread" ] 		= gun.bullet_spread
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

	gun.max_action 						= gun_dict.get( "max_action" )
	gun.curr_action 					= gun_dict.get( "curr_action" )
	
	#gun.max_ammo 						= str_to_var( gun_dict.get( "max_ammo" ) )
	#gun.curr_ammo 						= str_to_var( gun_dict.get( "curr_ammo" ) )

	gun.attack_cost 					= gun_dict.get( "attack_cost" )
	
	gun.generic_damage 					= gun_dict.get( "generic_damage", 	1.0 )
	gun.bio_damage 						= gun_dict.get( "bio_damage", 		1.0 )
	gun.cyber_damage 					= gun_dict.get( "cyber_damage", 	1.0 )
	gun.mental_damage 					= gun_dict.get( "mental_damage", 	1.0 )
	gun.cosmic_damage 					= gun_dict.get( "cosmic_damage", 	1.0 )
	gun.zauber_damage 					= gun_dict.get( "zauber_damage", 	1.0 )

	gun.weapon_lvl 						= gun_dict.get( "weapon_lvl", 		1 )
	gun.weapon_xp 						= gun_dict.get( "weapon_xp", 		0 )
	
	#gun.skill_list 						= str_to_var( gun_dict.get( "skill_list" ) )
	
	gun.favorite 						= str_to_var( gun_dict.get( "favorite", "false" ) )
	gun.generation 						= gun_dict.get( "generation", 1 )
	#gun.gunmap_pos 						= str_to_var( gun_dict.get( "gunmap_pos" 	) )
		
	gun.son							= gun_dict.get( "son", {} )
	gun.lineage_top					= gun_dict.get( "lineage_top", {} )
	gun.lineage_bot					= gun_dict.get( "lineage_bot", {} )
	gun.dominant_genes				= gun_dict.get( "dominant_genes", [] )

	gun.bullets_per_shot 				= gun_dict.get( "bullets_per_shot" )
	gun.ammo_per_shot 					= gun_dict.get( "ammo_per_shot" )
	gun.wait_per_shot 					= gun_dict.get( "wait_per_shot" )
	gun.bullet_spread 					= gun_dict.get( "bullet_spread" )
	return gun
#endregion

#region Position the gun on the players hand
## NOTE THis section was on the player script
## Values taken from scr_player_muzzle_position. unsure how I can use this.
static func get_muzzle_dist() -> float:
	var heldBulletDist := 0.0
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
			heldBulletDist = 10.0 # was 8.0
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			heldBulletDist = 8.0
		B2_Gun.TYPE.GUN_TYPE_BFG:
			heldBulletDist = 16.0
	return heldBulletDist
	
## Values taken from scr_player_muzzle_position. unsure how I can use this.
static func get_muzzle_pos() -> float: ## TODO
	return 0.0
	
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
			print( B2_Gun.TYPE.keys()[B2_Gun.get_current_gun().weapon_type] )
	return heldDist

## scr_player_getGunShifts - set the offsef for the held gun
static func get_gun_shifts() -> Vector2:
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
	
	#heldVShift = 0 ## DEBUG
	#return Vector2( heldHShift, heldVShift )
	return Vector2( heldVShift, heldHShift )
#endregion
