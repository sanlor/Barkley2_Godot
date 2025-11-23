extends Resource
class_name B2_WeaponStats
## Class to hold Weapon data.
# Should be similar to the gun[?, "example dictionary from the original game.
# check scr_combat_weapons_new
# check scr_combat_weapons_resetStats

## Weapon stats, thats what goes up as you fuse gun's and raise levels on em.
@export var sPower  			: float = 30
@export var sSpeed  			: float = 30
@export var sRange  			: float = 30
@export var sAmmo  				: float = 30
@export var sAffix  			: float = 30
@export var sWeight  			: float = 3
@export var pEquipped 			:= false

@export var numberval 			:= 0; 		## TODO
@export var rarity 				:= 0; 		## TODO
@export var pointsUsed 			:= 0; 		## TODO

#scr_combat_weapons_resetStats(gun);

## Charge variables
@export var pChargeGain 			:= "cg_shot";
@export var pChargeGainAmount 		:= "ga_gainOne";
@export var pChargeLoss 			:= "cl_none";
@export var pChargeLossAmount 		:= "la_loseOne";

@export var pChargeMax 				: float = 6;
@export var pChargeCur 				: float = 0;
@export var pChargeRatio 			: float = 0;
@export var pChargeEffect 			:= "";

@export var pChargeAccum 			: float = 1;
@export var pChargeIncAccum 		: float = 1.05;
@export var pChargeMaxAccum 		: float = 6;
@export var pChargeLossAccum 		: float = 1;
@export var pChargeGainAmmoMax 		: float = 1;
@export var pChargeGainAmmoMin 		: float = 12;
@export var pChargeGainTime			: float = 1;

@export var pChargeGainVar 			: float = 0;
@export var pChargeLossVar 			: float = 0;

@export var pChargeShot 			: float = 0;
@export var pChargeDamage 			: float = 0;
@export var pChargeHurt 			: float = 0;
@export var pChargeHits 			: float = 0;
@export var pChargeKilled 			: float = 0;
@export var pChargeKilledPow 		: float = 0;
@export var pChargeMissed 			: float = 0;
@export var pChargeCandy 			: float = 0;

## Sprites
@export var gunHeldSprite 			:= "s_Pistol"
@export var hudIconSprite 			:= "s_hud_pistols"
@export var hudIconFrame 			: int = 0;
@export var flashSprite 			:= "s_Flash"
@export var pBulletColor 			: String = Color.WHITE.to_html()
@export var pBulletScale 			: float = 1;
@export var pBulletSprite 			:= "s_bull"
@export var pBulletBurst 			:= "s_ricochet"

@export var col 					: String = Color.WHITE.to_html(); ####blend color of gun sprite in the hud
@export var gunheldcol 				: String = Color.WHITE.to_html(); ####blend color of gun held in hoopz hands
@export var bulscale 				: float = 1;

## Material
@export var gunheldcol1 			: String = ""
@export var displaySpots  			: bool = false
@export var gunheldcol3  			: String = ""
@export var displayParts  			: bool = false
@export var gunheldcol2  			: String = ""

@export var normalFlame  			: bool = false
@export var specialFlame  			: bool = false
@export var sound_normalPitchDmg 	: float = 1
@export var specialBFG  			: bool = false
@export var specialFlaregun  		: bool = false
@export var specialRocket  			: bool = false

@export var speedBonus 				: float = 1

## Type
@export var soundLoop 				:= false
@export var bExplodeDamageMod 		:= 1.0	## NOTE Huge mess. Both scr_combat_weapons_applyGraphic and scr_combat_weapons_applyType change this value.
@export var bUseMoveOffset 			: bool = false
@export var periodic_mutlishot 		: float = 1.0
@export var pChargeLossTime 		: float = 1.0

## Bullet casings
@export var readyCasing 			: int = 0;
@export var bcasing 				:= "s_casing"
@export var bcasingDir 				: float = 240;
@export var bcasingSpd 				: float = 12;
@export var bcasingRot 				: float = 30;
@export var bcasingSpin 			: float = 60;
@export var bcasingHeight 			: float = -16;
@export var bcasingVertSpd 			: float = -12;
@export var bcasingScale 			: float = 0.5;
@export var bcasingCol 				: String = Color.YELLOW.to_html()

#### Position into gunspace
@export var pGunspaceX 				: float = 0;
@export var pGunspaceY 				: float = 0;

@export var pBurstSpeed 			: float = 0;

