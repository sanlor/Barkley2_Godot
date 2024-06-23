extends Node

## NOTES
# This script has a lot of tabs. I´ve translated that as one big script.

## BALANCE
# original # # original # # original #  ZAUBERS # original # # original # 
# original #  Press F12 on scripts for subsections
var zauberDribbleTime = 0.33;
var zauberCastTime = 0.25;
var zauberCastAuto = 1; # original #  When 1, hoopz does 1 dribble then casts right away

# original #  Boss Alignment
var alignmentModifier = 0.03;    # original #  boss alignment base modifier percentage - 0.03
var alignmentDamageDealt = 1;    # original #  this should always be 1 except during boss fights
var alignmentDamageTaken = 1;    # original #  this should always be 1 except during boss fights

# original #  Status effect and Prefix 2 balancing
## StatusEffects();

# original #  Single zaubers
## WARNING Disabled inexistent functions
## BalanceZauberPozzosPrison();
## BalanceZauberStarlight();
## BalanceZauberBolt();
## BalanceZauberBallSucker();
## DropDestructible("init"); # original #  <-- Press F12

# original #  Gun balance
var windupModifier = 2; # original #  1 = 100% speed, 1.5 = 150% speed, etc

## BalanceZauberStarlight

##  STAR LIGHT ##

# original #  RANGE in pixels with PIETY 0
var zauberStarlightRangeMinimum = 60;
# original #  RANGE in pixels with PIETY 99
var zauberStarlightRangeMaximum = 200;
# original #  AMOUNT based on PIETY 0
var zauberStarlightAmountMinimum = 4;
# original #  AMOUNT based on PIETY 99
var zauberStarlightAmountMaximum = 20;
# original #  FIRE SPEED based on PIETY 99 (REVERSED as lower fire speed is better)
var zauberStarlightIntervalMinimum = 0.33; # original #  a second
# original #  FIRE SPEED based on PIETY 0 (REVERSED as lower fire speed is better)
var zauberStarlightIntervalMaximum = 1; # original #  a second
# original #  DAMAGE based on PIETY 0
var zauberStarlightDamageMinimum = 1;
# original #  DAMAGE based on PIETY 99
var zauberStarlightDamageMaximum = 10;
# original #  KNOCKBACK based on PIETY 0
var zauberStarlightKnockbackMinimum = 1;
# original #  KNOCKBACK based on PIETY 99
var zauberStarlightKnockbackMaximum = 5;
# original #  STAGGER value of starlight hits - SOFT, MEDIUM, HARD
var zauberStarlightStagger = null ## STAGGER_HARDNESS_HARD;
# original #  Ability to target destructables?
var zauberStarlightTargetDestructible = 1;
# original #  EXPIRY based on piety, remove all existing on new cast
# original #  Animation for them coming out? some kind of visual thing
# original #  better gfx than dots
# original #  dont allow it to attack hidden enemy (fishmen in water)

## BalanceZauberPozzosPrison

##  POZZO'S PRISON ##

# original #  The minimum amount of Jello's thrown, if you had PIETY 0
var zauberPozzoJelloMinimum = 2;
# original #  The maximum amount of Jello's thrown, if you had PIETY 99
var zauberPozzoJelloMaximum = 5;
# original #  Minimum direction in degrees a Jello will be thrown at PIETY 0
var zauberPozzoJelloDirectionMinimum = 55;
# original #  Maximum direction in degrees a Jello will be thrown at PIETY 99
var zauberPozzoJelloDirectionMaximum = 125;
# original #  Speed at which Jelly moves in air (faster means hits the ground quicker)
var zauberPozzoJelloSpeed = 2;
# original #  Time in seconds a Jello will remain on the ground at PIETY 0
var zauberPozzoJelloTrapMinimum = 3;
# original #  Time in seconds a Jello will remain on the ground at PIETY 99
var zauberPozzoJelloTrapMaximum = 10;
# original #  Time in seconds a Prison will hold an enemy at PIETY 0
var zauberPozzoJelloPrisonMinimum = 3;
# original #  Time in seconds a Prison will hold an enemy at PIETY 99
var zauberPozzoJelloPrisonMaximum = 10;
# original #  Minimum distance in pixels a Jello will be thrown
var zauberPozzoJelloDistanceMinimum = 30;
# original #  Maximum distance in pixels a Jello will be thrown
var zauberPozzoJelloDistanceMaximum = 120;
# original #  Jellos must be this many pixels away from each other (to prevent clumping)
var zauberPozzoJelloSpacing = 24;
# original #  Enemies must be this close in pixels to get stuck
var zauberPozzoJelloEnemy = 24;
# original #  Hoopz must be this close in pixels to get stuck
var zauberPozzoJelloHoopz = 12;
# original #  Minimum visual width of Jello
var zauberPozzoJelloVisualMinimum = 40;
# original #  Maximum visual width of Jello
var zauberPozzoJelloVisualMaximum = 48;

