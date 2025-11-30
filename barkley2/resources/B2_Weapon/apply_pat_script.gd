extends Resource
## Holy shit, the spaghetti just wont stop!!!!!
# Simulates the scr_combat_weapons_prepPattern script.
# Motherfucker.

static func apply_pattern( gun : B2_Weapon ) -> void:
	match gun.weapon_stats.pPattern:
		"pt_burst":
			gun.weapon_stats.pBurstAmount = 3;
			gun.weapon_stats.pBurstSpeed = gun.weapon_stats.pFireSpeed * 2;
			gun.weapon_stats.pFireSpeed = gun.weapon_stats.pFireSpeed * 0.4;
			
		"pt_longburst":
			pass
			
		"pt_multishot":
			pass
			
		"pt_flintlock":
			gun.weapon_stats.pShots = 3;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/3;
			gun.weapon_stats.pSpreadAmount = 25;
		
		"pt_musket":
			gun.weapon_stats.pShots = 2;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/2;
			gun.weapon_stats.pSpreadAmount = 20;
			
		"pt_scopespread":
			gun.weapon_stats.pShots = 4;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/4;
			gun.weapon_stats.pSpreadAmount = 15;
			
		"pt_spread":
			gun.weapon_stats.pShots = 6;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/4;
			gun.weapon_stats.pSpreadAmount = 30;
			
		"pt_doublespread":
			gun.weapon_stats.pShots = 12;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/8;
			gun.weapon_stats.pSpreadAmount = 60;
			gun.weapon_stats.pAmmoCost = 2;

	## FUCK! not a pattern bellow!!!! Why is this here???????
	if gun.weapon_material == B2_Gun.MATERIAL.FUNGUS:
		gun.weapon_stats.bAdvanced = true;
		
		gun.weapon_stats.pAccuracy+=15;
		gun.weapon_stats.pAccuracy*=1.5;
		gun.weapon_stats.pRecoil *= 0.2;
		
		
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_BFG:
			gun.weapon_stats.pShots = gun.weapon_stats.pShots+2;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/10;
			gun.weapon_stats.pDamageRand = gun.weapon_stats.pDamageRand/2;
			gun.weapon_stats.pSpreadAmount = gun.weapon_stats.pSpreadAmount*1.5 + 5;
		
		gun.weapon_stats.pKnockback = 0;
		gun.weapon_stats.pStagger *= 0;
		
		gun.weapon_stats.bWallRicochet += 2;
		gun.weapon_stats.bEnemySeek += 8;
		gun.weapon_stats.bEnemySeekRange += 32;
		gun.weapon_stats.bEnemySeekTime = .5;
		gun.weapon_stats.bRoaming += 300;
		
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER and gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bSpeed *= .20;
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.bAccel = -1;

		gun.weapon_stats.bExplodeOnWall = true;
		gun.weapon_stats.bExplodeOnEnemy = false;
		gun.weapon_stats.bExplodeOnGround = true;
		gun.weapon_stats.bExplodeOnTimeout = true;
		gun.weapon_stats.bExplodeEffect = null;
		
		if gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_BFG:
			gun.weapon_stats.bExplode = "o_fungiBFG"
			gun.weapon_stats.bExplosion = "";
			gun.weapon_stats.bExplodeDamageMod = 1;
		else:
			gun.weapon_stats.bExplode = "o_shroom"
			gun.weapon_stats.bExplosion = "s_fungus_shroomgrow"
			gun.weapon_stats.bExplodeDamageMod = 1.5;
		
		gun.weapon_stats.bTimeLife += 64;
		gun.weapon_stats.bTimeLife *= 4;
		
		gun.weapon_stats.bDistanceLife += 32;
		gun.weapon_stats.bDistanceLife *= 1.5;
		
		if gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bLobGravity = 0.01
		else:
			gun.weapon_stats.bLobGravity = 0.005
		gun.weapon_stats.bRangeEndGrav = 0.1;

	if gun.weapon_material == B2_Gun.MATERIAL.ORIGAMI:
		gun.weapon_stats.bAdvanced = true;
		if gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_FLAREGUN && gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_ROCKET && gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_BFG:
			gun.weapon_stats.bRoaming += 20;
			gun.weapon_stats.bSpeed *= .50;
			gun.weapon_stats.pAccuracy+=10
		else:
			gun.weapon_stats.pAccuracy+=30
			gun.weapon_stats.pAccuracy*=2;
			gun.weapon_stats.bSpeed *= .20;
			gun.weapon_stats.bAccel = 1.5;
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.bRoaming += 60;
			gun.weapon_stats.bTimeLife += 990;
			gun.weapon_stats.bDistanceLife += 16;
			gun.weapon_stats.bDistanceLife *= 1.25;
			gun.weapon_stats.bLobGravity = 0.5;
			gun.weapon_stats.bRangeEndGrav = 2;


	if gun.weapon_material == B2_Gun.MATERIAL.CHITIN:
		gun.weapon_stats.bAdvanced = true;
		gun.weapon_stats.bExplodeDamageMod = 1.5;
		
		gun.weapon_stats.bSpeed *= .4;
		gun.weapon_stats.bMinSpeed = 2;
		gun.weapon_stats.bLobGravity = 6;

	if gun.weapon_material == B2_Gun.MATERIAL.MARBLE:
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER && gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bSpeed *= .20;
			gun.weapon_stats.bAccel = 1.5;
			
		gun.weapon_stats.bMinSpeed = 1;
		gun.weapon_stats.bTimeLife += 990;
		gun.weapon_stats.bDistanceLife *= 1.25;
		gun.weapon_stats.bRoaming += 120;
		gun.weapon_stats.bEnemySeek += 12;
		gun.weapon_stats.bEnemySeekRange += 96;
		gun.weapon_stats.bEnemySeekTime = .5;

	if gun.weapon_material == B2_Gun.MATERIAL.SALT:
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_ROCKET && gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_BFG:
			gun.weapon_stats.pShots = gun.weapon_stats.pShots*3;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/3;
			gun.weapon_stats.pDamageRand = gun.weapon_stats.pDamageRand/2;
			gun.weapon_stats.pSpreadAmount = gun.weapon_stats.pSpreadAmount*1.75 + 10;

	if gun.weapon_material == B2_Gun.MATERIAL.NAPALM:
		var ptype = gun.weapon_type;
		if ptype != B2_Gun.TYPE.GUN_TYPE_FLAREGUN && ptype != B2_Gun.TYPE.GUN_TYPE_ROCKET && ptype != B2_Gun.TYPE.GUN_TYPE_BFG:
			
			gun.weapon_stats.pShots = gun.weapon_stats.pShots*2;
			gun.weapon_stats.pDamageMin = gun.weapon_stats.pDamageMin/3;
			gun.weapon_stats.pDamageRand = gun.weapon_stats.pDamageRand/3;
			gun.weapon_stats.pSpreadAmount = gun.weapon_stats.pSpreadAmount*1.5 + 6;

	if gun.weapon_material == B2_Gun.MATERIAL.DIGITAL:
		
		gun.weapon_stats.pAccuracy+=15;
		gun.weapon_stats.bAdvanced = true;
		gun.weapon_stats.bEnemyPierce += 2;

	if gun.weapon_material == B2_Gun.MATERIAL.SILVER:
		
		gun.weapon_stats.bAdvanced = true;
		gun.weapon_stats.bEnemyPierce += 1;

	if gun.weapon_material == B2_Gun.MATERIAL.DUAL:
		pass

	if gun.weapon_material == B2_Gun.MATERIAL.TAXIDERMY:
		gun.weapon_stats.bAdvanced = true;
		gun.weapon_stats.pAccuracy+=20
		gun.weapon_stats.pAccuracy*=2;
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER && gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bSpeed *= .4
		gun.weapon_stats.bAccel = -1.5;
		gun.weapon_stats.bMinSpeed = 3;
		gun.weapon_stats.bRoaming += 80;
		gun.weapon_stats.bTimeLife += 700;
		gun.weapon_stats.bDistanceLife += 16;
		gun.weapon_stats.bDistanceLife *= 1.25;
		
		gun.weapon_stats.bRangeEndGrav = 2;
		
		gun.weapon_stats.bEnemySeek += 8;
		gun.weapon_stats.bEnemySeekRange += 32;
		gun.weapon_stats.bEnemySeekTime = .5;

	if gun.weapon_material == B2_Gun.MATERIAL.ITANO:  # ITANO
		gun.weapon_stats.bEnemySeek += 16;
		gun.weapon_stats.bEnemySeekRange += 64;
		gun.weapon_stats.bEnemySeekTime = .5;
		
		if gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER && gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bSpeed *= .15
		gun.weapon_stats.bMaxSpeed = 80;
		gun.weapon_stats.bMinSpeed = 2;
		gun.weapon_stats.bAccel = 2;
		
		gun.weapon_stats.bExplodeOnWall = true;
		gun.weapon_stats.bExplodeOnEnemy = true;
		gun.weapon_stats.bExplodeOnEnemyProx = false;
		gun.weapon_stats.bExplodeOnGround = true;
		gun.weapon_stats.bExplodeOnTimeout = true;
		gun.weapon_stats.bDealDamage = false;
		
		gun.weapon_stats.pAccuracy+=30
		gun.weapon_stats.pAccuracy*=2;
		gun.weapon_stats.pRangeMod*=1.5;
		gun.weapon_stats.bTimeLife += 32;
		gun.weapon_stats.bDistanceLife += 48;
		
		gun.weapon_stats.bTrail = "o_explEffect"
		gun.weapon_stats.bTrailExplosion = "s_pixel" # effect_itanosmoke);
		gun.weapon_stats.bTrailAcc = 0;
		gun.weapon_stats.bTrailAmount = 1;
		gun.weapon_stats.bTrailInterval = 2;
		
		if gun.weapon_stats.bExplode == null:
			gun.weapon_stats.bExplode = "o_explosion"
			gun.weapon_stats.bExplosion = "s_effect_explo_32"
			gun.weapon_stats.bExplodeDamageMod = 0.8;
		
		if gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			gun.weapon_stats.bLobGravity = 2.5
		gun.weapon_stats.bAdvanced = true;
