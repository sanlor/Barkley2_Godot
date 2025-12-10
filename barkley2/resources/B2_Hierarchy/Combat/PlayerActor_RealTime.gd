@icon("res://barkley2/assets/b2_original/images/merged/sHoopzFace.png")
extends B2_PlayerCombatActor
class_name B2_Player_FreeRoam

# I THINK o_hoopz is the main player object. there is also o_cts_hoopz, but I think its only meant for cutscenes. 
# Not being able to debug the original game makes this harder.

# check scr_player_init()
# check scr_player_step_executePipeline()
# check scr_player_step_processInput() #  NOTE Handle player input
# check scr_player_step_preProcessing() # NOTE Handle player damage and combat?
# check scr_player_calculateWeight() # NOTE Oh fuck you
# check BodySwap() # INFO IMPORTANT Has important setup for each body. What a mess.
# check scr_player_stance_diaper() # NOTE Finally, stuff related to the audio and steps.
# i hate this

## NOTE
# Missing footsteps o_hoopz_footstep
# Missing "Wading wave" (No idea what it is)

## Combat
# Check scr_player_stance_drawing()
# Check scr_player_stance_gunmode()
# Check scr_player_draw_walking_gunmode()



@export_category("Player Permission")
#@export var can_roll 		:= true
@export var can_draw_weapon := true
@export var can_shoot		:= true

@onready var aim_origin: 		Marker2D 					= $aim_origin
@onready var aim_reticle: 		AnimatedSprite2D 			= $aim_origin/aim_reticle
@onready var interaction_node: 	B2_Player_Interaction_Node 	= $aim_origin/interaction_node

## Gun Stuff
var gun_held_offset := 0.0 # offset used when a gun was not reloaded / cocked yet.

## Debug
var debug_line 			: Vector2
var debug_walk_dir 		: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert( is_instance_valid(actor_ai), "No valid AI found." )
	actor_ai.actor = self
	_connect_ai_signals()
	
	B2_CManager.o_hoopz = self
	B2_SignalBus.player_follow_mouse.connect( func(state): follow_mouse = state )
	B2_SignalBus.player_input_permission_changed.connect( func(): curr_aim = Vector2.ZERO; curr_input = Vector2.ZERO ) ## Avoid moving torward a direction if control is taken from the player.
	B2_SignalBus.gun_changed.connect( _update_held_gun )
	linear_damp = walk_damp
	
	_change_sprites()
	if flashlight:
		if get_parent() is B2_ROOMS: flashlight_enabled = get_parent().get_room_darkness()
		else: flashlight_enabled = false
		flashlight.enabled = flashlight_enabled
	
	## Default animation
	hoopz_normal_body.animation = STAND
	hoopz_normal_body.frame = 6
	
	state_changed.connect( _changed_state )
	
func _changed_state():
	_change_sprites()
	if flashlight:
		_update_flashlight()
	
func _ai_ranged_attack( enabled : bool ) -> void:
	if curr_STATE == STATE.AIM:
		shoot_gun( enabled )
		
func _ai_aim_ranged( enabled : bool ) -> void:
	if curr_STATE == STATE.NORMAL:
		if enabled:
			## Aiming is complex. Original code takes inertia to move the character, aparently. check scr_player_stance_drawing() line 71
			if B2_Gun.has_any_guns(): start_aiming()
			else:	print_rich("[color=yellow]Can't aim without any guns, stupid.[/color]")
				
	elif curr_STATE == STATE.AIM:
		if enabled:
			stop_aiming()
			
func _ai_roll_at( enabled : bool ) -> void:
	if enabled:
		start_rolling( curr_input )
	
func get_aim_origin( is_local := false ) -> Vector2:
	if is_local: 	return aim_origin.position
	else:			return aim_origin.global_position
	
