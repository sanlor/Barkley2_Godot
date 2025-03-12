extends Node2D
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

@onready var bullet_trail: 	Line2D 				= $bullet_trail
@onready var bullet_spr: 	AnimatedSprite2D 	= $bullet_spr

var dir : Vector2
var speed := 5.0

## The gun that fired me
var my_gun : B2_Weapon

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

## NOTE choice(1,-1) -> [1,-1].pick_random()

func set_direction( _dir :Vector2 ) -> void:
	dir = _dir

## Gamedev is my passion...
# here is the thing; this game uses too many bullet types. Making a bullet with a fuck ton of animations seems wasteful.
# my idea is this: lets make an animation on the fly! shouldnt impact the performance.
## NOTE forget that, I just added all animations using a convetion script. 11/03/25
func setup_bullet_sprite( spr : String, col : Color ) -> void:
	if spr:
		if bullet_spr.sprite_frames.has_animation( spr ):
			bullet_spr.animation = spr
			bullet_spr.look_at( position + dir )
		else:
			push_warning("No animation called %s." % spr)
		
	modulate = col
	sprite_selection()

func enable_trail() -> void:
	pass

## based on some settings, some sprites can change.
func sprite_selection() -> void:
	var pow := my_gun.att ## missing other stats
	
	match bullet_spr.animation:
	# NORMAL BULLETS #
		"s_bull":
			modulate = Color.YELLOW
			if !superShot:
				bullet_spr.animation = "s_physShot";
				motionBlur = true;
			else:
				bullet_spr.animation = "s_physShot";
			scale.x *= 1.5;
			scale.y *= 1.4;

		#/NORMAL CROSSBOWS
		"s_bull_arrowHead":
			bullet_spr.frame = clamp(floor(pow / 10), 0, 7)
			bullet_spriteTurn = true;

		# CANDY 
		"s_bull_candyShot":
			bullet_spr.frame = clamp( 0, 21, (pow/6) - 2 + randi_range(0,4) );
			if speedBonus>1.5:
				speedBonus = 1
			scale.y = choose(1,-1);
			image_angle = choose(0,90,180,270);
			bullet_spriteTurn = false;
			bulletSpin = choose(1,-1)*(5+irandom(20));        
			var dr = point_direction(0,0,move_x,move_y);         

		# STONE
		"s_bull_stone":
			specialShot = "stone";

			if(pow>32):
				bullet_spr.frame = "s_bull_stone_large"
			elif (pow>16):
				bullet_spr.frame = "s_bull_stone"
			elif (pow>8):
				bullet_spr.frame = "s_bull_stone_small"
			else:
				bullet_spr.frame = "s_bull_stone_tiny"
			image_angle = choose(0,90,180,270);
			if bfgShot:
				bullet_spr.frame = "s_bull_stone_moai"; 
				image_angle = 0;
				scr_entity_makeSoundEmitter();
				audio_play_sound_on_actor(id,"hoopzweap_stone_moai", false, 0);
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if (speedBonus>1.2):
				speedBonus = 1.2
			specialBFG = true;

		# CARBON
		"s_bull_carbon":
			if(pow>32):
				bullet_spr.frame = 5
			elif (pow>24):
				bullet_spr.frame = 4
			elif (pow>18):
				bullet_spr.frame = 3
			elif (pow>12):
				bullet_spr.frame = 2
			elif (pow>6):
				bullet_spr.frame = 1
			else:
				bullet_spr.frame = 0
			lobAngledSprite = true;
			
			if(speedBonus>1.5):
				speedBonus = 1.5

		# MYTHRIL
		"s_bull_mythril":
			bullet_spr.frame = clamp( 0, 14, pow/6 );
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;

		# BRONZE
		"s_bull_rusty":
			if(pow>64):bullet_spr.frame = 8
			elif (pow>48):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else:
				bullet_spr.frame = 0
			if(speedBonus>1.5): speedBonus = 1.5
			lobAngledSprite = true;

		# Foil
		"s_bull_foil":
			if(pow>80):bullet_spr.frame = 9
			elif (pow>64):bullet_spr.frame = 8
			elif (pow>48):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5): speedBonus = 1.5
			lobAngledSprite = true;
			scale.y = [1,-1].pick_random();

		# SALT
		"s_bull_salt":
			bullet_spr.frame = floor(min(19,pow))
			image_angle = [0,90,180,270].pick_random();
			scale.x = 1;
			scale.y = 1;
			saltTrail = 1;
			if(speedBonus>1.2): speedBonus = 1.2

		# GLASS
		"s_bull_glass_light":
			if(pow>80):bullet_spr.frame = 8
			elif (pow>64):bullet_spr.frame = 7
			elif (pow>48):bullet_spr.frame = 6
			elif (pow>32):bullet_spr.frame = 5
			elif (pow>24):bullet_spr.frame = 4
			elif (pow>18):bullet_spr.frame = 3
			elif (pow>12):bullet_spr.frame = 2
			elif (pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			image_alpha = 0.6;
			lobAngledSprite = true;
			if(speedBonus>1.5): speedBonus = 1.5  

		# NEON
		"s_bull_neon":
			neon = true;
			neonHue = irandom(255);
			neonSat = 0;
			neonVal = 255;
			neonSize = 0.2 + pow/50;
			neonTrail = 3;
			colorBlend = make_color_hsv(neonHue,neonSat,neonVal);
			if(speedBonus>1.2): speedBonus = 1.2
			specialBFG = true;


		"s_bull_neonGloworb":
			neonHue = irandom(255);
			neonSat = 255;
			neonVal = 255;
			colorBlend = make_color_hsv(neonHue,neonSat,neonVal);
			if(speedBonus>1.2):speedBonus = 1.2
			useColorBlend = true;
			image_speed = 0;
			bullet_spr.frame = 1;

			var scl = pow/80;
			scale.x = scl;
			scale.y = scl;
			bullet_spriteTurn = false;
			specialBFG = true;

		# COPPER
		"s_bull_copper":
			if(pow>80):bullet_spr.frame = 7
			elif (pow>48):bullet_spr.frame = 6
			elif (pow>32):bullet_spr.frame = 5
			elif (pow>24):bullet_spr.frame = 4
			elif (pow>18):bullet_spr.frame = 3
			elif (pow>12):bullet_spr.frame = 2
			elif (pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1.5
			lobAngledSprite = true;
			

		# BRASS
		"s_bull_brass":
			steamTimer = 5+pow/3;
			steamInterval = 4;
			steamStop = 10;
			if(pow>80):bullet_spr.frame = 10
			elif (pow>64):bullet_spr.frame = 9
			elif (pow>46):bullet_spr.frame = 8
			elif (pow>38):bullet_spr.frame = 7
			elif (pow>30):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			if(speedBonus>1.5):speedBonus = 1.5
			Smoke("puff",x,y,z,2+max(5,pow));
	

		"s_bull_polenta":
			if(pow>80):bullet_spr.frame = 10
			elif (pow>64):bullet_spr.frame = 9
			elif (pow>46):bullet_spr.frame = 8
			elif (pow>38):bullet_spr.frame = 7
			elif (pow>30):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1
			lobAngledSprite = true;
			scale.y = choose(1,-1);
	
		# FOAM
		"s_bull_foam":
			if(pow>52):bullet_spr.frame = 4
			elif (pow>32):bullet_spr.frame = 3
			elif (pow>16):bullet_spr.frame = 2
			elif (pow>8):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.25):speedBonus = 1.25
			if(bfgShot):
				bullet_spr.frame = "s_bull_plasticBFG";
				bullet_spriteTurn = false;
				anglespray = -90;
				spraytimer = 1;
				rangeEndGrav = 0;
			else:
				lobAngledSprite = true;
			specialBFG = true;
	

		# RUBBER
		"s_bull_rubber":
			if(pow>48):bullet_spr.frame = 3
			elif (pow>24):bullet_spr.frame = 2
			elif (pow>12):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.25):speedBonus = 1.25
			lobAngledSprite = true;
			specialBFG = true;
	
		# BONE
		"s_bull_bone":
			specialShot = "bone";
			if(image_index==0):
				bullet_spr.frame = 6 + clamp(0,11,floor(pow/5)-1+irandom(2));
				image_angle = choose(0,90,180,270);
				scale.x = 1;
				scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			if(rocketShot):bullet_spr.frame = s_bull_boneRocket
			if(bfgShot):
				boneTrail = 0.1;
				boneSpawnX = x;
				boneSpawnY = y;
				bullet_spr.frame = s_bull_boneBFG;
				tailLength = 0;
				tailPos = min(15,floor(pow/5));
				tailRemaining = floor(pow/5);
				if(wave<20):wave = 20
				if(waveAmp<20):waveAmp = 20
				bullet_spriteTurn = true;
			specialBFG = true;
	
		"s_bull_antimatter":
			holeObj = instance_create(x,y,o_cosmichole);
			holeObj.radiusbase = 4 + floor(pow/3);
			holeObj.radiusShake = floor(pow/4);
			if(speedBonus>1):speedBonus = 1
			antimatterTrail = 0;
			drawSprite = false;
			scr_entity_setShadowVisible(false);
	
		# BRONZE
		"s_bull_bronze":
			if(pow>64):bullet_spr.frame = 8
			elif (pow>48):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(speedBonus>1.5):speedBonus = 1.5
			lobAngledSprite = true;
		
		"s_bull_orichal":
			#/bullet_spr.frame = 6 + clamp(0,13,floor(pow/5)-1+irandom(2));
			#image_angle = 0;#/choose(0,90,180,270);
			if (pow>140):bullet_spr.frame = 14
			elif (pow>100):bullet_spr.frame = 13
			elif (pow>80):bullet_spr.frame = 12
			elif (pow>70):bullet_spr.frame = 11
			elif (pow>60):bullet_spr.frame = 10
			elif (pow>50):bullet_spr.frame = 9
			elif (pow>40):bullet_spr.frame = 8
			elif (pow>33):bullet_spr.frame = 7
			elif (pow>26):bullet_spr.frame = 6
			elif (pow>20):bullet_spr.frame = 5
			elif (pow>12):bullet_spr.frame = 4
			elif (pow>7):bullet_spr.frame = 3
			elif (pow>4):bullet_spr.frame = 2
			else: bullet_spr.frame = 1
			ricochetSound = "hoopzweap_orichalcum_bounce";
			wobbleAnim = 2;
			orichalnim = 1
			stoneSkipping = 3;
			orichalFrame = image_index;
			specialBFG = true;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
	
		"s_bull_chitin_egg":
			if(pow>110):bullet_spr.frame = 18
			elif (pow>100):bullet_spr.frame = 17
			elif (pow>90):bullet_spr.frame = 16
			elif (pow>80):bullet_spr.frame = 15
			elif (pow>70):bullet_spr.frame = 14
			elif (pow>60):bullet_spr.frame = 13
			elif (pow>50):bullet_spr.frame = 12
			elif (pow>45):bullet_spr.frame = 11
			elif (pow>40):bullet_spr.frame = 10
			elif (pow>35):bullet_spr.frame = 9
			elif (pow>30):bullet_spr.frame = 8
			elif (pow>25):bullet_spr.frame = 7
			elif (pow>20):bullet_spr.frame = 6
			elif (pow>15):bullet_spr.frame = 5
			elif (pow>12):bullet_spr.frame = 4
			elif (pow>9):bullet_spr.frame = 3
			elif (pow>6):bullet_spr.frame = 2
			elif (pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.2):speedBonus = 1.0
	
		"s_bull_plantain":
			#/bullet_spr.frame = 6 + clamp(0,13,floor(pow/5)-1+irandom(2));
			#image_angle = 0;#/choose(0,90,180,270);
			if(pow>120):bullet_spr.frame = 13
			elif (pow>100):bullet_spr.frame = 12
			elif (pow>80):bullet_spr.frame = 11
			elif (pow>70):bullet_spr.frame = 10
			elif (pow>60):bullet_spr.frame = 9
			elif (pow>50):bullet_spr.frame = 8
			elif (pow>40):bullet_spr.frame = 7
			elif (pow>33):bullet_spr.frame = 6
			elif (pow>26):bullet_spr.frame = 5
			elif (pow>20):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>7):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0

			scale.x = choose(1,-1);
			scale.y = choose(1,-1);
			lobAngledSprite = true;
			bullet_spriteTurn = true;
			specialBFG = true;
	
		# JUNK
		"s_bull_junk":
			bullet_spr.frame = 7 + clamp(0,27,floor(pow/3)-1+irandom(2));
			image_angle = choose(0,90,180,270);
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2): speedBonus = 1.2
			if(arrowShot):
				bullet_spr.frame = s_bull_plunger;
				bullet_spr.frame = clamp(pow/12,0,3);
				bullet_spriteTurn = true;
			specialBFG = true;
	
		# GOO
		"s_bull_goo_med":
			if(pow>48):bullet_spr.frame = s_bull_goo_large
			elif (pow>24):bullet_spr.frame = s_bull_goo_med
			elif (pow>12):bullet_spr.frame = s_bull_goo_small
			else: bullet_spr.frame = s_bull_goo_tiny
			scale.x = 1;
			scale.y = 1;
			image_speed = 0.25;
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
	
		"s_bull_goo_bfg":
			specialBFG = true;
			specialShot = "goo";
			var scl = 1;
			scl = clamp(0.5,2,pow / 40);
			image_speed = 0.25;
			scale.x = scl;
			scale.y = scl;
			specialBFG = true;
	
		##PAPER
		"s_bull_paper":
			specialShot = "paper";
			playedPapersound = true;
			if(pow>64):bullet_spr.frame = 5
			elif (pow>48):bullet_spr.frame = 4
			elif (pow>24):bullet_spr.frame = 3
			elif (pow>12):bullet_spr.frame = 2
			elif (pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			
			if(image_index>=3):playedPapersound = false
			if(flaregun):bullet_spr.frame = s_bull_paperSpecial; bullet_spr.frame = 0
			if(rocketShot):bullet_spr.frame = s_bull_paperSpecial;bullet_spr.frame = 1
			if(bfgShot):bullet_spr.frame = s_bull_paperSpecial;bullet_spr.frame = 2; bullet_spriteTurn = false
			
			scale.x = 1;
			scale.y = 1;
			specialBFG = true;
			if(speedBonus>1.2):speedBonus = 1.2
	
		# GOLD #
		"s_bull_gold":
			bullet_spr.frame = clamp(0,14,pow/10);
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;
	
		# SILVER #
		"s_bull_silver":
			bullet_spr.frame = clamp(0,14,pow/10);
			scale.x = 1;
			scale.y = 1;
			lobAngledSprite = true;
	
		#/ ITANO GUN's / ROCKET LAUNCHER
		"s_bull_rocket":
			trailScale = 1;
			trailAngle = choose(0,90,180,270);
			speedBonus = 1;
			if(pow>96):bullet_spr.frame = 7
			elif (pow>80):bullet_spr.frame = 6; trailScale = 0.9
			elif (pow>64):bullet_spr.frame = 5; trailScale = 0.8
			elif (pow>48):bullet_spr.frame = 4; trailScale = 0.6
			elif (pow>32):bullet_spr.frame = 3; trailScale = 0.5
			elif (pow>16):bullet_spr.frame = 2; trailScale = 0.4
			elif (pow>8):bullet_spr.frame = 1; trailScale = 0.3
			else: bullet_spr.frame = 0;trailScale = 0.2
			scale.x = 1;
			scale.y = 1;

			if(matName=="Itano"):
				if(rocketShot):
					if(pow<50):bullet_spr.frame += 1
					else: sprite_index= "s_bull_itanoRocket"
				if(bfgShot):
					if(pow<50):bullet_spr.frame += 2
					else: sprite_index= "s_bull_itanoBFG"
			lobAngledSprite = true;
			# Play a looping exhaust effect on rockets, create sound emitter for this.
			scr_entity_makeSoundEmitter();
			audio_play_sound_on_actor(id, "hoopzweap_rocket_exhaust", true, 10);
		
		"s_bull_offal":
			speedBonus = 1;
			bullet_spr.frame = clamp(0,15,floor(pow / 8) - 2 + irandom(4));
			scale.x = 1;
			scale.y = choose(-1,1);
			specialBFG = true;
			bloodTrail = 1+irandom(6);
	
		"s_bull_blood":
			speedBonus = 1;
			specialShot = "blood";
			specialBFG = true;
			bullet_spr.frame = clamp(0,7,floor(pow / 12));
			scale.x = 1;
			scale.y = choose(-1,1);
			bloodTrail = 1+irandom(6);
			lobAngledSprite = true;
			if(bfgShot):bullet_spr.frame = s_bull_bloodBFG; image_speed = 0.1; scale.y = 1; bullet_spriteTurn = false
	
		"s_bull_soiled":
			speedBonus = 1;
			bullet_spr.frame = clamp(0,7,floor(pow / 12));
			scale.x = 1;
			scale.y = choose(-1,1);
			bloodTrail = 1+irandom(6);
		
		"s_bull_tofu1":
			if(pow>64):		bullet_spr.frame = "s_bull_tofu5"
			elif (pow>32):	bullet_spr.frame = "s_bull_tofu4"
			elif (pow>16):	bullet_spr.frame = "s_bull_tofu3"
			elif (pow>8):	bullet_spr.frame = "s_bull_tofu2"
			else: bullet_spr.frame = "s_bull_tofu1"
			image_angle = choose(0,90,180,270);
			image_speed = 0.25;
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1;
	
		"s_bull_grass":
			if (pow>80):	bullet_spr.frame = 14
			elif (pow>72):	bullet_spr.frame = 13
			elif (pow>64):	bullet_spr.frame = 12
			elif (pow>56):	bullet_spr.frame = 11
			elif (pow>48):	bullet_spr.frame = 10
			elif (pow>40):	bullet_spr.frame = 9
			elif (pow>32):	bullet_spr.frame = 8
			elif (pow>26):	bullet_spr.frame = 7
			elif (pow>20):	bullet_spr.frame = 6
			elif (pow>16):	bullet_spr.frame = 5
			elif (pow>12):	bullet_spr.frame = 4
			elif (pow>8):	bullet_spr.frame = 3
			elif (pow>4):	bullet_spr.frame = 2
			elif (pow>2):	bullet_spr.frame = 1
			scale.x = 1;
			scale.y = choose(1,-1);
			grassTimer = 0.2;
			specialBFG = true;
			lobAngledSprite = true;
			if(speedBonus>1.2):speedBonus = 1.2
	
		"s_bull_brainshot":
			if(speedBonus>1):speedBonus = 1
			antimatterTrail = 0;
			drawSprite = true;
			scr_entity_setShadowVisible(false);
			specialShot = "brain";

			pulseObj = instance_create(x,y,o_pulseEffect);
			pulseObj.radiusbase = 4 + floor(pow/3);
			pulseObj.radiusShake = floor(pow/4);

			if (pow>80):bullet_spr.frame = 14
			elif (pow>72):bullet_spr.frame = 13
			elif (pow>64):bullet_spr.frame = 12
			elif (pow>56):bullet_spr.frame = 11
			elif (pow>48):bullet_spr.frame = 10
			elif (pow>40):bullet_spr.frame = 9
			elif (pow>32):bullet_spr.frame = 8
			elif (pow>26):bullet_spr.frame = 7
			elif (pow>20):bullet_spr.frame = 6
			elif (pow>16):bullet_spr.frame = 5
			elif (pow>12):bullet_spr.frame = 4
			elif (pow>8):bullet_spr.frame = 3
			elif (pow>4):bullet_spr.frame = 2
			elif (pow>2):bullet_spr.frame = 1
			specialBFG = true;
	
		#/FUNGUS GUN's
		"s_bull_spore":
			if(pow>45):bullet_spr.frame = 9; scr_entity_setZHitbox(0-10, 2+10)
			elif (pow>38):bullet_spr.frame = 8; scr_entity_setZHitbox(0-8, 2+8)
			elif (pow>32):bullet_spr.frame = 7;scr_entity_setZHitbox(0-6, 2+6)
			elif (pow>26):bullet_spr.frame = 6;scr_entity_setZHitbox(0-4, 2+4)
			elif (pow>20):bullet_spr.frame = 5;scr_entity_setZHitbox(0-3, 2+3)
			elif (pow>14):bullet_spr.frame = 4;scr_entity_setZHitbox(0-3, 2+3)
			elif (pow>9):bullet_spr.frame = 3;scr_entity_setZHitbox(0-2, 2+2)
			elif (pow>5):bullet_spr.frame = 2;scr_entity_setZHitbox(0-1, 2+1)
			elif (pow>2):bullet_spr.frame = 1;scr_entity_setZHitbox(0-1, 2)
			else: bullet_spr.frame = 0
			image_angle = choose(0,90,180,270);
			scale.x = 1;
			scale.y = 1;
			hitHoopzIn = 5;
			ricochetSound = "";
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			specialBFG = true;
	
		"s_bull_magma":
			if(pow>132):bullet_spr.frame = 21
			elif (pow>128):bullet_spr.frame = 20
			elif (pow>120):bullet_spr.frame = 19
			elif (pow>112):bullet_spr.frame = 18
			elif (pow>104):bullet_spr.frame = 17
			elif (pow>96):bullet_spr.frame = 16
			elif (pow>88):bullet_spr.frame = 15
			elif (pow>80):bullet_spr.frame = 14
			elif (pow>72):bullet_spr.frame = 13
			elif (pow>64):bullet_spr.frame = 12
			elif (pow>56):bullet_spr.frame = 11
			elif (pow>48):bullet_spr.frame = 10
			elif (pow>40):bullet_spr.frame = 9
			elif (pow>32):bullet_spr.frame = 8
			elif (pow>26):bullet_spr.frame = 7
			elif (pow>20):bullet_spr.frame = 6
			elif (pow>16):bullet_spr.frame = 5
			elif (pow>12):bullet_spr.frame = 4
			elif (pow>8):bullet_spr.frame = 3
			elif (pow>4):bullet_spr.frame = 2
			elif (pow>2):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			if(!shotSetup):
				magmaCoolDelay = 6;
				magmacooldown = 24;
				if(bfgShot):magmaCoolDelay = 12
				if(rocketShot):magmaCoolDelay = 10
				if(flaregun):magmaCoolDelay = 8
			Smoke("customcolor",make_color_rgb(10,5,8),make_color_rgb(46,30,40),make_color_rgb(115,50,70),0)
			var smk = Smoke("puff",x,y,z,max(4,pow*1.5));
			Smoke("init",0,0,0,0);
			if(speedBonus>1.2):speedBonus = 1.2
			scale.x = 1;
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;
			lobAngledSprite = true;
			specialBFG = true;
	
		###MERCURY
		"s_bull_mercury":
			#show_debug_message("o_bullet move_dir:" + string(move_dir));
			if(pow>12 && choose(true,false)):
				var splitAmnt = (20+random(60) )/100;
				var splt = scr_combat_cloneBullet(id);
				scr_combat_bulletDmgmod(id,0,1-splitAmnt);
				scr_combat_bulletDmgmod(splt,0,splitAmnt);
				#with(splt):scr_entity_setDirSpd(90,20)
				#show_debug_message("o_bullet splt.move_dir0:" + string(splt.move_dir));
				if with(splt):
					scr_entity_setDirSpd(other.move_dir-10+irandom(20),other.move_dist)
				splt.initDir = splt.move_dir;
				pow = pow*(1-splitAmnt);

			if(pow>6 && choose(true,false,false)): #/split 1
				var splitAmnt = (30+random(50) )/100;
				var splt = scr_combat_cloneBullet(id);
				scr_combat_bulletDmgmod(id,0,1-splitAmnt);
				scr_combat_bulletDmgmod(splt,0,splitAmnt);
				#with(splt):scr_entity_setDirSpd(90,20)
				#show_debug_message("o_bullet splt.move_dir1:" + string(splt.move_dir));
				if with(splt):
					scr_entity_setDirSpd(other.move_dir-10+irandom(20),other.move_dist)
				splt.initDir = splt.move_dir;
				pow = pow*(1-splitAmnt);

			if(speedBonus>1.5):speedBonus = 1
			bullet_spriteTurn = true;
			bullet_spr.frame = clamp(0,16,pow/5);
			if(pow>2.5):image_index+=1
	
		#/DIGITAL
		"s_bull_digitalLaser":
			shotOriginx = dx;
			shotOriginy = y-z;
			lstPoints = ds_list_create();
			shotWidth = 1+floor(pow/12);
			speedBonus = 2;
			laserCol = c_red;
			laserTrail = 8;
			trailLength = 16;
			specialBFG = true;
			if(rocketShot):shotWidth += 4 + shotWidth/2
			if(bfgShot):shotWidth += 6 + shotWidth
	
		#/PEARL SHOT
		"s_bull_pearl_ghostShot":
			image_speed = 0.25;
			#scale.x = pow / 50;
			scale.y = scale.x*choose(1,-1);

			if(pow>80):bullet_spr.frame = s_bull_pearl_ghostMound
			elif(pow>64):sprite_index =s_bull_pearl_ghostShot
			elif(pow>48):sprite_index =s_bull_pearl_ghostShot
			elif(pow>36):bullet_spr.frame = s_bull_pearl_skullShot
			elif(pow>24):bullet_spr.frame = s_bull_pearl_handShot
			elif(pow>12):bullet_spr.frame = s_bull_pearl_eyeShot
			elif(pow>6):bullet_spr.frame = s_bull_pearl_lilGhost
			else: bullet_spr.frame = s_bull_pearl_tinyGhost 
			specialBFG = true;
			specialShot = "ghost";
			ghostTrail = 0;
			throughWalls = 10;
			bullet_spriteTurn = true;

			if(!bfgShot && !rocketShot):
				enemySeek += 4;
				enemySeekRange = 64;
				enemySeekTime = 0.5;

			#sparktrail = 3
			if(speedBonus>1.25):speedBonus = 1
	

		#/LEAD SHOT
		"s_bull_lead":
			if (pow>120):bullet_spr.frame = 14
			elif (pow>100):bullet_spr.frame = 13
			elif (pow>90):bullet_spr.frame = 12
			elif (pow>80):bullet_spr.frame = 11
			elif (pow>70):bullet_spr.frame = 10
			elif (pow>60):bullet_spr.frame = 9
			elif (pow>50):bullet_spr.frame = 8
			elif (pow>40):bullet_spr.frame = 7
			elif (pow>30):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			bullet_spriteTurn = false;
			stoneSkipping = -1; #/roll when hit the ground
			if(speedBonus>1.25):speedBonus = 1.25
	
		#/ FRANCIUM
		"s_bull_francium":
			mask_index = s_bull_francium
			motionBlur = true;
			scale.x = 1;
			scale.y = 1;
			image_speed = 0.2;
			franciumMax = 1;
			if(pow<3):franciumMax = 0.06
			elif(pow<6):franciumMax = 0.1
			elif(pow<12):franciumMax = 0.2
			elif(pow<18):franciumMax = 0.3
			elif(pow<24):franciumMax = 0.4
			elif(pow<30):franciumMax = 0.5
			elif(pow<40):franciumMax = 0.6
			elif(pow<50):franciumMax = 0.7
			elif(pow<60):franciumMax = 0.8
			elif(pow<70):franciumMax = 0.9
			elif(pow<80):franciumMax = 1
			elif(pow<100):franciumMax = 1.1
			elif(pow<120):franciumMax = 1.2
			elif(pow<140):franciumMax = 1.3
			elif(pow<180):franciumMax = 1.4
			elif(pow<220):franciumMax = 1.5
			elif(pow<240):franciumMax = 1.6
			elif(pow<260):franciumMax = 1.7
			elif(pow<280):franciumMax = 1.8
			elif(pow<300):franciumMax = 1.9
			else: franciumMax = 2

			image_angle = choose(0,90,180,270);
			shadow_visible = false;
			show_hiteffect = false;
			franciumScale = 0.01;
			scale.x = franciumMax*franciumScale;
			scale.y = franciumMax*franciumScale;
			bullet_spriteTurn = false;
			if(speedBonus>1.2):speedBonus = 1.2
			if (!audio_is_playing_ext(franciumSnd)):
				scr_entity_makeSoundEmitter();
				audio_play_sound_on_actor(id,franciumSnd, true, 0);
	
		"s_bull_scrollWeapon":
			image_speed = 0;
			scr_entity_setZHitbox(0-10, 2+10);
	
		"s_bull_flamethrower":
			specialBFG = true;
			if (superShot):
				drawWhiteOverlay = true;
	
		"s_bull_spFlame":
			pass

		"s_bull_bfg":
			mask_index = mask_disk_20by20;
			bfgFiredDirection = move_dir;
			scr_entity_makeSoundEmitter();
			audio_play_sound_on_actor(id,"hoopzweap_BFG_shot", 0, 0);
		

		"s_bull_adamant":
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
			bullet_spr.frame = clamp(0,27,clamp(0,27,floor(pow/3)) - 2 + irandom(4));
		

		"s_bull_tin":
			bullet_spriteTurn = false;
			if(bfgShot && rocketShot && flaregun):
				bullet_spr.frame = s_bull_tincan;
				image_speed = 0.2;

		"s_bull_cobalt":
			if(speedBonus>1.2):speedBonus = 1.5
			if (pow>90):bullet_spr.frame = 10
			elif (pow>76):bullet_spr.frame = 9
			elif (pow>64):bullet_spr.frame = 8
			elif (pow>52):bullet_spr.frame = 7
			elif (pow>40):bullet_spr.frame = 6
			elif (pow>30):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
		
		"s_bull_angelCore":
			scale.x = 1;
			scale.y = 1;
			if(speedBonus>1.2):speedBonus = 1; accel = accel*2; move_dist= (move_dist+1)*2

			bullet_spriteTurn = false;
			wingSprite = noone;
			wingFrame = 0;
			if(pow>200):bullet_spr.frame = 13
			elif (pow>160):bullet_spr.frame = 12
			elif (pow>140):bullet_spr.frame = 11
			elif (pow>120):bullet_spr.frame = 10
			elif (pow>96):bullet_spr.frame = 9
			elif (pow>84):bullet_spr.frame = 8
			elif (pow>72):bullet_spr.frame = 7
			elif (pow>60):bullet_spr.frame = 6
			elif (pow>48):bullet_spr.frame = 5
			elif (pow>36):bullet_spr.frame = 4
			elif (pow>24):bullet_spr.frame = 3
			elif (pow>12):bullet_spr.frame = 2
			elif (pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0

			if(image_index==0):wingSprite 		= "s_bull_angel_tiny"
			elif(image_index<=2):wingSprite 	= "s_bull_angel_small"
			elif(image_index<=4):wingSprite 	= "s_bull_angel_medium"
			elif(image_index<=6):wingSprite 	= "s_bull_angel_large"
			elif(image_index<=8):wingSprite 	= "s_bull_angel_huge"
			else: wingSprite = "s_bull_angel_giant"

			var featherCount = 1;
			if(pow>240):featherCount 	= 3+irandom(6)
			elif(pow>120):featherCount 	= 2+irandom(4)
			elif(pow>60):featherCount 	= 1+irandom(3)
			elif(pow>30):featherCount 	= 1+irandom(2)
			elif(pow>15):featherCount 	= 1+irandom(1)
			else: featherCount 			= 1

			if(bfgShot):
				featherCount = featherCount*2; 
				bullet_spr.animation = "s_bull_angelBFG"
				bullet_spr.frame = 0; 
				wingSprite = "noone"

			specialShot = "angel";

			featherInterval = 10;
			featherNext = irandom(featherInterval);
			
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
			if (pow>96):bullet_spr.frame = 12
			elif (pow>72):bullet_spr.frame = 11
			elif (pow>64):bullet_spr.frame = 10
			elif (pow>56):bullet_spr.frame = 9
			elif (pow>48):bullet_spr.frame = 8
			elif (pow>40):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>6):bullet_spr.frame = 2
			elif (pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;
			lobAngledSprite = true;
			sinewparts = 0.2;
		

		"s_bull_orb":
			shotOriginx = dx;
			shotOriginy = y-z;
			lstPoints = ds_list_create();
			shotWidth = 1+floor(pow/14);
			turnTimer = 32;
			speedBonus = 2;
			laserTrail = 8;
			trailLength = 24;
			speedBonus = 1;
			match laserGen:
				"0": laserCol = c_white; 
				"1": laserCol = make_color_rgb(136,249,157); 
				"2": laserCol = make_color_rgb(0,255,0); 
				"3": laserCol = make_color_rgb(3,201,40); ; 
				"4": laserCol = make_color_rgb(55,165,73); 
				"5": laserCol = make_color_rgb(65,127,71); 
				_: laserCol = make_color_rgb(56,100,62); 
			drawSprite = false;
		

		##/BLASTER
		"s_bull_blaster":
			if (pow>80):bullet_spr.frame = 9
			elif (pow>60):bullet_spr.frame = 8
			elif (pow>50):bullet_spr.frame = 7
			elif (pow>40):bullet_spr.frame = 6
			elif (pow>30):bullet_spr.frame = 5
			elif (pow>20):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;
			specialBFG = true;
			if(speedBonus>1):speedBonus = 1
			lobAngledSprite = true;
			

			scr_entity_makeSoundEmitter();
			audio_play_sound_on_actor(id,"hoopzweap_blaster_impact", true, 0);

		##YGGDRASIL
		"s_bull_yggShot":
			if (pow>48):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			plantInterval = max(0.1,(7-pow/10)/6);
			plantNext = random(plantInterval);
			plantSize = 5+pow;
			if(speedBonus>1.2):speedBonus = 1
			specialBFG = true;
			lobAngledSprite = true;
		

		# CHOBHAM
		"s_bull_chobham":
			if(pow>64):bullet_spr.frame = 8
			elif (pow>48):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>8):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
			if(speedBonus>1.5):speedBonus = 1.5
		

		"s_bull_frankincense":
			if (pow>96):bullet_spr.frame = 12
			elif (pow>72):bullet_spr.frame = 11
			elif (pow>64):bullet_spr.frame = 10
			elif (pow>56):bullet_spr.frame = 9
			elif (pow>48):bullet_spr.frame = 8
			elif (pow>40):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>6):bullet_spr.frame = 2
			elif (pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;

			steamTimer = 4+pow/3;
			steamInterval = 4;
			steamStop = 6;
			lobAngledSprite = true;
			Smoke("puff",x,y,z,2+max(5,pow));
		

		"s_bull_myrrh":
			if (pow>96):bullet_spr.frame = 12
			elif (pow>72):bullet_spr.frame = 11
			elif (pow>64):bullet_spr.frame = 10
			elif (pow>56):bullet_spr.frame = 9
			elif (pow>48):bullet_spr.frame = 8
			elif (pow>40):bullet_spr.frame = 7
			elif (pow>32):bullet_spr.frame = 6
			elif (pow>24):bullet_spr.frame = 5
			elif (pow>18):bullet_spr.frame = 4
			elif (pow>12):bullet_spr.frame = 3
			elif (pow>6):bullet_spr.frame = 2
			elif (pow>3):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			lobAngledSprite = true;
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;
		

		"s_bull_crystalshot":
			if(pow>160):bullet_spr.frame = 15
			elif (pow>140):bullet_spr.frame = 14
			elif (pow>120):bullet_spr.frame = 13
			elif (pow>100):bullet_spr.frame = 12
			elif (pow>80):bullet_spr.frame = 11
			elif (pow>70):bullet_spr.frame = 10
			elif (pow>60):bullet_spr.frame = 9
			elif (pow>50):bullet_spr.frame = 8
			elif (pow>42):bullet_spr.frame = 7
			elif (pow>36):bullet_spr.frame = 6
			elif (pow>30):bullet_spr.frame = 5
			elif (pow>24):bullet_spr.frame = 4
			elif (pow>18):bullet_spr.frame = 3
			elif (pow>12):bullet_spr.frame = 2
			elif (pow>6):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.x = choose(1,-1);
			scale.y = choose(1,-1);
			bullet_spriteTurn = false;
			specialBFG = true;

			scr_entity_makeSoundEmitter();
			audio_play_sound_on_actor(id,"hoopzweap_crystal_bullet", true, 0);

		

		"s_bull_crystalshard":
			if (pow>48):bullet_spr.frame = 10
			elif (pow>40):bullet_spr.frame = 9
			elif (pow>32):bullet_spr.frame = 8
			elif (pow>24):bullet_spr.frame = 7
			elif (pow>20):bullet_spr.frame = 6
			elif (pow>16):bullet_spr.frame = 5
			elif (pow>12):bullet_spr.frame = 4
			elif (pow>8):bullet_spr.frame = 3
			elif (pow>4):bullet_spr.frame = 2
			elif (pow>2):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.y = choose(1,-1);
			bullet_spriteTurn = true;
		

		"s_bull_diamond", "s_bull_diamondShard":
			if (pow>100):bullet_spr.frame = 10
			elif (pow>80):bullet_spr.frame = 9
			elif (pow>60):bullet_spr.frame = 8
			elif (pow>50):bullet_spr.frame = 7
			elif (pow>40):bullet_spr.frame = 6
			elif (pow>32):bullet_spr.frame = 5
			elif (pow>24):bullet_spr.frame = 4
			elif (pow>16):bullet_spr.frame = 3
			elif (pow>10):bullet_spr.frame = 2
			elif (pow>5):bullet_spr.frame = 1
			else: bullet_spr.frame = 0
			scale.x = 1;
			scale.y = 1;
			bullet_spriteTurn = false;
			if(sprite_index==s_bull_diamondShard):bullet_spriteTurn = true
			else: image_angle = startAngle
		
		##/IMAGINARY
		"emptySprite":
			drawSprite = false;
		
		"s_bull_pinataShot":
			bullet_spr.frame = clamp(0,21,(pow/6)-2+irandom(4));
			if(speedBonus>1.5):speedBonus = 1
			scale.y = choose(1,-1);
			image_angle = choose(0,90,180,270);
			bullet_spriteTurn = false;
			bulletSpin = choose(1,-1)*(5+irandom(20));

			var dr = point_direction(0,0,move_x,move_y);
			amnt = floor(1 + pow/20 + irandom(pow/10))
			
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
			if (pow>60):bullet_spr.frame = 5
			elif (pow>40):bullet_spr.frame = 4
			elif (pow>20):bullet_spr.frame = 3
			elif (pow>10):bullet_spr.frame = 2
			elif (pow>4):bullet_spr.frame = 1
			bullet_spriteTurn = true;
			steamTimer = 5+pow/3;
			steamInterval = 4;
			steamStop = 3;
			speedBonus = 1;
		
		"s_bull_flyshot":
			flyflutter = 0;
			flyBaseframe = 0;
			if (pow>40):flyBaseframe = 8
			elif (pow>20):flyBaseframe = 6
			elif (pow>10):flyBaseframe = 4
			elif (pow>4):flyBaseframe = 2
			bullet_spriteTurn = true;
			speedBonus = 1;
		
		"s_bull_aerogel":
			if(speedBonus>1.5):speedBonus = 1
			bullet_spriteTurn = false;
			bullet_spr.frame = clamp(0,17,pow/6);
			if(pow>3):image_index +=1
			image_alpha = 0.3;
		
		# Untamonium
		"s_bull_untamonium_med":
			if(pow>48):bullet_spr.frame = s_bull_untamonium_large
			elif (pow>24):bullet_spr.frame = s_bull_untamonium_med
			elif (pow>12):bullet_spr.frame = s_bull_untamonium_small
			else: bullet_spr.frame = s_bull_untamonium_tiny
			scale.x = 1;
			scale.y = 1;
			image_speed = 0.25;
			if(speedBonus>1.2):speedBonus = 1.2
			lobAngledSprite = true;
		

		"s_bull_untamonium_bfg":
			#specialBFG = true;
			#specialShot = "goo";
			var scl = 1;
			scl = clamp(0.5,2,pow / 70);
			image_speed = 0.25;
			scale.x = scl;
			scale.y = scl;
			specialBFG = true;

func _physics_process(delta: float) -> void:
	position += dir * speed ## TEMP

func _on_visible_on_screen_enabler_2d_screen_exited() -> void:
	queue_free()
