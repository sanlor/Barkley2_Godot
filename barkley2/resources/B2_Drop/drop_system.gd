extends Resource
class_name B2_Drop

const GUN_PICKUP 					= preload("uid://dw2s64ww53llb")
const CANDY_PICKUP 					= preload("uid://m5r040j0bgdj")
const AMMO_PICKUP 					= preload("uid://b408woyvd6k12")

## Handle Weapon, ammo and candy drops
# Check Settings() line 129 and Drop()

## Drop settings
const settingDropScale = 0.7; 				# Scale (of gun drawn on floor) of dropped guns
const settingFuseCompatibility = 0.95; 		# Range guns can be within, 0.95 = 5%
const settingFuseWeight = 0.75; 			# Weight gain for every fuse
const settingDropWeightPercent = 0.10; 		# 10% - Percent of gunsvalue that is weight for new gun
const settingDropWeightAdd = 1.0; 			# was 1.5 - Add this to percent of gunsvalue on fresh gun
const settingDropAmmo = 0.25; 				# (down from 0.5, bhroom) How much ammo dropped guns have (0.5 = 50%)
const settingDropTimeMin = 4; 				# Minimum time an item stays on the ground
const settingDropTimeLuck = 8; 				# Add this number * (Luck / 100) in seconds to min time

# Drop percentages - Make values under 100 total, any remaining of the 100 will drop nothing
# (change quest constiable dropTable to define which table is used)
# Normal drop table
const settingDropGun = 85;      				# (up from 60, bhroom)
const settingDropCandy = 10;    				# 
const settingDropWildAmmo = 5; 				# Wild Ammo - Either FULL for one gun, or 20% for BANDO

## Boss fighting drop table 
const settingBossDropGun = 25;      			# (up from 55, bhroom) Gun + Candy + Nothing must equal 100
const settingBossDropCandy = 25;    			# (bhroom) Gun + Candy + Nothing must equal 100
const settingBossDropWildAmmo = 50; 			# Wild Ammo - Either FULL for one gun, or 20% for BANDO
## scr_combat_weapons_buildName has cryptic names for dropped guns
const settingAmmoRandom = 50; 				# Percent chance it will give 100% to current gun

static func create_drops_from_db( db_name : String, src_pos : Vector2, dst_pos : Vector2, force : float ) -> void:
	var gun := GUN_PICKUP.instantiate()
	gun.setup_from_db( db_name )
	gun.dst_position = dst_pos
	gun.force_multi = force
	gun.disapear_after_some_time = false
	B2_RoomXY.room_reference.call_deferred( "add_child", gun, true )
	gun.position = src_pos

static func create_drops( enemy_data : B2_EnemyData, pos : Vector2, is_a_boss : bool ) -> void:
	if B2_Playerdata.Quest("dropEnabled") == 0:
		## Weapon drop disabled.
		return
		
	var drop_chance := randf() * 100.0
	if drop_chance <= enemy_data.gunsdrop:
		var DropWildAmmo 	:= 0
		var DropCandy 		:= 0
		
		## Drop Tables
		if is_a_boss:
			DropCandy = settingBossDropCandy
			DropWildAmmo = settingBossDropWildAmmo
		else:
			DropCandy = settingDropCandy
			DropWildAmmo = settingDropWildAmmo
			
		var drop_type := randf() * 100.0
		if drop_type < DropWildAmmo:
			var ammo := AMMO_PICKUP.instantiate()
			B2_RoomXY.room_reference.call_deferred( "add_child", ammo, true )
			ammo.position = pos
			
		elif drop_type < DropCandy:
			## TODO Use luck to select a candy to drop. For now, its random.
			# check Candy("drop") and Drop("candy")
			var candy := CANDY_PICKUP.instantiate()
			candy.setup( B2_Candy.CANDY_LIST.keys().pick_random() ) ## FIXME Should not be random.
			B2_RoomXY.room_reference.call_deferred( "add_child", candy, true )
			candy.position = pos
			
		else:
			## TODO Use luck to select an apropriate gun.
			var gun := GUN_PICKUP.instantiate()
			var choices := []
			## Weapon Types
			if enemy_data.shotguns > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.SHOTGUNS, 		[] ).pick_random() )
			if enemy_data.rifles > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.RIFLES, 			[] ).pick_random() )
			if enemy_data.mounted > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.MOUNTED, 			[] ).pick_random() )
			if enemy_data.pistols > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.PISTOLS, 			[] ).pick_random() )
			if enemy_data.automatic > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.AUTOMATIC, 		[] ).pick_random() )
			if enemy_data.projectile > 0.0: choices.append( B2_Gun.GROUP_TYPE_LIST.get( B2_Gun.GROUP.PROJECTILE, 	[] ).pick_random() )
			
			var sel_choice = choices.pick_random()
			
			if is_instance_valid( B2_RoomXY.room_reference ):
				gun.setup( sel_choice )
				B2_RoomXY.room_reference.call_deferred( "add_child", gun, true )
				gun.position = pos
				## TODO apply stat modifiers to the weapon.
			else:
				## Should not be invalid
				push_warning( "B2_RoomXY.room_reference is invalid: ", B2_RoomXY.room_reference )
