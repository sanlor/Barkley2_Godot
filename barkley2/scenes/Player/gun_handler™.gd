@icon("uid:##cmy1updvjdpaf")
extends Node
class_name B2_GunHandler
## Node used to interface the player with its gun.
## The Gun_Handler™ handles guns. duh.
# Mainly, its an interface to help communications with the gun resource, holding timers and such.

# the ™ was added for fun. Im curious to see if it can break any part of the game.
# Once, in a Checkpoint firewall, we added a rule with a comment (or name? dont remmember) with a 'ç' on it. The firewall wasnt able to save policies anymore and we spent a few hours trying to find the reason.
# Lol, whats this guy event talking about?

## NOTE Enemies should be ale to use this too.

signal spin_up_now(		) # Used to play the spin up sfx and the sustain sfx
signal spin_down_now(	) # used to play the spin down sfx
signal no_ammo(			) # Used to alert that the ammo was spent up.

const O_BULLET 		:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_bullet.tscn")
const O_CASINGS 	:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_casings.tscn")
const S_FLASH 		:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/muzzle_flash/s_flash.tscn")

##################################
######## AFFIX Settings ##########
##################################

## Magician
const affixMagicianDegrees 			:= 210; ## Deviation in degrees it can shoot from barrel 

## Flooding - Set the lowest bullets it can shoot and highest per shot
const affixFloodingMin 				:= 2;
const affixFloodingMax 				:= 8;
const affixFloodingAim 				:= 20; ## In degrees, aim penalty of flooding

## NoScope360
const affixNoScope360 				:= 8; ## Number of bullets to shoot
const affixNoScope360Distance 		:= 12; ## Distance to generate bullets from player
const affixNoScope360Knockback 		:= 0; ## If 0, shooting with noscope360 has no knockback

## Ghostic
const affixGhosticDamage 			:= 0.6; ## Multiplier for bullet damage, 0.6 = 60%

## Gravitational
const affixGravitationalSpeed 		:= 0.4;
const affixGravitationalSeek 		:= 64; ## Higher number = more seeking
const affixGravitationalSeekRange 	:= 200; ## In pixels from bullet

## Chaining
const affixChainingRange 			:= 200; ## Distance to next enemy to get chain
const affixChainingEnemies 			:= 3; ## How many enemies it can hit
const affixChainingReduction 		:= 0.5; ## How much to lose damage per hit, 0.5 = 50% reduce

## Power
const powerMinesLight 				:= 0.5; ## Darkness in mines
const colorGuilderberg 				:= B2_Gamedata.c_cosmic;

## Gun balance
const windupModifier 				:= 2; ## 1 = 100% speed, 1.5 = 150% speed, etc

## Combat Settings
var ammoBooster 	:= 0.25; 		# % boost to all ammo counts
var rateBooster 	:= 0.5; 		# % boost of all gun's firing rate
var pietyBonus 		:= 1.0; 		# Gain this for every point of PIETY for resist
var baseSpeed 		:= 8.5; 		# previously 9
var lethargyMod 	:= 0.05;
var encumbranceMod 	:= 0.5; 		# loss of speed for each point of weight over - OLD = 0.05
var logWeight 		:= 1.0;
var baseShake 		:= 1.0;
var marksmanMod 	:= 17.5;

@onready var constant_stream		: AudioStreamPlayer = $constant_stream
@onready var gun_noises_stream		: AudioStreamPlayer = $gun_noises_stream 	## Responsible to produce gun noises (winding, for example)
@onready var pre_shooting_timer		: Timer = $pre_shooting_timer				## Timer used when a gun need some time before firing (muskets)
@onready var firing_rate			: Timer = $firing_rate						## Timer used to control the firing rate
@onready var post_shooting_timer	: Timer = $post_shooting_timer				## Timer used when a gun need some time after firing
@onready var reload_timer			: Timer = $reload_timer						## Timer used to play the reload sound (Shotgun + Crossbow)
@onready var charge_timer			: Timer = $charge_timer						## Responsible to add and control the gun charge stuff.

var is_shooting 	:= false 	## Is the players activally shooting?
#var can_shoot 		:= true		## Can the player shoot right now?

var curr_gun 		: B2_Weapon
var source_actor	: B2_CombatActor

## SFX control
var currently_playing	:= ""		## Keep track of which SFX is playhing right now
var windupSound 		:= ""		## Wind up SFX (Ex.: Minigun)
var winddownSound 		:= ""		## Wind down SFX (Ex.: Minigun)
var sustainSound 		:= ""		## Wind Sustain SFX (Ex.: Minigun)
var spinning_up			:= false	## Used to check if the Wind up or Sustain should be played.
var minigun_spin_anim	:= ["s_Minigun", "s_Minigun_Anim"]
var magnun_spin_anim	:= ["s_Magnum", "s_Magnum_Anim"]

