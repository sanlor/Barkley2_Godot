@icon("res://barkley2/assets/b2_original/images/merged/icon_parent.png")
extends B2_CombatActor
class_name B2_PlayerCombatActor

## Class used only by Hoopz - Mostly used to organize things.
## WARNING Class incomplete. Its missing a lot of things.

## Check B2_Player for the movement code and aiming, damage and such.

# Non combat related animations
const SHUFFLE 		:= "shuffle"
const STAND 		:= "stand"
const STAND_E 		:= 0
const STAND_NE 		:= 1
const STAND_N		:= 2
const STAND_NW		:= 3
const STAND_W		:= 4
const STAND_SW		:= 5
const STAND_S		:= 6
const STAND_SE		:= 7

const WALK_E 		:= "walk_E"
const WALK_NE 		:= "walk_NE"
const WALK_N		:= "walk_N"
const WALK_NW		:= "walk_NW"
const WALK_W		:= "walk_W"
const WALK_SW		:= "walk_SW"
const WALK_S		:= "walk_S"
const WALK_SE		:= "walk_SE"

# Combat related animations
const COMBAT_SHUFFLE 		:= "aim_shuffle"
const COMBAT_STAND 			:= "aim_stand"
const COMBAT_STAND_E 		:= 0
const COMBAT_STAND_NE 		:= 1
const COMBAT_STAND_N		:= 2
const COMBAT_STAND_NW		:= 3
const COMBAT_STAND_W		:= 4
const COMBAT_STAND_SW		:= 5
const COMBAT_STAND_S		:= 6
const COMBAT_STAND_SE		:= 7

const COMBAT_WALK_E 		:= "walk_E"
const COMBAT_WALK_NE 		:= "walk_NE"
const COMBAT_WALK_N			:= "walk_N"
const COMBAT_WALK_NW		:= "walk_NW"
const COMBAT_WALK_W			:= "walk_W"
const COMBAT_WALK_SW		:= "walk_SW"
const COMBAT_WALK_S			:= "walk_S"
const COMBAT_WALK_SE		:= "walk_SE"

# Used on the tutorial
const DIAPER_GROUND 	:= "diaper_ground"
const DIAPER_SPANK 		:= "diaper_spank"
const DIAPER_GETUP 		:= "diaper_getup"
const DIAPER_GOOROLL 	:= "diaper_gooroll"
const DIAPER_SPANKCRY 	:= "diaper_spankcry"

## Used to calculate aim, look and move direction
const DIR_RIGHT				:= 0.0
const DIR_RIGHT_DOWNISH 	:= 0.46364760398865
const DIR_RIGHT_DOWN		:= 0.78539818525314
const DIR_DOWN_RIGHTISH		:= 1.10714876651764
const DIR_DOWN				:= 1.57079637050629
const DIR_DOWN_LEFTISH		:= 2.03444385528564
const DIR_LEFT_DOWN			:= 2.35619449615479
const DIR_LEFT_DOWNISH		:= 2.67794513702393
const DIR_LEFT				:= 3.14159274101257
const DIR_LEFT_UPISH		:= -2.67794513702393
const DIR_LEFT_UP			:= -2.35619449615479
const DIR_UP_LEFTISH		:= -2.03444385528564
const DIR_UP				:= -1.57079637050629
const DIR_UP_RIGHTISH		:= -1.10714876651764
const DIR_RIGHT_UP			:= -0.78539818525314
const DIR_RIGHT_UPISH	 	:= -0.46364760398865

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D
@export var combat_weapon_fuse		: AnimatedSprite2D
@export var combat_weapon_parts 	: AnimatedSprite2D
@export var combat_weapon_spots 	: AnimatedSprite2D
@export var combat_shield			: AnimatedSprite2D
@export var gun_muzzle				: Marker2D

@export_category("Gun Handler")
@export var gun_handler				: Node

@export_category("Animation")
@export var normal_anim_speed_scale	:= 2.0
@export var STAGGER					:= "stagger"
@export var ROLL					:= "full_roll" # "diaper_gooroll"
@export var ROLL_BACK				:= "full_roll_back" # "diaper_gooroll"

@export var hoopz_normal_body		: AnimatedSprite2D
@export var step_smoke				: GPUParticles2D
@export var hit_timer				: Timer
@export var i_frame_timer			: Timer

