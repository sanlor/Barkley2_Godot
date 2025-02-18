extends  B2_CombatActor
class_name B2_CinemaCombatActor_Base

## Class used by the player actor, during combat. Original system, so it probably wont work well.
## large part of the codebase were ported from B2_PlayerCombatActor, B2_Player
## Mostly, this has functions to control animations and such. Cinema controll will use another class.

signal aim_target_changed
signal move_target_changed

enum STATE{NORMAL,ROLL,AIM}
var curr_STATE := STATE.NORMAL :
	set(s) : 
		curr_STATE = s
		_change_sprites()

# Sprite frame indexes - s_cts_hoopz_stand
const SHUFFLE 		:= "shuffle"
const STAND 		:= "stand"
const ROLL			:= "hoopz_gooroll"
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

# Combat Sprite frame indexes
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

@export_category("Normal Sprites")
@export var hoopz_normal_body: 	AnimatedSprite2D

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D

@export_category("Misc")
@export var step_smoke: 		GPUParticles2D

## General Animation
var last_direction 	:= Vector2.ZERO
var last_input 		:= Vector2.ZERO
var is_turning 		:= false # Shuffling when turning using the mouse. # check scr_player_stance_diaper() line 142
var turning_time 	:= 1.0

## Combat Animations
var anim_aim_dir := Vector2.ZERO
var waddle	:= false # If hoopz legs should waddle torward the aiming direction

var combat_last_direction 	:= Vector2.ZERO
var combat_last_input 		:= Vector2.ZERO

## Movement
var external_velocity 	:= Vector2.ZERO ## DEBUG - applyied by the door.
var velocity			:= Vector2.ZERO

var walk_speed			:= 5000000
var roll_impulse		:= 1000000
var walk_damp			:= 10.0
var roll_damp			:= 2.5

## Sound
var min_move_dist 	:= 1.0
var move_dist 		:= 0.0 # Avoid issues with SFX playing too much during movement. # its a bad sollution, but ist works.

## Control stuff
var is_moving 		:= false
var move_target 	:= Vector2.ZERO ## Cinema stuff: Tells where the node should walk to.
var aim_target 		:= Vector2.ZERO ## Cinema stuff: Tells where the node should aim to. Can be used with "move_target" to move and aim at the same time.

func _ready() -> void:
	B2_CManager.o_cbt_hoopz = self
	
	## Fallback setup
	if not is_instance_valid( hoopz_normal_body ):
		hoopz_normal_body = get_node( "hoopz_normal_body" )
	if not is_instance_valid( combat_upper_sprite ):
		hoopz_normal_body = get_node( "combat_upper_sprite" )
	if not is_instance_valid( combat_lower_sprite ):
		hoopz_normal_body = get_node( "combat_lower_sprite" )
	if not is_instance_valid( combat_arm_back ):
		hoopz_normal_body = get_node( "combat_arm_back" )
	if not is_instance_valid( combat_arm_front ):
		hoopz_normal_body = get_node( "combat_arm_front" )
	if not is_instance_valid( combat_weapon ):
		hoopz_normal_body = get_node( "combat_weapon" )
	
	linear_damp = walk_damp
	_change_sprites()
	
	## Reset movement variables.
	move_target 	= position
	aim_target 		= position

func _change_sprites():
	match curr_STATE:
		STATE.NORMAL, STATE.ROLL:
			hoopz_normal_body.show()
			
			combat_lower_sprite.hide()
			combat_upper_sprite.hide()
			combat_arm_back.hide()
			combat_arm_front.hide()
			combat_weapon.hide()
		STATE.AIM:
			hoopz_normal_body.hide()
			
			combat_lower_sprite.show()
			combat_upper_sprite.show()
			combat_arm_back.show()
			combat_arm_front.show()
			combat_weapon.show()

func add_smoke() -> void:
	#for i in randi_range( 1, 2 ):
	step_smoke.emit_particle( Transform2D( 0, step_smoke.position ), Vector2.ZERO, Color.WHITE, Color.WHITE, 2 )
	