func _ready() -> void:
	pre_shooting_timer.one_shot			= true
	firing_rate.one_shot				= true
	post_shooting_timer.one_shot		= true
	
	if get_parent() is B2_CombatActor:		source_actor = get_parent()
	else:									push_error( "Invalid parent: %s" % get_parent().name ); breakpoint
		
	_gun_changed()
	B2_SignalBus.gun_changed.connect( _gun_changed )
	B2_SignalBus.gun_owned_changed.connect( _gun_changed )
	spin_up_now.connect( _spin_up_sfx_requested )
	spin_down_now.connect( _spin_down_sfx_requested )
	
#region Weapon Operation
		
## Check if the gun can be shot right now.
#func _can_shoot() -> bool:
#	return firing_rate.is_stopped() and pre_shooting_timer.is_stopped() and post_shooting_timer.is_stopped() and not is_shooting
		
func select_gun( force_gun : B2_Weapon ) -> void:
	B2_Gun.select_gun_from_resource( force_gun )
		
## Actor is shooting a gun (or not, it depends on the "action" var)
func shoot_gun( action : bool ) -> void:
	if pre_attack_action( action ):
		attack_action()
		
## Check combat_gunwield_firing
# Perform speccific checks and actions before firing a gun.
@warning_ignore("unused_parameter")
func pre_attack_action( action : bool ) -> bool:
	## Delay is running
	if not pre_shooting_timer.is_stopped():
		return false
	if not post_shooting_timer.is_stopped():
		return false
		
	## controls the 'windup' variable. Some guns need to wind up before shooting (minigun).
	var pWindUp 	:= curr_gun.weapon_stats.pWindUp
	windupSound 	= curr_gun.weapon_stats.windupSound
	winddownSound 	= curr_gun.weapon_stats.winddownSound
	sustainSound 	= curr_gun.weapon_stats.sustainSound
	
	## Some guns have a delay before shooting, like muskets.
	var fireTimer 	:= curr_gun.weapon_stats.pFireTimerTarget * ( 1.0 - curr_gun.weapon_stats.pShotDelay)
	var delayTimer 	:= curr_gun.weapon_stats.pFireTimerTarget * (curr_gun.weapon_stats.pShotDelay)
	
	## Control if the gun can be shot or not.
	var can_shoot	:= action
	
	## Gun needs to wind up before shooting.
	if curr_gun.weapon_stats.pWindUpSpeed > 0.0:
		if pWindUp > 0.0:
			if source_actor is B2_PlayerCombatActor:
				if randf_range(pWindUp,100) > 85:
					source_actor.switch_combat_weapon_anim( minigun_spin_anim.front() )
					minigun_spin_anim.reverse()
		## Player is holding the trigger
		if action:
			## Shoot if the windup is full
			can_shoot = pWindUp >= 100.0 
			
			## Unsure what this does. Maybe play sfx only after a certain threshold? <- Understand it now.
			# Handles SpinUp and SpinDown sfx, based on if you are holding the trigger.
			# NOTE This should not work as is, since we are using a different method to trigger a gun.
			#if pWindUp > 60.0 and not winddownSound.is_empty(): 
			#	spin_up_now.emit() ## TODO play spin up sfx
			# NOTE 26/11/25 disabled the above. Seems redundant.
			
			if pWindUp < 100.0:
				if not windupSound.is_empty():
					spin_up_now.emit()
						
				## Wind up gun
				# Increase the gun Windup variable. NOTE this need to be tweaked to work on this new system.
				var godot_modifier := 10.0 # An extra modifier, since in Godot the pWindUp value increases to slowly.
				pWindUp += max( 3.0, curr_gun.weapon_stats.pWindUpSpeed / curr_gun.weapon_stats.pWeight * 0.5) * windupModifier * godot_modifier * get_physics_process_delta_time()
				pWindUp = clamp( pWindUp, 0.0, 100.0 ) # improved version of 'pWindUp = min( 100, pWindUp )'.
		
		# 26/11/25 cleaned up some code not being used in the Godot version.
		
		## Player is NOT holding the trigger
		else:
			if pWindUp > 0.0: #60:
				if not winddownSound.is_empty():
					spin_down_now.emit()
			# curr_gun.weapon_stats.reloaded"] = false;
			if pWindUp > 4.0:
				pWindUp -= 24.0 * windupModifier * get_physics_process_delta_time()
				pWindUp = max(0.0, pWindUp);
			else:
				pWindUp = 0.0;
	
	## Save the modified 'pWindUp' value.
	curr_gun.weapon_stats.pWindUp = pWindUp
	
	## delayed shot: flintlocks, etc.
	if delayTimer > 0.0 and action:
		print("Delay -> ", curr_gun.weapon_stats.pFireTimer)
		
		match curr_gun.weapon_type:
			B2_Gun.TYPE.GUN_TYPE_MUSKET:			B2_Sound.play( "musket_fuse" )
			B2_Gun.TYPE.GUN_TYPE_FLINTLOCK:			B2_Sound.play( "flintlock_fuse" )
			B2_Gun.TYPE.GUN_TYPE_BFG:				B2_Sound.play( "hoopzweap_BFG_charge" )
		
		if source_actor is B2_PlayerCombatActor:
			source_actor.light_fuse()
		
		pre_shooting_timer.start( curr_gun.weapon_stats.pFireTimer * 0.003 )
		can_shoot = false
	
	## Actually shoot the gun.
	## TODO
	return can_shoot 
	
