#extends CharacterBody2D
extends B2_PlayerCombatActor
class_name B2_Player

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
@export var can_roll 	:= true
@export var can_shoot	:= true

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
@export var combat_arm_back 		: AnimatedSprite2D
@export var combat_arm_front 		: AnimatedSprite2D
@export var combat_weapon 			: AnimatedSprite2D

const COMBAT_SHUFFLE 		:= "shuffle"
const COMBAT_STAND 			:= "stand"
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

# Handle costume / body changes
enum BODY{HOOPZ,MATTHIAS,GOVERNOR,UNTAMO,DIAPER,PRISON}
var curr_BODY := BODY.HOOPZ

enum STATE{NORMAL,ROLL,AIM}
var curr_STATE := STATE.NORMAL :
	set(s) : 
		curr_STATE = s
		_change_sprites()

# Movement
var external_velocity 	:= Vector2.ZERO ## DEBUG - applyied by the door.
var velocity			:= Vector2.ZERO

var walk_speed			:= 80000
var roll_impulse		:= 1000000
var walk_damp			:= 10.0
var roll_damp			:= 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	B2_Cinema.o_hoopz = self
	B2_Input.player_follow_mouse.connect( func(state): follow_mouse = state )
	_change_sprites()
	
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

func combat_walk_animation():
	var input 			:= Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
	
	if input != Vector2.ZERO: # Player is moving the character
		# Emit a puff of smoke during the inicial direction change.
		if last_input != input:
			#add_smoke()
			
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
			
		# change the animation itself.
		match last_direction:
			Vector2.UP + Vector2.LEFT:		combat_lower_sprite.frame = STAND_NW
			Vector2.UP + Vector2.RIGHT:		combat_lower_sprite.frame = STAND_NE
			Vector2.DOWN + Vector2.LEFT:	combat_lower_sprite.frame = STAND_SW
			Vector2.DOWN + Vector2.RIGHT:	combat_lower_sprite.frame = STAND_SE
				
			Vector2.UP:		combat_lower_sprite.frame = STAND_N
			Vector2.LEFT:	combat_lower_sprite.frame = STAND_W
			Vector2.DOWN:	combat_lower_sprite.frame = STAND_S
			Vector2.RIGHT:	combat_lower_sprite.frame = STAND_E
				
			_: # Catch All
				combat_lower_sprite.frame = STAND_S
				# print("Catch all, ", input)

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_aim_animation():
	var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( get_global_mouse_position() ).snapped( Vector2(0.33,0.33) )
	print(mouse_input)
	
	## Remember, 0.9999999999999 != 1.0
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99):
				combat_upper_sprite.frame = 	4
				combat_arm_back.frame = 		4
				combat_arm_front.frame = 		4
			Vector2(-0.99,	0):
				combat_upper_sprite.frame = 	8
				combat_arm_back.frame = 		8
				combat_arm_front.frame = 		8
			Vector2(0,	0.99):
				combat_upper_sprite.frame = 	12
				combat_arm_back.frame = 		12
				combat_arm_front.frame = 		12
			Vector2(0.99,	0):	
				combat_upper_sprite.frame = 	0
				combat_arm_back.frame = 		0
				combat_arm_front.frame = 		0
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				combat_upper_sprite.frame = 	14
				combat_arm_back.frame = 		14
				combat_arm_front.frame = 		14
			Vector2(-0.66,	0.66): # Low Left
				combat_upper_sprite.frame = 	10
				combat_arm_back.frame = 		10
				combat_arm_front.frame = 		10
			Vector2(0.66,	-0.66): # High Right
				combat_upper_sprite.frame = 	2
				combat_arm_back.frame = 		2
				combat_arm_front.frame = 		2
			Vector2(-0.66,	-0.66):	# High Left
				combat_upper_sprite.frame = 	6
				combat_arm_back.frame = 		6
				combat_arm_front.frame = 		6
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				combat_upper_sprite.frame = 	13
				combat_arm_back.frame = 		13
				combat_arm_front.frame = 		13
			Vector2(-0.33,	0.99): # Leftish
				combat_upper_sprite.frame = 	11
				combat_arm_back.frame = 		11
				combat_arm_front.frame = 		11
			#Up
			Vector2(0.33,	-0.99): # Rightish
				combat_upper_sprite.frame = 	3
				combat_arm_back.frame = 		3
				combat_arm_front.frame = 		3
			Vector2(-0.33,	-0.99): # Leftish
				combat_upper_sprite.frame = 	5
				combat_arm_back.frame = 		5
				combat_arm_front.frame = 		5
			#Left
			Vector2(-0.99,	0.33): # Upish
				combat_upper_sprite.frame = 	9
				combat_arm_back.frame = 		9
				combat_arm_front.frame = 		9
			Vector2(-0.99,	-0.33): # Downish
				combat_upper_sprite.frame = 	7
				combat_arm_back.frame = 		7
				combat_arm_front.frame = 		7
			#Right
			Vector2(0.99,	0.33): # Upish
				combat_upper_sprite.frame = 	15
				combat_arm_back.frame = 		15
				combat_arm_front.frame = 		15
			Vector2(0.99,	-0.33): # Downish
				combat_upper_sprite.frame = 	1
				combat_arm_back.frame = 		1
				combat_arm_front.frame = 		1