func normal_animation( _move_dir : Vector2, delta : float ) -> void:
	var input := _move_dir.round()
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:
					hoopz_normal_body.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:
					hoopz_normal_body.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:
					hoopz_normal_body.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:
					hoopz_normal_body.play(WALK_SE)
					
				Vector2.UP:
					hoopz_normal_body.play(WALK_N)
				Vector2.LEFT:
					hoopz_normal_body.play(WALK_W)
				Vector2.DOWN:
					hoopz_normal_body.play(WALK_S)
				Vector2.RIGHT:
					hoopz_normal_body.play(WALK_E)
					
				_: # Catch All
					hoopz_normal_body.play(WALK_S)
					print("Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		hoopz_normal_body.stop()
		move_dist = min_move_dist
		
		var curr_direction : Vector2 = input
		
		if curr_direction != last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			hoopz_normal_body.animation = SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle.
				## WARNING Original game doesnt do this.
				B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			hoopz_normal_body.animation = STAND
			is_turning = false
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:
				hoopz_normal_body.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:
				hoopz_normal_body.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_SE
				
			Vector2.UP:
				hoopz_normal_body.frame = STAND_N
			Vector2.LEFT:
				hoopz_normal_body.frame = STAND_W
			Vector2.DOWN:
				hoopz_normal_body.frame = STAND_S
			Vector2.RIGHT:
				hoopz_normal_body.frame = STAND_E
				
			_: # Catch All
				hoopz_normal_body.frame = STAND_S
				# print("Catch all, ", input)
				
		# Update var
		last_direction = curr_direction
	# Update var
	last_input = input

## Very similar to normal animation control, but with some more details related to the diffferent body parts.
func combat_walk_animation( _move_dir : Vector2, delta : float) -> void:
	var input := _move_dir
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if combat_last_input != input:
			add_smoke()
			
			match input:
				Vector2.UP + Vector2.LEFT:			combat_lower_sprite.play(WALK_NW)
				Vector2.UP + Vector2.RIGHT:			combat_lower_sprite.play(WALK_NE)
				Vector2.DOWN + Vector2.LEFT:		combat_lower_sprite.play(WALK_SW)
				Vector2.DOWN + Vector2.RIGHT:		combat_lower_sprite.play(WALK_SE)
					
				Vector2.UP:			combat_lower_sprite.play(WALK_N)
				Vector2.LEFT:		combat_lower_sprite.play(WALK_W)
				Vector2.DOWN:		combat_lower_sprite.play(WALK_S)
				Vector2.RIGHT:		combat_lower_sprite.play(WALK_E)
				_: # Catch All
					combat_lower_sprite.play(WALK_S)
					print("Catch all, ", input)
					
	else:
		# player is not moving the character anymore
		combat_lower_sprite.stop()
		
		var curr_direction : Vector2 = ( position - Vector2( 0, 16 ) ).direction_to( get_global_mouse_position() ).round()
		
		if curr_direction != combat_last_direction:
			turning_time = 1.0
		
		# handle the turning animation for a litle while.
		if turning_time > 0.0:
			combat_lower_sprite.animation = COMBAT_SHUFFLE
			if not is_turning:
				# play step sound when you change directions, during shuffle. 
				## WARNING Original game doesnt do this.
				#B2_Sound.play_pick("hoopz_footstep")
				is_turning = true
				
			turning_time -= 6.0 * delta
		else:
			combat_lower_sprite.animation = COMBAT_STAND
			is_turning = false
		
		# change the animation itself.
		match combat_last_direction:
			Vector2.UP + Vector2.LEFT:		combat_lower_sprite.frame = COMBAT_STAND_NW
			Vector2.UP + Vector2.RIGHT:		combat_lower_sprite.frame = COMBAT_STAND_NE
			Vector2.DOWN + Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_SW
			Vector2.DOWN + Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_SE
				
			Vector2.UP:		combat_lower_sprite.frame = COMBAT_STAND_N
			Vector2.LEFT:	combat_lower_sprite.frame = COMBAT_STAND_W
			Vector2.DOWN:	combat_lower_sprite.frame = COMBAT_STAND_S
			Vector2.RIGHT:	combat_lower_sprite.frame = COMBAT_STAND_E
				
			_: # Catch All
				combat_lower_sprite.frame = STAND_S
				print("Catch all, ", input)
				
		# Update var
		combat_last_direction = curr_direction
	# Update var
	combat_last_input = input

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_aim_animation( _aim_dir : Vector2 ) -> void:
	var mouse_input := ( position + Vector2( 0, -16 ) ).direction_to( _aim_dir ).snapped( Vector2(0.33,0.33) )
	var dir_frame 	= combat_upper_sprite.frame
	
	## Remember, 0.9999999999999 != 1.0
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99):
				dir_frame = 		4
			Vector2(-0.99,	0):
				dir_frame = 		8
			Vector2(0,	0.99):
				dir_frame = 		12
			Vector2(0.99,	0):	
				dir_frame = 		0
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				dir_frame = 		14
			Vector2(-0.66,	0.66): # Low Left
				dir_frame = 		10
			Vector2(0.66,	-0.66): # High Right
				dir_frame = 		2
			Vector2(-0.66,	-0.66):	# High Left
				dir_frame = 		6
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				dir_frame = 		13
			Vector2(-0.33,	0.99): # Leftish
				dir_frame = 		11
			#Up
			Vector2(0.33,	-0.99): # Rightish
				dir_frame = 		3
			Vector2(-0.33,	-0.99): # Leftish
				dir_frame = 		5
			#Left
			Vector2(-0.99,	0.33): # Upish
				dir_frame = 		9
			Vector2(-0.99,	-0.33): # Downish
				dir_frame = 	7

			#Right
			Vector2(0.99,	0.33): # Upish
				dir_frame = 	15

			Vector2(0.99,	-0.33): # Downish
				dir_frame = 	1
	
	# only change if there is a change in dir
	if dir_frame != combat_upper_sprite.frame:
		combat_upper_sprite.frame = 	dir_frame
		combat_arm_back.frame = 		dir_frame
		combat_arm_front.frame = 		dir_frame

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_weapon_animation( _aim_dir : Vector2 ) -> void:
	# That Vector is an offset to make the calculation origin to be Hoopz torso
	var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( _aim_dir ).snapped( Vector2(0.33,0.33) )
	var gun_pos 		:= Vector2(18, 0)
	
	## Many Manual touch ups.
	var s_frame 		:= combat_weapon.frame
	var angle 			:= 0.0
	var height_offset	:= Vector2(0, 4)
	var _z_index		:= 0
	
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99): # Up
				s_frame = 	4
				angle = 270
				_z_index = -1
			Vector2(-0.99,	0): # Left
				s_frame = 	8
				angle = 180
				height_offset = Vector2.ZERO
			Vector2(0,	0.99): # Down
				s_frame = 	12
				angle = 90
				height_offset *= -1
			Vector2(0.99,	0):	 # Right
				s_frame = 	0
				angle = 0
				height_offset = Vector2.ZERO
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				s_frame = 	14
				angle = 45
				height_offset *= -1
			Vector2(-0.66,	0.66): # Low Left
				s_frame = 	10
				angle = 135
				height_offset *= -1
			Vector2(0.66,	-0.66): # High Right
				s_frame = 	2
				angle = 315
			Vector2(-0.66,	-0.66):	# High Left
				s_frame = 	6
				angle = 225
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				s_frame = 	13
				angle = 60
				height_offset *= -1
			Vector2(-0.33,	0.99): # Leftish
				s_frame = 	11
				angle = 120
				height_offset *= -1
			#Up
			Vector2(0.33,	-0.99): # Rightish
				s_frame = 	3
				angle = 300
			Vector2(-0.33,	-0.99): # Leftish
				s_frame = 	5
				angle = 240
			#Left
			Vector2(-0.99,	0.33): # Downish
				s_frame = 	9
				angle = 150
				height_offset *= -1
			Vector2(-0.99,	-0.33): # Upish
				s_frame = 	7
				angle = 210
				#height_offset *= -1
			#Right
			Vector2(0.99,	0.33): # Downish
				s_frame = 	15
				angle = 30
				height_offset *= -1
			Vector2(0.99,	-0.33): # Upish
				s_frame = 	1
				angle = 330
			_:
				#print(mouse_input)
				pass
				
	if combat_weapon.frame != s_frame:
		combat_weapon.frame 	= s_frame
		combat_weapon.offset 	= gun_pos.rotated( deg_to_rad(angle) ) + height_offset
		combat_weapon.z_index	= _z_index
		
		anim_aim_dir = mouse_input