@warning_ignore("unused_parameter")
func post_attack_action() -> void:
	var rate := curr_gun.get_rate() / maxf( 1.0, curr_gun.weapon_stats.pBurstAmount ) # Avoid dividing by zero.
	post_shooting_timer.start( rate )
	
	## Set timer to reload gun
	if not curr_gun.weapon_stats.reloaded:
		reload_timer.start( rate / 3.0 )

## Check combat_gunwield_shoot
## Check o_bullet
func attack_action() -> void:
	if not curr_gun: push_error("Gun resource not loaded correctly."); return
		
	## Can't shoot again while the respective timers are still active.
	#if not _can_shoot(): return
		
	var dir			:= source_actor.curr_aim
		
	## Start timers and necessary variables.
	is_shooting = true
	# FIXME firing_rate.start( curr_gun.wait_per_shot )
	
	var source_pos 	: Vector2 = get_parent().get_muzzle_position()
	var may_shoot	:= true ## Certain situations may disable shooting the gun
	
	## Material and stat related checks before shooting the gun.
	var shotRepeats 	:= 1 		# Amount of bullet to shoot at once.
	var nosDir 			:= 0		# NOTE Not sure
	var nosSpl 			:= 0		# NOTE Not sure
	var shotEffects 	:= true; 	# shot SFX and muzzle flash should be turned off after the first repeat
	
	## Broken / Junk gun related vars.
	var malfunction 	:= 0.0;
	var _junkAmount 	:= 0;
	var _junkSize 		:= 0;
	
	if curr_gun.prefix1 == "Flooding":
		shotRepeats = affixFloodingMin + randi_range(0, affixFloodingMax - affixFloodingMin);
	if curr_gun.prefix1 == "NoScope360":
		shotRepeats = affixNoScope360
		@warning_ignore("integer_division")
		nosSpl = 360 / affixNoScope360
	
	var soilClog 		:= false 	# Clog weapon, shotting a glob os sludge.
	if curr_gun.weapon_material == B2_Gun.MATERIAL.SOILED:
		if randi_range(0,3) == 0:
			soilClog = true
			
	## May break gun.
	if curr_gun.weapon_material == B2_Gun.MATERIAL.BROKEN:
		if randi_range(0,3) == 0:
			var indicatorText 		:= ""
			_junkAmount 			= 0
			_junkSize 				= 3
			var malfunctionDraw 	:= randf()
			var malfunctionCol 		:= Color.RED;
			if malfunctionDraw > 0.90: ## the gun makes a big spark and deals a bit of cyber damage to you and nearby enemies.
				B2_Sound.play("hoopzweap_broken_misfire");
				if randf() <= 0.1: 	malfunction = 5; _junkSize = 6; _junkAmount = 8 + randi_range(0,12); indicatorText = "GUN EXPLODED!"
				else: 				malfunction = 4;_junkAmount = 4 + randi_range(0,4); indicatorText = "ELECTRIC SHOCK!"
			# the gun blows up in your hands, the explosion does a lot of damage to you and everyone nearby.
			elif malfunctionDraw > 0.70: malfunction=3; _junkAmount = 0; malfunctionCol = Color.TEAL # the powerful shot
			elif malfunctionDraw > 0.40: malfunction=2; _junkAmount = 1+randi_range(0,2); malfunctionCol = Color.ORANGE; B2_Sound.play("hoopzweap_broken_misfire") #the gun fails to fire, and a screw falls off
			else: malfunction = 1; _junkAmount = 1 # the gun fires a wildly inaccurate shot
			print_rich("[color=red]MALFUNCTION! %s[/color]" % malfunction );
			
			if indicatorText != "":
				B2_Screen.display_generic_text( source_actor, indicatorText, malfunctionCol )
	
	if curr_gun.weapon_material == B2_Gun.MATERIAL.JUNK:
		@warning_ignore("integer_division")
		_junkSize = randi_range(0,3) + randi_range(0, floor( int( curr_gun.get_gun_stat("pDamageMin") ) / 30 ) );
		_junkAmount = 1;
	
	for repeat : int in shotRepeats:
		B2_Screen.pulse_cursor() # Do a little bulls eye animation.
		
		## Only shoot if you have ammo.
		if curr_gun.has_ammo() and may_shoot:
			## only apply knockback if you actually fire the weapon.
			var bonus_knockback := 1.0
			var dir_knockback := -dir
			if curr_gun.prefix1 == "Afterburner":
				bonus_knockback = 4.0
			if curr_gun.prefix1 == "NoScope360":
				dir_knockback = dir
				source_pos = get_parent().get_muzzle_position( true ) ## Update position.
			source_actor.apply_central_impulse( dir_knockback * curr_gun.get_gun_knockback() * bonus_knockback ) 
			
			var _bulratio 	:= 1.0
			var _extra 		:= 0;
			if curr_gun.weapon_stats.pCurAmmo < curr_gun.weapon_stats.pAmmoCost:
				_bulratio = curr_gun.weapon_stats.pCurAmmo / curr_gun.weapon_stats.pAmmoCost
				
			var bulletCount := floori(curr_gun.weapon_stats.pShots * _bulratio)+_extra;
			
			## Apply multishot (No idea what this does) combat_gunwield_shoot line 198
			if curr_gun.weapon_stats.periodic_mutlishot !=1 && curr_gun.weapon_stats.pChargeRatio == 1:
				bulletCount += ceil( curr_gun.weapon_stats.periodic_mutlishot * curr_gun.weapon_stats.pAffix / 100.0 )
			
			## Junk gun.
			if malfunction==2: bulletCount = 0
			
			## Use ammo
			curr_gun.use_ammo( int(curr_gun.weapon_stats.pAmmoCost) )
				
			B2_Sound.play( curr_gun.get_soundID(), 0.0, false, 1, 1.0, 0.5 )
			_create_flash( source_pos, dir, 1.5)
			
			## Spawn bullets. Handguns shoot only one bullet per shot. Shotguns can shoot many per shot.
			for i in bulletCount * curr_gun.weapon_stats.pBurstAmount:
				## Angle variations
				var _angle : float = curr_gun.weapon_stats.pSpreadAmount / curr_gun.weapon_stats.pShots
				
				## Aim variations
				var my_acc := curr_gun.weapon_stats.pAimMod + deg_to_rad( dir.angle() ) - ( curr_gun.weapon_stats.pSpreadAmount / 2 ) + _angle * i;
				my_acc -= curr_gun.weapon_stats.pAccuracy / 2.0 + randf_range( 0, curr_gun.weapon_stats.pAccuracy ) + curr_gun.weapon_stats.bAimAjarMin + randf_range(0, curr_gun.weapon_stats.bAimAjarMax); ## TODO add better accuracy
				
				var b_dir := dir.rotated( deg_to_rad( randf_range( -my_acc, my_acc ) ) )
				if curr_gun.prefix1 == "NoScope360":
					b_dir *= -1 # Invert directionq
				
				## broken gun malfunction 1: inaccurate shot
				if malfunction == 1: b_dir += Vector2.from_angle( deg_to_rad( 35.0 + randf_range(0.0,35.0) ) * [1.0,-1.0].pick_random() )
				if malfunction >= 4: b_dir = dir + Vector2.from_angle( deg_to_rad(180) )
				if malfunction == 5: curr_gun.weapon_stats.pCurAmmo = 0 ## on malfunction 5, gun breaks
				
				## Set the bullet type
				var _btype = "o_bullet";
				if curr_gun.weapon_stats.bAdvanced: 	_btype = "o_advBullet"
				if malfunction >= 4:					_btype = "o_advBullet"
				
				## Actually fire the gun
				_create_bullet( source_pos, b_dir, _btype )
				curr_gun.weapon_stats.reloaded = false
				source_actor.set_gun_reloaded( false )
				_shake_screen()
			
			## Charge stuff
			curr_gun.weapon_stats.pChargeShot += 1
			if curr_gun.weapon_stats.pChargeRatio == 1.0:
				curr_gun.weapon_stats.pChargeCur 	= 0;
				curr_gun.weapon_stats.pChargeShot 	= 0 # reset super timer if this was a super attack
				source_actor.flash_gun( false )
				
		else:
			## Out of ammo.
			B2_Sound.play( "hoopz_click" )
	
	post_attack_action()