@export_category("Light Stuff")
@export var flashlight_enabled 		:= true
@export var flashlight_pivot 		: Marker2D
@export var flashlight 				: PointLight2D

@export_category("Scpecial cases")
@export var combat_ready					:= true # This actor can't do battle. NOTE OO player or mathias can't do battle.
@export var can_shuffle						:= true # This actor can shuffle its feets.
@export var can_roll						:= true # This actor is able to roll, granted it has permission.
@export var can_flip_sprite					:= false # This actor's sprite can be flipped.

## Sound
var min_move_dist 	:= 1.0
var move_dist 		:= 0.0 # Avoid issues with SFX playing too much during movement. # its a bad sollution, but ist works.
 
# Animation
var is_turning 					:= false # Shuffling when turning using the mouse. # check scr_player_stance_diaper() line 142
var turning_time 				:= 0.25
var is_on_a_puddle				:= false
var is_on_water					:= false
var last_stand_frame 			:= 0	# Used to remember the last animation frame used.
var last_combat_stand_frame 	:= 0 # Used to remember the last animation frame used. (Combat related)

# player direction is influenced by the mouse position
var follow_mouse := true

# Used when you are hit.
var hit_tween : Tween

# Combat Vars, used for animations
var aim_dir := Vector2.ZERO
var waddle	:= false # If hoopz legs should waddle torward the aiming direction

var combat_last_direction 	:= Vector2.ZERO
var combat_last_input 		:= Vector2.ZERO

var prev_gun : B2_Weapon ## Used to update animations

func _enter_tree() -> void:
	if hit_timer:
		if not hit_timer.timeout.is_connected( _on_hit_timer_timeout ):
			hit_timer.timeout.connect( _on_hit_timer_timeout )

## Debug stuff
func debug_enable_collision( enabled : bool ) -> void:
	push_error( "%s: collision -> ' %s '." % [name,not enabled] )
	ActorCol.disabled = enabled

func apply_curr_input( dir : Vector2 ) -> void:
	if curr_STATE != STATE.HIT:
		curr_input = dir
	
func apply_curr_aim( dir : Vector2 ) -> void:
	if curr_STATE != STATE.HIT:
		curr_aim = dir
		if curr_aim != Vector2.ZERO:
			last_aim = curr_aim

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if B2_Debug.can_disable_player_col:
			if Input.is_key_pressed(KEY_F4):
				toggle_collision()
	
func toggle_collision() -> void:
	var hoopz_collision: CollisionShape2D = $hoopz_collision
	hoopz_collision.disabled = not hoopz_collision.disabled
	print_rich("[color=red][b]Hoopz collision has been changed to %s. This should not happen outside of DEBUG situations.[/b][/color]" % not hoopz_collision.disabled)

func add_smoke(): ## TODO Web exports dont support this. Maybe fix this?
	if not is_on_a_puddle and not is_on_water: ## emit smoke on water?
		for i in randi_range( 1, 4 ):
			var rand_offset := Vector2( randf_range(-4.0,4.0), randf_range(-4.0,4.0) )
			step_smoke.emit_particle( Transform2D( 0, step_smoke.position + rand_offset ), Vector2( randf_range(-20,20), randf_range(0,-20) ), Color.WHITE, Color.WHITE, 2 )
	
func _point_flashlight( input : Vector2 ) -> void:
	flashlight_pivot.rotation = input.angle() - PI/2
	
func _update_flashlight() -> void:
	match curr_STATE:
		STATE.NORMAL, STATE.AIM:
			flashlight.enabled = (true == flashlight_enabled) ## is only true if both is true.
		_:
			flashlight.enabled = false
			
func _change_sprites():
	match curr_STATE:
		STATE.NORMAL, STATE.ROLL, STATE.HIT:
			hoopz_normal_body.show()
			
			if combat_ready:
				combat_lower_sprite.hide()
				combat_upper_sprite.hide()
				combat_arm_back.hide()
				combat_arm_front.hide()
				combat_weapon.hide()
				combat_weapon_parts.hide()
				combat_weapon_spots.hide()
		STATE.AIM, STATE.SHOOT:
			hoopz_normal_body.hide()
			
			if combat_ready:
				combat_lower_sprite.show()
				combat_upper_sprite.show()
				combat_arm_back.show()
				combat_arm_front.show()
				combat_weapon.show()
				if B2_Gun.get_current_gun():
					combat_weapon_parts.visible 	= B2_Gun.get_current_gun().weapon_stats.displayParts
					combat_weapon_spots.visible 	= B2_Gun.get_current_gun().weapon_stats.displaySpots
			
