extends Node

## NOTES
# null values are temp, since they call scripts or functions taht doesnt exist yet


# original # /Put variable things in here, like marquee speed, etc
var settingVersion = "0.1.5.285"

# original # Debug Log Printing
var lastLog = ""
var logRepeatCount = 0
var logfile = null ##file_text_open_write(working_directory + "log.txt")

# original #  IMPORTANT SCRIPTS
# original #  TextSpecial - Contains the text effects

var settingDeferred = 1 # original #  If 0, disable deferred render
var DEBUGMODE = 1 # original #  debug_mode || DEBUG_MODE # original #  enables in-game developper tools
var demoBlocker = 1 # original # Check DemoMapCheck() to see if area is on White List, disable to open entire game

var settingFadeIn = 0.25
var settingFadeDelay = 1 # original #  Time to wait between rooms, will scale based on room load time to make it consistent
var settingFadeOut = 0.25

# original #  Max distance you can be from someone to click them in PIXELS
var settingInteractiveDistance = 64 # original #  For KEYBOARD # original #  Was 100
var settingInteractiveDistanceGamepad = 48 # original #  For GAMEPAD # original #  Was 64

# original #  Holster / Draw time
var settingHolsterMinimum = 0.10
var settingHolsterMaximum = 0.75

# original #  In seconds how long time freezes when Hoopz gets hit
var settingFreezeTime = 0 # original #  0.1 Disabled because of ticket 2053

# original #  Turn speed - In degrees the player can turn a second
# original #  If the base were 400 and the player had no acro, it would take
# original #  0.45 seconds to do a 180 degree change in aim direction
var settingTurnSpeedBase = 400 # original #  9999 effectively disables
var settingTurnSpeedBonus = 10 # original #  For every ACRO, multiply it by this number and add to turn speed

var settingMarqueeQuest = 25 # original #  Percent chance of a quest notification (if you have one)
var settingMarqueeSpeed = 3.0 # original # Default value is 3
var pistolAutoFire = 0 # original # If 1 can hold to shoot auto for all guns
var ladderDelay = 0.25 # original # Time in seconds to go up ladder
var ladderSpeed = 5.00 # original # Was 4.00, speed hoopz climbs ladder
var ladderAnimSpeed = 4 # original # Was 3, the higher the slower it animates when on ladder

# original #  Zauber testing room # original #  This is where you will be taken when you leave the zauber test area # original # 
var zauberRoomName = null ## r_gau_01_entrance01
var zauberRoomNameX = 264
var zauberRoomNameY = 224

# original #  Combat Settings
var ammoBooster = 0.25 # original # % boost to all ammo counts
var rateBooster = 0.5 # original # % boost of all gun's firing rate
var pietyBonus = 1 # original #  Gain this for every point of PIETY for resist
var baseSpeed = 8.5 # original # previously 9
var lethargyMod = 0.05
var encumbranceMod = 0.5 # original #  loss of speed for each point of weight over - OLD = 0.05
var logWeight = 1
var baseShake = 1
var marksmanMod = 17.5

# original # Text Colors (Converted from make_colour_rgb to Color)
var textcolorMainquest = Color(255, 190, 40)
var textcolorSidequest = Color(140, 160, 255)
var textcolorKeyword = Color(110, 250, 150)
var textcolorRegular = Color(255, 255, 255)
var textcolorCurses = Color(255, 210, 210)
var textcolorNames = Color(200, 200, 255) 
var textcolorTime = Color(220, 220, 20) 
var textcolorFlavor = Color(255, 230, 255)
var textcolorEncounter = Color(255, 255, 150)
var textcolorQuote = Color(230, 255, 240)

var textcolorCuchulainn = Color(40, 90, 220)
var textcolorCyberdwarf = Color(255, 185, 80)

var textcolorHoopzBanter = Color(255, 255, 255)
var textcolorHoopzDamage = Color(255, 50, 100)
var textcolorHoopzCandy = Color(100, 50, 255)

# original #  Utility Menu Settings
var settingUtilitySmelt = 50 # original #  How much smelt you get per gun - balance 30->50 on 031719 - bhroom
var settingUtilityTextAlpha = 0.8 # original #  Alpha of all text
var settingUtilitySpriteAlpha = 0.8 # original #  Alpha of all sprites
var settingUtilityAlphaBack = 0.05 # original #  Alpha of grid BG
var settingUtilityAlphaGlow = 0.075 # original #  Alpha of glowing (text, grid)
var settingUtilityAlphaBorder = 0.15 # original #  Alpha of foreground grids, lines, etc
# original # var settingUtilityHue = 80 # original #  Menu hue - Set in player identity by gumball
var settingUtilityMono = 0.15 # original #  How colorful the menu is, 0 being more B&W 1 being full color
var utilityAlpha = 0