#endregion
		
func _gun_changed() -> void:
	# Reset some vars
	currently_playing	= ""		## Keep track of which SFX is playhing right now
	windupSound 		= ""		## Wind up SFX (Ex.: Minigun)
	winddownSound 		= ""		## Wind down SFX (Ex.: Minigun)
	sustainSound 		= ""		## Wind Sustain SFX (Ex.: Minigun)
	spinning_up			= false		## Used to check if the Wind up or Sustain should be played.

	# register new guns
	if B2_Gun.has_any_guns():	curr_gun = B2_Gun.get_current_gun()
	else:						curr_gun = null
	
	# Stop SFX
	gun_noises_stream.stop()
	constant_stream.stop()
	
	# Stop timers
	if curr_gun:
		curr_gun.weapon_stats.pWindUp = 0 	## Reset minigun Winding
		charge_timer.start() 				## Start charge timer
		
		# Play constant sound if specified -> combat_gunwield_attacking line 29
		if curr_gun.weapon_stats.constantSound:
			constant_stream.stream = B2_Sound.get_sound_stream( curr_gun.weapon_stats.constantSound )
			constant_stream.stream.loop = true
			constant_stream.play()
		
	pre_shooting_timer.stop()
	post_shooting_timer.stop()
	reload_timer.stop()
	firing_rate.stop()
	
	source_actor.flash_gun( false )
	