func start_aiming() -> void:
	if not get_room_pacify():
		# change state, allowing the player to aim.
		B2_Screen.set_cursor_type( B2_Screen.TYPE.BULLS )
		curr_STATE = STATE.AIM
		B2_Sound.play_pick("hoopz_swapguns")
		if B2_Input.curr_CONTROL == B2_Input.CONTROL.GAMEPAD: ## Only show if its using a gamepad
			aim_reticle.show()

func stop_aiming() -> void:
	curr_STATE = STATE.NORMAL
	B2_Screen.set_cursor_type( B2_Screen.TYPE.POINT )
	B2_Sound.play_pick("hoopz_swapguns")
	aim_reticle.hide()
	
## Debug function. Should not be used normaly.
## Maybe not so debug anymore
func shoot_gun( enabled : bool ) -> void:
	if not get_room_pacify():
		if B2_Gun.has_any_guns() and B2_Input.player_has_control:
			if curr_STATE == STATE.AIM:
				if enabled:
					curr_STATE = STATE.SHOOT
					
				gun_handler.shoot_gun( enabled )
				
				## Reset vars.
				var my_aim := Vector2.ZERO
				if curr_aim != Vector2.ZERO:	my_aim = curr_aim
				else: 							my_aim = last_aim
				
				#gun_handler.use_normal_attack( combat_weapon.global_position, my_aim, self ) ## TODO fix this. 
				if enabled:
					if curr_STATE == STATE.SHOOT:
						curr_STATE = STATE.AIM
	