func _update_held_gun() -> void:
	if curr_STATE == STATE.AIM:
		var gun := B2_Gun.get_current_gun()
		if gun:
			if gun != prev_gun:
				set_gun( gun.get_held_sprite(), gun.weapon_type )
				
				assert( is_instance_valid(gun.weapon_stats), "Gun stats invalid.")
				
				combat_weapon.modulate 			= Color.html( gun.weapon_stats.gunheldcol1 )	## Base color
				
				combat_weapon_parts.visible 	= gun.weapon_stats.displayParts
				combat_weapon_parts.modulate 	= Color.html( gun.weapon_stats.gunheldcol2 )	## Parts color
					
				combat_weapon_spots.visible 	= gun.weapon_stats.displaySpots
				combat_weapon_spots.modulate 	= Color.html( gun.weapon_stats.gunheldcol3 )	## Spots color
				
				prev_gun = gun
			
## Change the held weapon sprite. Also can change hoopz torso.
## NOTE Check combat_gunwield_drawGun_player_frontHand() and combat_gunwield_drawGun_player_backHand().
## WARNING Missing "Dual" type. TODO
func set_gun( gun_name : String, gun_type : B2_Gun.TYPE ) -> void:
	if combat_weapon.sprite_frames.has_animation( gun_name ):
		combat_weapon.show()
		combat_weapon.animation = gun_name
	else: combat_weapon.hide(); push_warning("Invalid main gun sprite")
		
	if combat_weapon_parts.sprite_frames.has_animation( gun_name ):
		combat_weapon_parts.show()
		combat_weapon_parts.animation = gun_name
	else: combat_weapon_parts.hide(); push_warning("Invalid main gun parts sprite")
		
	if combat_weapon_spots.sprite_frames.has_animation( gun_name ):
		combat_weapon_spots.show()
		combat_weapon_spots.animation = gun_name
	else: combat_weapon_spots.hide(); push_warning("Invalid main gun spots sprite")
	
	# Save current frame. changing animations resets the frame
	var combat_arm_back_frame 	:= combat_arm_back.frame
	var combat_arm_front_frame 	:= combat_arm_front.frame
	
	# Apply new torso animation
	if [
		B2_Gun.TYPE.GUN_TYPE_REVOLVER,
		B2_Gun.TYPE.GUN_TYPE_PISTOL,
		B2_Gun.TYPE.GUN_TYPE_FLINTLOCK,
		B2_Gun.TYPE.GUN_TYPE_FLAREGUN,
		B2_Gun.TYPE.GUN_TYPE_MAGNUM,
		B2_Gun.TYPE.GUN_TYPE_SUBMACHINEGUN,
		B2_Gun.TYPE.GUN_TYPE_MACHINEPISTOL ].has( gun_type ): 
			combat_arm_back.animation 	= "s_HoopzTorso_Handgun"
			combat_arm_front.animation 	= "s_HoopzTorso_Handgun"
	elif [
		B2_Gun.TYPE.GUN_TYPE_HEAVYMACHINEGUN,
		B2_Gun.TYPE.GUN_TYPE_ASSAULTRIFLE,
		B2_Gun.TYPE.GUN_TYPE_RIFLE,
		B2_Gun.TYPE.GUN_TYPE_MUSKET,
		B2_Gun.TYPE.GUN_TYPE_HUNTINGRIFLE,
		B2_Gun.TYPE.GUN_TYPE_TRANQRIFLE,
		B2_Gun.TYPE.GUN_TYPE_SHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_DOUBLESHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_REVOLVERSHOTGUN,
		B2_Gun.TYPE.GUN_TYPE_ELEPHANTGUN,
		B2_Gun.TYPE.GUN_TYPE_FLAMETHROWER,
		B2_Gun.TYPE.GUN_TYPE_CROSSBOW,
		B2_Gun.TYPE.GUN_TYPE_SNIPERRIFLE].has( gun_type ):
			combat_arm_back.animation 	= "s_HoopzTorso_Rifle"
			combat_arm_front.animation 	= "s_HoopzTorso_Rifle"
	elif [
		B2_Gun.TYPE.GUN_TYPE_GATLINGGUN,
		B2_Gun.TYPE.GUN_TYPE_MINIGUN,
		B2_Gun.TYPE.GUN_TYPE_MITRAILLEUSE,
		B2_Gun.TYPE.GUN_TYPE_BFG,].has( gun_type ):
			combat_arm_back.animation 	= "s_HoopzTorso_Heavy"
			combat_arm_front.animation 	= "s_HoopzTorso_Heavy"
	elif gun_type == B2_Gun.TYPE.GUN_TYPE_ROCKET:
			combat_arm_back.animation 	= "s_HoopzTorso_Rocket"
			combat_arm_front.animation 	= "s_HoopzTorso_Rocket"
	else:
		## Unknown type. Should never hit this.
		breakpoint
		
	# reapply the animation frame
	combat_arm_back.frame 	= combat_arm_back_frame
	combat_arm_front.frame 	= combat_arm_front_frame
			