## Check combat_gunwield_step
# Handles gun charge. Motherfucker look at this function. It's madness!!
func _charge_gun() -> void:
	var _triggerGain = 0;
	var move_dist = 0
	
	# Which charge gain type is used #
	match curr_gun.weapon_stats.pChargeGain:
		# No charge
		"cg_none":
			pass
		
		# Always full charge #
		"cg_full":
			curr_gun.weapon_stats.pChargeCur = curr_gun.weapon_stats.pChargeMax
			
		# Each shot increases charge #
		"cg_shot":
			_triggerGain += curr_gun.weapon_stats.pChargeShot
			
		# Dealing damage increases charge (1pt = 1 min bullet damage) #
		"cg_damage":
			if curr_gun.weapon_stats.pChargeDamage > 0 and curr_gun.weapon_stats.pDamageMin > 0:
				_triggerGain += curr_gun.weapon_stats.pChargeDamage / curr_gun.weapon_stats.pDamageMin
			
		# Taking damage increases charge (1pt = 1% MAX HP damage) #
		"cg_hurt":
		#	if curr_gun.weapon_stats.pChargeHurt > 0 and scr_stats_getEffectiveStat(id, STAT_EFFECTIVE_MAX_HP) > 0:
		#		var maxhp = scr_stats_getEffectiveStat(id, STAT_EFFECTIVE_MAX_HP);
		#		_triggerGain += (curr_gun.weapon_stats.pChargeHurt / (maxhp)) * 100
			pass
			
		# Hitting something increases charge? #
		"cg_hit":
			_triggerGain += curr_gun.weapon_stats.pChargeHits
			
		# Each shot increases charge, hit increases charge by 2x #
		"cg_shot_2xhit":
			_triggerGain += curr_gun.weapon_stats.pChargeShot
			_triggerGain += curr_gun.weapon_stats.pChargeHits * 2;
			
		# Constantly hitting something increases charge? #
		"cg_conshit":
			if curr_gun.weapon_stats.pChargeMissed > 0:
				curr_gun.weapon_stats.pChargeGainVar=  0
			if curr_gun.weapon_stats.pChargeHits > 0:
				curr_gun.weapon_stats.pChargeGainVar += 1
				if curr_gun.weapon_stats.pChargeGainVar > 1:
					_triggerGain += 1
			
		# Increase charge via kills #
		"cg_kill":
			_triggerGain += curr_gun.weapon_stats.pChargeKilled
			
		# Candy eat #
		"cg_candy":
			_triggerGain += curr_gun.weapon_stats.pChargeCandy
			
		# Stand still #
		"cg_nomove":
			if curr_gun.weapon_stats.pFireDelay == 0:
				_triggerGain = 1;
			
		# Stand still and enemy is nearby #
		"cg_nomove_enemyProximity":
			if move_dist == 0:
				## TODO Fix this
			#	var nearest = scr_actor_getNearestOfTypeList(target_list, x, y);
			#	if (nearest != noone) {
			#		var dist = point_distance(x, y, nearest.x, nearest.y);
			#		if (dist < 250) {
			#			_triggerGain = 1;
				pass
		# Charge while gun is loaded #
		"cg_loaded":
			if move_dist == 0:
				_triggerGain = 1;
			
		# Heartbeat ? #
		"cg_heartbeat":
			curr_gun.weapon_stats.pChargeGainVar = int(curr_gun.weapon_stats.pChargeGainVar * 0.85) % 8 # + dt()
			var phase = floor(curr_gun.weapon_stats.pChargeGainVar)
			if phase == 4:
				curr_gun.weapon_stats.pChargeCur = .75;
			elif phase == 6:
				curr_gun.weapon_stats.pChargeCur = 1
			else:
				curr_gun.weapon_stats.pChargeCur = 0
			
		# Minigun: Each shot increases charge + Full charge when gun has winded down #
		"cg_mitrailleuse":
			_triggerGain += curr_gun.weapon_stats.pChargeShot
			if curr_gun.weapon_stats.pWindUpSpeed > 0 and curr_gun.weapon_stats.pWindUp <= 0:
				curr_gun.weapon_stats.pChargeCur = curr_gun.weapon_stats.pChargeMax
			
		# Enemy is nearby #
		"cg_enemyProximity":
		#	var nearest = scr_actor_getNearestOfTypeList(target_list, x, y);
		#	if (nearest != noone) {
		#		var dist = point_distance(x, y, nearest.x, nearest.y);
		#		var gain = max(0, (1 - dist/200) * dt());
		#		curr_gun.weapon_stats.pChargeCur"] += gain;
			pass
			
		# Aim at enemy #
		"cg_aim":
		#	var aimx;
		#	var aimy;
		#	var nearest;
		#	if (object_is_ancestor(object_index, PlayerCombatActor)) {
		#		aimx = o_curs.x + view_xview;
		#		aimy = o_curs.y + view_yview;
		#		nearest = instance_nearest(aimx, aimy, EnemyCombatActor);
		#		if (PlayerCombatActor.move_x != 0 || PlayerCombatActor.move_y != 0) nearest = noone;
		#	} else {
		#		aimx = o_hoopz.x;
		#		aimy = o_hoopz.y;
		#		nearest = scr_actor_getNearestOfTypeList(target_list, aimx, aimy);
		#	}
		#		var dist = point_distance(aimx, aimy, nearest.x, nearest.y);
		#		var gain = max(0, (1 - dist/100) * dt());
		#		curr_gun.weapon_stats.pChargeCur"] += gain;
		#	}
		#	if (curr_gun.weapon_stats.pChargeShot"] > 0) {
		#		curr_gun.weapon_stats.pChargeCur"] = 0;
		#	}
		#	break;
			pass

	# How much charge is gained #
	if _triggerGain:
		curr_gun.weapon_stats.pChargeLossAccum = 0;
		match curr_gun.weapon_stats.pChargeGainAmount:
			"ga_gainAll":
				curr_gun.weapon_stats.pChargeCur = curr_gun.weapon_stats.pChargeMax
				
			"ga_gainOne":
				curr_gun.weapon_stats.pChargeCur += _triggerGain;
				
			"ga_gainTime":
				curr_gun.weapon_stats.pChargeCur += _triggerGain * curr_gun.weapon_stats.pChargeGainTime # dt()
				
			"ga_gainAmmoLevel":
				if curr_gun.weapon_stats.pMaxAmmo > 0:
					@warning_ignore("integer_division")
					var ammoLevel = curr_gun.weapon_stats.pCurAmmo / curr_gun.weapon_stats.pMaxAmmo
					var diff = curr_gun.weapon_stats.pChargeGainAmmoMax - curr_gun.weapon_stats.pChargeGainAmmoMin
					curr_gun.weapon_stats.pChargeCur += _triggerGain * (curr_gun.weapon_stats.pChargeGainAmmoMin + ammoLevel * diff);
				
			"ga_gainAccum": # Accumulates while holding the fire button
				#while (_triggerGain >= 1) {
				if _triggerGain >= 1:
					curr_gun.weapon_stats.pChargeCur += curr_gun.weapon_stats.pChargeAccum
					curr_gun.weapon_stats.pChargeAccum *= curr_gun.weapon_stats.pChargeIncAccum
					if curr_gun.weapon_stats.pChargeAccum > curr_gun.weapon_stats.pChargeMaxAccum:
						curr_gun.weapon_stats.pChargeAccum = curr_gun.weapon_stats.pChargeMaxAccum
					
					_triggerGain -= 1
				
			"ga_none":
				pass

	# Which charge loss type is used #
	var _triggerLoss = 0

	match curr_gun.weapon_stats.pChargeLoss:
		# Charge is never lost #
		"cl_none":
			_triggerLoss = 0;

		# Charge lost when you shoot #
		"cl_shot":
			if curr_gun.weapon_stats.pChargeShot > 0:
				_triggerLoss = 1
				
		# Charge lost when you miss #
		"cl_shotmissed":
			if curr_gun.weapon_stats.pChargeMissed > 0:
				_triggerLoss = 1;
				
		# Charge is lost when you move or shoot #
		"cl_move":
			if move_dist != 0:
				_triggerLoss = 1;
				
			if curr_gun.weapon_stats.pChargeShot > 0:
				curr_gun.weapon_stats.pChargeCur = 0
				
		# Charge is lost always #
		"cl_time":
			_triggerLoss = 1;
		_:
			_triggerLoss = 0;

	# How much charge is lost #
	if _triggerLoss > 0:
		curr_gun.weapon_stats.pChargeAccum = 1;
		
		match curr_gun.weapon_stats.pChargeLossAmount:
			"la_loseAll":
				curr_gun.weapon_stats.pChargeCur = 0;
			"la_loseOverTime":
				curr_gun.weapon_stats.pChargeCur -= curr_gun.weapon_stats.pChargeLossTime; # dt() *
			"la_loseOne":
				curr_gun.weapon_stats.pChargeCur -= _triggerLoss;   
			_:
				pass
	# Upper and lower limits of charge #
	curr_gun.weapon_stats.pChargeCur = clampf( curr_gun.weapon_stats.pChargeCur, 0.0, curr_gun.weapon_stats.pChargeMax )

	# The ratio of how much of the charge is filled up #
	var chargeBefore := curr_gun.weapon_stats.pChargeRatio
	curr_gun.weapon_stats.pChargeRatio = curr_gun.weapon_stats.pChargeCur / curr_gun.weapon_stats.pChargeMax
	if curr_gun.weapon_stats.pChargeRatio >= 1 and chargeBefore < 1:
		B2_Sound.play( "periodic_charged" )
		source_actor.flash_gun( true )
	
	# Reset things #
	curr_gun.weapon_stats.pChargeMissed 	= 0;
	curr_gun.weapon_stats.pChargeShot 		= 0;
	curr_gun.weapon_stats.pChargeHits 		= 0;
	curr_gun.weapon_stats.pChargeKilled 	= 0;
	curr_gun.weapon_stats.pChargeKilledPow 	= 0;
	curr_gun.weapon_stats.pChargeDamage 	= 0;
	curr_gun.weapon_stats.pChargeHurt 		= 0;
	curr_gun.weapon_stats.pChargeCandy 		= 0;
	