# original #  Game
var settingGameFPSMax = 60
var settingLoadRoom = null ## r_debugGreets01 # original #  First room to do
var settingLoadX = 36
var settingLoadY = 36

# original #  Stagger
var settingStaggerSoft = 0.3 # original #  Time in seconds (from 0.2)
var settingStaggerMedium = 0.4 # original #  Time in seconds (from 0.3)
var settingStaggerHard = 1.0 # original #  Time in seconds (from 0.8)

# original #  Big Enemy Height / Flying Height - TRAC Ticket #1880 Standardize Flying Enemies
# original #  Big = Catfish Shield / Mounted, Junkbot, Kobold Medium / Large, Crabbold, 
# original #  Big = Sewer Beast Large, Crabotron, Swamp Man, Bugflower
var settingEnemyBigHeight = 48 # original #  Big enemy z height hitbox
# original #  Fly = CGrem Jetpack, Tengu Normal / Crossbow
var settingEnemyFlyHeight = 48 # original #  Flying enemy z height

# original #  Hoopz
var settingGunsbagDrawEmpty = 0 # original #  If 0, only draw guns with ammo
var settingRespawnBagKeep = 0.25 # original #  down from .6 (bhroom) Percentage of guns bag guns kept on death
var settingRespawnAmmo = 0.25 # original #  Bandolier guns get this much ammo on respawn
# original #  JUNKLORD HAS CODE THAT EDITS THIS
var settingHoopzBio = 90 # original # 80
var settingHoopzCyber = 10 # original # 20
var settingHoopzCosmic = 0
var settingHoopzZauber = 0
var settingHoopzDeathSwap = 2 # original #  Loss of bio per life

# original #  Drop settings
var settingDropScale = 0.7 # original #  Scale (of gun drawn on floor) of dropped guns
var settingFuseCompatibility = 0.95 # original #  Range guns can be within, 0.95 = 5%
var settingFuseWeight = 0.75 # original #  Weight gain for every fuse
var settingDropWeightPercent = 0.10 # original #  10% - Percent of gunsvalue that is weight for new gun
var settingDropWeightAdd = 1.0 # original #  was 1.5 - Add this to percent of gunsvalue on fresh gun
var settingDropAmmo = 0.25 # original #  (down from 0.5, bhroom) How much ammo dropped guns have (0.5 = 50%)
var settingDropTimeMin = 4 # original #  Minimum time an item stays on the ground
var settingDropTimeLuck = 8 # original #  Add this number * (Luck / 100) in seconds to min time

## gun drop vars moved to Init
var settingDropGun : Array[int]
var settingDropCandy : Array[int]
var settingDropWildAmmo : Array[int]

# original #  scr_combat_weapons_buildName has cryptic names for dropped guns
var settingAmmoRandom = 50 # original #  Percent chance it will give 100% to current gun

# original # Dialog text speed
var dialogSpeed = 2 # original # 1 = Slow, 2 = Medium, 3 = Fast, 1000 = Instant
var dialogFaceSpeed = 10 # original # Higher means they animate faster

# original # Breakout
# original # var breakoutX = 8 # original # Breakout on left side
var breakoutX = 384 - 8 # original # Breakout on right side
var breakoutY = 92 + 4
# original # var breakoutY = 92 + 16 # original # Merge breakout into dialog box

# original # STAIR SLOW DOWN - Higher means slower
var stairLR0 = .33 # original #  0.75 - Take this percent off X movement when walking up stairs (ie. .6 is 40% speed)
var stairLR1 = .33 # original #  0.50 - Take this percent off Y movement
var stairUD  = .50 # original #  0.33 - 

# original # Scanlines POST EFFECT - Only works with surfaces enabled
var scanlines = 1

# original #  Default fade times
var fadeRoom = 0.25
var fadeDeath = 6

# original #  Room cache / rTree size
var rtreeCache = 0 # original #  When 1, cache rtrees
var rtreeSize = 64 # original #  We used to use 16 for solids, 8 for wading and shadows (obsolete)

# original #  Gun decal settings
var bulletCasings = 200 # original #  0 sets it to old style where it fades over time

# original #  Misc settings
var elevatorBorkSpeed = 30

# original #  DO NOT TOUCH SETTINGS BELOW
var fadeRoomTemp = -1 # original # For custom fade times

var dialogFrame 			= null ## s_diag_frame
var dialogCorner 			= null ## s_diag_corner
var dialogReturn 			= null ## s_return
var dialogEdge 				= null ## s_diag_edge
var dialogBG 				= null ## s_diag_bg
var dialogBGalt 			= null ## s_diag_bg_alt