## Minigun & Magnum spin animation
func switch_combat_weapon_anim( anim : String ) -> void:
	if combat_weapon.sprite_frames.has_animation(anim):						## Check if base animation exists
		if combat_weapon.sprite_frames.has_animation(anim + "_Anim"):		## Check if the alternative animation exists (it may not, like in the 's_Mitrailleuse' case)
			var last_frame := combat_weapon.frame							## Save current frame (direction)
			if combat_weapon.animation == anim:		combat_weapon.animation = anim + "_Anim"	# Toggle animation
			else:									combat_weapon.animation = anim				# Toggle animation
			combat_weapon.frame = last_frame								## Restore current frame (direction)
	else:
		push_error("Invalid Animation: ", anim)
			
## For spreccific guns
func light_fuse() -> void:
	if combat_weapon_fuse:
		combat_weapon_fuse.play()
	else: push_error( "combat_weapon_fuse -> not set." )

func flash_gun( state : bool ) -> void:
	if combat_weapon:
		combat_weapon.material.set_shader_parameter( "hit_effect", 0.6 * float(state) )
	else:
		# No combat weapon????
		breakpoint

## Used to know where should a bullet spawn
func get_muzzle_position( inverted := false, random := false ) -> Vector2:
	var pos : Vector2
	if random: ## Return a random position, around the player
		pos = to_global( gun_muzzle.position.rotated( randf_range(0,TAU) ) )
	else:
		if inverted:	pos = to_global(gun_muzzle.position)
		else:			pos = gun_muzzle.global_position
	return pos
	
## Used to know where the gun currlently is.
func get_attack_origin() -> Vector2:
	return combat_weapon.global_position

## Used to apply a gun offset when a shot is fired.
func set_gun_reloaded( _reload_state : bool ) -> void:
	pass

## Return a valid aim vector (curr_aim or last_aim)
func get_aim() -> Vector2:
	if curr_aim:
		return curr_aim
	else:
		return last_aim