func _shake_screen() -> void:
	var agile = B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_AGILE )
	var weight = B2_Playerdata.Stat( B2_HoopzStats.STAT_BASE_WEIGHT )
	var lethargy = max( ((agile - weight) * lethargyMod), -1);
	var speed_log = max( log(lethargy + logWeight) / log(10.0), -1) # lethargy
	var marksmanship = abs(speed_log);
	var shakiness = marksmanship * marksmanMod + baseShake;
	var effectiveShake = shakiness;
	var actor := B2_CManager.o_hoopz.global_position
	
	B2_CManager.camera.add_shake( effectiveShake, 999, actor.x, actor.y, max(effectiveShake / 2.0, 1.0) / 10.0 )
	
## Create a bullet object on the current room
func _create_bullet( source_pos : Vector2, dir : Vector2, bullet_type : String ) -> void: #, skill_mod : B2_WeaponSkill = null ) -> void:
	var bullet : B2_Bullet
	match bullet_type:
		"o_bullet":			bullet = O_BULLET.instantiate()
		"o_advBullet":		bullet = O_BULLET.instantiate(); push_error("Advanced gun NOT ADDED YET.")
		_:					breakpoint
		
	## Charge stuff
	if curr_gun.weapon_stats.pChargeRatio == 1.0:
		## Apply charge shot.
		bullet.superShot = true # Super attacks can last longer for some prefixes, and have a bigger movement hitbox
		if curr_gun.weapon_type != B2_Gun.TYPE.GUN_TYPE_FLAREGUN:
			#_bullet.distlife *= 1 + gun[? "pAffix"]/100;
			pass
		else:
			bullet.glowEffect = true;
		
	bullet.my_gun = curr_gun
	bullet.set_direction( dir )

	bullet.setup_bullet_sprite( curr_gun.get_bullet_sprite(), curr_gun.get_bullet_color() )
	bullet.source_actor = source_actor

	source_actor.add_sibling( bullet, true )
	bullet.position = source_pos
	bullet.final_multiplier = B2_Config.PLAYER_BULLET_DAMAGE_MULTIPLIER

