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

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D
@export var combat_weapon_parts 	: AnimatedSprite2D
@export var combat_weapon_spots 	: AnimatedSprite2D
@export var combat_shield			: AnimatedSprite2D
@export var gun_muzzle				: Marker2D

@export_category("Gun Handler")
@export var gun_handler				: Node

@export_category("Animation")
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

## Sound
var min_move_dist 	:= 1.0
var move_dist 		:= 0.0 # Avoid issues with SFX playing too much during movement. # its a bad sollution, but ist works.
 
# Animation
var is_turning 		:= false # Shuffling when turning using the mouse. # check scr_player_stance_diaper() line 142
var turning_time 	:= 1.0

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

func apply_curr_input( dir : Vector2 ) -> void:
	if curr_STATE != STATE.HIT:
		curr_input = dir
	
func apply_curr_aim( dir : Vector2 ) -> void:
	if curr_STATE != STATE.HIT:
		curr_aim = dir

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if B2_Debug.can_disable_player_col:
			if Input.is_key_pressed(KEY_F4):
				toggle_collision()

func toggle_collision() -> void:
	var hoopz_collision: CollisionShape2D = $hoopz_collision
	hoopz_collision.disabled = not hoopz_collision.disabled
	print_rich("[color=red][b]Hoopz collision has been changed to %s. This should not happen outside of DEBUG situations.[/b][/color]" % not hoopz_collision.disabled)

func add_smoke():
	#for i in randi_range( 1, 2 ):
	step_smoke.emit_particle( Transform2D( 0, step_smoke.position ), Vector2.ZERO, Color.WHITE, Color.WHITE, 2 )
	
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
			
			combat_lower_sprite.hide()
			combat_upper_sprite.hide()
			combat_arm_back.hide()
			combat_arm_front.hide()
			combat_weapon.hide()
			combat_weapon_parts.hide()
			combat_weapon_spots.hide()
		STATE.AIM, STATE.SHOOT:
			hoopz_normal_body.hide()
			
			combat_lower_sprite.show()
			combat_upper_sprite.show()
			combat_arm_back.show()
			combat_arm_front.show()
			combat_weapon.show()
			combat_weapon_parts.show()
			combat_weapon_spots.show()
			
func normal_animation(delta : float):
	var input := curr_input
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		_point_flashlight( input )
		
		if last_input != input:
			add_smoke()
			
			match input.round():
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
					print("Catch all, ", input)
	else:
		# player is not moving the character anymore
		hoopz_normal_body.stop()
		move_dist = min_move_dist
		
		var curr_direction : Vector2 = input
		
		if follow_mouse:
			curr_direction = position.direction_to( curr_aim ) # position.direction_to( get_global_mouse_position() ).round()
			if input == Vector2.ZERO:
				_point_flashlight( curr_direction )
				
			curr_direction = curr_direction.round()
		
		if curr_direction != last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			hoopz_normal_body.animation = SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle.
				## WARNING Original game doesnt do this.
				#B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			hoopz_normal_body.animation = STAND
			is_turning = false
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:				hoopz_normal_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:				hoopz_normal_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:			hoopz_normal_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:			hoopz_normal_body.frame = STAND_SE
				
			Vector2.UP:				hoopz_normal_body.frame = STAND_N
			Vector2.LEFT:			hoopz_normal_body.frame = STAND_W
			Vector2.DOWN:			hoopz_normal_body.frame = STAND_S
			Vector2.RIGHT:			hoopz_normal_body.frame = STAND_E
				
			_: # Catch All
				hoopz_normal_body.frame = STAND_S
				
		# Update var
		last_direction = curr_direction
		
	# Update var
	last_input = input

func damage_actor( damage : float, force : Vector2 ) -> void:
	if curr_STATE == STATE.DEFEAT or curr_STATE == STATE.DEFEAT:
		## Dont apply damage if the battle is over.
		return
		
	if curr_STATE == STATE.ROLL:
		## Dont apply damage if the player is rolling.
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
		damage *= 0.5
	
	@warning_ignore("narrowing_conversion")
	B2_Playerdata.player_stats.decrease_hp( damage )
	B2_Screen.display_damage_number( self, damage )
	apply_central_impulse( force )
	
	## Check if ded :(
	if B2_Playerdata.player_stats.curr_health == 0:
		print_rich("[color=red]H O O P Z I S D E A D .[/color]")
		linear_velocity = Vector2.ZERO
		
		defeat_anim()
		
		B2_CombatManager.player_defeated()
		
		if false: # 10/08/25 disabled the code bellow.
			if is_instance_valid( B2_CManager.combat_manager ):
				B2_CManager.combat_manager.player_defeated()
			else:
				## CM should be loaded.
				# 02/08/25 Not always.
				#breakpoint
				push_warning("Combat Manager not loaded.")
			
		## Add a bunch of blood. Go crazy with it.
		for i in randi_range(10,60):
			@warning_ignore("narrowing_conversion")
			B2_Screen.make_blood_drop( global_position + Vector2(0,-8) + Vector2( randf_range(-8,8), randf_range(-8,8) ), randf_range(0.5,5.0) )
			for d in randi_range(0,2):
				await get_tree().physics_frame
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