## Very similar to normal animation control, but with some more details related to the diffferent body parts.
func combat_walk_animation(delta : float):
	## TODO fix the leg walking animation when aiming.
	var input 			:= curr_input # Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	
	var speed_scale = max( curr_input.length_squared(), 0.4 ) * normal_anim_speed_scale # Gamepad mod. Since you can move slowly using the gamepad, match the walking animation to the analog input.
	
	## Back-pedal -> scr_player_stance_drawing line 197
	if curr_aim.dot(input) < 0:
		speed_scale *= -1
		input *= -1
		#print( "back: ", curr_aim.dot(input) )
	
	if flashlight:
		_point_flashlight( input )
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if combat_last_input != input:
			add_smoke()
			
			match input.round():
				Vector2.UP + Vector2.LEFT:			combat_lower_sprite.play(WALK_NW, speed_scale)
				Vector2.UP + Vector2.RIGHT:			combat_lower_sprite.play(WALK_NE, speed_scale)
				Vector2.DOWN + Vector2.LEFT:		combat_lower_sprite.play(WALK_SW, speed_scale)
				Vector2.DOWN + Vector2.RIGHT:		combat_lower_sprite.play(WALK_SE, speed_scale)
					
				Vector2.UP:			combat_lower_sprite.play(WALK_N, speed_scale)
				Vector2.LEFT:		combat_lower_sprite.play(WALK_W, speed_scale)
				Vector2.DOWN:		combat_lower_sprite.play(WALK_S, speed_scale)
				Vector2.RIGHT:		combat_lower_sprite.play(WALK_E, speed_scale)
				Vector2.ZERO:		pass
				
				_: # Catch All
					combat_lower_sprite.play(WALK_S, speed_scale)
					print("Hoopz combat_walk_animation: Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		if combat_lower_sprite.is_playing():
			combat_lower_sprite.stop()
		
		var standing_dir 	:= curr_aim.round()
		
		if combat_last_direction != standing_dir:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			combat_lower_sprite.animation = COMBAT_SHUFFLE
			if not is_turning: # play step sound when you change directions, during shuffle.
				B2_Sound.play_pick( "hoopz_footstep", 0.0, false, 1, randf_range(0.75,1.25), 0.50 ) ## WARNING Original game doesnt do this.
				add_smoke()
				is_turning = true # Ensures that the SFX plays only once.
			turning_time -= 6.0 * delta
		else:
			combat_lower_sprite.animation = COMBAT_STAND
			combat_lower_sprite.frame = last_combat_stand_frame
			is_turning = false

		combat_lower_sprite.frame = last_combat_stand_frame ## The last frame is the default.
			
		# change the animation itself.
		match standing_dir:
			Vector2.UP + Vector2.LEFT:		combat_lower_sprite.frame = COMBAT_STAND_NW
			Vector2.UP + Vector2.RIGHT:		combat_lower_sprite.frame = COMBAT_STAND_NE
			Vector2.DOWN + Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_SW
			Vector2.DOWN + Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_SE
				
			Vector2.UP:		combat_lower_sprite.frame = COMBAT_STAND_N
			Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_W
			Vector2.DOWN:	combat_lower_sprite.frame = COMBAT_STAND_S
			Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_E
			Vector2.ZERO:	print("unh"); pass
				
			_: # Catch All
				print("Catch all, ", input)
		
		# Update var
		combat_last_direction = standing_dir
		
	# Update var
	combat_last_input = input
	debug_walk_dir = input
	
## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_aim_animation():
	if B2_Input.player_has_control:
		if curr_aim == Vector2.ZERO: ## Gamepad issues. Values of ZERO messes up the code bellow.
			return
			
		#var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( curr_aim ).snapped( Vector2(0.33,0.33) )
		#var mouse_input 	:= curr_aim.snapped( Vector2(0.33,0.33) )
		var dir_frame = combat_upper_sprite.frame
		# That Vector is an offset to make the calculation origin to be Hoopz torso
		var target_dir 			:= curr_aim
		var target_angle		:= target_dir.angle()
		var target_dir_snap 	:= curr_aim.snappedf( TAU / 16.0 )
		var target_angle_snap	:= target_dir_snap.angle()
		
		if flashlight:
			_point_flashlight( Vector2.from_angle(target_angle_snap) )
		
		if is_equal_approx(target_angle_snap, DIR_UP): 				dir_frame = 4	# Up
		elif is_equal_approx(target_angle_snap, DIR_LEFT): 			dir_frame = 8 	# Left
		elif is_equal_approx(target_angle_snap, DIR_DOWN): 			dir_frame = 12	# Down
		elif is_equal_approx(target_angle_snap, DIR_RIGHT):			dir_frame = 0 	# Right
		# Diagonal stuff
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_DOWN): 	dir_frame = 14	# Low Right
		elif is_equal_approx(target_angle_snap, DIR_LEFT_DOWN): 	dir_frame = 10	# Low Left
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_UP): 		dir_frame = 2	# High Right
		elif is_equal_approx(target_angle_snap, DIR_LEFT_UP):		dir_frame = 6	# High Left
				
		# Madness
		elif is_equal_approx(target_angle_snap, DIR_DOWN_RIGHTISH): dir_frame =	13	# Down Rightish
		elif is_equal_approx(target_angle_snap, DIR_DOWN_LEFTISH): 	dir_frame =	11	# Down Leftish
		elif is_equal_approx(target_angle_snap, DIR_UP_RIGHTISH): 	dir_frame = 3	# Up Rightish
		elif is_equal_approx(target_angle_snap, DIR_UP_LEFTISH): 	dir_frame = 5	# Up Leftish
		elif is_equal_approx(target_angle_snap, DIR_LEFT_DOWNISH): 	dir_frame =	9	# Left Downish
		elif is_equal_approx(target_angle_snap, DIR_LEFT_UPISH): 	dir_frame = 7	# Left Upish
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_DOWNISH): dir_frame =	15	# Right Downish
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_UPISH): 	dir_frame = 1	# Right Upish
		else: print( "Invalid combat_aim angle: ", target_angle_snap )
		
		# only change if there is a change in dir
		if dir_frame != combat_upper_sprite.frame:
			combat_upper_sprite.frame = 	dir_frame
			combat_arm_back.frame = 		dir_frame
			combat_arm_front.frame = 		dir_frame

