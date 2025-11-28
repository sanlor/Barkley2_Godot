extends Resource
# @tutorial(https://youtu.be/8tsHkpesBdY)
# check scr_combat_weapons_applyGraphic

## This is a direct copy of the scr_combat_weapons_applyGraphic script. Cant think of a better way to deal with this.
# What a mess... X3

const c_white 		:= Color.WHITE
const c_yellow 		:= Color.YELLOW
const c_aqua		:= Color.AQUA
const c_green		:= Color.GREEN
const c_red			:= Color.RED
const c_dkgray		:= Color.DARK_GRAY

static func apply_graphic( gun : B2_Weapon ) -> void:
	# Main gun color #
	var col 		:= c_white;

	# Gun decal colors #
	var gunheldcol1 := c_white;
	var gunheldcol2 := c_white;
	var gunheldcol3 := c_white;
	
	## NOTE Is this even used in this script ??????
	var _kbc := 1.0
	var _stn := 1.0
	
	# Gun type, aka PISTOL, SHOTGUN, RIFLE etc. #
	var type : String = B2_Gun.TYPE.keys()[gun.weapon_type]

	# Gun material, aka Steel, Grass, Candy etc. #
	var material : String = B2_Gun.MATERIAL_NAMES.get(gun.weapon_material)

	# Decal sprites #
	var secondSprite 	:= "";
	var thirdSprite 	:= "";

	# Some sort of a bullet alpha multiplier #
	var overlayAlpha 	:= 1;

	# Use decals or not #
	var displaySpots 	:= false
	var displayParts 	:= false

	# Hoopz's torso sprite for this particular gun #
	var torsoFrame 		:= "s_HoopzTorsoAim";

	# Use default BFG and Flamethrower bullet sprites or not #
	var specialBFG 				:= false;
	var specialFlame 			:= false;
	var normalFlame 			:= true;
	var specialFlaregun 		:= false;
	var specialRocket 			:= false;

	# Stuff applied to materials #
	match material:
		"Candy":
			gun.weapon_stats.pBulletSprite = "s_bull_candyShot"
			col = Color8(190,200,190);
			gunheldcol1= col;
			col = c_white;
			displaySpots = true; gunheldcol3 = Color8(40,200,70);
			displayParts = true; gunheldcol2 = Color8(255,50,80);
			gun.weapon_stats.soundId = "candy_shot";
			gun.weapon_stats.bcasing = "";
			
					
		"3D Printed":
			col = Color8(142,180,198);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(55, 215, 195).to_html()
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.4
			
					
		"Soiled":
			col = Color8(187,230,255);
			gunheldcol1= col;
			col = c_white;
			gunheldcol3 = Color8(222,91,204);
			displaySpots = true;
			normalFlame = true; specialFlame = false;
			gun.weapon_stats.soundId = "hoopzweap_soiled_shot";
			
					
		"Rotten":
			col = Color8(187,250,230);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_goo_med"
			gun.weapon_stats.pBulletColor = Color8(30, 160, 20).to_html()
			gun.weapon_stats.bRangeEndGrav = 7;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.65
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_rotten_shot";
			gun.weapon_stats.sound_normalPitchDmg = 15;
			gun.weapon_stats.bExplodeEffect = null
			match type:
				"GUN_TYPE_FLAREGUN": 
					gun.weapon_stats.bExplosion = "s_effect_explo_rotten" 
				"GUN_TYPE_ROCKET": 
					gun.weapon_stats.bExplosion = "s_effect_explo_rotten" 
				"GUN_TYPE_BFG":
					gun.weapon_stats.pBulletSprite = "s_bull_goo_bfg"
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bDealDamage = true;
			
					gun.weapon_stats.bExplode = "o_explosion_rocket"
					gun.weapon_stats.bExplodeDamageMod = 1;
					gun.weapon_stats.bExplosion = "s_effect_explo_rotten"
			
			displaySpots = true; gunheldcol3 = Color8(3,201,40);
			normalFlame = false; specialFlame = false;
			specialBFG = true;
			specialFlaregun = true;
			specialRocket = true;
					
		"Broken":
			col = Color8(167,210,235);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_broken_shot";
			if type != "GUN_TYPE_SHOTGUN" or type != "GUN_TYPE_DOUBLESHOTGUN" or type != "GUN_TYPE_REVOLVERSHOTGUN":
				gun.weapon_stats.soundId = "hoopzweap_broken_wideshot";
			gun.weapon_stats.pBulletColor = Color8(105, 55, 55).to_html()
			gunheldcol3 = Color8(30,30,30);
			displaySpots = true;
			normalFlame = true; specialFlame = false;
					
		"Carbon":
			_kbc = 0.9;
			_stn = 0.9;
			col = Color8(80,80,80);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.75
			gun.weapon_stats.pBulletSprite = "s_bull_carbon"
			gun.weapon_stats.pBulletColor = Color8(105, 20, 125).to_html()
			match type:
				"GUN_TYPE_PISTOL": gun.weapon_stats.gunHeldSprite = "s_Pistol_Luger"
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Mythril":
			col = Color8(140,160,255);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(230, 240, 255).to_html()
			displayParts = true; gunheldcol2 = Color8(240,240,255);
			normalFlame = true; specialFlame = false;
			

		"Rusty":
			col = Color8(200,160,190);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(250, 115, 65).to_html()
			displaySpots = true; gunheldcol3 = Color8(230,120,60);
			normalFlame = true; specialFlame = false;
			
					
		"Junk":
			col = Color8(110,60,50);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_junk"
			gun.weapon_stats.bRangeEndGrav = 7;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.65
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.soundId = "hoopzweap_junk_shot";
			gun.weapon_stats.sound_normalPitchDmg = 17;
			gun.weapon_stats.bcasing = "";
			
			match type:
				"GUN_TYPE_FLAREGUN","GUN_TYPE_ROCKET","GUN_TYPE_BFG":
					gun.weapon_stats.bExplodeDamageMod = 0.2;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplosion = "";
					
			gun.weapon_stats.bExplodeEffect = null
			
			specialBFG = true;
			displaySpots = true; gunheldcol3 = Color8(150,40,40);
			displayParts = true; gunheldcol2 = Color8(140,140,190);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
					
		"Neon":
			col = Color8(117,60,150);
			gunheldcol1= col;
			col = c_white;
			displaySpots = true; gunheldcol3 = Color8(65,170,80);
			displayParts = true; gunheldcol2 = Color8(255,135,180);
			gun.weapon_stats.soundId = "hoopzweap_neon_shot";
			gun.weapon_stats.sound_normalPitchDmg = 20;
			gun.weapon_stats.bExplodeEffect = null
			gun.weapon_stats.pBulletSprite = "s_bull_neon"
			
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = ""
					gun.weapon_stats.pBulletSprite = "s_bull_neonGloworb"
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = ""
					gun.weapon_stats.pBulletSprite = "s_bull_neonGloworb"
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.pBulletSprite = "s_bull_neonGloworb"
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bDealDamage = true;
					gun.weapon_stats.bExplode = "o_explosion_rocket"
					gun.weapon_stats.bExplodeDamageMod = 1;
					gun.weapon_stats.bExplosion = ""
			
			specialBFG = true;
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
								   
		"Salt":
			col = Color8(255,255,255);
			_kbc = 1.2;
			_stn = 1.2;
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_salt"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .6
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_salt_shot";
			gun.weapon_stats.sound_normalPitchDmg = 10;
			gun.weapon_stats.bExplodeEffect = null
			match type:
				"GUN_TYPE_FLAREGUN": 
					gun.weapon_stats.bExplosion = ""; 
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.2;
					gun.weapon_stats.bEnemyPierce += 2;
					gun.weapon_stats.bDealDamage = false;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bExplodeDamageMod = 0.2;
					gun.weapon_stats.bEnemyPierce += 2;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "o_explosion_rocket"
					gun.weapon_stats.bExplodeDamageMod = 1;
					gun.weapon_stats.bExplosion = ""
			
			specialBFG = true;
			col = c_white;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
									
		"Wood":
			col = Color8(205,70,54);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(180, 100, 40).to_html()
			if type == "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= 2;
				gun.weapon_stats.bDistanceLife = 2000;
				gun.weapon_stats.bTimeLife = 5;
			displayParts = true; gunheldcol2 = Color8(205,170,110);
			normalFlame = true; specialFlame = false;
								   
		"Aluminum":
			col = Color8(162,190,218);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(210, 210, 205).to_html()
			normalFlame = true; specialFlame = false;
									
		"Glass":
			col = Color8(55,75,170);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_glass_light"
			gun.weapon_stats.soundId = "hoopzweap_glass_shot";
			gun.weapon_stats.sound_normalPitchDmg = 20;
			displaySpots = true; gunheldcol3 = Color8(220,230,255);
			displayParts = true; gunheldcol2 = Color8(170,200,225);
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .6
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
									
		"Plastic":
			col = Color8(30,160,255);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_foam"
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_foamdart_shot";
			gun.weapon_stats.bRangeEndGrav = 7;
			gun.weapon_stats.sound_normalPitchDmg = 15;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .65
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.bcasing = "";
			
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bDealDamage = false;
			
			displayParts = true; gunheldcol2 = Color8(230,100,210);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			specialBFG = true;
			
									
		"Leather":
			col = Color8(196,70,60);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(230, 190, 70).to_html()
			displaySpots = true; gunheldcol3 = Color8(230,200,30);
			displayParts = true; gunheldcol2 = Color8(180,140,105);
			normalFlame = true; specialFlame = false;
			
									
		"Studded":
			col = Color8(90,30,60);
			gunheldcol1= col;
			gun.weapon_stats.pBulletColor = Color8(180, 60, 30).to_html()
			match type:
				"GUN_TYPE_PISTOL": col = c_white; 
				_: col = c_dkgray; 
			displaySpots = true; gunheldcol3 = Color8(240,240,230);
			displayParts = true; gunheldcol2 = Color8(195,65,55);
			normalFlame = true; specialFlame = false;
								   
		"Dual":
			col = Color8(160,210,255);
			gunheldcol1= col;
			displayParts = true; gunheldcol2 = Color8(215,220,255);
			gunheldcol1= col;
			col = c_white;
			normalFlame = true; specialFlame = false;
									
		"Plantain":
			col = Color8(246,195,20);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(230, 225, 30).to_html()
			gun.weapon_stats.bExplodeEffect = null
			match type:
				"GUN_TYPE_FLAREGUN": 
					gun.weapon_stats.bExplosion = ""; 
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bDealDamage = true;
					gun.weapon_stats.bExplodeDamageMod = 0.2;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.2;
				_:
					gun.weapon_stats.bAccel = -1;
					
			gun.weapon_stats.soundId = "hoopzweap_plantain_shot";
			gun.weapon_stats.sound_normalPitchDmg = 20;
			specialBFG = true;
			gun.weapon_stats.bSpeed *= .5;
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.pBulletSprite = "s_bull_plantain"
			gun.weapon_stats.bcasing = "s_plantainPeel";
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
									
		"Bone":
			col = Color8(250,250,250);
			gunheldcol1= col;
			gun.weapon_stats.bRangeEndGrav = 7;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .65
			gun.weapon_stats.bMinSpeed = 2;
			
			gun.weapon_stats.bLobGravity = 0.3;
			gun.weapon_stats.bRangeEndGrav = 15;
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.soundId = "hoopzweap_bone_shot";
			gun.weapon_stats.sound_normalPitchDmg = 20;
			gun.weapon_stats.pBulletSprite = "s_bull_bone"
			gun.weapon_stats.bcasing = "";
			
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.25;
					gun.weapon_stats.bDealDamage = false;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.25;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 24;
					gun.weapon_stats.bAdvanced = true;
			
			specialBFG = true;
			displaySpots = true; gunheldcol2 = Color8(0,0,0);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
									
		"Aluminium":
			col = Color8(255,255,255);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(255, 240, 255).to_html()
			normalFlame = true; specialFlame = false;
			
					
		"Titanium":
			col = Color8(120,70,155);
			gunheldcol1= col;
			gun.weapon_stats.pBulletColor = Color8(220, 225, 225).to_html()
			match type:
				"GUN_TYPE_PISTOL": col = c_white; 
				"GUN_TYPE_SUBMACHINEGUN": col = c_white; 
				_: pass
			displaySpots = true; gunheldcol3 = Color8(230,220,130);
			displayParts = true; gunheldcol2 = Color8(140,160,250);
			normalFlame = true; specialFlame = false;
			
					
		"Stone":
			_kbc = 1.2;
			_stn = 1.2;
			col = Color8(140,130,190);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_stone"
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .65;
				gun.weapon_stats.bMinSpeed = 2;
				col = c_white;
				
				gun.weapon_stats.bLobGravity = 2;
				gun.weapon_stats.bRangeEndGrav = 15;
				gun.weapon_stats.bLobDirection = 0;
			
			gun.weapon_stats.soundId = "hoopzweap_stone_shot";
			gun.weapon_stats.sound_normalPitchDmg = 22;
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.25;
					gun.weapon_stats.bDealDamage = false;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.25;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 12;
					gun.weapon_stats.bMinSpeed = 2;
					gun.weapon_stats.bRoaming += 5;
					gun.weapon_stats.bEnemySeek -= 10;
					gun.weapon_stats.bEnemySeekRange += 96;
					gun.weapon_stats.bEnemySeekTime = .1;
					gun.weapon_stats.bLobGravity = 0.4;
					gun.weapon_stats.bRangeEndGrav = 10;
					gun.weapon_stats.bAdvanced = true;
			
			specialBFG = true;
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.bAdvanced = true;
			displayParts = true; gunheldcol2 = Color8(140,190,215);
			displaySpots = true; gunheldcol3 = Color8(100,65,150);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Chrome":
			col = Color8(115,65,155);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(235, 230, 235).to_html()
			displaySpots = true; gunheldcol3 = Color8(240,240,240);
			displayParts = true; gunheldcol2 = Color8(190,200,240);
			normalFlame = true; specialFlame = false;
			
					
		"Frankincense":
			col = Color8(230,160,22);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_frankincense"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
			gun.weapon_stats.bcasing = "";
			col = c_white;
			displaySpots = true; gunheldcol3 = Color8(100,60,40);
			displayParts = true; gunheldcol2 = Color8(255,255,60);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
									
		"Iron":
			col = Color8(110,64,150);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(150,142,200);
			normalFlame = true; specialFlame = false;
			
									
		"Cobalt":
			col = Color8(140,165,255);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_cobalt"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .7
			gun.weapon_stats.bMinSpeed = 3;
			displayParts = true; gunheldcol2 = Color8(230,210,225);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
									
		"Nickel":
			col = Color8(235,215,225);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(200, 190, 140).to_html()
			normalFlame = true; specialFlame = false;
			
									
		"Copper":
			col = Color8(160,63,63);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_copper"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .7
			displayParts = true; gunheldcol2 = Color8(210,150,80);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
									
		"Zinc":
			col = Color8(130,86,176);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(90, 90, 80).to_html()
			displaySpots = true; gunheldcol3 = Color8(225,203,217);
			displayParts = true; gunheldcol2 = Color8(160,190,200);
			normalFlame = true; specialFlame = false;
			
			
		"Fiberglass":
			col = Color8(142,130,180);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(240, 250, 240).to_html()
			displaySpots = true; gunheldcol3 = Color8(152,190,210);
			displayParts = true; gunheldcol2 = Color8(152,210,255);
			normalFlame = true; specialFlame = false;
			
					
		"Grass":
			col = Color8(119,65,42);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .5
				gun.weapon_stats.bMinSpeed = 2
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_grass_shot";
			gun.weapon_stats.sound_normalPitchDmg = 25;
			gun.weapon_stats.pBulletSprite = "s_bull_grass"
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = true;
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 24;
					
			specialBFG = true;
			displaySpots = true; gunheldcol3 = Color8(30,230,40);
			displayParts = true; gunheldcol2 = Color8(75,137,81);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Soy":
			col = Color8(255,200,187);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_soy_shot";
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			displayParts = true; gunheldcol2 = Color8(248,244,239);
			gun.weapon_stats.pBulletSprite = "s_bull_tofu1"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .3
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.bLobGravity = 0.5;
			gun.weapon_stats.bRangeEndGrav = 20;
			gun.weapon_stats.bcasing = "";
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
		"Steel":
			col = Color8(160,210,255);
			gunheldcol1= col;
			displayParts = true; gunheldcol2 = Color8(215,220,255);
			normalFlame = true; specialFlame = false;
					
		"Brass":
			col = Color8(197,68,58);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .5
			gun.weapon_stats.pBulletSprite = "s_bull_brass"
			displayParts = true; gunheldcol2 = Color8(142,132,186);
			displaySpots = true; gunheldcol3 = Color8(238,195,22);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					 
		"Orichalcum":
			col = Color8(30,80,30);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(50,147,80);
			displaySpots = true; gunheldcol3 = Color8(240,230,30);
			gun.weapon_stats.pBulletSprite = "s_bull_orichal"
			gun.weapon_stats.soundId = "hoopzweap_orichalcum_shot";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
				gun.weapon_stats.bMinSpeed = 2;
				gun.weapon_stats.bLobGravity = 6;
				gun.weapon_stats.bWallRicochet += 2;
				gun.weapon_stats.bRicochetRandom = true
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bcasing = "";
			
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 24;
			
			specialBFG = true;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Napalm":
			col = Color8(20,174,255);
			gunheldcol1= col;
			displayParts = true; gunheldcol2 = Color8(232,100,214);
			gun.weapon_stats.pBulletSprite = "s_bull_flamethrower"
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_napalm_shot";
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bAccel = -4
				gun.weapon_stats.bMinSpeed = 2;
				gun.weapon_stats.bRangeEndGrav = 0
			gun.weapon_stats.sound_normalPitchDmg = 20;
			gun.weapon_stats.speedBonus = 1;
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
				"GUN_TYPE_FLAMETHROWER","GUN_TYPE_MACHINEPISTOL","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_MINIGUN","GUN_TYPE_GATLINGGUN","GUN_TYPE_MITRAILLEUSE":
					gun.weapon_stats.soundId = "hoopzweap_napalm_shot_alt";
					gun.weapon_stats.sound_normalPitchDmg = 10;
					gun.weapon_stats.bSpeed *= .5;
					gun.weapon_stats.bDistanceLife = -1;
					gun.weapon_stats.bTimeLife = 7;
				_:
					gun.weapon_stats.bSpeed *= .5;
					gun.weapon_stats.bDistanceLife = -1;
					gun.weapon_stats.bTimeLife = 7;
					
			specialBFG = true;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Origami":
			col = Color8(150,130,160);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(255,255,255);
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			gun.weapon_stats.pKnockback = 0;
			gun.weapon_stats.pStagger *= 0;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_paper"
			gun.weapon_stats.soundId = "hoopzweap_origami_shot";
			gun.weapon_stats.sound_normalPitchDmg = 25;
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
				_: pass

			specialBFG = true;
			
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Offal":
			col = Color8(150,40,40);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_offal"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
				gun.weapon_stats.bMinSpeed = 2
			gun.weapon_stats.soundId = "hoopzweap_offal_shot";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			gun.weapon_stats.bcasing = "";
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
				_: pass

			specialBFG = true;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			displayParts = true; gunheldcol2 = Color8(255,40,20);
			displaySpots = true; gunheldcol3 = Color8(160,20,190);
			
					
		"Crystal":
			col = Color8(190,78,95);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .5
				gun.weapon_stats.bMinSpeed = 4
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_crystalshot"
			gun.weapon_stats.soundId = "hoopzweap_crystal_shot";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
					
				"GUN_TYPE_FLAMETHROWER","GUN_TYPE_MACHINEPISTOL","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_MINIGUN","GUN_TYPE_GATLINGGUN","GUN_TYPE_MITRAILLEUSE":
					gun.weapon_stats.soundId = "hoopzweap_crystal_shot_alt";
					gun.weapon_stats.sound_normalPitchDmg = 15;
				_: pass

			specialBFG = true;
			displayParts = true; gunheldcol2 = Color8(152,190,210);
			displaySpots = true; gunheldcol3 = Color8(20,165,255);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Adamantium":
			col = Color8(255,245,235);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_adamantium_shot";
			gun.weapon_stats.pBulletSprite = "s_bull_adamant"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
				gun.weapon_stats.bMinSpeed = 3
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bEnemyPierce += 3;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pAccuracy = gun.weapon_stats.pAccuracy*0.5;
			gun.weapon_stats.bDistanceLife = gun.weapon_stats.bDistanceLife*0.6;
			displayParts = true; gunheldcol2 = Color8(20,165,255);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Silk":
			col = Color8(150,190,210);
			gun.weapon_stats.pBulletColor = col.to_html()
			gunheldcol1= col;
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .65;
				gun.weapon_stats.bMinSpeed = 2;
				col = c_white;
				
				gun.weapon_stats.bLobGravity = 2;
				gun.weapon_stats.bRangeEndGrav = 15;
				gun.weapon_stats.bLobDirection = 0;
			col = c_white;
			gun.weapon_stats.sound_normalPitchDmg = 25;
			gun.weapon_stats.soundId = "hoopzweap_silk_shot";
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(235,215,225);
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			normalFlame = false; specialFlame = false;
			
					
		"Marble":
			col = Color8(190,145,110);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(255,255,255);
			displaySpots = true; gunheldcol3 = Color8(255,200,40);
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_marble_shot";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			gun.weapon_stats.pBulletSprite = "s_bull_angelCore"
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
					gun.weapon_stats.bLobGravity = 1.5;
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "o_angelBFG";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bDealDamage = true;
					gun.weapon_stats.bExplodeDamageMod = 1;
				"GUN_TYPE_FLAMETHROWER","GUN_TYPE_MACHINEPISTOL","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_MINIGUN","GUN_TYPE_GATLINGGUN","GUN_TYPE_MITRAILLEUSE":
					gun.weapon_stats.soundId = "hoopzweap_marble_shot_alt";
					gun.weapon_stats.sound_normalPitchDmg = 15;
				_: pass

			specialBFG = true;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Rubber":
			col = Color8(40,30,70);
			gunheldcol1= col;
			gun.weapon_stats.soundId = "hoopzweap_rubber_shot";
			gun.weapon_stats.pBulletSprite = "s_bull_rubber"
			gun.weapon_stats.pBulletColor = Color8(200, 40, 215).to_html()
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bRicochetRandom = false;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .5
				gun.weapon_stats.bWallRicochet += 2;
				gun.weapon_stats.bMinSpeed = 2;
			
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
				_: pass

			specialBFG = true;
			
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(100,60,150);
			displaySpots = true; gunheldcol3 = Color8(230,100,210);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Foil":
			col = Color8(110,67,150);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_foil_shot";
			gun.weapon_stats.pBulletSprite = "s_bull_foil"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .6
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(190,210,255);
			displaySpots = true; gunheldcol3 = Color8(240,240,235);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Blood":
			col = Color8(100,60,140);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_blood"
			gun.weapon_stats.pBulletColor = Color8(250, 60, 40).to_html()
			gun.weapon_stats.bcasing = "";
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "";
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 20;
					gun.weapon_stats.bAccel = 0;
					gun.weapon_stats.bSpeed *= .5;

			specialBFG = true;
			displayParts = true; gunheldcol2 = Color8(180,122,140);
			displaySpots = true; gunheldcol3 = Color8(245,30,15);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Silver":
			col = Color8(100,50,130);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(210, 210, 215).to_html()
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed = 1;
				gun.weapon_stats.bMaxSpeed = 80;
				gun.weapon_stats.bMinSpeed = 1;
				gun.weapon_stats.bAccel = 15;
			gun.weapon_stats.pBulletSprite = "s_bull_silver"
			displayParts = true; gunheldcol2 = Color8(150,190,210);
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
					
		"Chitin":
			col = Color8(222,100,200);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "hoopzweap_chitin_shot";
			gun.weapon_stats.sound_normalPitchDmg = 25;
			gun.weapon_stats.pBulletSprite = "s_bull_chitin_egg"
			displayParts = true; gunheldcol2 = Color8(255,160,255);
			displaySpots = true; gunheldcol3 = Color8(255,160,255);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
					
		"Sinew":
			col = Color8(150,40,30);
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_sinew"
			gun.weapon_stats.pBulletColor = Color8(120, 20, 20).to_html()
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.5
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(231,40,10);
			displaySpots = true; gunheldcol3 = Color8(230,160,20);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
					
		"Tin":
			col = Color8(120,70,160);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.5;
				gun.weapon_stats.bMinSpeed = 2
			gun.weapon_stats.pBulletSprite = "s_bull_tin"
			gun.weapon_stats.bSpiraling = 15;
			gun.weapon_stats.bWallRicochet += 1;
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bRicochetRandom = false;
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(160,200,210);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
					
		"Obsidian":
			col = Color8(40,15,25);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(120,50,90);
			displaySpots = true; gunheldcol3 = Color8(255,120,45);
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.3;
				gun.weapon_stats.bMaxSpeed = 80;
				gun.weapon_stats.bMinSpeed = 2
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_magma"
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bExplode = "o_obsidianBFG";
					gun.weapon_stats.bLobGravity = 4;
					gun.weapon_stats.bExplosion = "";
					gun.weapon_stats.bSpeed = 14;
					gun.weapon_stats.bAccel = -1;
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bDealDamage = true;
					gun.weapon_stats.bExplodeDamageMod = 1;
					
			specialBFG = true;
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
					
		"Fungus":
			col = Color8(150,190,210);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_spore"
			col = c_white;
			gun.weapon_stats.soundId = "fungi_spore_shot";
			gun.weapon_stats.sound_normalPitchDmg = 25;
			gun.weapon_stats.bcasing = "";
			specialBFG = true;
			displayParts = true; gunheldcol2 = Color8(255,250,255);
			displaySpots = true; gunheldcol3 = Color8(245,30,10);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
									
		"Damascus":
			col = Color8(110,65,150);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(175, 170, 170).to_html()
			displayParts = true; gunheldcol2 = Color8(195,210,255);
			displaySpots = true; gunheldcol3 = Color8(110,65,150);
			normalFlame = true; specialFlame = false;
			
					
		"Analog":
			col = Color8(90,30,90);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(132,132,160);
			normalFlame = true; specialFlame = false;
			
					
		"Digital":
			col = Color8(110,70,150);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "digital_shot";
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			gun.weapon_stats.pBulletSprite = "s_bull_digitalLaser"
			displayParts = true; gunheldcol2 = Color8(150,190,210);
			specialBFG = true;
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Brain":
			col = Color8(160,25,190);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_brainshot"
			displayParts = true; gunheldcol2 = Color8(255,160,255);
			displaySpots = true; gunheldcol3 = Color8(230,175,200);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Chobham":
			col = Color8(80,30,120);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(44,68,140);
			gun.weapon_stats.pBulletSprite = "s_bull_chobham"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.6
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Bronze":
			col = Color8(139,76,52);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_bronze"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.6
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(187,146,104);
			displaySpots = true; gunheldcol3 = Color8(133,77,47);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Blaster":
			col = Color8(75,70,85);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_blaster_shot";
			displayParts = true; gunheldcol2 = Color8(140,164,255);
			gun.weapon_stats.bcasing = "";
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.75
			gun.weapon_stats.pBulletSprite = "s_bull_blaster"
			gun.weapon_stats.bExplodeEffect = null
			match type:
				"GUN_TYPE_FLAREGUN":
					gun.weapon_stats.bExplosion = "s_bull_blasterBlast";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bDealDamage = false;
					gun.weapon_stats.bAccel = 0;
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.bExplosion = "s_bull_blasterBlastMed";
					gun.weapon_stats.bExplodeDamageMod = 0.20;
					gun.weapon_stats.bAccel = 0.1;
					gun.weapon_stats.bDealDamage = true;
					
				"GUN_TYPE_BFG":
					gun.weapon_stats.bDealDamage = true;
					gun.weapon_stats.bExplode = "o_explosion";
					gun.weapon_stats.bSpeed = 14;
					gun.weapon_stats.bExplosion = "s_bull_blasterBlastMed";
					gun.weapon_stats.bExplodeOnWall = true;
					gun.weapon_stats.bExplodeOnEnemy = true;
					gun.weapon_stats.bExplodeOnEnemyProx = false;
					gun.weapon_stats.bExplodeOnGround = true;
					gun.weapon_stats.bExplodeOnTimeout = true;
					gun.weapon_stats.bExplodeDamageMod = 1;

			specialBFG = true;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Tungsten":
			col = Color8(140,130,186);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(165, 160, 160).to_html()
			displayParts = true; gunheldcol2 = Color8(155,200,210);
			normalFlame = true; specialFlame = false;
			

		"Itano":
			col = Color8(110,65,155);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_rocket"
			normalFlame = true; specialFlame = false;
			match type:
				"GUN_TYPE_MACHINEPISTOL","GUN_TYPE_SUBMACHINEGUN","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_ASSAULTRIFLE","GUN_TYPE_TRANQRIFLE":
					gun.weapon_stats.soundId = "hoopzweap_itano_minirocket";
					gun.weapon_stats.sound_normalPitchDmg = 10;
				"GUN_TYPE_GATLINGGUN","GUN_TYPE_MINIGUN","GUN_TYPE_MITRAILLEUSE","GUN_TYPE_FLAMETHROWER","GUN_TYPE_CROSSBOW","GUN_TYPE_BFG","GUN_TYPE_ROCKET":
					##/no change
					gun.weapon_stats.sound_normalPitchDmg = 30;
					
				"GUN_TYPE_RIFLE","GUN_TYPE_PISTOL","GUN_TYPE_MUSKET","GUN_TYPE_FLINTLOCK","GUN_TYPE_HUNTINGRIFLE","GUN_TYPE_FLAREGUN","GUN_TYPE_SHOTGUN","GUN_TYPE_DOUBLESHOTGUN","GUN_TYPE_REVOLVERSHOTGUN":
					gun.weapon_stats.soundId = "hoopzweap_itano_smallrocket";
					gun.weapon_stats.sound_normalPitchDmg = 20;
					
				"GUN_TYPE_REVOLVER","GUN_TYPE_MAGNUM","GUN_TYPE_SNIPERRIFLE","GUN_TYPE_ELEPHANTGUN":
					gun.weapon_stats.soundId = "hoopzweap_itano_bigrocket";
					gun.weapon_stats.sound_normalPitchDmg = 40;
			
			col = c_white;
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(196,210,255);
			displaySpots = true; gunheldcol3 = Color8(250,30,10);
			specialBFG = true;
			specialFlaregun = true; specialRocket = true;
			
									
		"Pearl":
			col = Color8(120,65,151);
			gunheldcol1= col;
			col = c_white;
			specialBFG = true;
			gun.weapon_stats.soundId = "hoopzweap_pearl_shot";
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.pBulletSprite = "s_bull_pearl_ghostShot"
			displayParts = true; gunheldcol2 = Color8(250,240,225);
			displaySpots = true; gunheldcol3 = Color8(0,160,255);
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= 0.3
			gun.weapon_stats.bcasing = "";
			if gun.weapon_stats.bSpeed < 8:
				gun.weapon_stats.bSpeed = 8
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Myrrh":
			col = Color8(170,80,100);
			gunheldcol1= col;
			gun.weapon_stats.pBulletColor = Color8(210,150,140).to_html()
			gun.weapon_stats.pBulletSprite = "s_bull_myrrh"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 0.4
			gun.weapon_stats.bcasing = "";
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(230,150,115);
			displaySpots = true; gunheldcol3 = Color8(150,130,180);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Platinum":
			col = Color8(240,240,240);
			gunheldcol1= col;
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(150,190,200);
			displaySpots = true; gunheldcol3 = Color8(245,245,245);
			normalFlame = true; specialFlame = false;
			
					
		"Gold":
			_kbc = 1.3;
			_stn = 1.3;
			col = Color8(200,80,50);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed = 1;
				gun.weapon_stats.bMaxSpeed = 80;
				gun.weapon_stats.bMinSpeed = 1;
				gun.weapon_stats.bAccel = 15;
			gun.weapon_stats.pBulletSprite = "s_bull_gold"
			displayParts = true; gunheldcol2 = Color8(255,245,40);
			displaySpots = true; gunheldcol3 = Color8(255,245,200);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
					
		"Mercury":
			col = Color8(100,60,140);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_mercury"
			gun.weapon_stats.bcasing = "";
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .6
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(160,190,210);
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Imaginary":
			gun.weapon_stats.pBulletSprite = "emptySprite"
			gun.weapon_stats.bcasing = "";
			match type:
				"GUN_TYPE_MACHINEPISTOL","GUN_TYPE_SUBMACHINEGUN","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_ASSAULTRIFLE":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_machine_gun";
					
				"GUN_TYPE_GATLINGGUN","GUN_TYPE_MINIGUN","GUN_TYPE_MITRAILLEUSE":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_gatling_gun";
					gun.weapon_stats.windupSound = "hoopzweap_imaginary_windup";
					gun.weapon_stats.winddownSound = "hoopzweap_imaginary_winddown";
					gun.weapon_stats.sustainSound = "hoopzweap_imaginary_windsustain";
					
					
				"GUN_TYPE_RIFLE","GUN_TYPE_PISTOL","GUN_TYPE_MUSKET","GUN_TYPE_FLINTLOCK","GUN_TYPE_HUNTINGRIFLE","GUN_TYPE_FLAREGUN","GUN_TYPE_REVOLVER","GUN_TYPE_MAGNUM","GUN_TYPE_SNIPERRIFLE":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_pistol";
				
				"GUN_TYPE_SHOTGUN","GUN_TYPE_DOUBLESHOTGUN","GUN_TYPE_REVOLVERSHOTGUN","GUN_TYPE_ELEPHANTGUN":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_shotgun";
				
				"GUN_TYPE_BFG":
					#TODO: this needs to be expanded to the chargeup, shot, explosion sounds
					gun.weapon_stats.soundId = "hoopzweap_imaginary_bfg_shot";
				
				"GUN_TYPE_FLAMETHROWER":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_flamethrower";
					
				"GUN_TYPE_CROSSBOW":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_crossbow";
						
				"GUN_TYPE_TRANQRIFLE":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_tranquilizer";
					
				"GUN_TYPE_ROCKET":
					gun.weapon_stats.soundId = "hoopzweap_imaginary_rocket";

			col = Color8(255,255,255);
			gunheldcol1= col;
			col = c_white;
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Lead":
			col = Color8(138,40,40);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_lead"
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bWallRicochet += 1;
			gun.weapon_stats.bRicochetRandom = false;
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .6
				gun.weapon_stats.bMinSpeed = 2;
				gun.weapon_stats.bLobGravity = 5;
				gun.weapon_stats.bRangeEndGrav = 15;
				gun.weapon_stats.bEnemyPierce += 2;
			gun.weapon_stats.bShadow = 2;
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(235,120,70);
			displaySpots = true; gunheldcol3 = Color8(150,170,255);
			normalFlame = true; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
					
		"Diamond":
			_kbc = 0.8;
			_stn = 0.8;
			col = Color8(150,190,210);
			gunheldcol1= col;
			col = c_white;
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .5
				gun.weapon_stats.bMinSpeed = 4
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_diamond"
			displayParts = true; gunheldcol2 = Color8(240,210,225);
			displaySpots = true; gunheldcol3 = Color8(255,255,255);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
					
		"Polenta":
			col = Color8(255,205,40);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(240,255,30).to_html()
			gun.weapon_stats.pBulletSprite = "s_bull_polenta"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .35
				gun.weapon_stats.bcasing = "";
				gun.weapon_stats.bLobGravity = 0.5;
				gun.weapon_stats.bRangeEndGrav = 20
			displayParts = true; gunheldcol2 = Color8(255,255,20);
			displaySpots = true; gunheldcol3 = Color8(240,190,30);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
					
		"Yggdrasil":
			col = Color8(90,25,65);
			gunheldcol1= col;
			specialBFG = true;
			gun.weapon_stats.pBulletSprite = "s_bull_yggShot"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
			gun.weapon_stats.bcasing = "";
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(70,150,90);
			displaySpots = true; gunheldcol3 = Color8(55,180,60);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
					
		"Pinata":
			col = Color8(255,255,20);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.soundId = "hoopzweap_pinata_shot";
			gun.weapon_stats.pBulletSprite = "s_bull_pinataShot"
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= .4
			gun.weapon_stats.bcasing = "";
			displayParts = true; gunheldcol2 = Color8(255,20,20);
			displaySpots = true; gunheldcol3 = Color8(0,90,255);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
					
		"Francium":
			col = Color8(10,225,50);
			gunheldcol1= col;
			gun.weapon_stats.pBulletSprite = "s_bull_francium"
			gun.weapon_stats.pBulletColor = Color8(100,255,70).to_html()
			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bExplosion = "s_effect_franciumExplo"
			gun.weapon_stats.soundId = "hoopzweap_francium_shot";
			gun.weapon_stats.sound_normalPitchDmg = 30;
			if type !="GUN_TYPE_FLAREGUN" && type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bRangeEndGrav = 0;
				gun.weapon_stats.bSpeed *= .30;
				gun.weapon_stats.bMaxSpeed = 40;
				gun.weapon_stats.bMinSpeed = 2;
				gun.weapon_stats.bAccel = -3;
			gun.weapon_stats.bShadow = 0;
			gun.weapon_stats.bcasing = "";
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(40,255,60);
			displaySpots = true; gunheldcol3 = Color8(255,255,50);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
		"Orb":
			col = Color8(120,30,70);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(180,255,230).to_html()
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .8
			gun.weapon_stats.bDistanceLife = gun.weapon_stats.bDistanceLife*1.8;
			gun.weapon_stats.bShadow = 0;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_orb"
			displayParts = true; gunheldcol2 = Color8(132,122,170);
			displaySpots = true; gunheldcol3 = Color8(20,255,20);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
		"Nanotube":
			col = Color8(90,50,140);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(50, 10, 255).to_html()
			displayParts = true; gunheldcol2 = Color8(140,130,190);
			normalFlame = false; specialFlame = false;
			
		"Taxidermy":
			col = Color8(30,30,30);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.pBulletSprite = "s_bull_flyshot"
			displayParts = true; gunheldcol2 = Color8(150,120,105);
			displaySpots = true; gunheldcol3 = Color8(130,40,40);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
		"Porcelain":
			col = Color8(20,160,255);
			gunheldcol1= col;
			gun.weapon_stats.bcasing = "";
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .6;
				gun.weapon_stats.bDistanceLife = gun.weapon_stats.bDistanceLife*0.6;
				gun.weapon_stats.bLobGravity = 0.5;
				gun.weapon_stats.bRangeEndGrav = 30;
			gun.weapon_stats.pBulletSprite = "s_bull_teashot"
			col = c_white;
			displayParts = true; gunheldcol2 = Color8(230,230,255);
			displaySpots = true; gunheldcol3 = Color8(10,130,230);
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
		
		"Anti-Matter":
			col = Color8(0,0,0);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.bcasing = "";
			displaySpots = true; gunheldcol3 = Color8(5,5,70);
			gun.weapon_stats.pBulletSprite = "s_bull_antimatter"
			gun.weapon_stats.soundId = "hoopzweap_antimatter_shot";
			gun.weapon_stats.bShadow = 0;
			gun.weapon_stats.sound_normalPitchDmg = 30;
			match type:
				"GUN_TYPE_FLAMETHROWER","GUN_TYPE_MACHINEPISTOL","GUN_TYPE_HEAVYMACHINEGUN","GUN_TYPE_MINIGUN","GUN_TYPE_GATLINGGUN","GUN_TYPE_MITRAILLEUSE":
					gun.weapon_stats.soundId = "hoopzweap_antimatter_rapidshot";
					gun.weapon_stats.sound_normalPitchDmg = 15;
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= 0.45
			normalFlame = false; specialFlame = true;
			specialFlaregun = true; specialRocket = true;
			
			
		"Aerogel":
			col = Color8(20,160,255);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletSprite = "s_bull_aerogel"
			gun.weapon_stats.pBulletColor = Color8(215,235,255).to_html()
			gun.weapon_stats.bcasing = "";
			if type != "GUN_TYPE_FLAMETHROWER":
				gun.weapon_stats.bSpeed *= .75
			displayParts = true; gunheldcol2 = Color8(180,210,255);
			displaySpots = true; gunheldcol3 = Color8(215,235,255);
			normalFlame = false; specialFlame = false;
			specialFlaregun = true; specialRocket = true;
			
		"Denim":
			col = Color8(95,100,200);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(170,230,235).to_html()
			displayParts = true; gunheldcol2 = Color8(140,160,255);
			displaySpots = true; gunheldcol3 = Color8(255,255,40);
			normalFlame = true; specialFlame = false;
			
			
		"Untamonium":
			col = Color8(70,140,80);
			gunheldcol1= col;
			col = c_white;
			gun.weapon_stats.pBulletColor = Color8(200, 190, 140).to_html()
			col = Color8(235,215,225);
			if type != "GUN_TYPE_FLAMETHROWER" && type != "GUN_TYPE_FLAREGUN":
				gun.weapon_stats.bSpeed *= 2.5
			gun.weapon_stats.bShadow = 1;
			gun.weapon_stats.bcasing = "";
			gun.weapon_stats.soundId = "untamonium_shot";
			displayParts = true; gunheldcol2 = Color8(40,230,65);
			displaySpots = true; gunheldcol3 = Color8(255,40,154);
			normalFlame = false; specialFlame = false;

	# Certain gun type's bullets override most materials
	match type:
		# Use default rocket if no special one is defined #
		"GUN_TYPE_ROCKET":
			if not specialRocket:
				gun.weapon_stats.pBulletSprite = "s_bull_itanoRocket"
				gun.weapon_stats.pBulletColor = c_white.to_html()
			else:
				gun.weapon_stats.pBulletColor = c_white.to_html()
			
		# Use default flaregun if no special one is defined #
		"GUN_TYPE_FLAREGUN":
			if not specialFlaregun:
				gun.weapon_stats.pBulletSprite = "s_flareshot"
				gun.weapon_stats.pBulletColor = c_white.to_html()
			else:
				gun.weapon_stats.pBulletColor = c_white.to_html()
			
		# Use special flamethrower flames or default ones? #
		# NOTE 25/11/25 maybe enable this one?
		#"GUN_TYPE_FLAMETHROWER":
		#	if not specialFlame:
		#	gun.weapon_stats.pBulletSprite = "s_bull_spFlame)
		
		"GUN_TYPE_FLAMETHROWER":
			if not specialFlame:
				if normalFlame:
					gun.weapon_stats.pBulletSprite = "s_bull_flamethrower"
					gun.weapon_stats.pBulletColor = c_white.to_html()
				elif not specialFlame:
					gun.weapon_stats.pBulletSprite = "s_bull_spFlame"
			
		# Use special BFG brast or a default one? #
		"GUN_TYPE_BFG":
			if not specialBFG:
				gun.weapon_stats.pBulletSprite = "s_bull_bfg"
				gun.weapon_stats.pBulletColor = c_white.to_html()
			else:
				gun.weapon_stats.pBulletColor = c_white.to_html()

	# Gun-in-hand decal sprite #
	if displayParts:
		match type:
			"GUN_TYPE_REVOLVER": secondSprite = "s_Revolver_Parts"
			"GUN_TYPE_PISTOL": secondSprite = "s_Pistol_Parts"
			"GUN_TYPE_FLINTLOCK": secondSprite = "s_Flintlock_Parts"
			"GUN_TYPE_FLAREGUN": secondSprite = "s_Flaregun_Parts"
			"GUN_TYPE_MAGNUM": secondSprite = "s_Magnum_Parts"
			"GUN_TYPE_MACHINEPISTOL": secondSprite = "s_Machpistol_Parts"
		
			"GUN_TYPE_SUBMACHINEGUN": secondSprite = "s_SMG_Parts" 
			"GUN_TYPE_HEAVYMACHINEGUN": secondSprite = "s_HeavyMg_Parts" 
			"GUN_TYPE_GATLINGGUN": secondSprite = "s_Gatling_Parts" 
			"GUN_TYPE_MINIGUN": secondSprite = "s_Minigun_Parts" 
			"GUN_TYPE_MITRAILLEUSE": secondSprite = "s_Mitrailleuse_Parts" 
		
			"GUN_TYPE_RIFLE": secondSprite = "s_Rifle_Parts" 
			"GUN_TYPE_MUSKET": secondSprite = "s_Musket_Parts" 
			"GUN_TYPE_HUNTINGRIFLE": secondSprite = "s_Huntrifle_Parts" 
			"GUN_TYPE_TRANQRIFLE": secondSprite = "s_Tranq_Parts" 
			"GUN_TYPE_SNIPERRIFLE": secondSprite = "s_Sniper_Parts" 
			"GUN_TYPE_ASSAULTRIFLE": secondSprite = "s_AssaultRifle_Parts"
		
			"GUN_TYPE_SHOTGUN": secondSprite = "s_Shotgun_Parts" 
			"GUN_TYPE_DOUBLESHOTGUN": secondSprite = "s_DbarrelShotgun_Parts" 
			"GUN_TYPE_REVOLVERSHOTGUN": secondSprite = "s_RevShgun_Parts" 
			"GUN_TYPE_ELEPHANTGUN": secondSprite = "s_ElephantGun_Parts"
		
			"GUN_TYPE_CROSSBOW": secondSprite = "s_Crossbow_Parts"
			"GUN_TYPE_FLAMETHROWER": secondSprite = "s_Flamethrower_GunParts" 
			"GUN_TYPE_ROCKET": secondSprite = "s_Rocket_Parts" 
			"GUN_TYPE_BFG": secondSprite = "s_Supergun_Parts" 

	# Gun-in-hand display Spots
	if displaySpots:
		match type:
			"GUN_TYPE_REVOLVER": thirdSprite = "s_Revolver_Spots"
			"GUN_TYPE_PISTOL": thirdSprite = "s_Pistol_Spots"
			"GUN_TYPE_FLINTLOCK": thirdSprite = "s_Flintlock_Spots"
			"GUN_TYPE_FLAREGUN": thirdSprite = "s_Flaregun_Spots"
			"GUN_TYPE_MAGNUM": thirdSprite = "s_Magnum_Spots"
			"GUN_TYPE_MACHINEPISTOL": thirdSprite = "s_Machpistol_Spots"
		
			"GUN_TYPE_SUBMACHINEGUN": thirdSprite = "s_Smg_Spots"
			"GUN_TYPE_HEAVYMACHINEGUN": thirdSprite = "s_HeavyMG_Spots"
			"GUN_TYPE_GATLINGGUN": thirdSprite = "s_GatlingGun_Spots"
			"GUN_TYPE_MINIGUN": thirdSprite = "s_Minigun_Spots"
			"GUN_TYPE_MITRAILLEUSE": thirdSprite = "s_Mitrailleuse_Spots"
		
			"GUN_TYPE_RIFLE": thirdSprite = "s_Rifle_Spots"
			"GUN_TYPE_MUSKET": thirdSprite = "s_Musket_Spots"
			"GUN_TYPE_HUNTINGRIFLE": thirdSprite = "s_HuntRifle_Spots"
			"GUN_TYPE_TRANQRIFLE": thirdSprite = "s_TranqGun_Spots"
			"GUN_TYPE_SNIPERRIFLE": thirdSprite = "s_Sniper_Spots"
			"GUN_TYPE_ASSAULTRIFLE": thirdSprite = "s_AssaultRifle_Spots"
		
			"GUN_TYPE_SHOTGUN": thirdSprite = "s_Shotgun_Spots"
			"GUN_TYPE_DOUBLESHOTGUN": thirdSprite = "s_SuperShot_Spots"
			"GUN_TYPE_REVOLVERSHOTGUN": thirdSprite = "s_RevShotgun_Spots"
			"GUN_TYPE_ELEPHANTGUN": thirdSprite = "s_Elephantgun_Spots"
		
			"GUN_TYPE_CROSSBOW": thirdSprite = "s_Crossbow_Spots"
			"GUN_TYPE_FLAMETHROWER": thirdSprite = "s_FlameGun_Spots"
			"GUN_TYPE_ROCKET": thirdSprite = "s_Rocket_Spots"
			"GUN_TYPE_BFG": thirdSprite = "s_Supergun_Spots"

	gun.weapon_stats.displayParts = displayParts
	gun.weapon_stats.displaySpots = displaySpots
	
	# Apply Gun decal colors #
	gun.weapon_stats.gunheldcol1 = gunheldcol1.to_html()
	gun.weapon_stats.gunheldcol2 = gunheldcol2.to_html()
	gun.weapon_stats.gunheldcol3 = gunheldcol3.to_html()

	# Apply Gun decal sprite #
	if secondSprite == "":
		gun.weapon_stats.gunHeldSprite2 = "";
	else:
		gun.weapon_stats.gunHeldSprite2 = "secondSprite"

	# Apply Gun decal sprite #
	if thirdSprite == "":
		gun.weapon_stats.gunHeldSprite3 = "";
	else:
		gun.weapon_stats.gunHeldSprite3 = "thirdSprite"

	# Apply some alpha multiplier #
	gun.weapon_stats.gunHeldSprite2Alpha = overlayAlpha;
