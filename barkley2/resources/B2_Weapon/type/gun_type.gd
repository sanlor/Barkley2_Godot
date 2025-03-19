extends Resource
class_name B2_WeaponType


#@export var type			:= TYPE.GUN_TYPE_PISTOL
@export var speedBonus		:= 1.0
@export var _riflebonus 	:= 1.5
@export var _pow 			:= 1.0
@export var _pmx 			:= 1.0
@export var _spd 			:= 1.0
@export var _amm 			:= 1.0
@export var _amb 			:= 0.0
@export var _afx 			:= 1.0
@export var _rng 			:= 1.0
@export var _acc 			:= 0.0
@export var _kbc 			:= 1.0
@export var _stn 			:= 0.0
@export var _stnh 			:= "STAGGER_HARDNESS_SOFT"
@export var _recoil 		:= 0.3
@export var _pattern 		:= ""
@export var _bscale 		:= 1.0
@export var _delayed 		:= 0.0
@export var swapSound		:= "hoopz_swapguns"
@export var bAdvanced		:= true


@export var gunHeldSprite : String
@export var hudIconSprite : String
@export var flashSprite : String
@export var bcasingSpd : String
@export var bcasingScale : String
@export var bcasingCol : String
@export var pChargeGain : String
@export var pChargeMax : String
@export var pChargeGainAmount : String
@export var pChargeLoss : String
@export var pChargeLossAmount : String
@export var soundId : String
@export var soundLoop : String
@export var casingSound : String
@export var bLongTimeOut : String
@export var pBulletSprite : String
@export var bLobGravity : String
@export var bRangeEndGrav : String
@export var bLobDirection : String
@export var bShadow : String
@export var bRoaming : String
@export var bExplodeOnWall : String
@export var bExplodeOnEnemy : String
@export var bExplodeOnGround : String
@export var bExplodeOnTimeout : String
@export var bExplode : String
@export var bExplodeEffect : String
@export var bExplodeDamageMod : String
@export var bDealDamage : String
@export var bTrail : String
@export var bTrailExplosion : String
@export var bTrailAcc : String
@export var bTrailAmount : String
@export var bTrailInterval : String
@export var bUseMoveOffset : String
@export var bMagician : String
@export var bSpiraling : String
@export var reloadSound : String
@export var periodic_mutlishot : String
@export var pWindUpSpeed : String
@export var pChargeIncAccum : String
@export var pChargeMaxAccum : String
@export var windupSound : String
@export var sustainSound : String
@export var winddownSound : String
@export var pChargeLossTime : String
@export var pChargeGainTime : String
@export var bcasing : String
@export var bTimeLife : String
@export var pChargeGainAmmoMax : String
@export var pChargeGainAmmoMin : String
@export var bNoDestroyOnHit : String
@export var constantSound : String
@export var triggerSound : String
@export var bExplodeOnEnemyProx : String

## NOTE What a mess.
# Its hard to manage weapons like this. The way that B2 handles weapon modifiers, effects and special behaviours isnt very good.
# Im having a hard time trying to port the behaviour to this version.

## TODO Figure this shit out.

## scr_combat_weapons_resetStats
# Stats used directly for the weapon behavior. Built from the weapon stats, ratios and affixes.
#@export var pPattern 		= "pt_norm" 	# basic pattern of shooting
#@export var pSpreadAmount 	= 0; 			# angle of shooting spread, in degrees. Low accuracy means the bullets are less predictable in the spread.
#@export var pShots 			= 1; 			# maximum number of shots fired at a time. They are evenly distributed on the spread amount. If more than one shot is fired, they have a random start position.
									## So that the individual shots appear separate and arnt all just one blob of superposed shots if accuracy is high.
#@export var pExtraChance = 0;		# chance to fire extra bullets
#@export var pExtraNumber = 0;		# max extra bullets fired upon chance
#@export var pBurstAmount = 1; 		# Number of times shots are fired in a row in bursts automatically.
#@export var pBurstInterval = 6; 	# Interval between shots during a burst. Supercedes fire interval, which is the time BETWEEN bursts. On weapons permitting it, it is a
								## RATIO of the actual firing interval.
#@export var pAmmoCost = 1;
#@export var pDamageMin = 10;
#@export var pDamageRand = 2;
#@export var pAccuracy = 1;
#@export var bAimAjarMin = 0;
#@export var bAimAjarMax = 0;
#@export var pRange = 1;
#@export var pFireSpeed = 0;
#@export var pFireDelay = 0;
#@export var pAimMod = 0;
#@export var pAffix = 0;
#
### balanced! adjuster to 300 for GoG (6/6/15) - bhroom
#@export var pFireTimer = 300;
#@export var pFireTimerTarget = 300;
#
#@export var pCurAmmo = 0;
#@export var pMaxAmmo = 0;
#@export var pWeight = 0;
#@export var pRatioAmmo = 1;
#
## /properties passed on to the bullets
## MOVEMENT PATTERNS
#@export var bType = "b_norm"; 	# bullet type. Sets some default values on the bullets. Can be a shorthand for weapon types or element types that have specific defaults
								## some affixes or weapon types may just manually modify individual values tho.