func combat_weapon_animation() -> void:
	## TODO backport this to o_hoopz.
	if B2_Input.player_has_control:
		if curr_aim == Vector2.ZERO: ## Gamepad issues. Values of ZERO messes up the code bellow.
			#return
			pass
			
		# That Vector is an offset to make the calculation origin to be Hoopz torso
		var target_dir 			:= curr_aim
		var target_angle		:= target_dir.angle()
		var target_dir_snap 	:= curr_aim.snappedf( TAU / 16.0 )
		var target_angle_snap	:= target_dir_snap.angle()
		
		## Many Manual touch ups.
		var s_frame 				:= 999 #combat_weapon.frame
		var _z_index				:= 0
		var update_gun_position 	:= true ## Force sprite update. This 'fixes' a bug with sprite frame 0.
		
		## This needs to be fixed. It has to be a better way to do this. TODO
		# The way hoopz aims is not a simple 8 way direction. It's 16 way, thats why I made this mess.
		# NOTICE Please believe me, this mess is not my fault... Ive spent so many hours trying to make this work....
		if is_equal_approx(target_angle_snap, DIR_UP): 				s_frame = 	4;	_z_index = -1	# Up
		elif is_equal_approx(target_angle_snap, DIR_LEFT): 			s_frame = 	8;	_z_index = -1	# Left
		elif is_equal_approx(target_angle_snap, DIR_DOWN): 			s_frame = 	12					# Down
		elif is_equal_approx(target_angle_snap, DIR_RIGHT):	 		s_frame = 	0					# Right
		
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_DOWN): 	s_frame = 	14					# Low Right
		elif is_equal_approx(target_angle_snap, DIR_LEFT_DOWN): 	s_frame = 	10;#_z_index = -1 	# Low Left
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_UP):		s_frame = 	2;_z_index = -1 	# High Right	
		elif is_equal_approx(target_angle_snap, DIR_LEFT_UP):		s_frame = 	6;_z_index = -1		# High Left
			
		elif is_equal_approx(target_angle_snap, DIR_DOWN_RIGHTISH): s_frame = 	13					# Down Rightish
		elif is_equal_approx(target_angle_snap, DIR_DOWN_LEFTISH): 	s_frame = 	11					# Down Leftish
		elif is_equal_approx(target_angle_snap, DIR_UP_RIGHTISH): 	s_frame = 	3					# Up Rightish
		elif is_equal_approx(target_angle_snap, DIR_UP_LEFTISH): 	s_frame = 	5					# Up Leftish
		elif is_equal_approx(target_angle_snap, DIR_LEFT_DOWNISH): 	s_frame = 	9					# Left Downish
		elif is_equal_approx(target_angle_snap, DIR_LEFT_UPISH): 	s_frame = 	7					# Left Upish
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_DOWNISH): s_frame = 	15					# Right Downish
		elif is_equal_approx(target_angle_snap, DIR_RIGHT_UPISH): 	s_frame = 	1					# Right Upish
		else:			print( "Invalid Gun angle: ", target_angle_snap )
		
		## My own slop.
		## Decide where the gun should be placed in relation to the player sprite.
		## Handguns usually are placed on the center, but rifles and heavy weapons are held by the right of the PC.
		# NOTE 27/11/25 Fun fact: the 'My own slop.' text was written because this was my first attempt to use AI to write code, trying to translate the-
		# GML code to Godot. It was messy and did not work. After banging my head, tryin to fix copilot's code, i gave up and came with my own solution.
		# I try to avoid using AI as much as possible. It's fun to think on my own.
		var new_gun_pos := target_dir_snap
		
		# adjust the gun position on hoopz hands. This is more complicated than it sounds, since each gun type has a different position and offset.
		# took 3 days finetuning this. 11/03/25 
		new_gun_pos 	*= B2_Gun.get_gun_held_dist()
		
		new_gun_pos 	-= B2_Gun.get_gun_shifts( gun_held_offset ).rotated( target_angle_snap )
		new_gun_pos.y 	-= B2_Gun.get_gun_shifts().y * 0.75
		new_gun_pos.y 	*= 0.75
		new_gun_pos.y 	-= 18.0 # was 16.0
		new_gun_pos 	= new_gun_pos.round()
		
		## Decide where the muzzle is.
		gun_muzzle.position = new_gun_pos + Vector2( B2_Gun.get_muzzle_dist(), 0.0 ).rotated( target_angle_snap )
		gun_muzzle.position.y -= 3.0
		
		#if combat_weapon.frame != s_frame or update_gun_position:
		combat_weapon.frame 			= s_frame
		combat_weapon.position 			= new_gun_pos
		combat_weapon.z_index			= _z_index
		
		combat_weapon_parts.frame 		= s_frame
		combat_weapon_parts.position 	= new_gun_pos
		combat_weapon_parts.z_index		= _z_index
		
		combat_weapon_spots.frame 		= s_frame
		combat_weapon_spots.position 	= new_gun_pos
		combat_weapon_spots.z_index		= _z_index

