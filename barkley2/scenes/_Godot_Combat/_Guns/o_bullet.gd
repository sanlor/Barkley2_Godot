extends Node2D
#extends Area2D
class_name B2_Bullet
## Bullet Scene for all bullet type weapons.

## Once again, due to B2´s weirdness, I have to create some weird code.
## Bullet sprites are referenced only as "s_bull" or "s_bull_brass". we have, like, hundredts of sprites like that...
## Initially, I was going to import all sprite animations inside "bullet_spr", but loading 100+ files each time a bullet is created seems dumb.
## Im doing something even dumber!

## TODO Check performance implications of this madness.

## Continuing with the madness.. bullet sprites...
# Some weapons shoot different kings of bullets. lets take "s_bull_bronze".
# Looks like we can chage shot this gun. depending on the charge, the bullet size may increase
# NOTE not charge, but the weapon stats, the sum of all stats. 
# Check o_bullet alarm0

## NOTE main theme for coding this section of the game: https://youtu.be/bFMWuAC5HV4

## WARNING as of 20/11/25, im trying to improve performance due to issues ith slowdowns on certain situations.
const O_RICOCHET 			:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/ricochet/o_ricochet.tscn")
const BULLET_MOTION_BLUR 	:= preload("uid://jtntp5snoywp")
const BULLET_SUPER_TRAIL 	:= preload("uid://c83yp1523vacs")

const DEBUG					:= true # show some debug data.

@onready var bullet_spr: 				AnimatedSprite2D 		= $bullet_spr
@onready var smoke_trail: 				GPUParticles2D 			= $smoke_trail
@onready var bullet_sfx: 				AudioStreamPlayer2D 	= $bullet_sfx
@onready var bullet_life: 				Timer 					= $bullet_life

## The gun that fired me
var my_gun 				: B2_Weapon

## The actor that fired me
var source_actor 		: B2_CombatActor

## Bullet trail
var has_trail			:= false

## Ricochet
var max_ricochet		:= 3

## Bullet mods
var specialShot			:= ""			## Bullet special effect, like "paper"
var superShot 			:= false
var motionBlur 			:= false
var glowEffect 			:= false;
var bullet_spriteTurn 	:= false
var superTrail 			= 0;		## Trail for the periodic/super shot ##
#var matName 			= "";		## Material name for the gun ## -> replaced by "my_gun.weapon_material == B2_Gun.MATERIAL.*"
var stoneSkipping 		= 0;		## Stone skipping movement for a bullet ## Must be init for Orichalcum
var paintball 			= 0;		## Paintball effect when bullet impacts with a combat actor ##
var lastDmg 			= 0;		## ??? ##
var lastHitKilled 		= false;	## If bullet kills something, this is used to count up the kill periodic charge ##
var lobAngledSprite 	= false;	## Angled sprite for vertically moving bullets ## Z axis ##
var wallRicochet 		= 0;		## Richochet off walls ##
var bloodTrail			:= 0
var image_speed			:= 0.0		## Define if a bullet has a animation

var shadow_visible 		:= true;		## Display cool shadow.
var show_hiteffect 		:= false;

var throughWalls 		= 0;
var rangeEndGrav 		= 0;
#var maxspd 				= 48;
#var minspd 				= 6;
var speedBonus 			= 1; 		## For rifles -> Applies a bonus for speed, depending on the type / material combination.
var is_lobbed			:= false	## Bullet is shot upward. Should happen only with Flareguns and guns with the "Lobbing" affix.
var lobDirection 		:= 0.0;		## Handles how the bullet should be "lobbed". Check combat_gunwield_shoot line 438 and 455
var lobGravity 			:= 0.0;		## Bullet gravity being applied. Usually between 0.0 and 10.0
var dotline 			= 0;
var dotlineAffix 		= false;
var spiraldir 			= 10;

var timelife			:= 128.0		## Equivalent to "bTimeLife". Negative values means infinite. Check o_bullet create, line 77
var distlife			:= 128.0		## Equivalent to "bDistanceLife". Negative values means infinite. Check o_bullet create, line 76

var specialBFG 			= "";
var arrowShot 			= false;
var flaregun 			= false;
var rocketShot 			= false;
var bfgShot 			= false;
var bfgSparkTimer 		= 0;
var bfgFiredDirection 	= 0;

var image_angle ## ????
var bulletSpin ## ????

var ricochetSound := "ricochet"

var neon 			:= false;
var neonHue 		:= 1.0
var neonSat 		:= 1.0;
var neonVal 		:= 1.0;
var neonSize 		:= 1.0
var neonTrail 		:= 1;
var colorBlend 		:= Color.from_hsv(neonHue,neonSat,neonVal);
var useColorBlend 	:= true;

var flyflutter 		:= 0
var flyBaseframe	:= 0

var sinewparts		:= 0.0

var plantInterval 	:= 0.0
var plantNext 		:= 0.0
var plantSize 		:= 0.0

var grassTimer		:= 0.0

var steamTimer 		:= 0.0
var steamInterval 	:= 0.0
var steamStop 		:= 0.0

## bullet fired from francium gun
var franciumShot 	:= false;
var franciumScale 	:= 0.01;
var franciumMax 	:= 1.0;
var franciumSnd 	:= "hoopzweap_francium_hum"

var wingSprite		:= ""
var featherInterval := 0
var featherNext		:= 0

var drawWhiteOverlay := false # o_bullet - draw - line 141

## Advanced bullet
var enable_advanced		:= false	# Behaves lake the o_advBullet
# Advanced bullets are affected by gravity and do a lot of weird shit. Check o_advBullet for more details.

var enemySeek 			:= 0;
var enemySeekCurrent 	:= 0;
var enemyTarget 		= null
var enemySeekRange 		:= 0;
var enemySeekTime 		:= 0;
var enemySeekAccel 		:= 0;

var turning 			:= 0;
var roaming				:= 0;
var wave 				:= 0;
var waveAmp 			:= 0;
var enemyPierce 		:= 0;
var enemyRicochet 		:= 0;
var ricochetRandom 		:= 0;
var noDestroyOnHit 		:= false;

var enemyChain 			:= 0;
var enemyChainRange 	:= 96;
var chainLeft 			:= 0;

var trailtimer 			:= 4;

var ptrailed 			:= 16;
var lobBounceCount 		:= 0;
var lobBounce 			:= 0;

var explodeObject		:= ""
var explodeEffect 		:= ""
var explodeOnTimeout	:= false;
var explodeOnGround 	:= false;
var explodeOnWall 		:= false;
var explodeOnEnemy 		:= false;

var trailObject 		:= ""

var waveInterv 			:= -1;
var waveSpd 			:= 0;

var barrierDist 		:= 0;
var barrierRotSpd 		:= 0;
var barrierRotCount 	:= 0;
var barrierRotTot		:= 0;

var dtCount				:= 0;

var _pow : float = 0.0

var final_multiplier				:= 1.0

## NOTE choice(1,-1) -> [1,-1].pick_random()

var spr := ""
var col := Color.WHITE

## Bullet movement code.
var dir 				: Vector2	
var speed 				:= 1.0		## Shoud be equivalent to "bSpeed"
var max_speed			:= 1.0		## Shoud be equivalent to "bMaxSpeed"
var min_speed			:= 1.0		## Shoud be equivalent to "bMinSpeed"
var acceleration		:= 1.0		## Shoud be equivalent to "bAccel"
var altitude			:= 12.0		## How high is the bullet. check o_bullet create "z" variable
var vertical_speed		:= 1.0		## The speed that a bullet move upward is downwards. check o_bullet create "move_z" variable

## Trail stuff
var bullet_motion_blur : GPUParticles2D
var bullet_super_trail : GPUParticles2D

## Gamedev is my passion...
# here is the thing; this game uses too many bullet types. Making a bullet with a fuck ton of animations seems wasteful.
# my idea is this: lets make an animation on the fly! shouldnt impact the performance.
## NOTE forget that, I just added all animations using a convetion script. 11/03/25
## NOTE 20/11/25 I have no idea what I mean with the text above.
func setup_bullet_sprite( _spr : String, _col : Color ) -> void:
	spr = _spr
	col = _col

func set_direction( _dir :Vector2 ) -> void:
	dir = _dir

## Modifiers applied by skills and such
#func apply_stat_mods( _att : float, _spd : float ) -> void:
	#att = _att
	#spd = _spd
	
