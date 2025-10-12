extends Node
class_name B2_GunHandler
## Node used to interface the player with its gun.
## The Gun_Handler™ handles guns. duh.
# Mainly, its an interface to help communications with the gun resource, holding timers and such.

# the ™ was added for fun. Im curious to see if it can break any part of the game.
# Once, in a Checkpoint firewall, we added a rule with a comment (or name? dont remmember) with a 'ç' on it. The firewall wasnt able to save policies anymore and we spent a few hours trying to fin the reason.

const O_BULLET 		:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_bullet.tscn")
const O_CASINGS 	:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/o_casings.tscn")
const S_FLASH 		:= preload("res://barkley2/scenes/_Godot_Combat/_Guns/muzzle_flash/s_flash.tscn")

@onready var pre_shooting_timer		: Timer = $pre_shooting_timer	## Timer used when a gun need some time before firing (muskets)
@onready var firing_rate			: Timer = $firing_rate			## Timer used to control the firing rate
@onready var post_shooting_timer	: Timer = $post_shooting_timer	## ## Timer used when a gun need some time after firing

var is_shooting 	:= false 	## Is the players activally shooting?
#var can_shoot 		:= true		## Can the player shoot right now?

var curr_gun 		: B2_Weapon

func _ready() -> void:
	pre_shooting_timer.one_shot			= true
	firing_rate.one_shot				= true
	post_shooting_timer.one_shot		= true
	_gun_changed()
	B2_SignalBus.gun_changed.connect( _gun_changed )
	
#region Weapon Operation
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
		
	if curr_gun.get_casing_sound():
		var casing = O_CASINGS.instantiate()
		casing.setup( curr_gun.get_casing_sound(), curr_gun.get_casing_scale(), curr_gun.get_casing_speed(), curr_gun.get_casing_color() )
		casing.position = casing_pos
		B2_RoomXY.get_curr_room().add_child( casing, true )
		
## Create a bullet object on the current room
func _create_bullet( source_pos : Vector2, dir : Vector2, source_actor : B2_CombatActor, skill_mod : B2_WeaponSkill = null ) -> void:
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
		
## Check if the gun can be shot right now.
func _can_shoot() -> bool:
	return firing_rate.is_stopped() and pre_shooting_timer.is_stopped() and post_shooting_timer.is_stopped() and not is_shooting
		
func select_gun( force_gun : B2_Weapon ) -> void:
	B2_Gun.select_gun_from_resource( force_gun )
		
func pre_attack_action() -> void:
	pass
	
func post_attack_action() -> void:
	pass
		
func use_normal_attack( casing_pos : Vector2, dir : Vector2, source_actor : B2_CombatActor ) -> void:
	if not curr_gun:
		push_error("Gun resource not loaded correctly.")
		return
		
	## Can't shoot again while the respective timers are still active.
	if not _can_shoot():
		return
		
	## Start timers and necessary variables.
	is_shooting = true
	firing_rate.start( curr_gun.wait_per_shot )
	
	var source_pos : Vector2 = get_parent().get_muzzle_position()
	
	## Only shoot if you have ammo.
	if curr_gun.has_ammo():
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
			
			_create_bullet( source_pos, b_dir, source_actor )
	else:
		## Out of ammo.
		B2_Sound.play( "hoopz_click" )
	
	## Used by the turn-based combat
	curr_gun.reset_action( curr_gun.curr_action - curr_gun.attack_cost )
	
	## Reset variable. NOTE This may not be needed anymore, since we don't AWAIT stuff no more.
	is_shooting = false
#endregion
		
func _gun_changed() -> void:
	curr_gun = B2_Gun.get_current_gun()
	_update_timers()
	
## After a gun changes, update its timers to avoid being able to change weapont and instantly shooting them.
func _update_timers() -> void:
	pre_shooting_timer.start( curr_gun.delay_before_action )
	firing_rate.start( curr_gun.wait_per_shot )
	post_shooting_timer.start( curr_gun.delay_after_action )

#region timer signal callbacks

func _on_pre_shooting_timer_timeout() -> void:
	pass # Replace with function body.

func _on_firing_rate_timeout() -> void:
	pass # Replace with function body.

func _on_post_shooting_timer_timeout() -> void:
	pass # Replace with function body.
#endregion
