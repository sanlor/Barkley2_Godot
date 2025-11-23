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

@onready var gun_noises_stream		: AudioStreamPlayer = $gun_noises_stream ## Responsible to produce gun noises (winding, for example)
@onready var pre_shooting_timer		: Timer = $pre_shooting_timer	## Timer used when a gun need some time before firing (muskets)
@onready var firing_rate			: Timer = $firing_rate			## Timer used to control the firing rate
@onready var post_shooting_timer	: Timer = $post_shooting_timer	## ## Timer used when a gun need some time after firing

var is_shooting 	:= false 	## Is the players activally shooting?
#var can_shoot 		:= true		## Can the player shoot right now?

var curr_gun 		: B2_Weapon
var source_actor	: B2_CombatActor

func _ready() -> void:
	pre_shooting_timer.one_shot			= true
	firing_rate.one_shot				= true
	post_shooting_timer.one_shot		= true
	
	if get_parent() is B2_CombatActor:		source_actor = get_parent()
	else:									push_error( "Invalid parent: %s" % get_parent().name ); breakpoint
		
	_gun_changed()
	B2_SignalBus.gun_changed.connect( _gun_changed )
	B2_SignalBus.gun_owned_changed.connect( _gun_changed )
	
#region Weapon Operation
		
## Check if the gun can be shot right now.
func _can_shoot() -> bool:
	return firing_rate.is_stopped() and pre_shooting_timer.is_stopped() and post_shooting_timer.is_stopped() and not is_shooting
		
func select_gun( force_gun : B2_Weapon ) -> void:
	B2_Gun.select_gun_from_resource( force_gun )
		
## Actor is shooting a gun (or not, it depends on the "action" var)
func shoot_gun( action : bool ) -> void:
	if action:
		if pre_attack_action( action ):
			
			attack_action()
		
		
## Check combat_gunwield_firing
# Perform speccific checks and actions before firing a gun.
@warning_ignore("unused_parameter")
func pre_attack_action( action : bool ) -> bool:
	var windupSound 	:= curr_gun.weapon_stats.windupSound
	var winddownSound 	:= curr_gun.weapon_stats.winddownSound
	var sustainSound 	:= curr_gun.weapon_stats.sustainSound
	
	var pWindUp 		:= curr_gun.weapon_stats.pWindUp
	
	
	var fireTimer 	:= curr_gun.weapon_stats.pFireTimerTarget * ( 1 - curr_gun.weapon_stats.pShotDelay)
	var delayTimer 	:= curr_gun.weapon_stats.pFireTimerTarget * (curr_gun.weapon_stats.pShotDelay)
	
	## TODO check if this applies to this version.
	#if (gun[? "pChargeRatio"] >= 1 and actor.gunBursting > 0 and (
	#	gun[? "pType"] == GUN_TYPE_MACHINEPISTOL or
	#	gun[? "pType"] == GUN_TYPE_ASSAULTRIFLE)) {
	#actor.gunBursting = 0;
	#}
	
	if curr_gun.weapon_stats.pWindUpSpeed > 0.0:
		
		## Player is holding the trigger
		if action: ## CRITICAL TODO Check if player is holding the trigger
		
			## Unsure what this does. Maybe play sfx only after a certain threshold? <- Understood it now.
			# Handles SpinUp and SpinDown sfx, based on if you are holding the trigger.
			# NOTE This should not work as is, since we are using a different method to trigger a gun.
			if pWindUp > 60.0 and not winddownSound.is_empty(): pass ## TODO play spin up sfx
			
			if pWindUp < 100.0:
				if not windupSound.is_empty():
					#if (triggerPressed || !audio_is_playing_ext(windupSound)):
					#	audio_stop_sound_ext(windupSound);
					#	if(gun[? "pWindUp"] <= 60) 
					#		audio_play_sound_on_actor(actor,windupSound,false,90);
					#		audio_sound_gain_ext(windupSound,1,0);
					pass
			
				## Wind up gun
				# Increase the gun Windup variable. NOTE this need to be tweaked to work on this new system.
				pWindUp += max( 3, curr_gun.weapon_stats.pWindUpSpeed / curr_gun.weapon_stats.pWeight * 0.5) * get_physics_process_delta_time() * windupModifier
				pWindUp = min(100, pWindUp)
		
		## Player is NOT holding the trigger
		else:
			if not windupSound.is_empty():
				pass # TODO audio_sound_gain_ext(windupSound,0,500);
			if pWindUp > 60:
				if not winddownSound.is_empty(): # TODO && !audio_is_playing_ext(winddownSound)) {
					pass # TODO audio_play_sound_on_actor(actor,winddownSound,false,90);
			# gun[? "reloaded"] = false;
			if pWindUp > 4:
				pWindUp -= 24 * get_physics_process_delta_time() * windupModifier
				pWindUp = max(0, pWindUp);
			else:
				pWindUp = 0;
				if not windupSound.is_empty():
					pass # TODOaudio_stop_sound_ext(windupSound);
			if not sustainSound.is_empty():
				pass
				## TODO
				#if(audio_is_playing_ext(sustainSound))
				#	audio_stop_sound_ext(sustainSound);
	
	## delayed shot: flintlocks etc
	if delayTimer > 0:
		pass
		
	## Actually shoot the gun.
	## TODO
	return true
	