#### stat ratios. Modified by weapon material, type and affixes.
@export var pPowerMod 				: float = 1;
@export var pPowerMaxMod 			: float = 1;
@export var pSpeedMod 				: float = 1;
@export var pRangeMod 				: float = 1;
@export var pAmmoMod 				: float = 1;
@export var pAmmoBase 				: float = 0;

@export var pAccMod 				: float = 1;

@export var pWeightMod 				: float = 1;
@export var pAffixMod 				: float = 1;

@export var pKnockback 				: float = 0;
@export var pStagger 				: float = 1;
@export var pStaggerHardness 		: float = 1
@export var pRecoil 				: float = 0.3;

#### Stats used directly for the weapon behavior. Built from the weapon stats, ratios and affixes.
@export var pPattern 				= "pt_norm" ## basic pattern of shooting

@export var pSpreadAmount 			: float = 0; 	# angle of shooting spread, in degrees. Low accuracy means the bullets are less predictable in the spread.
@export var pShots 					: float = 1; 	# maximum number of shots fired at a time. They are evenly distributed on the spread amount. If more than one shot is fired, they have a random start position.
											# So that the individual shots appear separate and arnt all just one blob of superposed shots if accuracy is high.
@export var pExtraChance 			: float = 0; 	# chance to fire extra bullets
@export var pExtraNumber 			: float = 0;	# max extra bullets fired upon chance
@export var pBurstAmount 			: float = 1; 	# Number of times shots are fired in a row in bursts automatically.
@export var pBurstInterval 			: float = 6; 	# Interval between shots during a burst. Supercedes fire interval, which is the time BETWEEN bursts. On weapons permitting it, it is a
											# RATIO of the actual firing interval.
@export var pAmmoCost 				: float = 1;
@export var pDamageMin 				: float = 10;
@export var pDamageRand 			: float = 2;
@export var pAccuracy 				: float = 1;
@export var bAimAjarMin 			: float = 0;
@export var bAimAjarMax 			: float = 0;
@export var pRange 					: float = 1;
@export var pFireSpeed 				: float = 0;
@export var pFireDelay 				: float = 0;
@export var pShotDelay 				: float = 0.0;
@export var pAimMod 				: float = 0;
@export var bRangeEndGrav 			: float = 7;
@export var pAffix 					: float = 0;

@export var pWindUp 				: float = 0;
@export var pWindUpSpeed 			: float = 0;

# balanced! adjuster to 300 for GoG (6/6/15) - bhroom
@export var pFireTimer 				: float = 300;
@export var pFireTimerTarget 		: float = 300;

@export var pCurAmmo 				: int = 0;
@export var pMaxAmmo 				: int = 0;
@export var pWeight 				: float = 0;
@export var pRatioAmmo 				: float = 1;

## properties passed on to the bullets
## MOVEMENT PATTERNS
@export var bType 				:= "b_norm"; # bullet type. Sets some default values on the bullets. Can be a shorthand for weapon types or element types that have specific defaults
											# some affixes or weapon types may just manually modify individual values tho.

## the following values are the NORMAL bullet defaults.
## FOLLOWING NUMBERS ARE THE SIMPLE BULLET STATS.
@export var bLongTimeOut 		:= false;
@export var bDistanceLife 		: float = 30; ## distance the bullet travels before destroying itself.
@export var bTimeLife 			: float = -1; ## number of steps before the bullet destroys itself

@export var bSpeed 				: float = 56;	## initial speed the bullet travels at every step. I feel 56 is a good starting point! Bhroom
@export var bAccel 				: float = 0; 	## bullet acceleration at every step (or deceleration)
@export var bMaxSpeed 			: float = 86; 	## doubled from 48 (after Bisse's bullet code fix 120414)
@export var bMinSpeed 			: float = 24; 	## doubled as well

@export var damageRatio 		: float = 1;

@export var bAutomatic 			:= false;
@export var bShowHiteffect 		:= true;

@export var bAdvanced 			:= false; 	## set this to true so the weapon creates the proper bullet type if handling a more advanced bullet.
											## FOLLOWING NUMBERS ARE ADVANCED BULLET STATS ONLY.