## Used to apply a gun offset when a shot is fired.
func set_gun_reloaded( reload_state : bool ) -> void:
	if not reload_state:	gun_held_offset = 2.0
	else:					gun_held_offset = 0.0
		

# Roll action
func start_rolling( roll_dir : Vector2 ) -> void:
	if not can_roll:
		return
		
	if curr_STATE != STATE.NORMAL and curr_STATE != STATE.AIM: ## Stop rolling when not possible to roll.
		return
		
	# Roooolliiing staaaaart! ...here vvv
	hoopz_normal_body.speed_scale = normal_anim_speed_scale
	curr_STATE = STATE.ROLL
	linear_damp = roll_damp
	
	## Cool ass animation
	if roll_dir != Vector2.ZERO:
		hoopz_normal_body.play( ROLL )
		hoopz_normal_body.flip_h = roll_dir.x < 0
		
	else:
		# Use the mouse to decide the roll direction. (Inverted)
		if curr_aim:	roll_dir 	= ( curr_aim * 128.0 ).normalized() * -1 # position.direction_to
		else:			roll_dir 	= ( last_aim * 128.0 ).normalized() * -1 # position.direction_to
		hoopz_normal_body.play( ROLL_BACK )
		hoopz_normal_body.flip_h = roll_dir.x >= 0
	
	linear_velocity = Vector2.ZERO
	apply_central_impulse( roll_dir * roll_impulse )
	
	## Reset some vars
	combat_last_direction 	= Vector2.ZERO
	last_direction 			= Vector2.ZERO
	last_input 				= Vector2.ZERO
	combat_last_input 		= Vector2.ZERO
	
	## Fluff
	B2_Sound.play("sn_hoopz_roll")
	if B2_CManager.get_BodySwap() == "diaper":
		step_smoke.emitting = true
		#hoopz_normal_body.offset.y += 15
	return

