extends Resource
# @tutorial(https://www.youtube.com/watch?v=IdAmkx8eAos)
# scr_combat_weapons_applyType

## This is a direct copy of the scr_combat_weapons_applyType script. Cant think of a better way to deal with this.
# What a mess...

const c_white 		:= Color.WHITE
const c_yellow 		:= Color.YELLOW
const c_aqua		:= Color.AQUA
const c_green		:= Color.GREEN
const c_red			:= Color.RED

# Combat Settings
const ammoBooster = 0.25; 	# % boost to all ammo counts
const rateBooster = 0.5; 	# % boost of all gun's firing rate

static func apply_type( gun : B2_Weapon, type : B2_Gun.TYPE ) -> void:
	var guntype : String = B2_Gun.TYPE.keys()[type]
	
	gun.weapon_stats.speedBonus = 1.0; #1 is no bonus at all
	var _riflebonus = 1.5;
	var _pow = 1;
	var _pmx = 1;
	var _spd = 1;
	var _amm = 1;
	var _amb = 0;
	var _afx = 1;
	var _rng = 1;
	var _acc = 0;
	var _kbc = 1;
	var _stn = 0; ## Stagger value
	var _stnh = "STAGGER_HARDNESS_SOFT" ## Stagger hardness
	var _recoil = 0.3;
	var _pattern = "";
	var _bscale = 1;
	var _delayed = 0;

	gun.weapon_stats.swapSound = "hoopz_swapguns"
	gun.weapon_stats.bAdvanced = true; # All bullets are advanced so I can riccochet

	match guntype:
		"GUN_TYPE_PISTOL":
			#_pow = 0.75;
			_pow = 0.7; # - balanced for GoG Build - bhroom
			_pmx = 1.0;
			#_spd = 1.2;
			_spd = 1.0 # - balanced for Gog Build
			_amm = 1.7;
			_amb = 10;
			_afx = 1.2;
			_rng = 1.3;

			_kbc = 20;
			_stn = 50;

			_recoil = 0.5;

			_acc = 0;

			gun.weapon_stats.bAutomatic = false;

			gun.weapon_stats.gunHeldSprite = "s_Pistol"
			gun.weapon_stats.hudIconSprite = "s_hud_pistols"
			gun.weapon_stats.flashSprite = "s_Flash3"
			_bscale = 0.8

			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.5;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_hit";
			gun.weapon_stats.pChargeMax = 6;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_shotmissed";
			gun.weapon_stats.pChargeLossAmount = "la_loseOne";

			gun.weapon_stats.soundId = ("hoopzweap_pistol3");
			gun.weapon_stats.soundLoop = false;
			gun.weapon_stats.casingSound = "hoopz_shellcasing_light";

		"GUN_TYPE_FLINTLOCK":
			_pow = 0.8;
			#_pmx = 1.5;
			_pmx = 1.25; #numbing power down for GOG Build (6/6/15) - bhroom
			#_spd = 0.4;
			_spd = 0.65; # wilmer's first gun, so speeding up from 0.4 for GOG build (6/6/15) - bhroom
			_rng = 1;
			_amm = 1;
			_afx = 1.6;

			_kbc = 25;
			_stn = 100;

			_acc = 30;

			_delayed = 0.4;
			_pattern = "pt_flintlock";
			gun.weapon_stats.bAutomatic = false;

			gun.weapon_stats.gunHeldSprite = "s_Flintlock"
			gun.weapon_stats.hudIconSprite = "s_hud_flintlock"
			gun.weapon_stats.flashSprite = "s_Flash3"
			_bscale = 0.8

			gun.weapon_stats.bcasingSpd = 1;
			gun.weapon_stats.bcasingScale = 0.5;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_hit";
			gun.weapon_stats.pChargeMax = 3;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_shotmissed";
			gun.weapon_stats.pChargeLossAmount = "la_loseOne";

			gun.weapon_stats.soundId = ("hoopzweap_flintlock");
			gun.weapon_stats.soundLoop = false;


		"GUN_TYPE_FLAREGUN":
			_pow = 2;
			_pmx = 4;
			_spd = 0.25;
			_rng = 1.2;
			_amm = 0.3;
			_afx = 3;

			_kbc = 80;
			_stn = 200;
			_stnh = "STAGGER_HARDNESS_HARD"

			_recoil = 0.1;

			_acc = 0;

			_delayed = 0.2;

			gun.weapon_stats.bAutomatic = false;
			gun.weapon_stats.bLongTimeOut = true;

			gun.weapon_stats.gunHeldSprite = "s_FlareGun"
			gun.weapon_stats.hudIconSprite = "s_hud_flaregun"
			gun.weapon_stats.flashSprite = "s_Flash6"
			gun.weapon_stats.pBulletSprite = "s_flareshot"
			_bscale = 1;

			gun.weapon_stats.bcasingSpd = 1;
			gun.weapon_stats.bcasingScale = 0.7;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_enemyProximity"; # combat_gunwield_step
			gun.weapon_stats.pChargeMax = 40; #15;
			gun.weapon_stats.pChargeGainAmount = "ga_none";
			gun.weapon_stats.pChargeLoss = "cl_shot";
			gun.weapon_stats.pChargeLossAmount = "la_loseAll";

			gun.weapon_stats.bLobGravity = 2;#2;
			gun.weapon_stats.bRangeEndGrav = 1.5;#3; # combat_gunwield_shoot has code for flaregun
			gun.weapon_stats.bLobDirection = 70;
			gun.weapon_stats.bShadow = 8;

			gun.weapon_stats.bRoaming = 1;

			gun.weapon_stats.bSpeed = 10;
			gun.weapon_stats.bAccel = -0.20;
			gun.weapon_stats.bMinSpeed = 0.5;

			gun.weapon_stats.bExplodeOnWall = true;
			gun.weapon_stats.bExplodeOnEnemy = true;
			gun.weapon_stats.bExplodeOnGround = true;
			gun.weapon_stats.bExplodeOnTimeout = true;
			gun.weapon_stats.bExplode = "o_explosion_flaregun"
			gun.weapon_stats.bExplodeEffect = "flaregun"; # Nullified by dynamic size from bullet power
			gun.weapon_stats.bExplodeDamageMod = 1;
			gun.weapon_stats.bDealDamage = false; # Only explosion deals dmg, not bullet

			gun.weapon_stats.bTrail = "o_explEffect"
			gun.weapon_stats.bTrailExplosion = "s_flareshot"
			gun.weapon_stats.bTrailAcc = 0;
			gun.weapon_stats.bTrailAmount = 1;
			gun.weapon_stats.bTrailInterval = 4;

			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.bUseMoveOffset = false;
			gun.weapon_stats.bMagician = false;
			gun.weapon_stats.bSpiraling = 0;

			gun.weapon_stats.soundId = ("hoopzweap_flaregun");
			gun.weapon_stats.reloadSound = ("hoopz_click");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_medium";

			gun.weapon_stats.periodic_mutlishot = 1;#4;


		"GUN_TYPE_REVOLVER":
			_pow = 1.45;
			_pmx = 1.60;
			_spd = 0.8;
			_rng = 1.5;
			_amm = 1.3;
			_afx = 1.6;

			_kbc = 25;
			_stn = 100;
			_stnh = "STAGGER_HARDNESS_MEDIUM";

			_acc = 0;

			_recoil = 0.7;

			gun.weapon_stats.bAutomatic = false;

			gun.weapon_stats.gunHeldSprite = "s_Revolver"
			gun.weapon_stats.hudIconSprite = "s_hud_revolvers"
			gun.weapon_stats.flashSprite = "s_Flash6"
			_bscale = 1;

			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.7;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 6;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_revolver");
			gun.weapon_stats.reloadSound = ("hoopz_click");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_medium";

		"GUN_TYPE_MAGNUM":
			_pow = 1.6;
			_pmx = 1.8;
			_spd = 0.75;
			_rng = 1.7;
			_amm = 1.0;
			_afx = 1.6;

			_kbc = 30;
			_stn = 120;
			_stnh = "STAGGER_HARDNESS_MEDIUM";

			_acc = 0;

			_recoil = 0.8;

			gun.weapon_stats.bAutomatic = false;

			gun.weapon_stats.gunHeldSprite = "s_Magnum"
			gun.weapon_stats.hudIconSprite = "s_hud_magnum"
			gun.weapon_stats.flashSprite = "s_Flash6"
			_bscale = 1;

			gun.weapon_stats.bcasingSpd = 1;
			gun.weapon_stats.bcasingScale = 0.7;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 3;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_magnum");
			gun.weapon_stats.reloadSound = ("hoopz_click");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_medium";

		"GUN_TYPE_MACHINEPISTOL":
			_pow = 0.7;
			_pmx = 0.8;
			_spd = 1.5;
			_rng = 1.4;
			_amm = 2.5;
			_afx = 0.8;

			_kbc = 10;
			_stn = 40;
			_stnh = "STAGGER_HARDNESS_SOFT";

			_recoil = 0.2;

			_pattern = "pt_burst";
			gun.weapon_stats.bAutomatic = true;

			_acc = 15;
			gun.weapon_stats.gunHeldSprite = "s_Machpistol"
			gun.weapon_stats.hudIconSprite = "s_hud_machinepistol"
			gun.weapon_stats.flashSprite = "s_Flash2"
			_bscale = 0.6

			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.5;
			gun.weapon_stats.bcasingCol = c_aqua.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot_2xhit";
			gun.weapon_stats.pChargeMax = 18;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_pistol6");
			gun.weapon_stats.soundLoop = false;
			gun.weapon_stats.casingSound = "hoopz_shellcasing_light";



		"GUN_TYPE_SUBMACHINEGUN":
			_pow = 0.45;
			_pmx = 0.6;
			_spd = 1.4;
			_amm = 3;
			_amb = 15;
			_afx = 0.6;
			_rng = 1.1;

			_kbc = 10;
			_stn = 20;
			_stnh = "STAGGER_HARDNESS_SOFT";

			_recoil = 0.4;

			_acc = 20;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_Smg"
			gun.weapon_stats.hudIconSprite = "s_hud_smg"
			gun.weapon_stats.flashSprite = "s_Flash3"
			_bscale = 0.5;

			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.4;
			gun.weapon_stats.bcasingCol = c_white.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 18;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_smg");
			gun.weapon_stats.soundLoop = false;
			gun.weapon_stats.casingSound = "hoopz_shellcasing_light";

		"GUN_TYPE_HEAVYMACHINEGUN":
			_pow = 0.5;
			_pmx = 0.7;
			_spd = 1.6;
			_rng = 1.3;
			_amm = 2;
			_afx = 0.6;

			_kbc = 7;
			_stn = 30;
			_stnh = "STAGGER_HARDNESS_SOFT";

			_recoil = 0.4;

			_acc = 20;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_HeavyMg"
			gun.weapon_stats.hudIconSprite = "s_hud_heavymachinegun"
			gun.weapon_stats.flashSprite = "s_Flash3"
			_bscale = 0.5;

			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.4;
			gun.weapon_stats.bcasingCol = c_white.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 18;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_hmg");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_heavy";

		"GUN_TYPE_GATLINGGUN":
			_pow = 0.3;
			_pmx = 0.5;
			_spd = 3;
			_rng = 1.4;
			_amm = 5;
			_afx = 0.7;

			_kbc = 5;
			_stn = 10;
			_stnh = "STAGGER_HARDNESS_SOFT";

			_recoil = 0.15;

			_acc = 22;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_GatlingGun"
			gun.weapon_stats.hudIconSprite = "s_hud_gatlinggun"
			gun.weapon_stats.flashSprite = "s_Flash5"
			_bscale = 0.6;
			gun.weapon_stats.pWindUpSpeed = 24;

			gun.weapon_stats.bcasingSpd = 12;
			gun.weapon_stats.bcasingScale = 0.3;
			gun.weapon_stats.bcasingCol = c_white.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 60;
			gun.weapon_stats.pChargeGainAmount = "ga_gainAccum";
			gun.weapon_stats.pChargeIncAccum = 1.05;
			gun.weapon_stats.pChargeMaxAccum = 7;
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_minigun");
			match randi_range(0,4):
				2:
					gun.weapon_stats.windupSound = "sn_windup02"; #AGN()
					gun.weapon_stats.sustainSound = "sn_sustain02"; #AGN()
					gun.weapon_stats.winddownSound = "sn_winddown02"; #AGN()

				4:
					gun.weapon_stats.windupSound = "sn_windup04"; #AGN()
					gun.weapon_stats.sustainSound = "sn_sustain04"; #AGN()
					gun.weapon_stats.winddownSound = "sn_winddown04"; #AGN()

			#gun.weapon_stats.windupSound = #("hoopzweap_minig_windup");
			#gun.weapon_stats.sustainSound = #("hoopzweap_minig_sustain");
			#gun.weapon_stats.winddownSound = #("hoopzweap_minig_winddown");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_heavy";

		"GUN_TYPE_MINIGUN":
			_pow = 0.4;
			_pmx = 0.525;
			_spd = 2.5;
			_amm = 4;
			_amb = 20;
			_afx = 0.6;
			_rng = 1.5;

			_kbc = 5;
			_stn = 15;
			_stnh = "STAGGER_HARDNESS_SOFT";

			_recoil = 0.15;

			_acc = 20;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_Minigun"
			gun.weapon_stats.hudIconSprite = "s_hud_minigun"
			gun.weapon_stats.flashSprite = "s_Flash5"
			_bscale = 0.8;
			gun.weapon_stats.pWindUpSpeed = 12;

			gun.weapon_stats.bcasingSpd = 15;
			gun.weapon_stats.bcasingScale = 0.4;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 60;
			gun.weapon_stats.pChargeGainAmount = "ga_gainAccum";
			gun.weapon_stats.pChargeIncAccum = 1.1;
			gun.weapon_stats.pChargeMaxAccum = 12;
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_minigun");
			gun.weapon_stats.windupSound = "sn_windup06"; #AGN()
			gun.weapon_stats.sustainSound = "sn_sustain06"; #AGN()
			gun.weapon_stats.winddownSound = "sn_winddown06"; #AGN()
			#gun.weapon_stats.windupSound = ("hoopzweap_minig_windup");
			#gun.weapon_stats.sustainSound = ("hoopzweap_minig_sustain");
			#gun.weapon_stats.winddownSound = ("hoopzweap_minig_winddown");
			gun.weapon_stats.soundLoop = false;
			gun.weapon_stats.casingSound = "hoopz_shellcasing_heavy";

		"GUN_TYPE_MITRAILLEUSE":
			_pow = 0.2;
			_pmx = 0.3;
			_spd = 3.5;
			_rng = 1.1;
			_amm = 8;
			_afx = 0.4;

			_kbc = 5;
			_stn = 7;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.1;

			_acc = 25;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_Mitrailleuse"
			gun.weapon_stats.hudIconSprite = "s_hud_mitrailleuse"
			gun.weapon_stats.flashSprite = "s_Flash5"
			_bscale = 0.4;
			gun.weapon_stats.pWindUpSpeed = 36;

			gun.weapon_stats.bcasingSpd = 12;
			gun.weapon_stats.bcasingScale = 0.2;
			gun.weapon_stats.bcasingCol = c_white.to_html()

			gun.weapon_stats.pChargeGain = "cg_mitrailleuse";
			gun.weapon_stats.pChargeMax = 60;
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_minigun");
			gun.weapon_stats.windupSound = "sn_windup01"; #AGN()
			gun.weapon_stats.sustainSound = "sn_sustain01"; #AGN()
			gun.weapon_stats.winddownSound = "sn_winddown01"; #AGN()
			#gun.weapon_stats.windupSound = ("hoopzweap_minig_windup"));
			#gun.weapon_stats.sustainSound = ("hoopzweap_minig_sustain"));
			#gun.weapon_stats.winddownSound = ("hoopzweap_minig_winddown"));
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_heavy";

		"GUN_TYPE_ASSAULTRIFLE":
			_pow = 0.80;
			_pmx = 0.9;
			_spd = 1.1;
			_rng = 1.5;
			_amm = 2;
			_afx = 1.2;

			_kbc = 15;
			_stn = 50;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.3;

			_pattern = "pt_burst";
			_acc = 12;
			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.gunHeldSprite = "s_AssaultRifle"
			gun.weapon_stats.hudIconSprite = "s_hud_assaultrifle"
			gun.weapon_stats.flashSprite = "s_Flash4"
			_bscale = 0.7;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 6;
			gun.weapon_stats.bcasingScale = 0.5;
			gun.weapon_stats.bcasingCol = c_yellow.to_html()

			gun.weapon_stats.pChargeGain = "cg_hurt";
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 5;

			gun.weapon_stats.soundId = ("hoopzweap_assaultrifle");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_RIFLE":
			_pow = 1.3;
			_pmx = 1.5;
			#_spd = 0.6;
			_spd = 0.5; #balanced for GOG Build (6/6/15) - bhroom
			_amm = 0.8;
			_amb = 4;
			_afx = 1.3;
			_rng = 2.1;

			_kbc = 50;
			_stn = 100;
			_stnh = "STAGGER_HARDNESS_MEDIUM"

			_recoil = 0.2;

			_acc = 0;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_scope";
			gun.weapon_stats.gunHeldSprite = "s_Rifle"
			gun.weapon_stats.hudIconSprite = "s_hud_rifle"
			gun.weapon_stats.flashSprite = "s_Flash4"
			_bscale = 1;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 0.8;
			gun.weapon_stats.bcasingCol = c_green.to_html()

			gun.weapon_stats.pChargeGain = "cg_candy";
			gun.weapon_stats.pChargeGainAmount = "ga_gainAll";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 1;

			gun.weapon_stats.soundId = ("hoopzweap_rifle");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_MUSKET":
			_pow = 1.0;
			_pmx = 1.7;
			_spd = 0.35;
			_rng = 1.8;
			_amm = 0.7;
			_afx = 1.8;

			_kbc = 60;
			_stn = 120;
			_stnh = "STAGGER_HARDNESS_MEDIUM"

			_recoil = 0.2;

			_acc = 8;

			_delayed = 0.7;

			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_musket";
			gun.weapon_stats.gunHeldSprite = "s_Musket"
			gun.weapon_stats.hudIconSprite = "s_hud_musket"
			gun.weapon_stats.flashSprite = "s_Flash4"
			_bscale = 1;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 0.5;
			gun.weapon_stats.bcasingScale = 0.8;
			gun.weapon_stats.bcasingCol = c_green.to_html()

			gun.weapon_stats.pChargeGain = "cg_aim";
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_time";
			gun.weapon_stats.pChargeLossAmount = "la_loseOverTime";
			gun.weapon_stats.pChargeLossTime = 0.5;
			gun.weapon_stats.pChargeMax = 4;

			gun.weapon_stats.soundId = ("hoopzweap_musket");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_HUNTINGRIFLE":
			_pow = 1.1;
			_pmx = 1.1;
			#_spd = 1;
			_spd = 0.85; #balanced for GOG Build (6/6/15) - bhroom
			_rng = 2.95;
			_amm = 2;
			_afx = 1.5;

			_recoil = 0.2;

			_kbc = 60;
			_stn = 150;
			_stnh = "STAGGER_HARDNESS_MEDIUM"

			_acc = 0;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_scope";
			gun.weapon_stats.gunHeldSprite = "s_HuntRifle"
			gun.weapon_stats.hudIconSprite = "s_hud_huntingrifle"
			gun.weapon_stats.flashSprite = "s_Flash4"
			_bscale = 1.2;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_green.to_html()

			gun.weapon_stats.pChargeGain = "cg_nomove";
			gun.weapon_stats.pChargeGainAmount = "ga_gainTime";
			gun.weapon_stats.pChargeGainTime = 1;
			gun.weapon_stats.pChargeMax = 25;
			gun.weapon_stats.pChargeLoss = "cl_move";
			gun.weapon_stats.pChargeLossAmount = "la_loseOverTime";
			gun.weapon_stats.pChargeLossTime = 6;

			gun.weapon_stats.soundId = ("hoopzweap_huntingrifle");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_TRANQRIFLE":
			_pow = 0.1;
			_pmx = 0.3;
			_spd = 0.6;
			_rng = 2.5;
			_amm = 0.5;
			_afx = 2;

			_kbc = 0;
			_stn = 0;

			_recoil = 0;

			_acc = 0;

			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_scope";
			gun.weapon_stats.gunHeldSprite = "s_TranqRifle"
			gun.weapon_stats.hudIconSprite = "s_hud_tranqrifle"
			gun.weapon_stats.flashSprite = "";
			_bscale = 1.4;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_green.to_html()
			gun.weapon_stats.bcasing = "";

			gun.weapon_stats.pChargeGain = "cg_nomove_enemyProximity";
			gun.weapon_stats.pChargeGainAmount = "ga_gainTime";
			gun.weapon_stats.pChargeGainTime = 1;
			gun.weapon_stats.pChargeMax = 20;
			gun.weapon_stats.pChargeLoss = "cl_move";
			gun.weapon_stats.pChargeLossAmount = "la_loseOverTime";
			gun.weapon_stats.pChargeLossTime = 6;

			gun.weapon_stats.soundId = ("hoopzweap_tranqrifle");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_SNIPERRIFLE":
			_pow = 2.0;
			_pmx = 2.0;
			_spd = 0.4;
			_rng = 3.5;
			_amm = 0.4;
			_afx = 1.5;

			_kbc = 75;
			_stn = 150;
			_stnh = "STAGGER_HARDNESS_MEDIUM"

			_recoil = 0.2;

			_acc = 0;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_scope";
			gun.weapon_stats.gunHeldSprite = "s_Sniper"
			gun.weapon_stats.hudIconSprite = "s_hud_sniper"
			gun.weapon_stats.flashSprite = "s_Flash4"
			_bscale = 1.4;

			gun.weapon_stats.speedBonus = _riflebonus; #Doubles shot speed
			#maxspd *= _riflebonus;
			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_green.to_html()

			gun.weapon_stats.pChargeGain = "cg_heartbeat";
			gun.weapon_stats.pChargeMax = 1;
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.soundId = ("hoopzweap_sniperrifle");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_large";

		"GUN_TYPE_SHOTGUN":
			_pow = 1.3;
			_pmx = 1.4;
			#_spd = 0.5;
			_spd = 0.4; # - balanced for GOG (6/6/15)-bhroom
			_amm = 0.6;
			_amb = 3;
			_afx = 1;
			_rng = 0.7;

			_kbc = 10;
			_stn = 20;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.3;

			_acc = 12;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_spread";
			gun.weapon_stats.gunHeldSprite = "s_Shotgun"
			gun.weapon_stats.hudIconSprite = "s_hud_shotgun"
			gun.weapon_stats.flashSprite = "s_Flash"
			_bscale = 0.7;

			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_red.to_html()

			gun.weapon_stats.pChargeGain = "cg_damage";
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 22;

			gun.weapon_stats.soundId = ("hoopzweap_shotgun");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.periodic_mutlishot = 8;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_shell";

		"GUN_TYPE_DOUBLESHOTGUN":
			_pow = 1.6;
			_pmx = 1.7;
			#_spd = 0.30;
			_spd = 0.25; #balanced for GOG (6/6/15)- bhroom
			_rng = 0.65;
			_amm = 0.7;
			_afx = 1;

			_kbc = 15;
			_stn = 20;
			_stnh = "STAGGER_HARDNESS_MEDIUM"

			_recoil = 0.5;

			_acc = 12;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_doublespread";
			gun.weapon_stats.gunHeldSprite = "s_DoubleShotgun"
			gun.weapon_stats.hudIconSprite = "s_hud_doubleshotgun"
			gun.weapon_stats.flashSprite = "s_Flash"
			_bscale = 0.7;

			gun.weapon_stats.bcasingSpd = 3;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_red.to_html()

			gun.weapon_stats.pChargeGain = "cg_damage";
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 44;

			gun.weapon_stats.soundId = ("hoopzweap_doublebarreledshotgun");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.periodic_mutlishot = 12;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_shell";

		"GUN_TYPE_REVOLVERSHOTGUN":
			_pow = 0.8;
			_pmx = 1.2;
			_spd = 0.8;
			_rng = 0.5;
			_amm = 1;
			_afx = 1;

			_kbc = 10;
			_stn = 20;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.3;

			_acc = 20;
			gun.weapon_stats.bAutomatic = true;

			_pattern = "pt_spread";
			gun.weapon_stats.gunHeldSprite = "s_RevShotgun"
			gun.weapon_stats.hudIconSprite = "s_hud_revshotgun"
			gun.weapon_stats.flashSprite = "s_Flash"
			_bscale = 0.7;

			gun.weapon_stats.bcasingSpd = 0.5;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_red.to_html()

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeGainAmount = "ga_gainOne";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 6;

			gun.weapon_stats.soundId = ("hoopzweap_revolvershotgun");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.periodic_mutlishot = 6;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_shell";

		"GUN_TYPE_ELEPHANTGUN":
			_pow = 1.6;
			_pmx = 1.8;
			_spd = 0.35;
			_rng = 1.8;
			_amm = 0.4;
			_afx = 1.6;

			_kbc = 90;
			_stn = 200;
			_stnh = "STAGGER_HARDNESS_HARD"

			_recoil = 0.2;

			_acc = 0;
			gun.weapon_stats.bAutomatic = false;

			_pattern = "pt_scopespread";
			gun.weapon_stats.gunHeldSprite = "s_ElephantGun"
			gun.weapon_stats.hudIconSprite = "s_hud_elephantgun"
			gun.weapon_stats.flashSprite = "s_Flash"
			_bscale = 1.2;

			gun.weapon_stats.bcasingSpd = 0.5;
			gun.weapon_stats.bcasingScale = 1;
			gun.weapon_stats.bcasingCol = c_green.to_html()

			gun.weapon_stats.pChargeGain = "cg_kill";
			gun.weapon_stats.pChargeGainAmount = "ga_gainAll";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 1;

			gun.weapon_stats.soundId = ("hoopzweap_elephantgun");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.periodic_mutlishot = 5;

			gun.weapon_stats.casingSound = "hoopz_shellcasing_shell";

		"GUN_TYPE_FLAMETHROWER":
			# In addition to damage per bullet, flamethrower also deals (5 * bullet damage) in DoT
			# after you stop shooting the enemy, thanks to Burning.
			# Both _pow and _pmx must be the same or damage might behave unexpectedly for flamethrower.
			_pow = 0.2;
			_pmx = 0.2;

			_spd = 2.5;
			_rng = 1; # This has no effect for flamethrower, see bSpeed and bAccel below instead
			_amm = 5;
			_afx = 0.5;

			_kbc = 0;
			_stn = 0;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.0;

			_acc = 30;

			gun.weapon_stats.bAutomatic = true;

			gun.weapon_stats.pWindUpSpeed = 60;

			gun.weapon_stats.gunHeldSprite = "s_Flamethrower_Gun"
			gun.weapon_stats.hudIconSprite = "s_hud_flamethrower"
			gun.weapon_stats.flashSprite = "";

			gun.weapon_stats.bcasing = "";

			gun.weapon_stats.bSpeed = 30;
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.bAccel = -4;
			gun.weapon_stats.bRangeEndGrav = 0;

			gun.weapon_stats.bDistanceLife = -1;
			gun.weapon_stats.bTimeLife = 7;

			gun.weapon_stats.pChargeGain = "cg_shot";
			gun.weapon_stats.pChargeMax = 60;
			gun.weapon_stats.pChargeGainAmount = "ga_gainAmmoLevel";
			gun.weapon_stats.pChargeGainAmmoMax = 1;
			gun.weapon_stats.pChargeGainAmmoMin = 12;
			gun.weapon_stats.pChargeLoss = "cl_none";

			gun.weapon_stats.bAdvanced = true;
			gun.weapon_stats.pBulletSprite = "s_bull_flamethrower"
			gun.weapon_stats.bShowHiteffect = false;
			gun.weapon_stats.bNoDestroyOnHit = true;

			gun.weapon_stats.constantSound = "hoopzweap_flamethrower_gas";
			gun.weapon_stats.triggerSound = "hoopzweap_flamethrower_trigger";
			gun.weapon_stats.windupSound = "hoopzweap_flamethrower_attack";
			gun.weapon_stats.sustainSound = "hoopzweap_flamethrower_sustain";
			gun.weapon_stats.winddownSound = "hoopzweap_flamethrower_release";
			gun.weapon_stats.soundLoop = false;

		"GUN_TYPE_CROSSBOW":
			_pow = 0.8;
			_pmx = 1.2;
			_spd = 0.3;
			_rng = 2;
			_amm = 0.3;
			_afx = 1;

			_kbc = 10;
			_stn = 40;
			_stnh = "STAGGER_HARDNESS_SOFT"

			_recoil = 0.2;

			_acc = 0;
			gun.weapon_stats.bAutomatic = false;

			_delayed = 0.05;

			gun.weapon_stats.gunHeldSprite = "s_Crossbow_Gun"
			gun.weapon_stats.hudIconSprite = "s_hud_crossbow"
			gun.weapon_stats.flashSprite = "";
			_bscale = 1;
			gun.weapon_stats.pBulletSprite = "s_bull_arrowHead"
			gun.weapon_stats.bcasing = "";

			gun.weapon_stats.pChargeGain = "cg_full";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 1;

			gun.weapon_stats.soundId = ("hoopzweap_crossbow");
			gun.weapon_stats.reloadSound = ("hoopz_reloadcrossbow");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.periodic_mutlishot = 1;

		"GUN_TYPE_ROCKET":
			_pow = 2;
			_pmx = 2.4;
			_spd = 0.2;
			_rng = 2.4;
			_amm = 0.3;
			_afx = 1.5;

			_kbc = 100;
			_stn = 200;
			_stnh = "STAGGER_HARDNESS_HARD"

			_recoil = 0.2;
			_acc = 0;

			_delayed = 0.1;

			gun.weapon_stats.bSpeed *= .30;
			gun.weapon_stats.bMinSpeed = 2;
			gun.weapon_stats.bAccel = 1;

			gun.weapon_stats.bAutomatic = false;
			gun.weapon_stats.bAdvanced = true;

			gun.weapon_stats.gunHeldSprite = "s_Rocket"
			gun.weapon_stats.hudIconSprite = "s_hud_rocket"
			gun.weapon_stats.flashSprite = "s_Flash"
			_bscale = 1;

			gun.weapon_stats.bcasing = "";

			gun.weapon_stats.pChargeGain = "cg_loaded";
			gun.weapon_stats.pChargeGainAmount = "ga_gainTime";
			gun.weapon_stats.pChargeMax = 30;
			gun.weapon_stats.pChargeLoss = "cl_shot";
			gun.weapon_stats.pChargeLossAmount = "la_loseAll";

			gun.weapon_stats.soundId = ("hoopzweap_rocket_shot");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;
			gun.weapon_stats.pBulletSprite = "s_bull_rocket"
			gun.weapon_stats.casingSound = "hoopz_shellcasing_shell";

			gun.weapon_stats.bTrail = "o_explEffect"
			gun.weapon_stats.bTrailExplosion = "s_pixel" #effect_itanosmoke);
			gun.weapon_stats.bTrailAcc = 0;
			gun.weapon_stats.bTrailAmount = 1;
			gun.weapon_stats.bTrailInterval = 2;

			gun.weapon_stats.bExplodeOnWall = true;
			gun.weapon_stats.bExplodeOnEnemy = true;
			gun.weapon_stats.bExplodeOnEnemyProx = false;
			gun.weapon_stats.bExplodeOnGround = true;
			gun.weapon_stats.bExplodeOnTimeout = true;
			gun.weapon_stats.bDealDamage = true;

			gun.weapon_stats.bExplode = "o_explosion_rocket"
			gun.weapon_stats.bExplodeEffect = "rocket"; # Nullified by variable explosion from bullet power
			gun.weapon_stats.bExplodeDamageMod = 0.8;

			gun.weapon_stats.bUseMoveOffset = false;

		"GUN_TYPE_BFG":
			_pow = 2.0;
			_pmx = 1.8;
			_spd = 0.1;
			_rng = 3.0;
			_amm = 0.4;
			_afx = 1.6;

			_kbc = 50;
			_stn = 400;
			_stnh = "STAGGER_HARDNESS_HARD";

			_recoil = 0.2;
			_delayed = 0.3;

			_acc = 6;

			gun.weapon_stats.bAutomatic = false;

			gun.weapon_stats.gunHeldSprite = "s_BFG"
			gun.weapon_stats.hudIconSprite = "s_hud_bfg"
			gun.weapon_stats.flashSprite = "s_Flash_BFG"
			_bscale = 0.6;

			gun.weapon_stats.bcasing = "";

			gun.weapon_stats.bSpeed = 12;
			gun.weapon_stats.bMinSpeed = 1;

			gun.weapon_stats.pChargeGain = "cg_none";
			gun.weapon_stats.pChargeLoss = "cl_none";
			gun.weapon_stats.pChargeMax = 1;

			gun.weapon_stats.soundId = ("hoopzweap_elephantgun");
			gun.weapon_stats.reloadSound = ("hoopz_reload");
			gun.weapon_stats.soundLoop = false;

			gun.weapon_stats.pBulletSprite = "s_bull_bfg"
		_:
			## Invalid type
			breakpoint

	if _pattern != "":
		gun.weapon_stats.pPattern		= _pattern

	gun.weapon_stats.pShotDelay = _delayed;

	gun.weapon_stats.pPowerMod *= _pow;
	gun.weapon_stats.pPowerMaxMod *= _pmx;
	gun.weapon_stats.pSpeedMod = gun.weapon_stats.pSpeedMod*( _spd + ( _spd * rateBooster) ) # added rate booster, in Settings()

	gun.weapon_stats.sRange = 40*_rng;

	gun.weapon_stats.pAmmoMod *= (_amm + (_amm * ammoBooster ) ); # added ammo booster
	gun.weapon_stats.pAffixMod *= _afx;
	gun.weapon_stats.pAmmoBase = _amb;

	gun.weapon_stats.pWeightMod *= scr_combat_weapons_getTypeWeight(guntype);

	gun.weapon_stats.bulscale *= _bscale;

	gun.weapon_stats.pAccuracy = _acc;

	gun.weapon_stats.pKnockback = _kbc;
	gun.weapon_stats.pStagger = _stn;
	gun.weapon_stats.pStaggerHardness = _stnh;

	gun.weapon_stats.pRecoil = _recoil;

## AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA WHAT THE FUUUUUUUCK!!!
static func scr_combat_weapons_getTypeWeight( type ) -> float:
	if type == "GUN_TYPE_FLINTLOCK":       return 0.750;
	if type == "GUN_TYPE_PISTOL":          return 0.781;
	if type == "GUN_TYPE_MUSKET":          return 0.813;
	if type == "GUN_TYPE_FLAREGUN":        return 0.844;
	if type == "GUN_TYPE_MACHINEPISTOL":   return 0.875;
	if type == "GUN_TYPE_REVOLVER":        return 0.906;
	if type == "GUN_TYPE_SUBMACHINEGUN":   return 0.938;
	if type == "GUN_TYPE_CROSSBOW":        return 0.969;
	if type == "GUN_TYPE_RIFLE":           return 1.000;
	if type == "GUN_TYPE_ASSAULTRIFLE":    return 1.063;
	if type == "GUN_TYPE_TRANQRIFLE":      return 1.125;
	if type == "GUN_TYPE_HEAVYMACHINEGUN": return 1.188;
	if type == "GUN_TYPE_SHOTGUN":         return 1.250;
	if type == "GUN_TYPE_HUNTINGRIFLE":    return 1.313;
	if type == "GUN_TYPE_SNIPERRIFLE":     return 1.375;
	if type == "GUN_TYPE_MAGNUM":          return 1.438;
	if type == "GUN_TYPE_ELEPHANTGUN":     return 1.500;
	if type == "GUN_TYPE_DOUBLESHOTGUN":   return 1.563;
	if type == "GUN_TYPE_FLAMETHROWER":    return 1.625;
	if type == "GUN_TYPE_REVOLVERSHOTGUN": return 1.688;
	if type == "GUN_TYPE_ROCKET":          return 1.750;
	if type == "GUN_TYPE_GATLINGGUN":      return 1.813;
	if type == "GUN_TYPE_MINIGUN":         return 1.875;
	if type == "GUN_TYPE_MITRAILLEUSE":    return 1.938;
	if type == "GUN_TYPE_BFG":             return 2.000;

	return 1;