func _on_combat_actor_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if curr_STATE == STATE.ROLL:
			body.apply_damage( 75.0 ) ## Debug setup
# handle step sounds
func _on_hoopz_upper_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0

func _on_combat_lower_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0

func start_roling( _roll_dir : Vector2, delta : float ) -> void:
	# Roooolliiing staaaaart! ...here vvv
	curr_STATE = STATE.ROLL
	linear_damp = roll_damp
	hoopz_normal_body.play( ROLL )
	var roll_dir 	: Vector2
	#var input 		:= Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	var input 		:= Input.get_vector("Left","Right","Up","Down")
	if input != Vector2.ZERO:
		roll_dir 	= input
	else:
		# Use the mouse to decide the roll direction. (Inverted)
		roll_dir 	= position.direction_to( get_global_mouse_position() ) * -1
	linear_velocity = Vector2.ZERO
	apply_central_force( roll_dir * roll_impulse )
	
	## Reset some vars
	combat_last_direction 	= Vector2.ZERO
	last_direction 			= Vector2.ZERO
	last_input 				= Vector2.ZERO
	combat_last_input 		= Vector2.ZERO
	
	## Fluff
	B2_Sound.play("sn_hoopz_roll")
	step_smoke.emitting = true
	hoopz_normal_body.offset.y += 15
	#return
	
	var move := _roll_dir ## CRITICAL Should not be Vector2.ZERO
	velocity = ( walk_speed * delta ) * move