@warning_ignore("unused_parameter")
func post_attack_action() -> void:
	pass
		

## Check combat_gunwield_shoot
## Check o_bullet
func attack_action() -> void:
	if not curr_gun: push_error("Gun resource not loaded correctly."); return
		
	## Can't shoot again while the respective timers are still active.
	if not _can_shoot(): return
		
	var casing_pos 	:= source_actor.get_attack_origin()
	var dir			:= source_actor.curr_aim
		
	## Start timers and necessary variables.
	is_shooting = true
	firing_rate.start( curr_gun.wait_per_shot )
	
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
			curr_gun.use_ammo( curr_gun.ammo_per_shot )
			B2_Sound.play( curr_gun.get_soundID() )
			_create_flash( source_pos, dir, 1.5)
			for i in curr_gun.ammo_per_shot: ## Double barrel shotgun spawn 2 casings
				_create_casing( casing_pos)
				
			## only apply knockback if you actually fire the weapon.
			source_actor.apply_central_impulse( -dir * curr_gun.get_gun_knockback() ) 
			
			## Spawn bullets. Handguns shoot only one bullet per shot. Shotguns can shoot many per shot.
			for i in curr_gun.bullets_per_shot:
				source_pos = get_parent().get_muzzle_position() ## Update position.
				
				var my_spread_offset := curr_gun.bullet_spread * ( float(i) / float(curr_gun.bullets_per_shot) )
				my_spread_offset -= curr_gun.bullet_spread / curr_gun.bullets_per_shot
				
				## Aim variations
				var my_acc := curr_gun.get_acc() * B2_Config.BULLET_SPREAD_MULTIPLIER
				var b_dir := dir.rotated( randf_range( -my_acc, my_acc ) + my_spread_offset )
				
				_create_bullet( source_pos, b_dir )
		else:
			## Out of ammo.
			B2_Sound.play( "hoopz_click" )
	
	## Used by the turn-based combat
	curr_gun.reset_action( curr_gun.curr_action - curr_gun.attack_cost )
	
	## Reset variable. NOTE This may not be needed anymore, since we don't AWAIT stuff no more.
	is_shooting = false
#endregion
		
func _gun_changed() -> void:
	if B2_Gun.has_any_guns():
		curr_gun = B2_Gun.get_current_gun()
		_update_timers()
	
## After a gun changes, update its timers to avoid being able to change weapont and instantly shooting them.
func _update_timers() -> void:
	pre_shooting_timer.start( curr_gun.delay_before_action )
	firing_rate.start( curr_gun.wait_per_shot )
	post_shooting_timer.start( curr_gun.delay_after_action )

func gun_noises_control( sfx_name : String ) -> void:
	if gun_noises_stream.playing:
		push_warning("gun_noises_stream was playin something...")
		gun_noises_stream.stop()
	var stream_file : AudioStreamOggVorbis = B2_Sound.get_sound_stream( sfx_name )
	stream_file.loop = false
	gun_noises_stream.stream = stream_file
	gun_noises_stream.play()

## Create a bullet object on the current room
func _create_bullet( source_pos : Vector2, dir : Vector2, skill_mod : B2_WeaponSkill = null ) -> void:
	var bullet = O_BULLET.instantiate()
	bullet.my_gun = curr_gun
	bullet.set_direction( dir )
	if skill_mod:
		bullet.apply_stat_mods( skill_mod.att, skill_mod.spd )
		bullet.apply_attribute_mods( skill_mod.bio_damage, skill_mod.cyber_damage, skill_mod.mental_damage, skill_mod.cosmic_damage, skill_mod.zauber_damage )
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
		flash.rotation += randf_range( -PI/32.0, PI/32.0 )
		flash.scale = Vector2.ONE * randf_range( 0.8, 1.2 )
		flash.scale *= _scale
		flash.modulate.a *= randf_range( 0.8, 1.2 )
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
	pass # Replace with function body.

func _on_firing_rate_timeout() -> void:
	pass # Replace with function body.

func _on_post_shooting_timer_timeout() -> void:
	pass # Replace with function body.
#endregion

## TODO
func _on_gun_noises_stream_finished() -> void:
	pass # Replace with function body.
