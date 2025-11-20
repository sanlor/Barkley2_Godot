extends Resource
class_name B2_WeaponStats
## Class to hold Weapon data.
# Should be similar to the gun[?, "example dictionary from the original game.
# check scr_combat_weapons_resetStats

## Charge variables
@export var pChargeGain 			= "cg_shot";
@export var pChargeGainAmount 		= "ga_gainOne";
@export var pChargeLoss 			= "cl_none";
@export var pChargeLossAmount 		= "la_loseOne";

@export var pChargeMax 				= 6;
@export var pChargeCur 				= 0;
@export var pChargeRatio 			= 0;
@export var pChargeEffect 			= "";

@export var pChargeAccum 			= 1;
@export var pChargeIncAccum 		= 1.05;
@export var pChargeMaxAccum 		= 6;
@export var pChargeLossAccum 		= 1;
@export var pChargeGainAmmoMax 		= 1;
@export var pChargeGainAmmoMin 		= 12;
@export var pChargeGainTime			= 1;

@export var pChargeGainVar 			= 0;
@export var pChargeLossVar 			= 0;

@export var pChargeShot 			= 0;
@export var pChargeDamage 			= 0;
@export var pChargeHurt 			= 0;
@export var pChargeHits 			= 0;
@export var pChargeKilled 			= 0;
@export var pChargeKilledPow 		= 0;
@export var pChargeMissed 			= 0;
@export var pChargeCandy 			= 0;

## Sprites
@export var gunHeldSprite 			= "s_Pistol"
@export var hudIconSprite 			= "s_hud_pistols"
@export var hudIconFrame 			= 0;
@export var flashSprite 			= "s_Flash"
@export var pBulletColor 			= Color.WHITE
@export var pBulletScale 			= 1;
@export var pBulletSprite 			= "s_bull"
@export var pBulletBurst 			= "s_ricochet"

@export var col 					= Color.WHITE; ####blend color of gun sprite in the hud
@export var gunheldcol 				= Color.WHITE; ####blend color of gun held in hoopz hands
@export var bulscale 				= 1;

## Bullet casings
@export var readyCasing 			= 0;
@export var bcasing 				= "s_casing"
@export var bcasingDir 				= 240;
@export var bcasingSpd 				= 12;
@export var bcasingRot 				= 30;
@export var bcasingSpin 			= 60;
@export var bcasingHeight 			= -16;
@export var bcasingVertSpd 			= -12;
@export var bcasingScale 			= 0.5;
@export var bcasingCol 				= Color.YELLOW;

####Position into gunspace
@export var pGunspaceX 				= 0;
@export var pGunspaceY 				= 0;

@export var pBurstSpeed 			= 0;

####stat ratios. Modified by weapon material, type and affixes.
@export var pPowerMod 				= 1;
@export var pPowerMaxMod 			= 1;
@export var pSpeedMod 				= 1;
@export var pRangeMod 				= 1;
@export var pAmmoMod 				= 1;
@export var pAmmoBase 				= 0;

@export var pAccMod 				= 1;

@export var pWeightMod 				= 1;
@export var pAffixMod 				= 1;

@export var pKnockback 				= 0;
@export var pStagger 				= 1;
@export var pRecoil 				= 0.3;

####Stats used directly for the weapon behavior. Built from the weapon stats, ratios and affixes.
@export var pPattern 				= "pt_norm" ##/basic pattern of shooting

@export var pSpreadAmount 			= 0; 	# angle of shooting spread, in degrees. Low accuracy means the bullets are less predictable in the spread.
@export var pShots 					= 1; 	# maximum number of shots fired at a time. They are evenly distributed on the spread amount. If more than one shot is fired, they have a random start position.
											# So that the individual shots appear separate and arnt all just one blob of superposed shots if accuracy is high.
@export var pExtraChance 			= 0; 	# chance to fire extra bullets
@export var pExtraNumber 			= 0;	# max extra bullets fired upon chance
@export var pBurstAmount 			= 1; 	# Number of times shots are fired in a row in bursts automatically.
@export var pBurstInterval 			= 6; 	# Interval between shots during a burst. Supercedes fire interval, which is the time BETWEEN bursts. On weapons permitting it, it is a
											# RATIO of the actual firing interval.
@export var pAmmoCost 				= 1;
@export var pDamageMin 				= 10;
@export var pDamageRand 			= 2;
@export var pAccuracy 				= 1;
@export var bAimAjarMin 			= 0;
@export var bAimAjarMax 			= 0;
@export var pRange 					= 1;
@export var pFireSpeed 				= 0;
@export var pFireDelay 				= 0;
@export var pAimMod 				= 0;
@export var bRangeEndGrav 			= 7;
@export var pAffix 					= 0;

@export var pWindUp 				= 0;
@export var pWindUpSpeed 			= 0;

# balanced! adjuster to 300 for GoG (6/6/15) - bhroom
@export var pFireTimer 				= 300;
@export var pFireTimerTarget 		= 300;

@export var pCurAmmo 				= 0;
@export var pMaxAmmo 				= 0;
@export var pWeight 				= 0;
@export var pRatioAmmo 				= 1;

## properties passed on to the bullets
## MOVEMENT PATTERNS
@export var bType 				= "b_norm"; # bullet type. Sets some default values on the bullets. Can be a shorthand for weapon types or element types that have specific defaults
											# some affixes or weapon types may just manually modify individual values tho.