func _physics_process(delta: float) -> void:
	## DEBUG
	if Input.is_key_pressed(KEY_0):
		move_target 	= Vector2( randf_range(0,1000), randf_range(0,1000) )
		aim_target 		= Vector2( randf_range(0,1000), randf_range(0,1000) )
	
	match curr_STATE:
		STATE.ROLL:
			hoopz_normal_body.speed_scale = max( 1.0, linear_velocity.length() / 70.0 )
			
			if linear_velocity.length() < 10.0:
				# Roooolliiing eeeeennd.
				curr_STATE = STATE.NORMAL
				hoopz_normal_body.animation = "stand"
				hoopz_normal_body.speed_scale = 1.0
				linear_damp = walk_damp
				step_smoke.emitting = false
				hoopz_normal_body.offset.y -= 15
				
		STATE.NORMAL, STATE.AIM:
			var aim_dir 	:= position.direction_to( aim_target )
			var move_dir 	:= position.direction_to( move_target )
			
			## Move target reached.
			if move_target.distance_to( position ) < 10:
				move_dir = Vector2.ZERO
				is_moving = false
			
			## Play Animations
			if curr_STATE == STATE.NORMAL:
				normal_animation( move_dir, delta)
				
			elif  curr_STATE == STATE.AIM:
				combat_walk_animation( move_dir, delta ) # delta is for the turning animation
				combat_aim_animation( move_dir )
				combat_weapon_animation( aim_dir )
			else:
				push_warning("Weird state: ", curr_STATE)
			
			var move := Vector2.ZERO ## CRITICAL Should not be Vector2.ZERO
			if is_moving:
				move = move_dir 
			velocity = ( walk_speed * delta ) * move
				
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			apply_central_force( velocity / Engine.time_scale )