func stop_rolling() -> void:
	if linear_velocity.length() < 10.0:
		## DEBUG - TODO Improve this.
		if hoopz_normal_body.animation == ROLL or hoopz_normal_body.animation == ROLL_BACK:
			if hoopz_normal_body.frame < 9: ## Wait for the animation to finish - TODO Signals?
				return
				
		# Roooolliiing eeeeennd.
		curr_STATE = prev_STATE
		hoopz_normal_body.animation = "stand"
		linear_damp = walk_damp
		step_smoke.emitting = false
		hoopz_normal_body.flip_h = false

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("DEBUG_DAMAGE"):
		damage_actor(0, Vector2.ZERO)
	if Input.is_action_just_pressed("DEBUG_DEATH"):
		damage_actor(9999, Vector2.ZERO)
		
	## Makers the AI think.
	if actor_ai:
		actor_ai.step()
		
	match curr_STATE:
		STATE.ROLL:
			stop_rolling()
				
		STATE.NORMAL, STATE.AIM, STATE.SHOOT:
			## Play Animations
			if curr_STATE == STATE.NORMAL:
				normal_animation(delta)
				if curr_input.round() != Vector2.ZERO:
					interaction_node.position = curr_input.round() * 32.0
				
			elif curr_STATE == STATE.AIM or curr_STATE == STATE.SHOOT:
				_update_held_gun()
				aim_reticle.position = curr_aim * 64.0 #aim_origin.position.direction_to(curr_aim) * 64.0
				combat_walk_animation( delta ) # delta is for the turning animation
				combat_aim_animation()
				combat_weapon_animation()
			else:
				push_warning("Weird state: ", curr_STATE)
			
			# Take the input from the keyboard / Gamepag and apply directly.
			var move := Vector2.ZERO
			if (curr_input * 2.5).normalized().round(): ## Check to avoid moving without activating the animation.
				move = curr_input
			velocity = ( walk_speed * delta ) * move
			
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
			
	# Reset input (Test)
	#curr_input = Vector2.ZERO
	#curr_aim = Vector2.ZERO

func _on_combat_actor_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if curr_STATE == STATE.ROLL:
			# body.apply_damage( 75.0 ) ## Debug setup
			pass

# handle step sounds
func _on_hoopz_upper_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				if is_on_a_puddle:		B2_Sound.play_pick("hoopz_puddlestep")
				elif is_on_water:		B2_Sound.play_pick("hoopz_wadestep")
				else:					B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
			
	if hoopz_normal_body.animation.begins_with("full_roll"):
		if hoopz_normal_body.frame in [0,1,2]:
			#hoopz_normal_body.look_at( linear_velocity )
			pass
		elif hoopz_normal_body.frame in [3,4,5,6]:
			hoopz_normal_body.rotation = 0
			if not step_smoke.emitting:
				if not is_on_a_puddle and not is_on_water: ## emit smoke on water?
					step_smoke.emitting = true
		else:
			step_smoke.emitting = false
			hoopz_normal_body.rotation = 0

func _on_combat_lower_body_frame_changed() -> void:
	if curr_STATE == STATE.AIM or curr_STATE == STATE.SHOOT:
		if combat_lower_sprite.animation.begins_with("walk_"):
			# play audio only on frame 0 or 2
			if combat_lower_sprite.frame in [0,2]:
				if move_dist <= 0.0:
					B2_Sound.play_pick("hoopz_footstep")
					move_dist = min_move_dist
			else:
				move_dist -= 1.0

## handle step sounds for normal state hoopz
func _on_hoopz_normal_body_frame_changed() -> void:
	if curr_STATE == STATE.NORMAL:
		if hoopz_normal_body.animation.begins_with("walk_"):
			if hoopz_normal_body.frame in [0,2]: # play audio only on frame 0 or 2
				if move_dist <= 0.0:
					B2_Sound.play_pick("hoopz_footstep")
					move_dist = min_move_dist
			else:
				move_dist -= 1.0
			
	if hoopz_normal_body.animation.begins_with("full_roll"):
		if hoopz_normal_body.frame in [0,1,2]: ## Hoopz is in air, no smoke
			# hoopz_normal_body.look_at( linear_velocity ) ## Test for changing roll sprite direction. need a better fix.
			step_smoke.emitting = false
		elif hoopz_normal_body.frame in [3,4,5,6]: ## Hoopz hits the floor and rolls, add smoke
			hoopz_normal_body.rotation = 0
			if not step_smoke.emitting:
				if not is_on_a_puddle and not is_on_water:
					step_smoke.emitting = true
		else: ## Getting up, no smoke.
			step_smoke.emitting = false
			hoopz_normal_body.rotation = 0