## Create a muzzle flash on the current room
func _create_flash( source_pos : Vector2, dir : Vector2, _scale := 1.0) -> void:
	if not curr_gun:
		push_error("Gun resource not loaded correctly.")
		return
		
	if curr_gun.get_flash_sprite():
		var flash = S_FLASH.instantiate()
		flash.position = source_pos
		flash.look_at( (source_pos + dir) )
		flash.rotation += randf_range( -PI/28.0, PI/28.0 )
		flash.scale = Vector2.ONE * randf_range( 0.8, 1.2 )
		flash.scale *= _scale
		flash.modulate.a *= randf_range( 0.4, 1.0 )
		B2_RoomXY.get_curr_room().add_child( flash, true )
		flash.play( curr_gun.get_flash_sprite() )
		
## Create a bullet casing object on the current room
func _create_casing( casing_pos : Vector2) -> void:
	if not curr_gun:
		push_error("Gun resource not loaded correctly.")
		return
		
	if curr_gun.get_casing_name():
		var casing = O_CASINGS.instantiate()
		casing.setup( 
			curr_gun.get_casing_name(), 
			curr_gun.get_casing_sound(), 
			curr_gun.get_casing_scale(), 
			curr_gun.get_casing_speed(), 
			curr_gun.get_casing_color(),
			curr_gun.get_casing_vert_speed(),
			curr_gun.get_casing_dir(),
			curr_gun.get_casing_spin(),
			)
		casing.position = casing_pos
		B2_RoomXY.get_curr_room().add_child( casing, true )