## Aiming is a bitch, it has a total of 16 positions for smooth movement.
func combat_weapon_animation():
	# That Vector is an offset to make the calculation origin to be Hoopz torso
	var mouse_input 	:= ( position + Vector2( 0, -16 ) ).direction_to( get_global_mouse_position() ).snapped( Vector2(0.33,0.33) )
	var gun_pos 		:= Vector2(18, 0)
	
	## Many Manual touch ups.
	match mouse_input:
			# Normal stuff
			Vector2(0,	-0.99): # Up
				combat_weapon.frame = 	4
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(270) ) + Vector2(0, 4)
			Vector2(-0.99,	0): # Left
				combat_weapon.frame = 	8
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(180) )
			Vector2(0,	0.99): # Down
				combat_weapon.frame = 	12
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(90) )
			Vector2(0.99,	0):	 # Right
				combat_weapon.frame = 	0
				combat_weapon.offset = gun_pos.rotated( 0 )
				
			# Diagonal stuff
			Vector2(0.66,	0.66): # Low Right
				combat_weapon.frame = 	14
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(45) ) - Vector2(0, 4)
			Vector2(-0.66,	0.66): # Low Left
				combat_weapon.frame = 	10
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(135) ) - Vector2(0, 4)
			Vector2(0.66,	-0.66): # High Right
				combat_weapon.frame = 	2
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(315) ) + Vector2(0, 4)
			Vector2(-0.66,	-0.66):	# High Left
				combat_weapon.frame = 	6
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(225) ) + Vector2(0, 4)
			
			# Madness
			#Down
			Vector2(0.33,	0.99): # Rightish
				combat_weapon.frame = 	13
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(60) ) - Vector2(0, 4)
			Vector2(-0.33,	0.99): # Leftish
				combat_weapon.frame = 	11
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(120) ) - Vector2(0, 4)
			#Up
			Vector2(0.33,	-0.99): # Rightish
				combat_weapon.frame = 	3
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(300) ) + Vector2(0, 4)
			Vector2(-0.33,	-0.99): # Leftish
				combat_weapon.frame = 	5
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(240) ) + Vector2(0, 4)
			#Left
			Vector2(-0.99,	0.33): # Downish
				combat_weapon.frame = 	9
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(150) ) - Vector2(0, 4)
			Vector2(-0.99,	-0.33): # Upish
				combat_weapon.frame = 	7
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(210) ) + Vector2(0, 4)
			#Right
			Vector2(0.99,	0.33): # Downish
				combat_weapon.frame = 	15
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(30) ) - Vector2(0, 4)
			Vector2(0.99,	-0.33): # Upish
				combat_weapon.frame = 	1
				combat_weapon.offset = gun_pos.rotated( deg_to_rad(330) ) + Vector2(0, 4)


func _physics_process(delta: float) -> void:
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
			if B2_Input.player_has_control:
				## Player has influence over this node
				if Input.is_action_just_pressed("Holster") and can_shoot:
					curr_STATE = STATE.AIM
					
				if Input.is_action_just_released("Holster"): # and can_shoot:
					curr_STATE = STATE.NORMAL
				
				if Input.is_action_just_pressed("Roll") and can_roll:
					# Roooolliiing staaaaart! ...here vvv
					curr_STATE = STATE.ROLL
					linear_damp = roll_damp
					hoopz_normal_body.play( ROLL )
					var roll_dir 	: Vector2
					var input 		:= Vector2( Input.get_axis("Left","Right"),Input.get_axis("Up","Down") )
					if input != Vector2.ZERO:
						roll_dir 	= input
					else:
						# Use the mouse to decide the roll direction. (Inverted)
						roll_dir 	= position.direction_to( get_global_mouse_position() ) * -1
					linear_velocity = Vector2.ZERO
					apply_central_force( roll_dir * roll_impulse )
					
					## Fluff
					B2_Sound.play("sn_hoopz_roll")
					step_smoke.emitting = true
					hoopz_normal_body.offset.y += 15
					return
				
				# Take the input from the keyboard / Gamepag and apply directly.
				var move := Input.get_vector("Left","Right","Up","Down")
				velocity = ( walk_speed * delta ) * move
			else:
				velocity = Vector2.ZERO
				
			velocity += external_velocity
			external_velocity = Vector2.ZERO # Reset Ext velocity
			
			apply_central_impulse( velocity )
			
			## Play Animations
			if curr_STATE == STATE.NORMAL:
				normal_animation(delta)
			elif  curr_STATE == STATE.AIM:
				combat_walk_animation()
				combat_aim_animation()
				combat_weapon_animation()
			else:
				push_warning("Weird state: ", curr_STATE)
	
# handle step sounds
func _on_hoopz_normal_body_frame_changed() -> void:
	if hoopz_normal_body.animation.begins_with("walk_"):
		# play audio only on frame 0 or 2
		if hoopz_normal_body.frame in [0,2]:
			if move_dist <= 0.0:
				B2_Sound.play_pick("hoopz_footstep")
				move_dist = min_move_dist
		else:
			move_dist -= 1.0
			
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body is B2_InteractiveActor:
		body.is_player_near = true

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body is B2_InteractiveActor:
		body.is_player_near = false

func _on_combat_actor_entered(body: Node) -> void:
	if body is B2_CombatActor:
		if curr_STATE == STATE.ROLL:
			body.apply_damage( 50.0 )
