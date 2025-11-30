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

@onready var gun_noises_stream		: AudioStreamPlayer = $gun_noises_stream ## Responsible to produce gun noises (winding, for example)
@onready var pre_shooting_timer		: Timer = $pre_shooting_timer	## Timer used when a gun need some time before firing (muskets)
@onready var firing_rate			: Timer = $firing_rate			## Timer used to control the firing rate
@onready var post_shooting_timer	: Timer = $post_shooting_timer	## ## Timer used when a gun need some time after firing
@onready var reload_timer			: Timer = $reload_timer		## Timer used to play the reload sound (Shotgun + Crossbow)

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
			# gun[? "reloaded"] = false;
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
	var rate := curr_gun.get_rate()
	post_shooting_timer.start( rate )
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
			curr_gun.use_ammo( int(curr_gun.weapon_stats.pAmmoCost) )
			B2_Sound.play( curr_gun.get_soundID(), 0.0, false, 1, 1.0, 0.5 )
			_create_flash( source_pos, dir, 1.5)
			
			## only apply knockback if you actually fire the weapon.
			var bonus_knockback := 1.0
			var dir_knockback := -dir
			if curr_gun.prefix1 == "Afterburner":
				bonus_knockback = 4.0
			if curr_gun.prefix1 == "NoScope360":
				dir_knockback = dir
				source_pos = get_parent().get_muzzle_position( true ) ## Update position.
			source_actor.apply_central_impulse( dir_knockback * curr_gun.get_gun_knockback() * bonus_knockback ) 
			
			## Spawn bullets. Handguns shoot only one bullet per shot. Shotguns can shoot many per shot.
			for i in curr_gun.weapon_stats.pShots: # FIXME curr_gun.bullets_per_shot:
				#source_pos = get_parent().get_muzzle_position() ## Update position.
				
				var my_spread_offset := deg_to_rad( curr_gun.weapon_stats.pSpreadAmount / curr_gun.weapon_stats.pShots )
				my_spread_offset = randf_range( -my_spread_offset, my_spread_offset )
				
				## Aim variations
				var my_acc := curr_gun.weapon_stats.pAccuracy * B2_Config.BULLET_SPREAD_MULTIPLIER ## TODO add better accuracy
				var b_dir := dir.rotated( randf_range( -my_acc, my_acc ) + my_spread_offset )
				if curr_gun.prefix1 == "NoScope360":
					b_dir *= -1 # Invert directionq
				
				## broken gun malfunction 1: inaccurate shot
				if malfunction == 1: b_dir += Vector2.from_angle( deg_to_rad( 35.0 + randf_range(0.0,35.0) ) * [1.0,-1.0].pick_random() )
				if malfunction >= 4: b_dir = dir + Vector2.from_angle( deg_to_rad(180) )
				if malfunction == 5: curr_gun.weapon_stats.pCurAmmo = 0 ## on malfunction 5, gun breaks
				
				_create_bullet( source_pos, b_dir )
		else:
			## Out of ammo.
			B2_Sound.play( "hoopz_click" )
	
	source_actor.set_gun_reloaded( false )
	_shake_screen()
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
	
	# Stop timers
	if curr_gun:
		curr_gun.weapon_stats.pWindUp = 0
	pre_shooting_timer.stop()
	post_shooting_timer.stop()
	reload_timer.stop()
	firing_rate.stop()
	
func _shake_screen() -> void:
	var agile = B2_Playerdata.Stat("STAT_BASE_AGILE")
	var weight = B2_Playerdata.Stat("STAT_BASE_WEIGHT")
	var lethargy = max( ((agile - weight) * lethargyMod), -1);
	var speed_log = max( log(lethargy + logWeight) / log(10.0), -1) # lethargy
	var marksmanship = abs(speed_log);
	var shakiness = marksmanship * marksmanMod + baseShake;
	var effectiveShake = shakiness;
	var actor := B2_CManager.o_hoopz.global_position
	
	B2_CManager.camera.add_shake( effectiveShake, 999, actor.x, actor.y, max(effectiveShake / 2.0, 1.0) / 10.0 )
	
## Create a bullet object on the current room
func _create_bullet( source_pos : Vector2, dir : Vector2 ) -> void: #, skill_mod : B2_WeaponSkill = null ) -> void:
	var bullet = O_BULLET.instantiate()
	bullet.my_gun = curr_gun
	bullet.set_direction( dir )
	#if skill_mod:
	#	bullet.apply_stat_mods( skill_mod.att, skill_mod.spd )
	#	bullet.apply_attribute_mods( skill_mod.bio_damage, skill_mod.cyber_damage, skill_mod.mental_damage, skill_mod.cosmic_damage, skill_mod.zauber_damage )
	bullet.setup_bullet_sprite( curr_gun.get_bullet_sprite(), curr_gun.get_bullet_color() )
	bullet.source_actor = source_actor
	#B2_RoomXY.get_curr_room().add_child( bullet, true )
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
		casing.setup( curr_gun.get_casing_name(), curr_gun.get_casing_sound(), curr_gun.get_casing_scale(), curr_gun.get_casing_speed(), curr_gun.get_casing_color() )
		casing.position = casing_pos
		B2_RoomXY.get_curr_room().add_child( casing, true )

#region timer signal callbacks
func _on_pre_shooting_timer_timeout() -> void:
	print("Delayed shot")
	attack_action()

func _on_firing_rate_timeout() -> void:
	pass # Replace with function body.

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
#endregion

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
