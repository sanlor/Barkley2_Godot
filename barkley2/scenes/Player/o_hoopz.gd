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

@export_category("Player Permission")
@export var can_roll 	:= true
@export var can_shoot	:= true

@export_category("Combat Sprites")
@export var combat_upper_sprite 	: AnimatedSprite2D
@export var combat_lower_sprite 	: AnimatedSprite2D
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
		STATE.NORMAL:
			pass
		STATE.ROLL:
			pass
		STATE.AIM:
			pass

func combat_animation(delta : float):
	pass

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
				if Input.is_action_just_pressed("Holster"):
					curr_STATE = STATE.AIM
					
				if Input.is_action_just_released("Holster"):
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
				combat_animation(delta)
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