#region timer signal callbacks
func _on_pre_shooting_timer_timeout() -> void:
	print("Delayed shot")
	attack_action()

func _on_firing_rate_timeout() -> void:
	pass # Replace with function body.

## Action after the shooting timer.
func _on_post_shooting_timer_timeout() -> void:
	if curr_gun.weapon_stats.readyCasing > 1:
		var casing_pos 	:= source_actor.get_attack_origin()
		for i in curr_gun.weapon_stats.readyCasing: ## Double barrel shotgun spawn 2 casings
			_create_casing( casing_pos )
	source_actor.set_gun_reloaded( true )

## Reload SFX
func _on_reload_timer_timeout() -> void:
	if curr_gun.weapon_stats.reloadSound:
		B2_Sound.play( curr_gun.weapon_stats.reloadSound )
	
	## create bullet casing
	if not curr_gun.weapon_stats.bcasing.is_empty(): # Certain guns dont produce bullet casings.
		_create_casing( source_actor.get_attack_origin() )
	
	curr_gun.weapon_stats.reloaded = true

## Controls the Wind up SFX.
func _spin_up_sfx_requested() -> void:
	if not windupSound.is_empty() and currently_playing != windupSound and not spinning_up:
		var playback_position	:= 0.0		## Used to play the spin up and down correctly.
		if gun_noises_stream.playing: 
			playback_position 	= gun_noises_stream.get_playback_position()
			gun_noises_stream.stop()
		var sfx : AudioStreamOggVorbis = B2_Sound.get_sound_stream( windupSound )
		sfx.loop = false
		gun_noises_stream.stream = sfx
		if playback_position > 0.0:
			var curr_sfx_lenght := gun_noises_stream.stream.get_length()
			gun_noises_stream.play( curr_sfx_lenght - playback_position )
		else:
			gun_noises_stream.play()
		currently_playing = windupSound
		
		spinning_up = true

## Controls the Wind down SFX.
func _spin_down_sfx_requested() -> void:
	if not winddownSound.is_empty() and currently_playing != winddownSound:
		var playback_position	:= 0.0		## Used to play the spin up and down correctly.
		if gun_noises_stream.playing:
			if currently_playing == windupSound: # Avoid issues with sustain sfx.
				playback_position 	= gun_noises_stream.get_playback_position()
			gun_noises_stream.stop()
		var sfx : AudioStreamOggVorbis = B2_Sound.get_sound_stream( winddownSound )
		sfx.loop = false
		gun_noises_stream.stream = sfx
		if playback_position > 0.0:
			var curr_sfx_lenght := gun_noises_stream.stream.get_length()
			gun_noises_stream.play( curr_sfx_lenght - playback_position )
		else:
			gun_noises_stream.play()
		currently_playing = winddownSound
		
		spinning_up = false

## Used to play the "sustain" sfx the WindUp SFX.
func _on_gun_noises_stream_finished() -> void:
	if spinning_up:
		spinning_up = false
		if gun_noises_stream.playing: gun_noises_stream.stop()
		if not sustainSound.is_empty() and currently_playing != sustainSound:
			var sfx : AudioStreamOggVorbis = B2_Sound.get_sound_stream( sustainSound )
			sfx.loop = true
			gun_noises_stream.stream = sfx
			gun_noises_stream.play()
			currently_playing = sustainSound

func _on_charge_timer_timeout() -> void:
	_charge_gun()
#endregion