## BalanceZauberBolt

##  CYBER BOLT ## 
# original #  Zauber Name
var zauberBoltName = "Cyber Bolt";
# original #  Sprite to use when casting
var zauberBoltSprite = null ## sHoopzFishShow;

## BalanceZauberBallSucker

##  BALLSUCKER ## 

# original #  Distance in pixels that ball moves away from Hoopz
var zauberBallSuckerDistanceMinimum = 40; # original #  PIETY 0
var zauberBallSuckerDistanceMaximum = 60; # original #  PIETY 99
# original #  Pixel movement per second to reach distance
var zauberBallSuckerSpeedMinimum = 80; # original #  PIETY 0
var zauberBallSuckerSpeedMaximum = 180; # original #  PIETY 99
# original #  Starting pixel radius of gravity well
var zauberBallSuckerRadiusStartMinimum = 24; # original #  PIETY 0
var zauberBallSuckerRadiusStartMaximum = 32; # original #  PIETY 99
# original #  Ending pixel radius of gravity well
var zauberBallSuckerRadiusEndMinimum = 80; # original #  PIETY 0
var zauberBallSuckerRadiusEndMaximum = 96; # original #  PIETY 99
# original #  Growth of radius in pixels per second to get to ending radius
var zauberBallSuckerRadiusGrowthMinimum = 56; # original #  PIETY 0
var zauberBallSuckerRadiusGrowthMaximum = 64; # original #  PIETY 99
# original #  Duration the ball sucker exists for
var zauberBallSuckerDurationMinimum = 5; # original #  PIETY 0
var zauberBallSuckerDurationMaximum = 8; # original #  PIETY 99

# original #  Maximum pixels to pull per second assuming you were in center of vortex
# original #  So someone at the mid point of the vortex has 50% of the value
# original #  And with 50 weight has 50% value (100 weight cannot be pulled)
# original #  So 60 = 30 = 15 pixels per second
var zauberBallSuckerPullMinimum = 80; # original #  PIETY 0
var zauberBallSuckerPullMaximum = 160; # original #  PIETY 99
# original #  Factor to pull in bullets
# original #  NOTE: Since bullets are so fast this is a bit hard to explain
# original #  But a value of 0 disables bullet pull, and higher values suck in bullets more
var zauberBallSuckerBulletPull = 3;

## StatusEffects

# original # / All info on status effects and prefix 2's go here

# original #  In seconds how long a status effect lasts UNLESS specified otherwise
var statusDuration = 20; 

# original #  NOTES
# original #  All below numbers are done based on GUN AFFIX value which ranges 0 - 50
# original #  So a gun affix value of 25 would be half of the value you specify
# original #  IE. var statusResistLowerAll = 0.4 would really be 0.2 at GUN AFFIX 25

# original #  Resist Boost One, Lower Rest (5 affix use this)
var statusResistBoostOne = 2;
var statusResistLowerRest = 0.5;
# original #  Resist Lower One (5 affix use this)
var statusResistLowerOne = 1;
# original #  Resist Lower All (1 affix uses this)
var statusResistLowerAll = 0.4;

# original #  Glamp Boost One, Lower Rest (5 affix use this)
var statusGlampBoostOne = 2;
var statusGlampLowerRest = 0.5;
# original #  Glamp Lower One (5 affix use this)
var statusGlampLowerOne = 1;
# original #  Glamp Lower All (1 affix uses this)
var statusGlampLowerAll = 0.4;