func _ready() -> void:
	bullet_spr.animation = "s_bull"
	
	if spr:
		if bullet_spr.sprite_frames.has_animation( spr ):
			bullet_spr.animation = spr
		else:
			push_warning("No animation called %s." % spr)
	else:
		## WTF???
		breakpoint
	
	bullet_spr.look_at( dir.normalized() )
	bullet_spr.self_modulate = col
	
	sprite_selection() 	## Apply some simple config related to sprites
	bullet_setup()		## Enable / Disable bullet options based on the gun stats (trail, etc)
	
	## TODO
	#if enable_advanced:
		#bullet_spr.offset.y = bullet_height
		#bullet_vert_speed = -5.0
		
func bullet_setup() -> void:
	## This preffix / type forces the bullet to be lobbed.
	if my_gun.prefix1 == "Lobbing" or my_gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
		is_lobbed = true
	
	if glowEffect:
		flash_bullet( true )
		
	if superTrail or superShot:
		bullet_super_trail = BULLET_SUPER_TRAIL.instantiate()
		add_child( bullet_super_trail )
		bullet_super_trail.emitting = true
		#print( "super" )
		
	if motionBlur:
		bullet_motion_blur = BULLET_MOTION_BLUR.instantiate()
		bullet_spr.add_child( bullet_motion_blur )
		bullet_motion_blur.texture 		= bullet_spr.sprite_frames.get_frame_texture( bullet_spr.animation, bullet_spr.frame )
		bullet_motion_blur.emitting = true
		#print( "motion")
	
	if drawWhiteOverlay:
		pass
	