@export var bEnemySeek 			: float = 0;		## speed of turning to find enemy. negative value means it avoids enemies.
@export var bEnemyTarget 		= null; 	## target of the seeking. -1 to find nearest enemy, or put an instance ID there to seek specific enemy (ex, enemy clicked)
@export var bEnemySeekRange 	: float = 96; 		## minimum distance from enemy for seeking to occur.
@export var bEnemySeekTime 		: float = 1; 		## time before bullet starts seeking. 0 means immediate seek.
@export var bEnemySeekAccel 	: float = 0; 		## Acceleration added when bullet finds enemy to seek.

@export var bBarrierDist 		: float = 0;
@export var bBarrierRotSpd 		: float = 0;
@export var bBarrierRotCount 	: float = 0;

@export var bReturning 			:= false;	## slows down and reverses speed at the end of distance
@export var bTurning 			= 0; 		## direction the bullet turns to every step.
@export var bRoaming 			= 0; 		## random amount of direction the bullet turns every step
@export var bWave 				= 0			## choose(10,20,30,40); ## bullet moves in a wave pattern. number is size of the wave.
@export var bWaveAmp 			= 0			## choose(10,20,30,40,50,60,70,80); ##  0.25-0.5-0.75-1-2-3
@export var bThroughWalls 		= 0; 		## bullet moves through solids
@export var bEnemyPierce 		= 0; 		## Bullet keeps going after piercing enemy
@export var bNoDestroyOnHit		:= false; 	## Bullet is never destroyed on hit
@export var bWallRicochet 		= 0; 		## amount of times a bullet will bounce off walls
@export var bEnemyRicochet 		= 0; 		## amount of times a bullet will bounce of enemies
@export var bMagician 			= 0;
@export var bRicochetRandom 	:= true; 	## bounce direction will be random instead of based on collision direction
@export var bEnemyChain 		= 0;
@export var bEnemyChainRange 	= 96;
@export var bProximity 			:= false;

@export var bSpiraling 			:= false;
@export var bAmmoChange 		= 0;
@export var bAmmoChangeTimer 	= 0;

@export var bDealDamage 		:= true;		## Set to false and the main bullet will not deal damage (but explosions,affixes,e.g. will)

@export var bShadow 			= 0; 		## bullet will cast a round shadow if that size on the ground. 0 for no shadow.

@export var bTrail 				:= ""; 		## object the bullet will leave behind at regular intervals
@export var bTrailAcc 			= 8;  		## random shift of trail explosion away from bullet
@export var bTrailAmount 		= 2; 		## number of trail explosions to create per interval
@export var bTrailInterval 		= 4; 		## pixel interval the bullet leaves a trail behind
@export var bTrailElement 		:= "phys"; 	## damage type of the trail
@export var bTrailExplosion 	:= "s_FireTrail"

@export var bLobEqualsRange 	:= false; 	## calculates the shot angle so it hits the floor at the end of the range
@export var bLobDirection 		= 0; 		## bullet will seem like it is travelling in a lob-like trajectory.
@export var bLobBounce 			= 0.8; 		## bounce power the bullet has if in a lob.
@export var bLobBounceCount 	= 0; 		## number of bounces before the bullet crashes
@export var bLobGravity 		= 0; 		## gravity effect on the bullet
@export var bDotline 			:= false; 	## bullet changes direction at specific interavals
@export var bExplode 			= "";		## o_explosion; ## object the bullet leaves behind after distance or time runs out.
@export var bExplodeEffect 		= null; 	## explosion effect bullet spawns on impact
@export var bExplodeOnGround 	:= false; 	## object will explode when hitting the ground when out of bounces
@export var bExplodeOnTimeout 	:= false; 	## object will explode when projectile times out.
@export var bExplodeOnWall 		:= false; 	## object will explode if it hits a wall after being out of ricochets.
@export var bExplodeOnEnemy 	:= false; 	## object will explode if it hits an enemy after being out of enemy bounces.
@export var bExplodeOnEnemyProx = -1; 		## object will explode if an enemy is within range. -1 means ignore range.

@export var bExplodeDamage 		: float = 40;
@export var bExplodeElement 	:= "phys";
@export var bExplosion 			:= "s_MBlast"

## Sounds
@export var reloaded 			:= false;
@export var soundId 			:= "";
@export var constantSound 		:= "";
@export var triggerSound 		:= "";
@export var windupSound 		:= "";
@export var sustainSound 		:= "";
@export var winddownSound 		:= "";
@export var reloadSound 		:= "";
@export var swapSound 			:= "";
@export var pickupSound 		:= "";
@export var casingSound 		:= "";
@export var emptySound 			:= "";

## Script to perform each step
@export var stepScript 			:= "";