func normal_animation(delta : float):
	var input := (curr_input * 2.5).normalized().round()
	
	hoopz_normal_body.speed_scale = max( curr_input.length_squared(), 0.4 ) * normal_anim_speed_scale # Gamepad mod. Since you can move slowly using the gamepad, match the walking animation to the analog input.
	
	if input != Vector2.ZERO: # Player is moving the character
		if flashlight:
			_point_flashlight( input )
			
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:			hoopz_normal_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:			hoopz_normal_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:		hoopz_normal_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:		hoopz_normal_body.play(WALK_SE)
					
				Vector2.UP:							hoopz_normal_body.play(WALK_N)
				Vector2.LEFT:						hoopz_normal_body.play(WALK_W)
				Vector2.DOWN:						hoopz_normal_body.play(WALK_S)
				Vector2.RIGHT:						hoopz_normal_body.play(WALK_E)
					
				_: # Catch All
					hoopz_normal_body.play(WALK_S)
					print("Hoopz normal_animation: input -> Catch all, ", input)
			
			if can_flip_sprite:
				hoopz_normal_body.flip_h = input.x < 0
	else:
		# player is not moving the character anymore
		hoopz_normal_body.stop()
		move_dist = min_move_dist
		var curr_direction : Vector2 = last_input 
		
		if follow_mouse and curr_aim != Vector2.ZERO: # if curr_aim == Vector.ZERO, leave this alone.
			curr_direction = curr_aim # position.direction_to( curr_aim )
			if input == Vector2.ZERO:
				if flashlight:		_point_flashlight( curr_direction )
			curr_direction = curr_direction.round()
			
		if curr_direction != last_direction and curr_direction != Vector2.ZERO: ## Handle the Shuffling animation when you change facind direction.
			if hoopz_normal_body.animation == STAND:
				turning_time = 0.5
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0 and can_shuffle:
			hoopz_normal_body.animation = SHUFFLE
			if not is_turning: # play step sound when you change directions, during shuffle.
				#B2_Sound.play_pick("hoopz_footstep") ## WARNING Original game doesnt do this.
				add_smoke()
				is_turning = true # Ensures that the SFX plays only once.
			turning_time -= 6.0 * delta
		else:
			hoopz_normal_body.animation = STAND
			hoopz_normal_body.frame = last_stand_frame
			is_turning = false
			
		hoopz_normal_body.frame = last_stand_frame ## The last frame is the default.
		
		# change the standing animation itself.
		match curr_direction:
		#match last_direction:
			Vector2.UP + Vector2.LEFT:				hoopz_normal_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:				hoopz_normal_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:			hoopz_normal_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:			hoopz_normal_body.frame = STAND_SE
				
			Vector2.UP:				hoopz_normal_body.frame = STAND_N
			Vector2.LEFT:			hoopz_normal_body.frame = STAND_W
			Vector2.DOWN:			hoopz_normal_body.frame = STAND_S
			Vector2.RIGHT:			hoopz_normal_body.frame = STAND_E
			_: # Catch All
				#hoopz_normal_body.frame = last_stand_frame
				pass
		
		if hoopz_normal_body.frame != last_stand_frame:
			last_stand_frame = hoopz_normal_body.frame
		
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input
	#print(hoopz_normal_body.animation)
	#print(hoopz_normal_body.frame)

func can_be_damaged() -> bool:
	return curr_STATE == STATE.SHOOT or curr_STATE == STATE.AIM or curr_STATE == STATE.NORMAL or curr_STATE == STATE.JUMP or curr_STATE == STATE.POINT

func damage_actor( damage : float, force : Vector2 ) -> void:
	if curr_STATE == STATE.DEFEAT or curr_STATE == STATE.DEFEAT: ## TODO remove this check
		## Dont apply damage if the battle is over.
		return
		
	if curr_STATE == STATE.ROLL: ## TODO remove this check
		## Dont apply damage if the player is rolling.
		return
		
	if not can_be_damaged():
		return
		
	if curr_STATE != STATE.DEFENDING:
		if i_frame_timer.is_stopped():
			## Hoopz got hit
			hit_timer.start( 0.5 )
			if curr_STATE == STATE.ROLL:
				linear_velocity = Vector2.ZERO
				B2_Playerdata.player_stats.block_action_increase = false
				
			## Deal with some issues with animations and getting stuck on wrong states
			if curr_STATE == STATE.SHOOT:
				curr_STATE = STATE.AIM
				
			## Hoopz was hit, start stagger animation and related shit.
			i_frame_timer.start()
			curr_STATE = STATE.HIT
			
			## TODO Add chance for hoopz not to stagger when hit.
			if hoopz_normal_body.sprite_frames.has_animation(STAGGER):
				hoopz_normal_body.stop()
				hoopz_normal_body.animation = STAGGER
				hoopz_normal_body.frame = 0
				curr_aim = Vector2.ZERO
				curr_input = Vector2.ZERO
			else: print("o_cbt_hoopz: has no stagger animation.")
			
			#B2_Sound.play_pick( "general_impact" ) ## TODO Better impact sounds. check B2_Sound line 1025
			B2_Sound.play_pick( "hoopzDmgSoundNormal" ) ## TODO add different sfx based on the attack type.
			
			if hit_tween:
				hit_tween.kill()
			hit_tween = create_tween()
			modulate = Color.WHITE * 5.0
			hit_tween.tween_property(self, "modulate", Color.WHITE, 0.1)
		else:
			pass ## I frame is running. Do nothing.
	else:
		## Hoopz was defending
		B2_Sound.play_pick("crab_hit_metal")
		@warning_ignore("narrowing_conversion")
		damage *= 0.5 ## TODO add actually some calculations to specifi the shields damage reduction.
	
	## Apply damage
	@warning_ignore("narrowing_conversion")
	B2_Playerdata.player_stats.decrease_hp( damage )
	B2_Screen.display_damage_number( self, damage )
	apply_central_impulse( force )
	
	## ## Hoopz was hit, Check if ded :(
	if B2_Playerdata.player_stats.curr_health == 0:
		print_rich("[color=red]H O O P Z I S D E A D .[/color]")
		linear_velocity = Vector2.ZERO
		defeat_anim()
		
		B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT ) ## Change cursor to its default (in case you die while shooting)
		B2_CombatManager.player_defeated()
		is_actor_dead = true
			
		## Add a bunch of blood. Go crazy with it.
		for i in randi_range(10,30):
			@warning_ignore("narrowing_conversion")
			B2_Screen.make_blood_drop( global_position + Vector2(0,-8) + Vector2( randf_range(-8,8), randf_range(-8,8) ), randf_range(0.5,5.0) )
			for d in randi_range(0,2):
				await get_tree().physics_frame
	
	## Hoopz was hit, but is still alive
	else:
		if B2_Gun.get_current_gun().is_shooting: ## Stop shooting if hit.
			B2_Gun.get_current_gun().abort_shooting = true
			
		## Make some blood splatter
		@warning_ignore("integer_division")
		@warning_ignore("narrowing_conversion")
		var n : int = max( 1.0, randi_range( 1.0, damage / 15.0 ) )
		for i in n:
			B2_Screen.make_blood_drop( global_position + Vector2(0,-16) + Vector2( randf_range(-15,15), randf_range(-15,15) ), randi_range(1,2) )
			
		B2_SignalBus.hoopz_got_hit.emit() ## Allow for action cancel.
		B2_Playerdata.player_stats.block_action_increase = false

