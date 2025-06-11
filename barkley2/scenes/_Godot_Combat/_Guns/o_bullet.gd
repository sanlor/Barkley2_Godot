#extends Node2D
extends Area2D
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

const O_RICOCHET = preload("res://barkley2/scenes/_Godot_Combat/_Guns/ricochet/o_ricochet.tscn")

@onready var bullet_trail: Line2D 				= $bullet_trail
@onready var bullet_spr: AnimatedSprite2D 		= $bullet_spr
@onready var smoke_trail: GPUParticles2D 		= $smoke_trail
@onready var bullet_sfx: AudioStreamPlayer2D 	= $bullet_sfx
@onready var bullet_life: Timer 				= $bullet_life

var dir : Vector2
var speed := 5.0

## The gun that fired me
var my_gun : B2_Weapon

## The actor that fired me
var source_actor : B2_CombatActor

## Bullet trail
var has_trail		:= true
var trail_len 		:= 16

## Ricochet
var max_ricochet	:= 3

## Bullet mods
var superShot 			:= false
var motionBlur 			:= false
var bullet_spriteTurn 	:= false
var superTrail 			= 0;		## Trail for the periodic/super shot ##
var matName 			= "";		## Material name for the gun ##
var stoneSkipping 		= 0;		## Stone skipping movement for a bullet ## Must be init for Orichalcum
var paintball 			= 0;		## Paintball effect when bullet impacts with a combat actor ##
var lastDmg 			= 0;		## ??? ##
var lastHitKilled 		= false;	## If bullet kills something, this is used to count up the kill periodic charge ##
var lobAngledSprite 	= false;	## Angled sprite for vertically moving bullets ## Z axis ##
var wallRicochet 		= 0;		## Richochet off walls ##

var throughWalls 		= 0;
var rangeEndGrav 		= 0;
var accel 				= 0;
var maxspd 				= 48;
var minspd 				= 6;
var speedBonus 			= 1; 		##for rifles
var lobDirection 		= 0;
var lobGravity 			= 0;
var dotline 			= 0;
var dotlineAffix 		= false;
var spiraldir 			= 10;

var specialBFG 			= "";
var arrowShot 			= false;
var flaregun 			= false;
var rocketShot 			= false;
var bfgShot 			= false;
var bfgSparkTimer 		= 0;
var bfgFiredDirection 	= 0;

var image_angle ## ????
var bulletSpin ## ????
var specialShot ## ????

var ricochetSound := "ricochet"

## Godot bullet mods
# Damage Modifiers
var att								:= 1.0 ## Higher number = more powerful
var spd								:= 1.0 ## Higher number = faster
var acc								:= 1.0 ## Lower number = more acturate

# Attribute Modifiers
var bio_damage						:= 1.0 ## Add Bio damage type to this attack
var cyber_damage					:= 1.0 ## Add Cyber damage type to this attack
var mental_damage					:= 1.0 ## Add Mental damage type to this attack
var cosmic_damage					:= 1.0 ## Add Cosmic damage type to this attack
var zauber_damage					:= 1.0 ## Add Zauber damage type to this attack

## NOTE choice(1,-1) -> [1,-1].pick_random()

var spr := ""
var col := Color.WHITE

var velocity : Vector2

## Gamedev is my passion...
# here is the thing; this game uses too many bullet types. Making a bullet with a fuck ton of animations seems wasteful.
# my idea is this: lets make an animation on the fly! shouldnt impact the performance.
## NOTE forget that, I just added all animations using a convetion script. 11/03/25
func setup_bullet_sprite( _spr : String, _col : Color ) -> void:
	spr = _spr
	col = _col

func set_direction( _dir :Vector2 ) -> void:
	dir = _dir

func apply_stat_mods( _att : float, _spd : float ) -> void:
	att = _att
	spd = _spd

## TODO add modifiers
func apply_attribute_mods( _bio_damage : float, _cyber_damage : float, _mental_damage : float, _cosmic_damage : float, _zauber_damage : float, ) -> void:
	bio_damage = _bio_damage
	cyber_damage = _cyber_damage
	mental_damage = _mental_damage
	cosmic_damage = _cosmic_damage
	zauber_damage = _zauber_damage
	
