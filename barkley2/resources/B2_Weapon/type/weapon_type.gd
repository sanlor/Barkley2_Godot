## Class used to apply different gun type stat modifiers
extends B2_WeaponStats
class_name B2_WeaponType

## NOTE What a mess.
# Its hard to manage weapons like this. The way that B2 handles weapon modifiers, effects and special behaviours isnt very good.
# Im having a hard time trying to port the behaviour to this version.

## TODO Figure this shit out.

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

## Weird ass variables. No idea what they do.
@export var soundLoop 				:= false
@export var bExplodeDamageMod 		:= 1.0	## NOTE Huge mess. Both scr_combat_weapons_applyGraphic and scr_combat_weapons_applyType change this value.
@export var bUseMoveOffset 			: bool
@export var periodic_mutlishot 		: float
@export var pChargeLossTime 		: float

## scr_combat_weapons_resetStats
# Stats used directly for the weapon behavior. Built from the weapon stats, ratios and affixes.