func defeat_anim() -> void:
	## TODO Defeat doesnt exits yet.
	## NOTE 26/04/25 it does now.
	if curr_STATE == STATE.ROLL:
		stop_rolling()
	if curr_STATE == STATE.AIM:
		stop_aiming()
	curr_STATE = STATE.DEFEAT
	_change_sprites()
	hoopz_normal_body.flip_h = false
	B2_Sound.play( "hoopz_demise" )
	hoopz_normal_body.play( "demise" )

# Roll action
func start_rolling( _roll_dir : Vector2 ) -> void:
	pass
	
func stop_rolling() -> void:
	pass
	
func start_aiming() -> void:
	pass
	
func stop_aiming() -> void:
	pass

## Used to throw gunbag guns, when in a pinch.
func throw_gun() -> void:
	if curr_STATE == STATE.AIM:
		if B2_Playerdata.gunbag_open:
			const O_THROWN_OBJECT = preload("uid://ubxvkr2io2ix")
			var obj := O_THROWN_OBJECT.instantiate()
			add_sibling( obj, true )
			obj.global_position = global_position + Vector2( 0, -8 )
			obj.setup( global_position.direction_to( get_aim() ), B2_Gun.get_current_gun().get_weapon_hud_sprite() )
			obj.damage_amount = maxf( float( B2_Gun.get_current_gun().get_curr_ammo() ) / float( B2_Gun.get_current_gun().get_max_ammo() ), 0.25 )
			B2_Gun.remove_gun_from_gunbag( B2_Gun.get_current_gun() )
			_update_held_gun()
			B2_Sound.play("catfishshield_netthrow")
		else: print("Throwing a Bando gun not supported.")
	
func _on_hit_timer_timeout() -> void:
	if curr_STATE == STATE.DEFEAT or curr_STATE == STATE.DEFEAT:
		## stop processing states if the battle is over.
		return
		
	## Reset some stuff relatedto animations
	last_input 				= Vector2.INF
	last_direction 			= Vector2.INF
	last_movement_vector 	= Vector2.INF
	
	if curr_STATE == STATE.HIT:
		if prev_STATE == STATE.ROLL: ## Avoid issues with being hit while rolling.
			stop_rolling()
		elif prev_STATE == STATE.DEFENDING:
			curr_STATE = STATE.NORMAL
			
		elif curr_STATE == STATE.AIM:
			curr_STATE = STATE.NORMAL
			
		elif curr_STATE == STATE.SHOOT:
			curr_STATE = STATE.NORMAL
			
		else:
			curr_STATE = prev_STATE
	else:
		breakpoint