func _ready() -> void:
	bullet_spr.animation = "s_bull"
	
	if spr:
		if bullet_spr.sprite_frames.has_animation( spr ):
			bullet_spr.animation = spr
		else:
			push_warning("No animation called %s." % spr)
	
	bullet_spr.look_at( dir.normalized() )
	bullet_spr.modulate = col
	sprite_selection()
	
	if has_trail:
		bullet_trail.show()
	else:
		bullet_trail.hide()
 
## based on some settings, some sprites can change. ## o_bullet alarm 0
func sprite_selection() -> void:
	var _pow := my_gun.att ## missing other stats
	
	match bullet_spr.animation:
	# NORMAL BULLETS #
		"s_bull":
			modulate = Color.YELLOW
			if !superShot:
				bullet_spr.animation = "s_physShot";
				motionBlur = true;
			else:
				bullet_spr.animation = "s_physShot";
			scale.x *= 1.0 # 1.5;
			scale.y *= 1.0 # 1.4;

		#/NORMAL CROSSBOWS
		"s_bull_arrowHead":
			bullet_spr.frame = clamp(floor(_pow / 10), 0, 7)
			bullet_spriteTurn = true;

		# CANDY 
		"s_bull_candyShot":
			bullet_spr.frame = clamp( 0, 21, (_pow/6) - 2 + randi_range(0,4) );
			if speedBonus>1.5:
				speedBonus = 1
			scale.y = [1,-1].pick_random()
			image_angle = [0,90,180,270].pick_random()
			bullet_spriteTurn = false;
			bulletSpin = [1,-1].pick_random() * ( 5 + randi_range(0,20) );       
			#var dr = point_direction(0,0,move_x,move_y);         

		# STONE
		"s_bull_stone":
			specialShot = "stone";

			if(_pow>32):
				bullet_spr.animation = "s_bull_stone_large"
			elif (_pow>16):
				bullet_spr.animation = "s_bull_stone"
			elif (_pow>8):
				bullet_spr.animation = "s_bull_stone_small"
			else:
				bullet_spr.animation = "s_bull_stone_tiny"
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
			if(_pow>32):
				bullet_spr.frame = 5
			elif (_pow>24):
				bullet_spr.frame = 4
			elif (_pow>18):
				bullet_spr.frame = 3
			elif (_pow>12):
				bullet_spr.frame = 2
			elif (_pow>6):
				bullet_spr.frame = 1
			else:
				bullet_spr.frame = 0
			lobAngledSprite = true;
			
			if(speedBonus>1.5):
				speedBonus = 1.5

		# MYTHRIL
		"s_bull_mythril":
			bullet_spr.frame = clamp( 0, 14, _pow/6 );
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;

		# BRONZE
		"s_bull_rusty":
			if(_pow>64):bullet_spr.frame = 8
			elif (_pow>48):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else:
				bullet_spr.frame = 0
			if(speedBonus>1.5): speedBonus = 1.5
			lobAngledSprite = true;

		# Foil
		"s_bull_foil":
			if(_pow>80):bullet_spr.frame = 9
			elif (_pow>64):bullet_spr.frame = 8
			elif (_pow>48):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
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
			if(_pow>80):bullet_spr.frame = 8
			elif (_pow>64):bullet_spr.frame = 7
			elif (_pow>48):bullet_spr.frame = 6
			elif (_pow>32):bullet_spr.frame = 5
			elif (_pow>24):bullet_spr.frame = 4
			elif (_pow>18):bullet_spr.frame = 3
			elif (_pow>12):bullet_spr.frame = 2
			elif (_pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			modulate.a = 0.6
			lobAngledSprite = true;
			if(speedBonus>1.5): speedBonus = 1.5  

		# NEON
		"s_bull_neon":
			## TODO 
			#neon = true;
			#neonHue = irandom(255);
			#neonSat = 0;
			#neonVal = 255;
			#neonSize = 0.2 + _pow/50;
			#neonTrail = 3;
			#colorBlend = make_color_hsv(neonHue,neonSat,neonVal);
			## TODO 
			if(speedBonus>1.2): speedBonus = 1.2
			specialBFG = true;


		"s_bull_neonGloworb":
			## TODO 
			#neonHue = irandom(255);
			#neonSat = 255;
			#neonVal = 255;
			#colorBlend = make_color_hsv(neonHue,neonSat,neonVal);
			#if(speedBonus>1.2):speedBonus = 1.2
			#useColorBlend = true;
			#image_speed = 0;
			## TODO 
			bullet_spr.frame = 1;

			var scl = _pow/80;
			scale.x = scl;
			scale.y = scl;
			bullet_spriteTurn = false;
			specialBFG = true;

		# COPPER
		"s_bull_copper":
			if(_pow>80):bullet_spr.frame = 7
			elif (_pow>48):bullet_spr.frame = 6
			elif (_pow>32):bullet_spr.frame = 5
			elif (_pow>24):bullet_spr.frame = 4
			elif (_pow>18):bullet_spr.frame = 3
			elif (_pow>12):bullet_spr.frame = 2
			elif (_pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1.5
			lobAngledSprite = true;
			

		# BRASS
		"s_bull_brass":
			#steamTimer = 5+_pow/3;
			#steamInterval = 4;
			#steamStop = 10;
			if(_pow>80):bullet_spr.frame = 10
			elif (_pow>64):bullet_spr.frame = 9
			elif (_pow>46):bullet_spr.frame = 8
			elif (_pow>38):bullet_spr.frame = 7
			elif (_pow>30):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			if(speedBonus>1.5):speedBonus = 1.5
			#Smoke("puff",x,y,z,2+max(5,_pow));
			smoke_trail.emitting = true
			has_trail = false
	

		"s_bull_polenta":
			if(_pow>80):bullet_spr.frame = 10
			elif (_pow>64):bullet_spr.frame = 9
			elif (_pow>46):bullet_spr.frame = 8
			elif (_pow>38):bullet_spr.frame = 7
			elif (_pow>30):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1
			lobAngledSprite = true;
			scale.y = [1,-1].pick_random()
	
		# FOAM
		"s_bull_foam":
			if(_pow>52):bullet_spr.frame = 4
			elif (_pow>32):bullet_spr.frame = 3
			elif (_pow>16):bullet_spr.frame = 2
			elif (_pow>8):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
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
			if(_pow>48):bullet_spr.frame = 3
			elif (_pow>24):bullet_spr.frame = 2
			elif (_pow>12):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.25):speedBonus = 1.25
			lobAngledSprite = true;
			specialBFG = true;
	
		# BONE
		"s_bull_bone":
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
	
		"s_bull_antimatter":
			## TODO holeObj = instance_create(x,y,o_cosmichole);
			## TODO holeObj.radiusbase = 4 + floor(_pow/3);
			## TODO holeObj.radiusShake = floor(_pow/4);
			if(speedBonus>1):speedBonus = 1
			## TODO antimatterTrail = 0;
			## TODO drawSprite = false;
			## TODO scr_entity_setShadowVisible(false);
	
		# BRONZE
		"s_bull_bronze":
			if(_pow>64):bullet_spr.frame = 8
			elif (_pow>48):bullet_spr.frame = 7
			elif (_pow>32):bullet_spr.frame = 6
			elif (_pow>24):bullet_spr.frame = 5
			elif (_pow>18):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>8):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1.5
			lobAngledSprite = true;
		
		"s_bull_orichal":
			#/bullet_spr.frame = 6 + clamp(0,13,floor(_pow/5)-1+irandom(2));
			#image_angle = 0;#/choose(0,90,180,270);
			if (_pow>140):bullet_spr.frame = 14
			elif (_pow>100):bullet_spr.frame = 13
			elif (_pow>80):bullet_spr.frame = 12
			elif (_pow>70):bullet_spr.frame = 11
			elif (_pow>60):bullet_spr.frame = 10
			elif (_pow>50):bullet_spr.frame = 9
			elif (_pow>40):bullet_spr.frame = 8
			elif (_pow>33):bullet_spr.frame = 7
			elif (_pow>26):bullet_spr.frame = 6
			elif (_pow>20):bullet_spr.frame = 5
			elif (_pow>12):bullet_spr.frame = 4
			elif (_pow>7):bullet_spr.frame = 3
			elif (_pow>4):bullet_spr.frame = 2
			else: bullet_spr.frame = 1
			ricochetSound = "hoopzweap_orichalcum_bounce";
			## TODO wobbleAnim = 2;
			## TODO orichalnim = 1
			stoneSkipping = 3;
			## TODO orichalFrame = image_index;
			specialBFG = true;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
	
		"s_bull_chitin_egg":
			if(_pow>110):bullet_spr.frame = 18
			elif (_pow>100):bullet_spr.frame = 17
			elif (_pow>90):bullet_spr.frame = 16
			elif (_pow>80):bullet_spr.frame = 15
			elif (_pow>70):bullet_spr.frame = 14
			elif (_pow>60):bullet_spr.frame = 13
			elif (_pow>50):bullet_spr.frame = 12
			elif (_pow>45):bullet_spr.frame = 11
			elif (_pow>40):bullet_spr.frame = 10
			elif (_pow>35):bullet_spr.frame = 9
			elif (_pow>30):bullet_spr.frame = 8
			elif (_pow>25):bullet_spr.frame = 7
			elif (_pow>20):bullet_spr.frame = 6
			elif (_pow>15):bullet_spr.frame = 5
			elif (_pow>12):bullet_spr.frame = 4
			elif (_pow>9):bullet_spr.frame = 3
			elif (_pow>6):bullet_spr.frame = 2
			elif (_pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.2):speedBonus = 1.0
	
		"s_bull_plantain":
			#/bullet_spr.frame = 6 + clamp(0,13,floor(_pow/5)-1+irandom(2));
			#image_angle = 0;#/choose(0,90,180,270);
			if(_pow>120):bullet_spr.frame = 13
			elif (_pow>100):bullet_spr.frame = 12
			elif (_pow>80):bullet_spr.frame = 11
			elif (_pow>70):bullet_spr.frame = 10
			elif (_pow>60):bullet_spr.frame = 9
			elif (_pow>50):bullet_spr.frame = 8
			elif (_pow>40):bullet_spr.frame = 7
			elif (_pow>33):bullet_spr.frame = 6
			elif (_pow>26):bullet_spr.frame = 5
			elif (_pow>20):bullet_spr.frame = 4
			elif (_pow>12):bullet_spr.frame = 3
			elif (_pow>7):bullet_spr.frame = 2
			elif (_pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0

			## TODO scale.x = choose(1,-1);
			## TODO scale.y = choose(1,-1);
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
			if(_pow>48):		bullet_spr.animation = "s_bull_goo_large"
			elif (_pow>24):	bullet_spr.animation = "s_bull_goo_med"
			elif (_pow>12):	bullet_spr.animation = "s_bull_goo_small"
			else: 			bullet_spr.animation = "s_bull_goo_tiny"
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
			if(_pow>64):bullet_spr.frame = 5
			elif (_pow>48):bullet_spr.frame = 4
			elif (_pow>24):bullet_spr.frame = 3
			elif (_pow>12):bullet_spr.frame = 2
			elif (_pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			
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
			if playedPapersound: B2_Sound.play("hoopzweap_origami_fly")
	
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
			if(_pow>96):bullet_spr.frame = 7
			elif (_pow>80):bullet_spr.frame = 6; trailScale = 0.9
			elif (_pow>64):bullet_spr.frame = 5; trailScale = 0.8
			elif (_pow>48):bullet_spr.frame = 4; trailScale = 0.6
			elif (_pow>32):bullet_spr.frame = 3; trailScale = 0.5
			elif (_pow>16):bullet_spr.frame = 2; trailScale = 0.4
			elif (_pow>8):bullet_spr.frame = 1; trailScale = 0.3
			else: bullet_spr.frame = 0;trailScale = 0.2
			scale.x = 1;
			scale.y = 1;

			if(matName=="Itano"):
				if(rocketShot):
					if(_pow<50):bullet_spr.frame += 1
					else: bullet_spr.animation = "s_bull_itanoRocket"
				if(bfgShot):
					if(_pow<50):bullet_spr.frame += 2
					else: bullet_spr.animation = "s_bull_itanoBFG"
			lobAngledSprite = true;
			# Play a looping exhaust effect on rockets, create sound emitter for this.
			play_sound( "hoopzweap_rocket_exhaust", true );
		
		"s_bull_offal":
			speedBonus = 1;
			bullet_spr.frame = clamp(0, 15, floor(_pow / 8) - 2 + randi_range(0,4) );
			scale.x = 1;
			## TODO scale.y = choose(-1,1);
			specialBFG = true;
			## TODO bloodTrail = 1+irandom(6);
	
		"s_bull_blood":
			speedBonus = 1;
			specialShot = "blood";
			specialBFG = true;
			bullet_spr.frame = clamp(0,7,floor(_pow / 12));
			scale.x = 1;
			## TODO scale.y = choose(-1,1);
			## TODO bloodTrail = 1+irandom(6);
			lobAngledSprite = true;
			if(bfgShot):
				bullet_spr.animation = "s_bull_bloodBFG"; 
				bullet_spr.speed_scale = 0.1; 
				scale.y = 1; 
				bullet_spriteTurn = false
	
		"s_bull_soiled":
			speedBonus = 1;
			bullet_spr.frame = clamp(0,7,floor(_pow / 12));
			scale.x = 1;
			## TODO scale.y = choose(-1,1);
			## TODO bloodTrail = 1+irandom(6);
		
		"s_bull_tofu1":
			if(_pow>64):		bullet_spr.animation = "s_bull_tofu5"
			elif (_pow>32):	bullet_spr.animation = "s_bull_tofu4"
			elif (_pow>16):	bullet_spr.animation = "s_bull_tofu3"
			elif (_pow>8):	bullet_spr.animation = "s_bull_tofu2"
			else: 			bullet_spr.animation = "s_bull_tofu1"
			## TODO image_angle = choose(0,90,180,270);
			## TODO image_speed = 0.25;
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
			## TODO scale.y = choose(1,-1);
			## TODO grassTimer = 0.2;
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
			#if(speedBonus>1.2):speedBonus = 1.2
			#scale.x = 1;
			#scale.y = choose(1,-1);
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
			#motionBlur = true;
			#scale.x = 1;
			#scale.y = 1;
			#image_speed = 0.2;
			#franciumMax = 1;
			#if(_pow<3):franciumMax = 0.06
			#elif(_pow<6):franciumMax = 0.1
			#elif(_pow<12):franciumMax = 0.2
			#elif(_pow<18):franciumMax = 0.3
			#elif(_pow<24):franciumMax = 0.4
			#elif(_pow<30):franciumMax = 0.5
			#elif(_pow<40):franciumMax = 0.6
			#elif(_pow<50):franciumMax = 0.7
			#elif(_pow<60):franciumMax = 0.8
			#elif(_pow<70):franciumMax = 0.9
			#elif(_pow<80):franciumMax = 1
			#elif(_pow<100):franciumMax = 1.1
			#elif(_pow<120):franciumMax = 1.2
			#elif(_pow<140):franciumMax = 1.3
			#elif(_pow<180):franciumMax = 1.4
			#elif(_pow<220):franciumMax = 1.5
			#elif(_pow<240):franciumMax = 1.6
			#elif(_pow<260):franciumMax = 1.7
			#elif(_pow<280):franciumMax = 1.8
			#elif(_pow<300):franciumMax = 1.9
			#else: franciumMax = 2
#
			#image_angle = choose(0,90,180,270);
			#shadow_visible = false;
			#show_hiteffect = false;
			#franciumScale = 0.01;
			#scale.x = franciumMax*franciumScale;
			#scale.y = franciumMax*franciumScale;
			#bullet_spriteTurn = false;
			#if(speedBonus>1.2):speedBonus = 1.2
			#if (!audio_is_playing_ext(franciumSnd)):
				#scr_entity_makeSoundEmitter();
				#audio_play_sound_on_actor(id,franciumSnd, true, 0);
			## TODO 
			pass
			
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
			#scale.x = 1;
			#scale.y = 1;
			#if(speedBonus>1.2):speedBonus = 1; accel = accel*2; move_dist= (move_dist+1)*2
#
			#bullet_spriteTurn = false;
			#wingSprite = "noone";
			#wingFrame = 0;
			## TODO 
			if(_pow>200):bullet_spr.frame = 13
			elif (_pow>160):bullet_spr.frame = 12
			elif (_pow>140):bullet_spr.frame = 11
			elif (_pow>120):bullet_spr.frame = 10
			elif (_pow>96):bullet_spr.frame = 9
			elif (_pow>84):bullet_spr.frame = 8
			elif (_pow>72):bullet_spr.frame = 7
			elif (_pow>60):bullet_spr.frame = 6
			elif (_pow>48):bullet_spr.frame = 5
			elif (_pow>36):bullet_spr.frame = 4
			elif (_pow>24):bullet_spr.frame = 3
			elif (_pow>12):bullet_spr.frame = 2
			elif (_pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			
			## TODO 
			#if(image_index==0):wingSprite 		= "s_bull_angel_tiny"
			#elif(image_index<=2):wingSprite 	= "s_bull_angel_small"
			#elif(image_index<=4):wingSprite 	= "s_bull_angel_medium"
			#elif(image_index<=6):wingSprite 	= "s_bull_angel_large"
			#elif(image_index<=8):wingSprite 	= "s_bull_angel_huge"
			#else: wingSprite = "s_bull_angel_giant"
#
			#var featherCount = 1;
			#if(_pow>240):featherCount 	= 3+irandom(6)
			#elif(_pow>120):featherCount 	= 2+irandom(4)
			#elif(_pow>60):featherCount 	= 1+irandom(3)
			#elif(_pow>30):featherCount 	= 1+irandom(2)
			#elif(_pow>15):featherCount 	= 1+irandom(1)
			#else: featherCount 			= 1
			## TODO 
			if(bfgShot):
				## TODO featherCount = featherCount*2; 
				bullet_spr.animation = "s_bull_angelBFG"
				bullet_spr.frame = 0; 
				## TODO wingSprite = "noone"

			specialShot = "angel";

			## TODO featherInterval = 10;
			## TODO featherNext = irandom(featherInterval);
			
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
			## TODO scale.y = choose(1,-1);
			bullet_spriteTurn = true;
			lobAngledSprite = true;
			## TODO sinewparts = 0.2;
		

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
			#match laserGen:
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
			## TODO scale.y = choose(1,-1);
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
			## TODO plantInterval = max(0.1,(7-_pow/10)/6);
			## TODO plantNext = random(plantInterval);
			## TODO plantSize = 5+_pow;
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
			## TODO scale.y = choose(1,-1);
			bullet_spriteTurn = true;

			## TODO steamTimer = 4+_pow/3;
			## TODO steamInterval = 4;
			## TODO steamStop = 6;
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
			## TODO scale.y = choose(1,-1);
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
			## TODO scale.x = choose(1,-1);
			## TODO scale.y = choose(1,-1);
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
			## TODO scale.y = choose(1,-1);
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
			## TODO scale.y = choose(1,-1);
			## TODO image_angle = choose(0,90,180,270);
			bullet_spriteTurn = false;
			## TODO bulletSpin = choose(1,-1)*(5+irandom(20));

			## TODO var dr = point_direction(0,0,move_x,move_y);
			## TODO amnt = floor(1 + _pow/20 + irandom(_pow/10))
			
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
			## TODO steamTimer = 5+_pow/3;
			## TODO steamInterval = 4;
			## TODO steamStop = 3;
			speedBonus = 1;
		
		"s_bull_flyshot":
			## TODO 
			#flyflutter = 0;
			#flyBaseframe = 0;
			#if (_pow>40):flyBaseframe = 8
			#elif (_pow>20):flyBaseframe = 6
			#elif (_pow>10):flyBaseframe = 4
			#elif (_pow>4):flyBaseframe = 2
			#bullet_spriteTurn = true;
			#speedBonus = 1;
			## TODO 
			pass
		
		"s_bull_aerogel":
			if(speedBonus>1.5):speedBonus = 1
			bullet_spriteTurn = false;
			bullet_spr.frame = clamp(0,17,_pow/6);
			if(_pow>3): bullet_spr.frame +=1
			modulate.a = 0.3;
		
		# Untamonium
		"s_bull_untamonium_med":
			if(_pow>48):		bullet_spr.animation = "s_bull_untamonium_large"
			elif (_pow>24):	bullet_spr.animation = "s_bull_untamonium_med"
			elif (_pow>12):	bullet_spr.animation = "s_bull_untamonium_small"
			else: 			bullet_spr.animation = "s_bull_untamonium_tiny"
			scale.x = 1;
			scale.y = 1;
			## TODO image_speed = 0.25;
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
		

		"s_bull_untamonium_bfg":
			#specialBFG = true;
			#specialShot = "goo";
			var scl = 1;
			scl = clamp(0.5,2,_pow / 70);
			## TODO image_speed = 0.25;
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

func _physics_process(_delta: float) -> void:
	velocity = dir * speed
	velocity *= spd ## Apply speed modifier
	position += velocity ## TEMP
	
	if has_trail:
		## Update trail
		bullet_trail.add_point( global_position )
		if bullet_trail.get_point_count() > trail_len:
			bullet_trail.remove_point(0)

func ricochet( ric_dir : Vector2 ) -> void:
	var rico 			= O_RICOCHET.instantiate()
	rico.ricochetSound 	= ricochetSound
	rico.scale 			= scale
	rico.position 		= position
	add_sibling( rico, true )
	rico.look_at( position + ric_dir.rotated( randf_range( -PI/8, PI/8 ) ) )
	
func destroy_bullet() -> void:
	ricochet( - dir )
	queue_free() ## add a tween, fade bullet out.

func _on_body_entered( body: Node2D ) -> void:
	if body == source_actor:
		## ignore collisions with source actor (unless it ricochets)
		return
		
	if body is B2_HoopzCombatActor:
		# can hit yourself if its a ricochet
		## TODO
		pass
		
	if body is B2_CombatActor:
		if not body.is_actor_dead: ## Avoid shooting dead bodies.
			if body.has_method("damage_actor"):
				var my_att := my_gun.get_att()
				my_att *= att ## Apply attack modifier
				body.damage_actor( clampi( my_att / float(my_gun.bullets_per_shot ), 1, 999 ) , 	velocity.normalized() * my_att * 100.0 )
				#body.damage_actor( 100, 		velocity.normalized() * att * 100.0 ); push_warning("DEBUG DAMAGE") ## DEBUG
				print( "Bullet applying %s points of damage." % str(my_att) )
				
			destroy_bullet()
		
	if body is CollisionObject2D:
		## TODO add damage to enemies and entities
		destroy_bullet()
		
	if body is TileMapLayer:
		## TODO add bullet ricochet
		# I was running into issues with the ricochet code, mostly because of tilemap colision shapes.
		# 21/03 oh shit, Godot 4.5 might acually fix this. https://github.com/godotengine/godot/pull/102662
		source_actor = null
		destroy_bullet() ## temp

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	await get_tree().create_timer(1.0).timeout
	queue_free()

func _on_bullet_life_timeout() -> void:
	destroy_bullet()