## based on some settings, some sprites can change. ## o_bullet alarm 0
# NOTE Ok, this is a mess. This function tries to emulate the original behaviour. I cant think of a better way to handle this besides a big ass match check.
func sprite_selection() -> void:
	if not my_gun:
		push_error("Gun resource not loaded.")
		breakpoint
		return
		
	## Set bullet power. NOTE Besides the sprite selection, how is this used?
	_pow			 = 	B2_Playerdata.Stat(B2_HoopzStats.STAT_ATTACK_DMG_NORMAL) 	+ \
						B2_Playerdata.Stat(B2_HoopzStats.STAT_ATTACK_DMG_BIO) 		+ \
						B2_Playerdata.Stat( B2_HoopzStats.STAT_ATTACK_DMG_CYBER ) 	+ \
						B2_Playerdata.Stat( B2_HoopzStats.STAT_ATTACK_DMG_MENTAL ) 	+ \
						B2_Playerdata.Stat( B2_HoopzStats.STAT_ATTACK_DMG_ZAUBER ) 	+ \
						B2_Playerdata.Stat( B2_HoopzStats.STAT_ATTACK_DMG_COSMIC )
	
	## Set some variables to avoid calling "my_gun.weapon_stats." all the time.
	speedBonus 		= my_gun.weapon_stats.speedBonus
	rocketShot 		= my_gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_ROCKET
	bfgShot 		= my_gun.weapon_type == B2_Gun.TYPE.GUN_TYPE_BFG
	lobGravity 		= my_gun.weapon_stats.bLobGravity	# combat_gunwield_shoot line 435
	lobDirection 	= my_gun.weapon_stats.bLobDirection	# combat_gunwield_shoot line 436
	
	vertical_speed = lobDirection ## TODO is this needed?
	
	bullet_spr.scale.x = my_gun.weapon_stats.pBulletScale # combat_gunwield_shoot line 348
	bullet_spr.scale.y = my_gun.weapon_stats.pBulletScale # combat_gunwield_shoot line 349
	
	bullet_spr.scale.x = my_gun.weapon_stats.bulscale # combat_gunwield_shoot line 372 ## INFO This is so stupid!
	bullet_spr.scale.y = my_gun.weapon_stats.bulscale # combat_gunwield_shoot line 373 ## INFO This is so stupid! x2
	
	if my_gun.weapon_stats.bLongTimeOut:	## Disables bullet timeout
		distlife = -1
		timelife = -1
	else:									## Enables bullet timeout
		if my_gun.weapon_stats.bDistanceLife > 0:
			distlife = my_gun.weapon_stats.bDistanceLife + randf_range(0,8)
		if my_gun.weapon_stats.bTimeLife > 0:
			distlife = my_gun.weapon_stats.bTimeLife
	
	## Set speed stuff
	speed 			= my_gun.weapon_stats.bSpeed
	min_speed 		= my_gun.weapon_stats.bMinSpeed
	max_speed 		= my_gun.weapon_stats.bMaxSpeed
	acceleration	= my_gun.weapon_stats.bAccel
	
	if my_gun.prefix1 == "Gravitational": # combat_gunwield_shoot line 329
		min_speed 		*= B2_Gun.affixGravitationalSpeed
		max_speed 		*= B2_Gun.affixGravitationalSpeed
		acceleration	*= B2_Gun.affixGravitationalSpeed
	
	## Mat stuff
	if my_gun.weapon_material == B2_Gun.MATERIAL.SILK:
		lobAngledSprite = true;
	
	## Apply modifier based on the bullet sprite.
	match bullet_spr.animation:
		# Flare Shot (22/12/25 to support animation)
		"s_flareshot","s_bull_flareshot":
			bullet_spr.play("s_flareshot", 2.0)
			bullet_spr.modulate.a = 0.75
			motionBlur 		= true;
			
		# NORMAL BULLETS #
		"s_bull":
			#modulate = Color.YELLOW
			if !superShot:
				bullet_spr.animation = "s_physShot";
				motionBlur = true;
			else:
				bullet_spr.animation = "s_physShot";
				scale.x *= 1.5;
				scale.y *= 1.4;

		#NORMAL CROSSBOWS
		"s_bull_arrowHead":
			bullet_spr.frame = clamp(floor(_pow / 10), 0, 7) ## WARNING Clamp is WRONG, should be median.
			bullet_spriteTurn = true;

		# CANDY 
		"s_bull_candyShot":
			bullet_spr.frame = clamp( 0, 21, (_pow/6) - 2 + randi_range(0,4) ); ## WARNING Clamp is WRONG, should be median.
			if speedBonus > 1.5:
				speedBonus = 1
			scale.y = [1,-1].pick_random()
			image_angle = [0,90,180,270].pick_random()
			bullet_spriteTurn = false;
			bulletSpin = [1,-1].pick_random() * ( 5 + randi_range(0,20) );       
			#var dr = point_direction(0,0,move_x,move_y); ## NOTE No idea what this does.

		# STONE
		"s_bull_stone":
			specialShot = "stone";
			if 		_pow > 32:			bullet_spr.animation = "s_bull_stone_large"
			elif 	_pow > 16:			bullet_spr.animation = "s_bull_stone"
			elif 	_pow > 8:			bullet_spr.animation = "s_bull_stone_small"
			else:						bullet_spr.animation = "s_bull_stone_tiny"
			## image_angle = choose(0,90,180,270);
			if bfgShot:
				bullet_spr.animation = "s_bull_stone_moai"; 
				image_angle = 0;
				B2_Sound.play("hoopzweap_stone_moai")
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if (speedBonus>1.2):
				speedBonus = 1.2
			specialBFG = true;

		# CARBON
		"s_bull_carbon":
			if(_pow>32):			bullet_spr.frame = 5
			elif (_pow>24):			bullet_spr.frame = 4
			elif (_pow>18):			bullet_spr.frame = 3
			elif (_pow>12):			bullet_spr.frame = 2
			elif (_pow>6):			bullet_spr.frame = 1
			else:					bullet_spr.frame = 0
			lobAngledSprite = true;
			
			if(speedBonus>1.5):
				speedBonus = 1.5

		# MYTHRIL
		"s_bull_mythril":
			bullet_spr.frame = clamp( 0, 14, _pow/6 ); ## WARNING Clamp is WRONG, should be median.
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;

		# BRONZE
		"s_bull_rusty":
			if(_pow>64):		bullet_spr.frame 	= 8
			elif (_pow>48):		bullet_spr.frame 	= 7
			elif (_pow>32):		bullet_spr.frame 	= 6
			elif (_pow>24):		bullet_spr.frame 	= 5
			elif (_pow>18):		bullet_spr.frame 	= 4
			elif (_pow>12):		bullet_spr.frame 	= 3
			elif (_pow>8):		bullet_spr.frame 	= 2
			elif (_pow>4):		bullet_spr.frame 	= 1
			else:				bullet_spr.frame 	= 0
			if(speedBonus>1.5): speedBonus = 1.5
			lobAngledSprite = true;

		# Foil
		"s_bull_foil":
			if(_pow>80):		bullet_spr.frame = 9
			elif (_pow>64):		bullet_spr.frame = 8
			elif (_pow>48):		bullet_spr.frame = 7
			elif (_pow>32):		bullet_spr.frame = 6
			elif (_pow>24):		bullet_spr.frame = 5
			elif (_pow>18):		bullet_spr.frame = 4
			elif (_pow>12):		bullet_spr.frame = 3
			elif (_pow>8):		bullet_spr.frame = 2
			elif (_pow>4):		bullet_spr.frame = 1
			else: 				bullet_spr.frame = 0
			if(speedBonus>1.5): speedBonus = 1.5
			lobAngledSprite = true;
			scale.y = [1,-1].pick_random();

		# SALT
		"s_bull_salt":
			bullet_spr.frame = floor(min(19,_pow))
			image_angle = [0,90,180,270].pick_random();
			scale.x = 1;
			scale.y = 1;
			## TODO saltTrail = 1;
			if(speedBonus>1.2): speedBonus = 1.2

		# GLASS
		"s_bull_glass_light":
			if(_pow>80):		bullet_spr.frame = 8
			elif (_pow>64):		bullet_spr.frame = 7
			elif (_pow>48):		bullet_spr.frame = 6
			elif (_pow>32):		bullet_spr.frame = 5
			elif (_pow>24):		bullet_spr.frame = 4
			elif (_pow>18):		bullet_spr.frame = 3
			elif (_pow>12):		bullet_spr.frame = 2
			elif (_pow>6):		bullet_spr.frame = 1
			else: 				bullet_spr.frame = 0
			self_modulate.a = 0.6
			lobAngledSprite = true;
			if(speedBonus>1.5): speedBonus = 1.5  

		# NEON
		"s_bull_neon":
			## TODO 
			neon = true;
			neonHue = randf()
			neonSat = 0.0;
			neonVal = 1.0;
			neonSize = 0.2 + _pow / 50;
			neonTrail = 3;
			colorBlend = Color.from_hsv(neonHue,neonSat,neonVal);
			## TODO 
			if(speedBonus>1.2): speedBonus = 1.2
			specialBFG = true;


		"s_bull_neonGloworb":
			neonHue = randf();
			neonSat = 1.0;
			neonVal = 1.0;
			colorBlend = Color.from_hsv(neonHue,neonSat,neonVal);
			if speedBonus>1.2 :speedBonus = 1.2
			useColorBlend = true;
			image_speed = 0.0
			bullet_spr.frame = 1;

			var scl = _pow/80;
			scale.x = scl;
			scale.y = scl;
			bullet_spriteTurn = false;
			specialBFG = true;

		# COPPER
		"s_bull_copper":
			if(_pow>80):			bullet_spr.frame = 7
			elif (_pow>48):			bullet_spr.frame = 6
			elif (_pow>32):			bullet_spr.frame = 5
			elif (_pow>24):			bullet_spr.frame = 4
			elif (_pow>18):			bullet_spr.frame = 3
			elif (_pow>12):			bullet_spr.frame = 2
			elif (_pow>6):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			if speedBonus>1.5 :		speedBonus = 1.5
			lobAngledSprite = true;
			
		# BRASS
		"s_bull_brass": ## TODO Finish this
			#steamTimer = 5+_pow/3;
			#steamInterval = 4;
			#steamStop = 10;
			if(_pow>80):			bullet_spr.frame = 10
			elif (_pow>64):			bullet_spr.frame = 9
			elif (_pow>46):			bullet_spr.frame = 8
			elif (_pow>38):			bullet_spr.frame = 7
			elif (_pow>30):			bullet_spr.frame = 6
			elif (_pow>24):			bullet_spr.frame = 5
			elif (_pow>18):			bullet_spr.frame = 4
			elif (_pow>12):			bullet_spr.frame = 3
			elif (_pow>8):			bullet_spr.frame = 2
			elif (_pow>4):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			bullet_spriteTurn = false;
			if speedBonus > 1.5: 	speedBonus = 1.5
			#Smoke("puff",x,y,z,2+max(5,_pow));
			smoke_trail.emitting = true
			has_trail = false
	

		"s_bull_polenta":
			if(_pow>80):			bullet_spr.frame = 10
			elif (_pow>64):			bullet_spr.frame = 9
			elif (_pow>46):			bullet_spr.frame = 8
			elif (_pow>38):			bullet_spr.frame = 7
			elif (_pow>30):			bullet_spr.frame = 6
			elif (_pow>24):			bullet_spr.frame = 5
			elif (_pow>18):			bullet_spr.frame = 4
			elif (_pow>12):			bullet_spr.frame = 3
			elif (_pow>8):			bullet_spr.frame = 2
			elif (_pow>4):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			if(speedBonus>1.5):		speedBonus = 1
			lobAngledSprite = true;
			scale.y = [1,-1].pick_random()
	
		# FOAM
		"s_bull_foam": ## TODO Finish this
			if(_pow>52):			bullet_spr.frame = 4
			elif (_pow>32):			bullet_spr.frame = 3
			elif (_pow>16):			bullet_spr.frame = 2
			elif (_pow>8):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.25):speedBonus = 1.25
			if(bfgShot):
				bullet_spr.animation = "s_bull_plasticBFG";
				bullet_spriteTurn = false;
				## TODO anglespray = -90;
				## TODO spraytimer = 1;
				rangeEndGrav = 0;
			else:
				lobAngledSprite = true;
			specialBFG = true;
	

		# RUBBER
		"s_bull_rubber":
			if(_pow>48):			bullet_spr.frame = 3
			elif (_pow>24):			bullet_spr.frame = 2
			elif (_pow>12):			bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.25):speedBonus = 1.25
			lobAngledSprite = true;
			specialBFG = true;
	
		# BONE
		"s_bull_bone": ## TODO Finish this
			specialShot = "bone";
			if bullet_spr.frame == 0:
				bullet_spr.frame = 6 + clamp( 0, 11, floor(_pow/5) - 1 + randi_range(0,2) );
				## TODO image_angle = choose(0,90,180,270);
				scale.x = 1;
				scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			if(rocketShot):bullet_spr.animation = "s_bull_boneRocket"
			if(bfgShot):
				## TODO boneTrail = 0.1;
				## TODO boneSpawnX = x;
				## TODO boneSpawnY = y;
				bullet_spr.animation = "s_bull_boneBFG"
				## TODO tailLength = 0;
				## TODO tailPos = min(15,floor(_pow/5));
				## TODO tailRemaining = floor(_pow/5);
				## TODO if(wave<20):wave = 20
				## TODO if(waveAmp<20):waveAmp = 20
				bullet_spriteTurn = true;
			specialBFG = true;
	
		"s_bull_antimatter": ## TODO Finish this
			## TODO holeObj = instance_create(x,y,o_cosmichole);
			## TODO holeObj.radiusbase = 4 + floor(_pow/3);
			## TODO holeObj.radiusShake = floor(_pow/4);
			if(speedBonus>1):speedBonus = 1
			## TODO antimatterTrail = 0;
			## TODO drawSprite = false;
			## TODO scr_entity_setShadowVisible(false);
	
		# BRONZE
		"s_bull_bronze":
			if(_pow>64):			bullet_spr.frame = 8
			elif (_pow>48):			bullet_spr.frame = 7
			elif (_pow>32):			bullet_spr.frame = 6
			elif (_pow>24):			bullet_spr.frame = 5
			elif (_pow>18):			bullet_spr.frame = 4
			elif (_pow>12):			bullet_spr.frame = 3
			elif (_pow>8):			bullet_spr.frame = 2
			elif (_pow>4):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			if(speedBonus>1.5):		speedBonus = 1.5
			lobAngledSprite = true;
		
		"s_bull_orichal": ## TODO Finish this
			#/bullet_spr.frame = 6 + clamp(0,13,floor(_pow/5)-1+irandom(2));
			#image_angle = 0;#/choose(0,90,180,270);
			if (_pow>140):			bullet_spr.frame = 14
			elif (_pow>100):		bullet_spr.frame = 13
			elif (_pow>80):			bullet_spr.frame = 12
			elif (_pow>70):			bullet_spr.frame = 11
			elif (_pow>60):			bullet_spr.frame = 10
			elif (_pow>50):			bullet_spr.frame = 9
			elif (_pow>40):			bullet_spr.frame = 8
			elif (_pow>33):			bullet_spr.frame = 7
			elif (_pow>26):			bullet_spr.frame = 6
			elif (_pow>20):			bullet_spr.frame = 5
			elif (_pow>12):			bullet_spr.frame = 4
			elif (_pow>7):			bullet_spr.frame = 3
			elif (_pow>4):			bullet_spr.frame = 2
			else: 					bullet_spr.frame = 1
			ricochetSound = "hoopzweap_orichalcum_bounce";
			## TODO wobbleAnim = 2;
			## TODO orichalnim = 1
			stoneSkipping = 3;
			## TODO orichalFrame = image_index;
			specialBFG = true;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
	
		"s_bull_chitin_egg":
			if(_pow>110):			bullet_spr.frame = 18
			elif (_pow>100):		bullet_spr.frame = 17
			elif (_pow>90):			bullet_spr.frame = 16
			elif (_pow>80):			bullet_spr.frame = 15
			elif (_pow>70):			bullet_spr.frame = 14
			elif (_pow>60):			bullet_spr.frame = 13
			elif (_pow>50):			bullet_spr.frame = 12
			elif (_pow>45):			bullet_spr.frame = 11
			elif (_pow>40):			bullet_spr.frame = 10
			elif (_pow>35):			bullet_spr.frame = 9
			elif (_pow>30):			bullet_spr.frame = 8
			elif (_pow>25):			bullet_spr.frame = 7
			elif (_pow>20):			bullet_spr.frame = 6
			elif (_pow>15):			bullet_spr.frame = 5
			elif (_pow>12):			bullet_spr.frame = 4
			elif (_pow>9):			bullet_spr.frame = 3
			elif (_pow>6):			bullet_spr.frame = 2
			elif (_pow>3):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			bullet_spriteTurn = false;
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.2):speedBonus = 1.0
	
		"s_bull_plantain":
			if(_pow>120):			bullet_spr.frame = 13
			elif (_pow>100):		bullet_spr.frame = 12
			elif (_pow>80):			bullet_spr.frame = 11
			elif (_pow>70):			bullet_spr.frame = 10
			elif (_pow>60):			bullet_spr.frame = 9
			elif (_pow>50):			bullet_spr.frame = 8
			elif (_pow>40):			bullet_spr.frame = 7
			elif (_pow>33):			bullet_spr.frame = 6
			elif (_pow>26):			bullet_spr.frame = 5
			elif (_pow>20):			bullet_spr.frame = 4
			elif (_pow>12):			bullet_spr.frame = 3
			elif (_pow>7):			bullet_spr.frame = 2
			elif (_pow>4):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			
			bullet_spr.flip_h = randf() > 0.5
			bullet_spr.flip_v = randf() > 0.5

			lobAngledSprite = true;
			bullet_spriteTurn = true;
			specialBFG = true;
	
		# JUNK
		"s_bull_junk":
			bullet_spr.frame = 7 + clamp(0, 27, floor(_pow/3) - 1 + randi_range(0,2) );
			## TODO image_angle = choose(0,90,180,270);
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2): speedBonus = 1.2
			if(arrowShot):
				bullet_spr.animation = "s_bull_plunger";
				bullet_spr.frame = clamp(_pow/12,0,3);
				bullet_spriteTurn = true;
			specialBFG = true;
	
		# GOO
		"s_bull_goo_med":
			if(_pow>48):			bullet_spr.animation = "s_bull_goo_large"
			elif (_pow>24):			bullet_spr.animation = "s_bull_goo_med"
			elif (_pow>12):			bullet_spr.animation = "s_bull_goo_small"
			else: 					bullet_spr.animation = "s_bull_goo_tiny"
			scale.x = 1;
			scale.y = 1;
			bullet_spr.speed_scale = 0.25;
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
	
		"s_bull_goo_bfg":
			specialBFG = true;
			specialShot = "goo";
			var scl = 1;
			scl = clamp(0.5,2,_pow / 40);
			bullet_spr.speed_scale = 0.25;
			scale.x = scl;
			scale.y = scl;
			specialBFG = true;
	
		##PAPER
		"s_bull_paper":
			specialShot = "paper";
			var playedPapersound = true;
			if(_pow>64):			bullet_spr.frame = 5
			elif (_pow>48):			bullet_spr.frame = 4
			elif (_pow>24):			bullet_spr.frame = 3
			elif (_pow>12):			bullet_spr.frame = 2
			elif (_pow>6):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			
			if(bullet_spr.frame >=3 ) :playedPapersound = false
			if(flaregun):
				bullet_spr.animation 		= "s_bull_paperSpecial"; 
				bullet_spr.frame = 0
			if(rocketShot):
				bullet_spr.animation 		= "s_bull_paperSpecial";
				bullet_spr.frame = 1
			if(bfgShot):
				bullet_spr.animation 		= "s_bull_paperSpecial";
				bullet_spr.frame = 2; 
				bullet_spriteTurn = false
			
			scale.x = 1;
			scale.y = 1;
			specialBFG = true;
			if(speedBonus>1.2):speedBonus = 1.2
			if playedPapersound: play_sound("hoopzweap_origami_fly", false)
	
		# GOLD #
		"s_bull_gold":
			bullet_spr.frame = clamp(0,14,_pow/10);
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;
	
		# SILVER #
		"s_bull_silver":
			bullet_spr.frame = clamp(0,14,_pow/10);
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;
	
		#/ ITANO GUN's / ROCKET LAUNCHER
		"s_bull_rocket":
			var trailScale = 1;
			#trailAngle = choose(0,90,180,270);
			speedBonus = 1;
			if(_pow>96):			bullet_spr.frame = 7
			elif (_pow>80):			bullet_spr.frame = 6; trailScale = 0.9
			elif (_pow>64):			bullet_spr.frame = 5; trailScale = 0.8
			elif (_pow>48):			bullet_spr.frame = 4; trailScale = 0.6
			elif (_pow>32):			bullet_spr.frame = 3; trailScale = 0.5
			elif (_pow>16):			bullet_spr.frame = 2; trailScale = 0.4
			elif (_pow>8):			bullet_spr.frame = 1; trailScale = 0.3
			else: 					bullet_spr.frame = 0;trailScale = 0.2
			scale.x = 1;
			scale.y = 1;

			if my_gun.weapon_material == B2_Gun.MATERIAL.ITANO:
				if(rocketShot):
					if(_pow<50):	bullet_spr.frame += 1
					else: 			bullet_spr.animation = "s_bull_itanoRocket"
				if(bfgShot):
					if(_pow<50):	bullet_spr.frame += 2
					else: 			bullet_spr.animation = "s_bull_itanoBFG"
			lobAngledSprite = true;
			# Play a looping exhaust effect on rockets, create sound emitter for this.
			play_sound( "hoopzweap_rocket_exhaust", true );
		
		"s_bull_offal":
			speedBonus = 1;
			bullet_spr.frame = clamp(0, 15, floor(_pow / 8) - 2 + randi_range(0,4) );
			scale.x = 1;
			scale.y = [1,-1].pick_random()
			specialBFG = true;
			bloodTrail = 1 + randi_range(0,6);
	
		"s_bull_blood":
			speedBonus = 1;
			specialShot = "blood";
			specialBFG = true;
			bullet_spr.frame = clamp(0,7,floor(_pow / 12));
			scale.x = 1;
			scale.y = [1,-1].pick_random()
			bloodTrail = 1 + randi_range(0,6);
			lobAngledSprite = true;
			if bfgShot:
				bullet_spr.animation = "s_bull_bloodBFG"; 
				bullet_spr.speed_scale = 0.1; 
				scale.y = 1; 
				bullet_spriteTurn = false
	
		"s_bull_soiled":
			speedBonus = 1;
			bullet_spr.frame = clamp(0,7,floor(_pow / 12));
			scale.x = 1;
			scale.y = [1,-1].pick_random()
			bloodTrail = 1 + randi_range(0,6);
		
		"s_bull_tofu1":
			if(_pow>64):		bullet_spr.animation = "s_bull_tofu5"
			elif (_pow>32):		bullet_spr.animation = "s_bull_tofu4"
			elif (_pow>16):		bullet_spr.animation = "s_bull_tofu3"
			elif (_pow>8):		bullet_spr.animation = "s_bull_tofu2"
			else: 				bullet_spr.animation = "s_bull_tofu1"
			## TODO image_angle = choose(0,90,180,270);
			image_speed = 0.25;
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1;
	
		"s_bull_grass":
			if (_pow>80):	bullet_spr.frame = 14
			elif (_pow>72):	bullet_spr.frame = 13
			elif (_pow>64):	bullet_spr.frame = 12
			elif (_pow>56):	bullet_spr.frame = 11
			elif (_pow>48):	bullet_spr.frame = 10
			elif (_pow>40):	bullet_spr.frame = 9
			elif (_pow>32):	bullet_spr.frame = 8
			elif (_pow>26):	bullet_spr.frame = 7
			elif (_pow>20):	bullet_spr.frame = 6
			elif (_pow>16):	bullet_spr.frame = 5
			elif (_pow>12):	bullet_spr.frame = 4
			elif (_pow>8):	bullet_spr.frame = 3
			elif (_pow>4):	bullet_spr.frame = 2
			elif (_pow>2):	bullet_spr.frame = 1
			scale.x = 1;
			scale.y = [1,-1].pick_random()
			grassTimer = 0.2;
			specialBFG = true;
			lobAngledSprite = true;
			if(speedBonus>1.2):speedBonus = 1.2
	
		"s_bull_brainshot":
			if(speedBonus>1):speedBonus = 1
			specialShot = "brain";
			## TODO 
			#antimatterTrail = 0;
			#drawSprite = true;
			#scr_entity_setShadowVisible(false);
			#
