#extends B2_WeaponStats
#class_name B2_WeaponMaterial
extends Resource

## Oh boy. There are a lot of conditioning stuff to apply speccial effects / behaviour depending on the gun type (Flamethrower for example).
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
@export var _wgt 			:= 1.0

@export var gunHeldSprite2Alpha 	:= 1.0

@export var gunheldcol1 			: String
@export var displaySpots  			: bool
@export var gunheldcol3  			: String
@export var displayParts  			: bool
@export var gunheldcol2  			: String

@export var normalFlame  			: bool
@export var specialFlame  			: bool
@export var sound_normalPitchDmg 	: float
@export var specialBFG  			: bool
@export var specialFlaregun  		: bool
@export var specialRocket  			: bool

@export var speedBonus 				: float