var CACHEcollision 			= 0 # original #  Temp variable. When 1, don't add collisions
var CACHEc_tree 			= null ## ds_map_create()
var CACHEc_alltree 			= null ## ds_map_create()
var CACHEc_ostree 			= null ## ds_map_create()
var CACHEc_stree 			= null ## ds_map_create()
var CACHEc_wadetree 		= null ## ds_map_create()

var dslCasings 				= null ## ds_list_create()

# original # Changing this to 1, as we don't necessarily need this for LUCK
var critMultiplier = 1.00 # original # 1.75 - old value

# original #  Junkpile shadow density # original # 
var junkShadow = 0.25

# original #  AFIIX STUFF
var settingCircusRoll = 0.1 # original #  How much you get per roll
var settingJarRoll = 1 # original #  If 1 Hoopz can break jars on roll



##///////////////////////////////////
##////////// Gene Settings //////////
##///////////////////////////////////

var geneAffixChance = 25     # original #  Range = 1-100% | Rolled 3 times per gun, 1 for each affix slot.

var geneAffixThreshold = 30  # original #  Range = 1-100  | Value all penchants must be above for an affix to be applied.
var geneMinimumVariance = 20 # original #  Range = 1-100
var geneMaximumBase = 20     # original #  Range = 1-100
var geneMaximumVariance = 30 # original #  Range = 1-100

# original #  ^^^ The above works by doing AffixThreshold + random(MinimumVariance) = MinimumValue a gene can get in this affix generation
# original #  ^^^ The maximum is the MinimumValue + var geneMaximumBase + random(var geneMaximumVariance) = MaximumValue
# original #  ^^^ Using the formula above, the lowest a gene could get is a range of 30 to 50 and the highest is 50 to 100

var geneSecondaryValue = .6    # original #  All penchant genes get this modifier
var geneOtherValue = .45       # original #  All non-penchant genes get this modifier
var genePrimaryValue = .85     # original #  NOT USED - IGNORE
var geneDistributedValue = .62 # original #  NOT USED - IGNORE


##///////////////////////////////////
##///////// AFFIX Settings //////////
##///////////////////////////////////
# original #  Magician
var affixMagicianDegrees = 210 # original #  Deviation in degrees it can shoot from barrel 

# original #  Flooding - Set the lowest bullets it can shoot and highest per shot
var affixFloodingMin = 2
var affixFloodingMax = 8
var affixFloodingAim = 20 # original #  In degrees, aim penalty of flooding

# original #  NoScope360
var affixNoScope360 = 8 # original #  Number of bullets to shoot
var affixNoScope360Distance = 12 # original #  Distance to generate bullets from player
var affixNoScope360Knockback = 0 # original #  If 0, shooting with noscope360 has no knockback

# original #  Ghostic
var affixGhosticDamage = 0.6 # original #  Multiplier for bullet damage, 0.6 = 60%

# original #  Gravitational
var affixGravitationalSpeed = 0.4
var affixGravitationalSeek = 64 # original #  Higher number = more seeking
var affixGravitationalSeekRange = 200 # original #  In pixels from bullet

# original #  Chaining
var affixChainingRange = 200 # original #  Distance to next enemy to get chain
var affixChainingEnemies = 3 # original #  How many enemies it can hit
var affixChainingReduction = 0.5 # original #  How much to lose damage per hit, 0.5 = 50% reduce

# original #  Power
var powerMinesLight = 0.5 # original #  Darkness in mines

var colorGuilderberg = null ## c_cosmic

# original #  DO NOT TOUCH
var whiplash = 0 # original #  For camera cursor tweening
# original #  OLD INFO
# original #  When a signifier is lower case it gets this value (note: currently all sigs are lower case)
# original #  When a SIGNIFIER is all CAPS it gets this value (note: currently all sigs are lower case)
# original #  When something is "distributed" / skip, give all in that pool this value

func _init():
	# original #  Drop percentages - Make values under 100 total, any remaining of the 100 will drop nothing
	# original #  (change quest variable dropTable to define which table is used)
	# original #  Normal drop table
	settingDropGun.append(85) ## var settingDropGun[0] = 85     	 	# original #  (up from 60, bhroom)
	settingDropGun.append(10) ## var settingDropCandy[0] = 10    		# original #  
	settingDropGun.append(5) ## var settingDropWildAmmo[0] = 5 			# original #  Wild Ammo - Either FULL for one gun, or 20% for BANDO

	# original #  Boss fighting drop table 
	settingDropGun.append(25) ## var settingDropGun[1] = 25      		# original #  (up from 55, bhroom) Gun + Candy + Nothing must equal 100
	settingDropCandy.append(25) ## var settingDropCandy[1] = 25   	 	# original #  (bhroom) Gun + Candy + Nothing must equal 100
	settingDropWildAmmo.append(50) ##var settingDropWildAmmo[1] = 50 	# original #  Wild Ammo - Either FULL for one gun, or 20% for BANDO