#
			#pulseObj = instance_create(x,y,o_pulseEffect);
			#pulseObj.radiusbase = 4 + floor(_pow/3);
			#pulseObj.radiusShake = floor(_pow/4);
			## TODO 
			if (_pow>80):bullet_spr.frame = 14
			elif (_pow>72):bullet_spr.frame = 13
			elif (_pow>64):bullet_spr.frame = 12
			elif (_pow>56):bullet_spr.frame = 11
			elif (_pow>48):bullet_spr.frame = 10
			elif (_pow>40):bullet_spr.frame = 9
			elif (_pow>32):bullet_spr.frame = 8
			elif (_pow>26):bullet_spr.frame = 7
			elif (_pow>20):bullet_spr.frame = 6
			elif (_pow>16):bullet_spr.frame = 5
			elif (_pow>12):bullet_spr.frame = 4
			elif (_pow>8):bullet_spr.frame = 3
			elif (_pow>4):bullet_spr.frame = 2
			elif (_pow>2):bullet_spr.frame = 1
			specialBFG = true;
	
		#/FUNGUS GUN's
		"s_bull_spore":
			if(_pow>45):bullet_spr.frame = 9#; scr_entity_setZHitbox(0-10, 2+10)
			elif (_pow>38):bullet_spr.frame = 8#; scr_entity_setZHitbox(0-8, 2+8)
			elif (_pow>32):bullet_spr.frame = 7#;scr_entity_setZHitbox(0-6, 2+6)
			elif (_pow>26):bullet_spr.frame = 6#;scr_entity_setZHitbox(0-4, 2+4)
			elif (_pow>20):bullet_spr.frame = 5#;scr_entity_setZHitbox(0-3, 2+3)
			elif (_pow>14):bullet_spr.frame = 4#;scr_entity_setZHitbox(0-3, 2+3)
			elif (_pow>9):bullet_spr.frame = 3#;scr_entity_setZHitbox(0-2, 2+2)
			elif (_pow>5):bullet_spr.frame = 2#;scr_entity_setZHitbox(0-1, 2+1)
			elif (_pow>2):bullet_spr.frame = 1#;scr_entity_setZHitbox(0-1, 2)
			else: bullet_spr.frame = 0
			## TODO image_angle = choose(0,90,180,270);
			scale.x = 1;
			scale.y = 1;
			## TODO hitHoopzIn = 5;
			ricochetSound = "";
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			specialBFG = true;
	
		"s_bull_magma":
			if(_pow>132):bullet_spr.frame = 21
			elif (_pow>128):bullet_spr.frame = 20
			elif (_pow>120):bullet_spr.frame = 19
			elif (_pow>112):bullet_spr.frame = 18
			elif (_pow>104):bullet_spr.frame = 17
			elif (_pow>96):bullet_spr.frame = 16
			elif (_pow>88):bullet_spr.frame = 15
			elif (_pow>80):bullet_spr.frame = 14
			elif (_pow>72):bullet_spr.frame = 13
			elif (_pow>64):bullet_spr.frame = 12
			elif (_pow>56):bullet_spr.frame = 11
			elif (_pow>48):bullet_spr.frame = 10
			elif (_pow>40):bullet_spr.frame = 9
			elif (_pow>32):bullet_spr.frame = 8
			elif (_pow>26):bullet_spr.frame = 7
			elif (_pow>20):bullet_spr.frame = 6
			elif (_pow>16):bullet_spr.frame = 5
			elif (_pow>12):bullet_spr.frame = 4
			elif (_pow>8):bullet_spr.frame = 3
			elif (_pow>4):bullet_spr.frame = 2
			elif (_pow>2):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			## TODO 
			#if(!shotSetup):
				#magmaCoolDelay = 6;
				#magmacooldown = 24;
				#if(bfgShot):magmaCoolDelay = 12
				#if(rocketShot):magmaCoolDelay = 10
				#if(flaregun):magmaCoolDelay = 8
			#Smoke("customcolor",make_color_rgb(10,5,8),make_color_rgb(46,30,40),make_color_rgb(115,50,70),0)
			#var smk = Smoke("puff",x,y,z,max(4,_pow*1.5));
			#Smoke("init",0,0,0,0);
			if(speedBonus>1.2):speedBonus = 1.2
			scale.x = 1;
			scale.y = [1,-1].pick_random()
			## TODO 
			smoke_trail.emitting = true
			has_trail = false
			bullet_spriteTurn = true;
			lobAngledSprite = true;
			specialBFG = true;
	
		###MERCURY
		"s_bull_mercury":
			## TODO 
			#show_debug_message("o_bullet move_dir:" + string(move_dir));
			#if(_pow>12 && choose(true,false)):
				#var splitAmnt = (20+random(60) )/100;
				#var splt = scr_combat_cloneBullet(id);
				#scr_combat_bulletDmgmod(id,0,1-splitAmnt);
				#scr_combat_bulletDmgmod(splt,0,splitAmnt);
				##with(splt):scr_entity_setDirSpd(90,20)
				##show_debug_message("o_bullet splt.move_dir0:" + string(splt.move_dir));
				#if with(splt):
					#scr_entity_setDirSpd(other.move_dir-10+irandom(20),other.move_dist)
				#splt.initDir = splt.move_dir;
				#_pow = _pow*(1-splitAmnt);