## the following values are the NORMAL bullet defaults.
## FOLLOWING NUMBERS ARE THE SIMPLE BULLET STATS.
@export var bLongTimeOut 		= false;
@export var bDistanceLife 		= 30; ##/distance the bullet travels before destroying itself.
@export var bTimeLife 			= -1; ##/number of steps before the bullet destroys itself

@export var bSpeed 				= 56;## initial speed the bullet travels at every step. I feel 56 is a good starting point! Bhroom
@export var bAccel 				= 0; ##/bullet acceleration at every step (or deceleration)
@export var bMaxSpeed 			= 86; ##doubled from 48 (after Bisse's bullet code fix 120414)
@export var bMinSpeed 			= 24; ##doubled as well

@export var damageRatio 		= 1;

@export var bAutomatic 			= false;
@export var bShowHiteffect 		= true;

@export var bAdvanced 			= false; 	## set this to true so the weapon creates the proper bullet type if handling a more advanced bullet.
											## FOLLOWING NUMBERS ARE ADVANCED BULLET STATS ONLY.
@export var bEnemySeek 			= 0;		## speed of turning to find enemy. negative value means it avoids enemies.
@export var bEnemyTarget 		= null; 	## target of the seeking. -1 to find nearest enemy, or put an instance ID there to seek specific enemy (ex, enemy clicked)
@export var bEnemySeekRange 	= 96; 		## minimum distance from enemy for seeking to occur.
@export var bEnemySeekTime 		= 1; 		## time before bullet starts seeking. 0 means immediate seek.
@export var bEnemySeekAccel 	= 0; 		## Acceleration added when bullet finds enemy to seek.

@export var bBarrierDist 		= 0;
@export var bBarrierRotSpd 		= 0;
@export var bBarrierRotCount 	= 0;

@export var bReturning 			= false;	## slows down and reverses speed at the end of distance
@export var bTurning 			= 0; 		## direction the bullet turns to every step.
@export var bRoaming 			= 0; 		## random amount of direction the bullet turns every step
@export var bWave 				= 0			## choose(10,20,30,40); ## bullet moves in a wave pattern. number is size of the wave.
@export var bWaveAmp 			= 0			## choose(10,20,30,40,50,60,70,80); ##  0.25-0.5-0.75-1-2-3
@export var bThroughWalls 		= 0; 		## bullet moves through solids
@export var bEnemyPierce 		= 0; 		## Bullet keeps going after piercing enemy
@export var bNoDestroyOnHit		= false; 	## Bullet is never destroyed on hit
@export var bWallRicochet 		= 0; 		## amount of times a bullet will bounce off walls
@export var bEnemyRicochet 		= 0; 		## amount of times a bullet will bounce of enemies
@export var bMagician 			= 0;
@export var bRicochetRandom 	= true; 	## bounce direction will be random instead of based on collision direction
@export var bEnemyChain 		= 0;
@export var bEnemyChainRange 	= 96;
@export var bProximity 			= false;

@export var bSpiraling 			= false;
@export var bAmmoChange 		= 0;
@export var bAmmoChangeTimer 	= 0;

@export var bDealDamage 		= true;		## Set to false and the main bullet will not deal damage (but explosions,affixes,e.g. will)

@export var bShadow 			= 0; 		## bullet will cast a round shadow if that size on the ground. 0 for no shadow.

@export var bTrail 				= ""; 		## object the bullet will leave behind at regular intervals
@export var bTrailAcc 			= 8;  		## random shift of trail explosion away from bullet
@export var bTrailAmount 		= 2; 		## number of trail explosions to create per interval
@export var bTrailInterval 		= 4; 		## pixel interval the bullet leaves a trail behind
@export var bTrailElement 		= "phys"; 	## damage type of the trail
@export var bTrailExplosion 	= "s_FireTrail"

@export var bLobEqualsRange 	= false; 	## calculates the shot angle so it hits the floor at the end of the range
@export var bLobDirection 		= 0; 		## bullet will seem like it is travelling in a lob-like trajectory.
@export var bLobBounce 			= 0.8; 		## bounce power the bullet has if in a lob.
@export var bLobBounceCount 	= 0; 		## number of bounces before the bullet crashes
@export var bLobGravity 		= 0; 		## gravity effect on the bullet
@export var bDotline 			= false; 	## bullet changes direction at specific interavals
@export var bExplode 			= "";		## o_explosion; ## object the bullet leaves behind after distance or time runs out.
@export var bExplodeEffect 		= null; 	## explosion effect bullet spawns on impact
@export var bExplodeOnGround 	= false; 	## object will explode when hitting the ground when out of bounces
@export var bExplodeOnTimeout 	= false; 	## object will explode when projectile times out.
@export var bExplodeOnWall 		= false; 	## object will explode if it hits a wall after being out of ricochets.
@export var bExplodeOnEnemy 	= false; 	## object will explode if it hits an enemy after being out of enemy bounces.
@export var bExplodeOnEnemyProx = -1; 		## object will explode if an enemy is within range. -1 means ignore range.

@export var bExplodeDamage 		= 40;
@export var bExplodeElement 	= "phys";
@export var bExplosion 			= "s_MBlast"

## Sounds
@export var reloaded 			= false;
@export var soundId 			= "";
@export var constantSound 		= "";
@export var triggerSound 		= "";
@export var windupSound 		= "";
@export var sustainSound 		= "";
@export var winddownSound 		= "";
@export var reloadSound 		= "";
@export var swapSound 			= "";
@export var pickupSound 		= "";
@export var casingSound 		= "";
@export var emptySound 			= "";

## Script to perform each step
@export var stepScript 			= "";