#
## the following values are the NORMAL bullet defaults.
## FOLLOWING NUMBERS ARE THE SIMPLE BULLET STATS.
#@export var bDistanceLife = 30; 	# distance the bullet travels before destroying itself.
#
#@export var bSpeed = 56;		# initial speed the bullet travels at every step. I feel 56 is a good starting point! Bhroom
#@export var bAccel = 0; 		# bullet acceleration at every step (or deceleration)
#@export var bMaxSpeed = 86; 	# doubled from 48 (after Bisse's bullet code fix 120414)
#@export var bMinSpeed = 24; 	# doubled as well
#
#@export var damageRatio = 1;
#
#@export var bAutomatic = false;
#@export var bShowHiteffect = true;
#
## FOLLOWING NUMBERS ARE ADVANCED BULLET STATS ONLY.
#@export var bEnemySeek = 0;# speed of turning to find enemy. negative value means it avoids enemies.
#@export var bEnemyTarget = noone; # target of the seeking. -1 to find nearest enemy, or put an instance ID there to seek specific enemy (ex, enemy clicked)
#@export var bEnemySeekRange = 96; # minimum distance from enemy for seeking to occur.
#@export var bEnemySeekTime = 1; # time before bullet starts seeking. 0 means immediate seek.
#@export var bEnemySeekAccel = 0; #  Acceleration added when bullet finds enemy to seek.
#
#@export var bBarrierDist = 0;
#@export var bBarrierRotSpd = 0;
#@export var bBarrierRotCount = 0;
#
#@export var bReturning = false;# slows down and reverses speed at the end of distance
#@export var bTurning = 0; # direction the bullet turns to every step.
#@export var bWave = 0		# choose(10,20,30,40); # bullet moves in a wave pattern. number is size of the wave.
#@export var bWaveAmp = 0	# choose(10,20,30,40,50,60,70,80); #  0.25-0.5-0.75-1-2-3
#@export var bThroughWalls = 0; # bullet moves through solids
#@export var bEnemyPierce = 0; # Bullet keeps going after piercing enemy
#@export var bWallRicochet = 0; # amount of times a bullet will bounce off walls
#@export var bEnemyRicochet = 0; # amount of times a bullet will bounce of enemies
#@export var bRicochetRandom = false # choose(true,false); //bounce direction will be random instead of based on collision direction
#@export var bEnemyChain = 0;
#@export var bEnemyChainRange = 96;
#@export var bProximity = false;

#@export var bSpiraling = false;
#@export var bAmmoChange = 0;
#@export var bAmmoChangeTimer = 0;
#
#@export var bDealDamage = true; #  Set to false and the main bullet will not deal damage (but explosions,affixes,e.g. will)
#
#@export var bShadow = 0; # bullet will cast a round shadow if that size on the ground. 0 for no shadow.
#
#@export var bTrailAcc = 8;  # random shift of trail explosion away from bullet
#@export var bTrailAmount = 2; # number of trail explosions to create per interval
#@export var bTrailInterval = 4; # pixel interval the bullet leaves a trail behind
#@export var bTrailElement = "phys"; # damage type of the trail
#@export var bTrailExplosion = sprite_get_name(s_FireTrail);
#
#@export var bLobEqualsRange = false; # calculates the shot angle so it hits the floor at the end of the range
#@export var bLobDirection = 0; # bullet will seem like it is travelling in a lob-like trajectory.
#@export var bLobBounce = 0.8; # bounce power the bullet has if in a lob.
#@export var bLobBounceCount = 0; # number of bounces before the bullet crashes
#@export var bLobGravity = 0; # gravity effect on the bullet
#@export var bExplodeEffect = NULL; # explosion effect bullet spawns on impact
#@export var bExplodeOnGround = false; # object will explode when hitting the ground when out of bounces
#@export var bExplodeOnTimeout = false; # object will explode when projectile times out.
#@export var bExplodeOnWall = false; # object will explode if it hits a wall after being out of ricochets.
#@export var bExplodeOnEnemy = false; # object will explode if it hits an enemy after being out of enemy bounces.
#@export var bExplodeOnEnemyProx = -1; # object will explode if an enemy is within range. -1 means ignore range.
#
#@export var bExplodeDamage = 40;
#@export var bExplodeElement = "phys";
#@export var bExplosion = sprite_get_name(s_MBlast);
#
### Sounds
#@export var reloaded = false;
#@export var soundId = NULL_STRING;
#@export var constantSound = NULL_STRING;
#@export var triggerSound = NULL_STRING;
#@export var windupSound = NULL_STRING;
#@export var sustainSound = NULL_STRING;
#@export var winddownSound = NULL_STRING;
#@export var reloadSound = NULL_STRING;
#@export var swapSound = NULL_STRING;
#@export var pickupSound = NULL_STRING;
#@export var casingSound = NULL_STRING;
#@export var emptySound = NULL_STRING;