#
			#if(_pow>6 && choose(true,false,false)): #/split 1
				#var splitAmnt = (30+random(50) )/100;
				#var splt = scr_combat_cloneBullet(id);
				#scr_combat_bulletDmgmod(id,0,1-splitAmnt);
				#scr_combat_bulletDmgmod(splt,0,splitAmnt);
				##with(splt):scr_entity_setDirSpd(90,20)
				##show_debug_message("o_bullet splt.move_dir1:" + string(splt.move_dir));
				#if with(splt):
					#scr_entity_setDirSpd(other.move_dir-10+irandom(20),other.move_dist)
				#splt.initDir = splt.move_dir;
				#_pow = _pow*(1-splitAmnt);
#
			#if(speedBonus>1.5):speedBonus = 1
			#bullet_spriteTurn = true;
			#bullet_spr.frame = clamp(0,16,_pow/5);
			#if(_pow>2.5):image_index+=1
			## TODO 
			pass
	
		#/DIGITAL
		"s_bull_digitalLaser":
			## TODO 
			#shotOriginx = dx;
			#shotOriginy = y-z;
			#lstPoints = ds_list_create();
			#shotWidth = 1+floor(_pow/12);
			#speedBonus = 2;
			#laserCol = c_red;
			#laserTrail = 8;
			#trailLength = 16;
			#specialBFG = true;
			#if(rocketShot):shotWidth += 4 + shotWidth/2
			#if(bfgShot):shotWidth += 6 + shotWidth
			## TODO 
			pass
	
		#/PEARL SHOT
		"s_bull_pearl_ghostShot":
			bullet_spr.speed_scale = 0.25;
			#scale.x = _pow / 50;
			#scale.y = scale.x*choose(1,-1);

			if(_pow>80):		bullet_spr.animation = "s_bull_pearl_ghostMound"
			elif(_pow>64):	bullet_spr.animation = "s_bull_pearl_ghostShot"
			elif(_pow>48):	bullet_spr.animation = "s_bull_pearl_ghostShot"
			elif(_pow>36):	bullet_spr.animation = "s_bull_pearl_skullShot"
			elif(_pow>24):	bullet_spr.animation = "s_bull_pearl_handShot"
			elif(_pow>12):	bullet_spr.animation = "s_bull_pearl_eyeShot"
			elif(_pow>6):	bullet_spr.animation = "s_bull_pearl_lilGhost"
			else: 			bullet_spr.animation = "s_bull_pearl_tinyGhost "
			specialBFG = true;
			specialShot = "ghost";
			## TODO ghostTrail = 0;
			throughWalls = 10;
			bullet_spriteTurn = true;

			if(!bfgShot && !rocketShot):
				## TODO enemySeek += 4;
				## TODO enemySeekRange = 64;
				## TODO enemySeekTime = 0.5;
				pass
			#sparktrail = 3
			if(speedBonus>1.25):speedBonus = 1
	
		#/LEAD SHOT
		"s_bull_lead":
			if (_pow>120):bullet_spr.frame = 14
			elif (_pow>100):bullet_spr.frame = 13
			elif (_pow>90):bullet_spr.frame = 12
			elif (_pow>80):bullet_spr.frame = 11
			elif (_pow>70):bullet_spr.frame = 10
			elif (_pow>60):bullet_spr.frame = 9
			elif (_pow>50):bullet_spr.frame = 8
			elif (_pow>40):bullet_spr.frame = 7
			elif (_pow>30):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			stoneSkipping = -1; #/roll when hit the ground
			if(speedBonus>1.25):speedBonus = 1.25
	
		#/ FRANCIUM
		"s_bull_francium":
			## TODO 
			#mask_index = s_bull_francium
			motionBlur = true;
			scale.x = 1;
			scale.y = 1;
			image_speed = 0.2;
			franciumMax = 1;
			if(_pow<3):				franciumMax = 0.06
			elif(_pow<6):			franciumMax = 0.1
			elif(_pow<12):			franciumMax = 0.2
			elif(_pow<18):			franciumMax = 0.3
			elif(_pow<24):			franciumMax = 0.4
			elif(_pow<30):			franciumMax = 0.5
			elif(_pow<40):			franciumMax = 0.6
			elif(_pow<50):			franciumMax = 0.7
			elif(_pow<60):			franciumMax = 0.8
			elif(_pow<70):			franciumMax = 0.9
			elif(_pow<80):			franciumMax = 1.0
			elif(_pow<100):			franciumMax = 1.1
			elif(_pow<120):			franciumMax = 1.2
			elif(_pow<140):			franciumMax = 1.3
			elif(_pow<180):			franciumMax = 1.4
			elif(_pow<220):			franciumMax = 1.5
			elif(_pow<240):			franciumMax = 1.6
			elif(_pow<260):			franciumMax = 1.7
			elif(_pow<280):			franciumMax = 1.8
			elif(_pow<300):			franciumMax = 1.9
			else: 					franciumMax = 2.0
#
			#image_angle = choose(0,90,180,270);
			shadow_visible = false;
			show_hiteffect = false;
			franciumScale = 0.01;
			scale.x = franciumMax*franciumScale;
			scale.y = franciumMax*franciumScale;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			play_sound(franciumSnd, true);
			
		"s_bull_scrollWeapon":
			bullet_spr.speed_scale = 0;
			## TODO scr_entity_setZHitbox(0-10, 2+10);
	
		"s_bull_flamethrower":
			specialBFG = true;
			if (superShot):
				## TODO drawWhiteOverlay = true;
				pass
	
		"s_bull_spFlame":
			pass

		"s_bull_bfg":
			## TODO mask_index = mask_disk_20by20;
			## TODO bfgFiredDirection = move_dir;
			play_sound("hoopzweap_BFG_shot", false);
		
		"s_bull_adamant":
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
			bullet_spr.frame = clamp(0, 27, clamp( 0, 27, floor(_pow/3) ) - 2 + randi_range(0,4) );
		

		"s_bull_tin":
			bullet_spriteTurn = false;
			if(bfgShot && rocketShot && flaregun):
				bullet_spr.animation = "s_bull_tincan";
				bullet_spr.speed_scale = 0.2;

		"s_bull_cobalt":
			if(speedBonus>1.2):speedBonus = 1.5
			if (_pow>90):bullet_spr.frame = 10
			elif (_pow>76):bullet_spr.frame = 9
			elif (_pow>64):bullet_spr.frame = 8
			elif (_pow>52):bullet_spr.frame = 7
			elif (_pow>40):bullet_spr.frame = 6
			elif (_pow>30):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
		
		"s_bull_angelCore":
			## TODO 
			scale.x = 1;
			scale.y = 1;
			#if(speedBonus>1.2):speedBonus = 1; accel = accel*2; move_dist= (move_dist+1)*2
#
			#bullet_spriteTurn = false;
			#wingSprite = "noone";
			#wingFrame = 0;
			## TODO 
			if(_pow>200):			bullet_spr.frame = 13
			elif (_pow>160):		bullet_spr.frame = 12
			elif (_pow>140):		bullet_spr.frame = 11
			elif (_pow>120):		bullet_spr.frame = 10
			elif (_pow>96):			bullet_spr.frame = 9
			elif (_pow>84):			bullet_spr.frame = 8
			elif (_pow>72):			bullet_spr.frame = 7
			elif (_pow>60):			bullet_spr.frame = 6
			elif (_pow>48):			bullet_spr.frame = 5
			elif (_pow>36):			bullet_spr.frame = 4
			elif (_pow>24):			bullet_spr.frame = 3
			elif (_pow>12):			bullet_spr.frame = 2
			elif (_pow>6):			bullet_spr.frame = 1
			else: 					bullet_spr.frame = 0
			
			## TODO 
			if		bullet_spr.frame:	wingSprite	= "s_bull_angel_tiny"
			elif	bullet_spr.frame:	wingSprite 	= "s_bull_angel_small"
			elif	bullet_spr.frame:	wingSprite 	= "s_bull_angel_medium"
			elif	bullet_spr.frame:	wingSprite 	= "s_bull_angel_large"
			elif	bullet_spr.frame:	wingSprite 	= "s_bull_angel_huge"
			else: 						wingSprite 	= "s_bull_angel_giant"
#
			var featherCount 					= 1;
			if(_pow>240):	featherCount 		= 3 + randi_range(0,6)
			elif(_pow>120):	featherCount 		= 2 + randi_range(0,4)
			elif(_pow>60):	featherCount 		= 1 + randi_range(0,3)
			elif(_pow>30):	featherCount 		= 1 + randi_range(0,2)
			elif(_pow>15):	featherCount 		= 1 + randi_range(0,1)
			else: 			featherCount 		= 1
			## TODO 
			if(bfgShot):
				featherCount = featherCount*2; 
				bullet_spr.animation = "s_bull_angelBFG"
				bullet_spr.frame = 0; 
				wingSprite = "noone"

			specialShot = "angel";

			featherInterval = 10;
			featherNext = randi_range(0,featherInterval);
			
			## TODO Disabled the bellow temporarelly
			#repeat(featherCount)
				#ob = instance_create(x-2+random(4),y-2+random(4),o_part_angelFeathers);
				#ob.z = z; ob.move_z = 1+random(8);
				#ob.move_dir = move_dir-30+random(60);
				#ob.move_dist = 1+random(10);
				#ob.move_x = lengthdir_x(ob.move_dist,ob.move_dir);
				#ob.move_y = lengthdir_y(ob.move_dist,ob.move_dir);
				#ob.bullet_spr.frame = clamp(irandom(image_index),0,9)
			## TODO
			
			specialBFG = true;
		
		###SINEW
		"s_bull_sinew":
			if (_pow>96):		bullet_spr.frame = 12
			elif (_pow>72):		bullet_spr.frame = 11
			elif (_pow>64):		bullet_spr.frame = 10
			elif (_pow>56):		bullet_spr.frame = 9
			elif (_pow>48):		bullet_spr.frame = 8
			elif (_pow>40):		bullet_spr.frame = 7
			elif (_pow>32):		bullet_spr.frame = 6
			elif (_pow>24):		bullet_spr.frame = 5
			elif (_pow>18):		bullet_spr.frame = 4
			elif (_pow>12):		bullet_spr.frame = 3
			elif (_pow>6):		bullet_spr.frame = 2
			elif (_pow>3):		bullet_spr.frame = 1
			else: 				bullet_spr.frame = 0
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = true;
			lobAngledSprite = true;
			sinewparts = 0.2;
		
		"s_bull_orb":
			## TODO 
			#shotOriginx = dx;
			#shotOriginy = y-z;
			#lstPoints = ds_list_create();
			#shotWidth = 1+floor(_pow/14);
			#turnTimer = 32;
			#speedBonus = 2;
			#laserTrail = 8;
			#trailLength = 24;
			#speedBonus = 1;
			#match laserGen: ## WARNING Migrate this
				#"0": laserCol = c_white; 
				#"1": laserCol = make_color_rgb(136,249,157); 
				#"2": laserCol = make_color_rgb(0,255,0); 
				#"3": laserCol = make_color_rgb(3,201,40); ; 
				#"4": laserCol = make_color_rgb(55,165,73); 
				#"5": laserCol = make_color_rgb(65,127,71); 
				#_: laserCol = make_color_rgb(56,100,62); 
			#drawSprite = false;
			## TODO 
			pass
		
		##/BLASTER
		"s_bull_blaster":
			if (_pow>80):bullet_spr.frame = 9
			elif (_pow>60):bullet_spr.frame = 8
			elif (_pow>50):bullet_spr.frame = 7
			elif (_pow>40):bullet_spr.frame = 6
			elif (_pow>30):bullet_spr.frame = 5
			elif (_pow>20):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = true;
			specialBFG = true;
			if(speedBonus>1):speedBonus = 1
			lobAngledSprite = true;
			
			play_sound( "hoopzweap_blaster_impact", true );

		##YGGDRASIL
		"s_bull_yggShot":
			if (_pow>48):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			plantInterval = max( 0.1, ( 7 - _pow / 10 ) / 6 );
			plantNext = randf_range(0,plantInterval);
			plantSize = 5 + _pow;
			if(speedBonus>1.2):speedBonus = 1
			specialBFG = true;
			lobAngledSprite = true;
		
		# CHOBHAM
		"s_bull_chobham":
			if(_pow>64):bullet_spr.frame = 8
			elif (_pow>48):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
			if(speedBonus>1.5):speedBonus = 1.5
		
		"s_bull_frankincense":
			if (_pow>96):bullet_spr.frame = 12
			elif (_pow>72):bullet_spr.frame = 11
			elif (_pow>64):bullet_spr.frame = 10
			elif (_pow>56):bullet_spr.frame = 9
			elif (_pow>48):bullet_spr.frame = 8
			elif (_pow>40):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>6):bullet_spr.frame = 2
			elif (_pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = true;

			steamTimer = 4 + _pow / 3
			steamInterval = 4;
			steamStop = 6;
			lobAngledSprite = true;
			## TODO Smoke("puff",x,y,z,2+max(5,_pow));
			smoke_trail.emitting = true
			has_trail = false
		

		"s_bull_myrrh":
			if (_pow>96):bullet_spr.frame = 12
			elif (_pow>72):bullet_spr.frame = 11
			elif (_pow>64):bullet_spr.frame = 10
			elif (_pow>56):bullet_spr.frame = 9
			elif (_pow>48):bullet_spr.frame = 8
			elif (_pow>40):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>6):bullet_spr.frame = 2
			elif (_pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = true;
		

		"s_bull_crystalshot":
			if(_pow>160):bullet_spr.frame = 15
			elif (_pow>140):bullet_spr.frame = 14
			elif (_pow>120):bullet_spr.frame = 13
			elif (_pow>100):bullet_spr.frame = 12
			elif (_pow>80):bullet_spr.frame = 11
			elif (_pow>70):bullet_spr.frame = 10
			elif (_pow>60):bullet_spr.frame = 9
			elif (_pow>50):bullet_spr.frame = 8
			elif (_pow>42):bullet_spr.frame = 7
			elif (_pow>36):bullet_spr.frame = 6
			elif (_pow>30):bullet_spr.frame = 5
			elif (_pow>24):bullet_spr.frame = 4
			elif (_pow>18):bullet_spr.frame = 3
			elif (_pow>12):bullet_spr.frame = 2
			elif (_pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.x = [1,-1].pick_random();
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = false;
			specialBFG = true;

			play_sound("hoopzweap_crystal_bullet", true)

		

		"s_bull_crystalshard":
			if (_pow>48):bullet_spr.frame = 10
			elif (_pow>40):bullet_spr.frame = 9
			elif (_pow>32):bullet_spr.frame = 8
			elif (_pow>24):bullet_spr.frame = 7
			elif (_pow>20):bullet_spr.frame = 6
			elif (_pow>16):bullet_spr.frame = 5
			elif (_pow>12):bullet_spr.frame = 4
			elif (_pow>8):bullet_spr.frame = 3
			elif (_pow>4):bullet_spr.frame = 2
			elif (_pow>2):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = [1,-1].pick_random()
			bullet_spriteTurn = true;
		
		"s_bull_diamond", "s_bull_diamondShard":
			if (_pow>100):bullet_spr.frame = 10
			elif (_pow>80):bullet_spr.frame = 9
			elif (_pow>60):bullet_spr.frame = 8
			elif (_pow>50):bullet_spr.frame = 7
			elif (_pow>40):bullet_spr.frame = 6
			elif (_pow>32):bullet_spr.frame = 5
			elif (_pow>24):bullet_spr.frame = 4
			elif (_pow>16):bullet_spr.frame = 3
			elif (_pow>10):bullet_spr.frame = 2
			elif (_pow>5):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			## TODO if(sprite_index==s_bull_diamondShard):bullet_spriteTurn = true
			## TODO else: image_angle = startAngle
		
		##/IMAGINARY
		"emptySprite":
			hide()
		
		"s_bull_pinataShot":
			bullet_spr.frame = clamp(0, 21, (_pow/6) - 2 + randi_range(0,4) );
			if(speedBonus>1.5):speedBonus = 1
			scale.y = [1,-1].pick_random()
			## TODO image_angle = choose(0,90,180,270);
			bullet_spriteTurn = false;
			bulletSpin = [1,-1].pick_random() * ( 5.0 + randf_range(0,20) );
			## TODO var dr = point_direction(0,0,move_x,move_y);
			@warning_ignore("narrowing_conversion")
			var amnt : int = floor(1 + _pow / 20 + randi_range(0, _pow / 10 ) )
			
			## TODO Disabled the bellow temporarelly
			#repeat(amnt)
				#var sprng = random(amnt/2);
				#var sppos = random(360);
				#obj = instance_create(x+lengthdir_x(sprng,sppos),y+lengthdir_y(sprng,sppos),o_papershredEffect);
				#var tdir = dr - 20+random(40);
				#var spdMd = 0.25+random(0.50);
				#obj.move_x = lengthdir_x(move_dist*spdMd,tdir);
				#obj.move_y = lengthdir_y(move_dist*spdMd,tdir);
				#obj.z = z;
				#obj.move_friction = 0.1;
				#obj.gravity_z = 1;
				#obj.dny = dny;
				#obj.image_blend = make_color_hsv(irandom(255),220,255);
			## TODO
		
		"s_bull_teashot":
			if (_pow>60):bullet_spr.frame = 5
			elif (_pow>40):bullet_spr.frame = 4
			elif (_pow>20):bullet_spr.frame = 3
			elif (_pow>10):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			bullet_spriteTurn = true;
			steamTimer = 5 + _pow / 3;
			steamInterval = 4;
			steamStop = 3;
			speedBonus = 1;
		
		"s_bull_flyshot":
			flyflutter = 0;
			flyBaseframe = 0;
			if (_pow>40):		flyBaseframe = 8
			elif (_pow>20):		flyBaseframe = 6
			elif (_pow>10):		flyBaseframe = 4
			elif (_pow>4):		flyBaseframe = 2
			bullet_spriteTurn = true;
			speedBonus = 1;
		
		"s_bull_aerogel":
			if(speedBonus>1.5):speedBonus = 1
			bullet_spriteTurn = false;
			bullet_spr.frame = clamp(0,17,_pow/6)
			if(_pow>3): bullet_spr.frame +=1
			self_modulate.a = 0.3;
		
		# Untamonium
		"s_bull_untamonium_med":
			if(_pow>48):		bullet_spr.animation = "s_bull_untamonium_large"
			elif (_pow>24):		bullet_spr.animation = "s_bull_untamonium_med"
			elif (_pow>12):		bullet_spr.animation = "s_bull_untamonium_small"
			else: 				bullet_spr.animation = "s_bull_untamonium_tiny"
			scale.x = 1;
			scale.y = 1;
			image_speed = 0.25;
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
		
		"s_bull_untamonium_bfg":
			specialBFG = true;
			specialShot = "goo";
			var scl = 1;
			scl = clamp(0.5,2,_pow / 70);
			image_speed = 0.25;
			scale.x = scl;
			scale.y = scl;
			specialBFG = true;

func play_sound(soundID : String, loop : bool) -> void:
	var sound_file = load( B2_Sound.get_sound(soundID) )
	if sound_file:
		sound_file.loop = loop
		bullet_sfx.stream = sound_file
		bullet_sfx.pitch_scale = randf_range(0.85,1.25)
		bullet_sfx.play()
	else:
		push_error("Invalid sound file for sound ID %s." % soundID)

func _physics_process(delta: float) -> void:
	if DEBUG: queue_redraw() ## Display debug info
	
	## Temp bullet direction var. Used to manipulate the bullet direction without messing with the original direction.
	var bullet_dir := dir
	
	if is_lobbed:
		vertical_speed -= lobGravity * delta
		#bullet_spr.offset = Vector2(0,bullet_height).rotated( bullet_spr.rotation )
		#
		#bullet_height += bullet_vert_speed
		#
		#bullet_vert_speed += BULLET_GRAVITY * delta
		#
		#if bullet_height > 16.0:
			#print("Bullet hit the flooooooooooor.")
			#if my_gun.weapon_stats.bExplode:
				#_make_explosion()
			#destroy_bullet( false )
		
		pass
	
	## Move the bullet
	position 	+= ( (bullet_dir * speed) * speedBonus ) * delta
		
	## Apply acceleration. This may speed up or speed down the bullet.
	speed = clampf( speed + (acceleration * delta), min_speed, max_speed )
	
	## Check if the bullet collided with something.
	check_collision()

func flash_bullet( state : bool ) -> void:
	if bullet_spr:
		bullet_spr.material.set_shader_parameter( "hit_effect", 0.6 * float(state) )
	else:
		# No combat weapon????
		breakpoint

func check_collision() -> void:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()#.create(global_position, global_position + Vector2(0, 1))
	params.collide_with_areas 	= false
	params.collide_with_bodies 	= true
	#params.exclude = [ get_rid(), source_actor.get_rid() ]
	params.exclude = [ source_actor.get_rid() ]
	params.collision_mask 		= 1 & 3
	params.position 			= global_position + bullet_spr.offset
	var result : Array[Dictionary] = space_state.intersect_point(params)
	if result:
		for r : Dictionary in result:
			if r["collider"] is Node2D:
				_on_body_entered( r["collider"] )
			else:
				print( "%s: invalid collider -> %s" % [name, r] )

func ricochet( ric_dir : Vector2 ) -> void:
	var rico 			= O_RICOCHET.instantiate()
	#rico.ricochetSound 	= ricochetSound
	rico.scale 			= scale
	rico.position 		= position + bullet_spr.offset
	add_sibling( rico, true )
	rico.look_at( position + ric_dir.rotated( randf_range( -PI/8, PI/8 ) ) )
	
func destroy_bullet( rico := true ) -> void:
	shadow_visible = false
	if rico: ## 19/12/25 Ricochet sound is disabled by default.
		ricochet( dir.rotated( randf_range(-0.3,0.3) ) )
	var t := 0.0
	if smoke_trail: smoke_trail.emitting = false; 				t = 2.0
	if bullet_motion_blur: bullet_motion_blur.emitting = false;	t = 2.0
	if bullet_super_trail: bullet_super_trail.emitting = false;	t = 2.0
	set_physics_process( false )
	set_process( false )
	queue_redraw() # hides shadow
	var tween := create_tween()
	#t.tween_property( bullet_spr, "self_modulate", Color.TRANSPARENT, 0.1 )
	tween.tween_callback( bullet_spr.hide )
	if t > 0.0: tween.tween_interval( t )
	tween.tween_callback( queue_free )

func _on_body_entered( body: Node2D ) -> void:
	if body == source_actor:
		## ignore collisions with source actor (unless it ricochets)
		return
		
	if body is B2_Player_TurnBased:
		# can hit yourself if its a ricochet
		## TODO
		pass
		
	if body is B2_CombatActor:
		if my_gun.weapon_stats.bExplode:
			if my_gun.weapon_stats.bExplodeOnEnemy:
				_make_explosion()
				destroy_bullet( false )
				return

		if not body.is_actor_dead: ## Avoid shooting dead bodies.
			if body.has_method("damage_actor"):
				#var my_att := my_gun.get_pow()
				
				body.damage_actor( _pow , dir.normalized() * _pow * 100.0 )
				#body.damage_actor( 100, 		velocity.normalized() * att * 100.0 ); push_warning("DEBUG DAMAGE") ## DEBUG
				print( "Bullet applying %s points of damage." % str(_pow) )
				
			destroy_bullet()
		
	if body is CollisionObject2D:
		## TODO add damage to enemies and entities
		destroy_bullet()
		
	if body is TileMapLayer:
		## TODO add bullet ricochet
		# I was running into issues with the ricochet code, mostly because of tilemap colision shapes.
		# 21/03/25 oh shit, Godot 4.5 might acually fix this. https://github.com/godotengine/godot/pull/102662
		# 20/11/25 Fix what?? Dont remember What i meant by that.
		if my_gun.weapon_stats.bExplode:
			if my_gun.weapon_stats.bExplodeOnEnemy:
				_make_explosion()
				destroy_bullet( false )
				return
		
		source_actor = null
		destroy_bullet() ## temp

## CRITICAL ->> https://youtu.be/R22zSrpeSA4?t=44
func _make_explosion() -> void:
	var asplode 				: AnimatedSprite2D = load(B2_Gun.O_EXPLOSION).instantiate()
	assert( is_instance_valid(asplode), "WTF is the explosion null?????" )
	asplode.my_gun 				= my_gun
	asplode.global_position 	= global_position + bullet_spr.offset
	add_sibling( asplode, true )

# Bullet is outside the screen. remove it.
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_bullet_life_timeout() -> void:
	destroy_bullet()

func _draw() -> void:
	if shadow_visible: ## Cast shadow without making a new node.
		var bull_text := bullet_spr.sprite_frames.get_frame_texture( bullet_spr.animation, bullet_spr.frame )
		draw_set_transform( Vector2(0,16), bullet_spr.rotation, bullet_spr.scale )
		draw_texture( bull_text, Vector2(0,0), Color("00000080") )
	
	if DEBUG: # Display some debug data related to the bullet.
		const FN_SMALL = preload("uid://c5asr1c5g1w6h")
		draw_string( FN_SMALL, Vector2(0,0), 	"speed: %s" % snappedf(speed, 0.01),							HORIZONTAL_ALIGNMENT_LEFT)
		draw_string( FN_SMALL, Vector2(0,8), 	"accel: %s" % acceleration, 									HORIZONTAL_ALIGNMENT_LEFT)
		draw_string( FN_SMALL, Vector2(0,16), 	"lifetime: %s" % snappedf(bullet_life.time_left, 0.01), 		HORIZONTAL_ALIGNMENT_LEFT)
		draw_string( FN_SMALL, Vector2(0,24), 	"v_speed: %s" % vertical_speed,									HORIZONTAL_ALIGNMENT_LEFT)
		draw_string( FN_SMALL, Vector2(0,32), 	"altitude: %s" % altitude,										HORIZONTAL_ALIGNMENT_LEFT)
